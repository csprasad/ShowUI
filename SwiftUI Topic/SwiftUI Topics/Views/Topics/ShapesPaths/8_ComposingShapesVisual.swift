//
//
//  8_ComposingShapesVisual.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
//import CoreGraphics

// MARK: - LESSON 8: Composing Shapes
struct ComposingShapesVisual: View {
    @State private var selectedDemo = 0
    @State private var cutoutSize: CGFloat = 50
    @State private var revealProgress: CGFloat = 0

    let demos = ["ZStack layers", "Even-odd fill", "Mask + clip"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Composing shapes", systemImage: "square.on.square.fill")
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
                    // ZStack shape layers
                    VStack(spacing: 10) {
                        ZStack {
                            // Layer 1 – background circle
                            Circle()
                                .fill(Color.spBlue.opacity(0.15))
                                .frame(width: 130, height: 130)
                            // Layer 2 – ring
                            Circle()
                                .strokeBorder(Color.spBlue.opacity(0.4), lineWidth: 2)
                                .frame(width: 110, height: 110)
                            // Layer 3 – star
                            StarPath(points: 5, innerRatio: 0.45)
                                .fill(LinearGradient(colors: [Color.spBlue, Color(hex: "#0891B2")],
                                                     startPoint: .top, endPoint: .bottom))
                                .frame(width: 70, height: 70)
                            // Layer 4 – centre circle
                            Circle()
                                .fill(Color.white)
                                .frame(width: 22, height: 22)
                            Circle()
                                .fill(Color.spBlue)
                                .frame(width: 14, height: 14)
                        }
                        .frame(maxWidth: .infinity).frame(height: 140)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        Text("Four shape layers in a ZStack - each independent fill/stroke")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }

                case 1:
                    // Even-odd cutout
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Text("cutout:").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 48)
                            Slider(value: $cutoutSize, in: 10...90, step: 2).tint(.spBlue)
                            Text("\(Int(cutoutSize))").font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.spBlue).frame(width: 24)
                        }
                        ZStack {
                            Color(.secondarySystemBackground)
                            CutoutShape(cutoutRadius: cutoutSize)
                                .fill(Color.spBlue, style: FillStyle(eoFill: true))
                                .frame(width: 160, height: 120)
                                .animation(.easeInOut(duration: 0.12), value: cutoutSize)

                        }
                        .frame(maxWidth: .infinity).frame(height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        Text("Even-odd fill (eoFill: true) - overlapping subpaths punch holes")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }

                default:
                    // Mask reveal
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Text("reveal:").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 48)
                            Slider(value: $revealProgress, in: 0...1).tint(.spBlue)
                            Text("\(Int(revealProgress * 100))%").font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.spBlue).frame(width: 36)
                        }
                        ZStack {
                            // Hidden layer
                            LinearGradient(colors: [Color.spBlue, Color(hex: "#0891B2"), Color(hex: "#BAE6FD")],
                                           startPoint: .leading, endPoint: .trailing)
                            // Mask layer - polygon reveals gradient
                            PolygonPath(sides: 6)
                                .trim(from: 0, to: revealProgress)
                                .stroke(.white, lineWidth: 80)
                                .frame(width: 140, height: 140)
                                .animation(.spring(response: 0.4), value: revealProgress)
                                .blendMode(.sourceAtop)
                        }
                        .compositingGroup()
                        .frame(maxWidth: .infinity).frame(height: 240)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        
                        Text("Trim on a wide stroke + .destinationIn blend mode reveals content along the path")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

struct CutoutShape: Shape {
    var cutoutRadius: CGFloat
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.addRoundedRect(in: rect, cornerSize: CGSize(width: 12, height: 12))
        let cr  = cutoutRadius
        let cx  = rect.midX
        let cy  = rect.midY
        p.addEllipse(in: CGRect(x: cx - cr, y: cy - cr, width: cr * 2, height: cr * 2))
        return p
    }
}

struct ComposingShapesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Composing shapes")
            Text("Complex shapes are built from simpler ones. Layer them with ZStack, punch holes with even-odd fill, reveal content with masks, or combine paths programmatically. The Fill Style and blend modes give you full control over how overlapping shapes interact.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "ZStack - layer shapes with independent fills, strokes and z-order. Most common composition.", color: .spBlue)
                StepRow(number: 2, text: "Even-odd fill - .fill(color, style: FillStyle(eoFill: true)) - overlapping sub-paths become transparent holes.", color: .spBlue)
                StepRow(number: 3, text: "Combine paths - path.addPath(otherPath) merges two paths into one for a single fill.", color: .spBlue)
                StepRow(number: 4, text: ".mask { shape } - uses the shape's alpha to mask the parent view. White = visible, clear = hidden.", color: .spBlue)
                StepRow(number: 5, text: ".blendMode(.destinationIn) + .compositingGroup() - an advanced mask that composites correctly.", color: .spBlue)
            }

            CalloutBox(style: .info, title: "Even-odd fill for donut shapes", contentBody: "To punch a circular hole in a rectangle (like a notification badge background), add both paths to the same Path and use FillStyle(eoFill: true). Where paths overlap an odd number of times, SwiftUI draws the fill. Where they overlap an even number of times, it leaves transparent.")

            CodeCode(code: """
// ZStack composition
ZStack {
    Circle().fill(.blue.opacity(0.2))
    Circle().strokeBorder(.blue, lineWidth: 2).padding(8)
    Star().fill(.blue)
}

// Even-odd cutout
struct RingShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.addEllipse(in: rect)            // outer circle
        p.addEllipse(in: rect.insetBy(dx: 20, dy: 20)) // inner hole
        return p
    }
}
RingShape()
    .fill(.blue, style: FillStyle(eoFill: true))

// Mask with shape
Text("Masked!")
    .font(.largeTitle.bold())
    .mask {
        LinearGradient(
            colors: [.black, .clear],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

// Combine paths
var combined = Path()
combined.addPath(outerPath)
combined.addPath(innerPath)
""")
        }
    }
}

// Alias to avoid duplication
private struct CodeCode: View {
    let code: String
    var body: some View { CodeBlock(code: code) }
}

