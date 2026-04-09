//
//
//  4_ShapeProtocol.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Shape Protocol

// Custom shapes as Shape-conforming structs
struct BubbleShape: Shape {
    var tailSide: Edge = .bottom
    var cornerRadius: CGFloat = 12
    var tailSize: CGFloat = 12

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let r = cornerRadius
        let t = tailSize
        let midX = rect.midX
//        let midY = rect.midY

        // Main rounded rect body (simplified version)
        path.addRoundedRect(in: rect.inset(by: UIEdgeInsets(top: tailSide == .top ? t : 0,
                                                             left: tailSide == .leading ? t : 0,
                                                             bottom: tailSide == .bottom ? t : 0,
                                                             right: tailSide == .trailing ? t : 0)),
                            cornerSize: CGSize(width: r, height: r))
        // Tail triangle
        switch tailSide {
        case .bottom:
            path.move(to: CGPoint(x: midX - t, y: rect.maxY - t))
            path.addLine(to: CGPoint(x: midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: midX + t, y: rect.maxY - t))
        case .top:
            path.move(to: CGPoint(x: midX - t, y: t))
            path.addLine(to: CGPoint(x: midX, y: 0))
            path.addLine(to: CGPoint(x: midX + t, y: t))
        default:
            break
        }
        return path
    }
}

struct RoundedTriangle: InsettableShape {
    var cornerRadius: CGFloat = 8
    var insetAmount: CGFloat = 0

    func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }

    func path(in rect: CGRect) -> Path {
        let insetRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        
        // Three sharp peaks of the triangle
        let top = CGPoint(x: insetRect.midX, y: insetRect.minY)
        let bl  = CGPoint(x: insetRect.minX, y: insetRect.maxY)
        let br  = CGPoint(x: insetRect.maxX, y: insetRect.maxY)
        
        var path = Path()
        
        // The Math Secret:
        // Midpoint of the bottom edge.
        path.move(to: CGPoint(x: insetRect.midX, y: insetRect.maxY))
        
        // Bottom Left
        path.addArc(tangent1End: bl, tangent2End: top, radius: cornerRadius)
        
        // Top
        path.addArc(tangent1End: top, tangent2End: br, radius: cornerRadius)
        
        // Bottom Right
        path.addArc(tangent1End: br, tangent2End: bl, radius: cornerRadius)
        path.closeSubpath()
        
        return path
    }
}

struct ShapeProtocolVisual: View {
    @State private var selectedDemo   = 0
    @State private var polygonSides   = 5
    @State private var starPoints     = 5
    @State private var cornerR: CGFloat = 12
    let demos = ["Chat bubble", "Rounded triangle", "Parameterized"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Shape protocol", systemImage: "hexagon.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.spBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.spBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.spBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Chat bubble
                    VStack(spacing: 14) {
                        HStack {
                            BubbleShape(tailSide: .bottom)
                                .fill(Color.spBlue)
                                .frame(width: 160, height: 60)
                                .overlay(Text("Hello there!").font(.system(size: 12)).foregroundStyle(.white))
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            BubbleShape(tailSide: .bottom)
                                .fill(Color(.systemFill))
                                .frame(width: 140, height: 60)
                                .overlay(Text("Hi! How are you?").font(.system(size: 11)).foregroundStyle(.primary))
                        }
                        Text("BubbleShape - custom Shape conformance with tail direction parameter")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }

                case 1:
                    // Rounded triangle
                    VStack(spacing: 12) {
                        HStack(spacing: 20) {
                            VStack(spacing: 6) {
                                RoundedTriangle()
                                    .fill(LinearGradient(colors: [Color.spBlue, Color(hex: "#0891B2")], startPoint: .top, endPoint: .bottom))
                                    .frame(width: 80, height: 80)
                                Text("fill").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                            }
                            VStack(spacing: 6) {
                                RoundedTriangle()
                                    .strokeBorder(Color.spBlue, lineWidth: 3)
                                    .frame(width: 80, height: 80)
                                Text("strokeBorder").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                            }
                            VStack(spacing: 6) {
                                ZStack {
                                    RoundedTriangle().fill(Color.spBlueLight)
                                    RoundedTriangle().strokeBorder(Color.spBlue, lineWidth: 2)
                                }
                                .frame(width: 80, height: 80)
                                Text("fill+stroke").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                            }
                        }
                        Text("Shape conformance gives fill, stroke, strokeBorder, clipShape - all for free")
                            .font(.system(size: 10)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                    }

                default:
                    // Parameterized live
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Text("sides:").font(.system(size: 12)).foregroundStyle(.secondary)
                            ForEach([3, 4, 5, 6, 7, 8], id: \.self) { n in
                                Button("\(n)") {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { polygonSides = n }
                                }
                                .font(.system(size: 11, weight: polygonSides == n ? .semibold : .regular))
                                .foregroundStyle(polygonSides == n ? .white : .secondary)
                                .frame(width: 26, height: 26)
                                .background(polygonSides == n ? Color.spBlue : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                        HStack(spacing: 10) {
                            // Fill
                            PolygonPath(sides: polygonSides)
                                .fill(LinearGradient(colors: [Color.spBlue, Color(hex: "#0891B2")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 80, height: 80)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: polygonSides)
                            // Stroke
                            PolygonPath(sides: polygonSides)
                                .stroke(Color.spBlue, lineWidth: 3)
                                .frame(width: 80, height: 80)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: polygonSides)
                            // Clip
                            GradientPlaceholder(index: 2)
                                .frame(width: 80, height: 80)
                                .clipShape(PolygonPath(sides: polygonSides))
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: polygonSides)
                        }
                        Text("Same struct: fill, stroke, clipShape - Shape protocol provides all three")
                            .font(.system(size: 10)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                    }
                }
            }
        }
    }
}

struct ShapeProtocolExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Shape protocol")
            Text("Conforming to Shape lets you create reusable, parameterized shapes that work exactly like built-in ones. Implement path(in:) and you get fill, stroke, strokeBorder, clipShape, and animation support for free.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "struct MyShape: Shape { func path(in rect: CGRect) -> Path { } } - implement one method.", color: .spBlue)
                StepRow(number: 2, text: "All Shape methods become available: .fill(), .stroke(), .strokeBorder(), .clipShape().", color: .spBlue)
                StepRow(number: 3, text: "Add parameters to the struct for a parameterized shape - sides, cornerRadius, tailSide, etc.", color: .spBlue)
                StepRow(number: 4, text: "Conform to InsettableShape (add inset(by:)) to gain .strokeBorder support.", color: .spBlue)
                StepRow(number: 5, text: "Shapes animate automatically when their parameters change if they conform to Animatable.", color: .spBlue)
            }

            CalloutBox(style: .success, title: "Shape is better than Path inline", contentBody: "Use Path { } inline for one-off drawings. Create a Shape-conforming struct for anything you'll reuse, parameterize, or animate. The struct gives you a named, testable, composable type.")

            CodeBlock(code: """
// Custom Shape
struct Polygon: Shape {
    var sides: Int

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        var path = Path()
        for i in 0..<sides {
            let angle = (Double(i) / Double(sides)) * 2 * .pi - .pi / 2
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            if i == 0 { path.move(to: point) }
            else { path.addLine(to: point) }
        }
        path.closeSubpath()
        return path
    }
}

// Use just like built-in shapes
Polygon(sides: 6)
    .fill(.blue)
    .frame(width: 100, height: 100)

Image("photo")
    .clipShape(Polygon(sides: 8))
""")
        }
    }
}

