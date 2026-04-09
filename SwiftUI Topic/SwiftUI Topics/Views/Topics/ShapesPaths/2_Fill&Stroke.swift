//
//
//  2_Fill&Stroke.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Fill & Stroke
struct FillStrokeVisual: View {
    @State private var lineWidth: CGFloat  = 3
    @State private var dashLength: CGFloat = 8
    @State private var dashGap: CGFloat    = 4
    @State private var selectedDemo        = 0

    let demos = ["Fill types", "Stroke styles", "Fill + stroke"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Fill & stroke", systemImage: "paintbrush.fill")
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
                    // Fill types
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                        fillCell("Color") {
                            RoundedRectangle(cornerRadius: 12).fill(Color.spBlue)
                        }
                        fillCell("LinearGradient") {
                            RoundedRectangle(cornerRadius: 12).fill(
                                LinearGradient(colors: [Color.spBlue, Color(hex: "#0891B2")],
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                        }
                        fillCell("RadialGradient") {
                            RoundedRectangle(cornerRadius: 12).fill(
                                RadialGradient(colors: [Color(hex: "#BAE6FD"), Color.spBlue],
                                               center: .center, startRadius: 0, endRadius: 60)
                            )
                        }
                        fillCell(".regularMaterial") {
                            ZStack {
                                LinearGradient(colors: [Color.spBlue, Color(hex: "#0891B2")],
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                                RoundedRectangle(cornerRadius: 12).fill(.regularMaterial)
                            }
                        }
                        fillCell("Color.gradient") {
                            RoundedRectangle(cornerRadius: 12).fill(Color.spBlue.gradient)
                        }
                        fillCell("ImagePaint") {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemFill))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.spBlue.opacity(0.15))
                                )
                        }
                    }

                case 1:
                    // Stroke styles
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            sliderRow("width", value: $lineWidth, range: 1...16)
                        }
                        HStack(spacing: 12) {
                            VStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.spBlue, lineWidth: lineWidth)
                                    .frame(height: 50)
                                Text(".stroke").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                            }
                            VStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.spBlue, lineWidth: lineWidth)
                                    .frame(height: 50)
                                Text(".strokeBorder").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                            }
                        }
                        .animation(.easeInOut(duration: 0.1), value: lineWidth)

                        // Dashed
                        HStack(spacing: 8) {
                            sliderRow("dash", value: $dashLength, range: 2...24)
                            sliderRow("gap",  value: $dashGap,   range: 2...16)
                        }
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.spBlue, style: StrokeStyle(lineWidth: lineWidth, dash: [dashLength, dashGap]))
                            .frame(height: 50)
                            .animation(.easeInOut(duration: 0.1), value: dashLength)
                            .animation(.easeInOut(duration: 0.1), value: dashGap)
                        Text(".stroke(style: StrokeStyle(lineWidth:dash:))").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                    }

                default:
                    // Fill + stroke layered
                    VStack(spacing: 10) {
                        // ZStack approach
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(LinearGradient(colors: [Color.spBlue.opacity(0.15), Color.spBlueLight],
                                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.spBlue, lineWidth: 2)
                        }
                        .frame(height: 60)
                        .overlay(Text("ZStack: fill + stroke separately").font(.system(size: 11)).foregroundStyle(Color.spBlue))

                        // .fill + .stroke modifier chain
                        Circle()
                            .fill(Color.spBlueLight)
                            .frame(width: 60, height: 60)
                            .overlay(Circle().stroke(Color.spBlue, lineWidth: 3))
                            .overlay(Text("A").font(.system(size: 22, weight: .bold)).foregroundStyle(Color.spBlue))

                        Text("ZStack or .overlay for fill+stroke - strokeBorder sits inside, stroke straddles the edge")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    func fillCell<S: View>(_ name: String, @ViewBuilder shape: () -> S) -> some View {
        VStack(spacing: 4) {
            shape().frame(height: 44)
            Text(name).font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
        }
    }

    func sliderRow(_ label: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>) -> some View {
        HStack(spacing: 6) {
            Text(label).font(.system(size: 10)).foregroundStyle(.secondary).frame(width: 28)
            Slider(value: value, in: range, step: 1).tint(.spBlue)
            Text("\(Int(value.wrappedValue))").font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.spBlue).frame(width: 20)
        }
    }
}

struct FillStrokeExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Fill, stroke and strokeBorder")
            Text(".fill() and .stroke() are the two ways to render a shape. Fill paints the interior. Stroke draws the outline. strokeBorder draws the stroke entirely inside the shape's bounds - important for shapes that need to fit a tight frame.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".fill(ShapeStyle) - fills the interior. Accepts Color, gradient, Material, or any ShapeStyle.", color: .spBlue)
                StepRow(number: 2, text: ".stroke(color, lineWidth:) - draws outline straddling the edge (half inside, half outside).", color: .spBlue)
                StepRow(number: 3, text: ".strokeBorder(color, lineWidth:) - draws outline entirely inside. Preferred for frames and borders.", color: .spBlue)
                StepRow(number: 4, text: "StrokeStyle(lineWidth:dash:dashPhase:lineCap:lineJoin:) - full stroke control including dashed lines.", color: .spBlue)
                StepRow(number: 5, text: "ZStack or .overlay for fill + stroke - shapes don't natively support both simultaneously.", color: .spBlue)
            }

            CalloutBox(style: .info, title: "stroke vs strokeBorder", contentBody: ".stroke() paints the line centered on the shape's edge - half goes outside the frame. .strokeBorder() keeps the entire stroke inside the frame. Use strokeBorder when the shape must fit exactly in its frame.")

            CodeBlock(code: """
// Fill with any ShapeStyle
Circle().fill(.blue)
Circle().fill(Color.blue.gradient)
Circle().fill(LinearGradient(...))
Circle().fill(.regularMaterial)

// Stroke
Circle().stroke(.blue, lineWidth: 3)
Circle().strokeBorder(.blue, lineWidth: 3)  // stays inside

// Dashed
Circle().stroke(
    .blue,
    style: StrokeStyle(lineWidth: 2, dash: [8, 4])
)

// Fill + stroke (ZStack)
ZStack {
    Circle().fill(.blue.opacity(0.1))
    Circle().strokeBorder(.blue, lineWidth: 2)
}

// Or .overlay
Circle()
    .fill(.blue.opacity(0.1))
    .overlay(Circle().strokeBorder(.blue, lineWidth: 2))
""")
        }
    }
}
