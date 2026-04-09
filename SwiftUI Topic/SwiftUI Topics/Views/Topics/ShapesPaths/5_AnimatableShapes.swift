//
//
//  5_AnimatableShapes.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Animatable Shapes
struct MorphingBlob: Shape {
    var morphAmount: CGFloat   // 0 = circle, 1 = blob

    var animatableData: CGFloat {
        get { morphAmount }
        set { morphAmount = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let cx   = rect.midX
        let cy   = rect.midY
        let base = min(rect.width, rect.height) / 2

        let offsets: [CGFloat] = [1.0, 0.85, 1.15, 0.9, 1.1, 0.8, 1.2, 0.95]
        let count = offsets.count
        var points: [CGPoint] = []

        for i in 0..<count {
            let angle  = (Double(i) / Double(count)) * 2 * .pi - .pi / 2
            let r      = base * (1 + (offsets[i] - 1) * morphAmount)
            let x = CGFloat(cx + r * cos(angle))
            let y = CGFloat(cy + r * sin(angle))
            points.append(CGPoint(x: x, y: y))
        }

        var path = Path()
        path.move(to: points[0])
        for i in 0..<count {
            let curr = points[i]
            let next = points[(i + 1) % count]
            let mid  = CGPoint(x: (curr.x + next.x) / 2, y: (curr.y + next.y) / 2)
            path.addQuadCurve(to: mid, control: curr)
        }
        path.closeSubpath()
        return path
    }
}

struct WaveShape: Shape {
    var phase: CGFloat
    var amplitude: CGFloat

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(phase, amplitude) }
        set { phase = newValue.first; amplitude = newValue.second }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let mid  = rect.height * 0.5
        path.move(to: CGPoint(x: 0, y: mid))
        stride(from: 0, through: rect.width, by: 2).forEach { x in
            let y = mid - sin((x / rect.width * 2 * .pi) + phase) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

struct AnimatableShapesVisual: View {
    @State private var morphAmount: CGFloat  = 0
    @State private var wavePhase: CGFloat    = 0
    @State private var waveAmp: CGFloat      = 20
    @State private var isAnimating           = false
    @State private var selectedDemo          = 0

    let demos = ["Blob morph", "Wave", "Polygon morph"]
    let timer  = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Animatable shapes", systemImage: "sparkles")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.spBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedDemo = i
                                isAnimating  = false
                            }
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

                ZStack {
                    Color(.secondarySystemBackground)
                    switch selectedDemo {
                    case 0:
                        MorphingBlob(morphAmount: morphAmount)
                            .fill(LinearGradient(colors: [Color.spBlue, Color(hex: "#0891B2")],
                                                 startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 140, height: 140)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: morphAmount)
                    case 1:
                        WaveShape(phase: wavePhase, amplitude: waveAmp)
                            .fill(LinearGradient(colors: [Color.spBlue.opacity(0.4), Color.spBlue],
                                                 startPoint: .top, endPoint: .bottom))
                            .frame(maxWidth: .infinity).frame(height: 160)
                            .onReceive(timer) { _ in
                                if isAnimating { wavePhase += 0.08 }
                            }
                    default:
                        HStack(spacing: 20) {
                            PolygonPath(sides: isAnimating ? 6 : 3)
                                .fill(Color.spBlue)
                                .frame(width: 80, height: 80)
                                .animation(.spring(response: 0.7, dampingFraction: 0.5), value: isAnimating)
                            PolygonPath(sides: isAnimating ? 3 : 8)
                                .fill(Color(hex: "#0891B2"))
                                .frame(width: 80, height: 80)
                                .animation(.spring(response: 0.7, dampingFraction: 0.5).delay(0.15), value: isAnimating)
                        }
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 170)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Controls
                switch selectedDemo {
                case 0:
                    HStack(spacing: 8) {
                        sliderRow("morph", value: $morphAmount, range: 0...1, step: 0.01, format: "%.2f")
                        Button(isAnimating ? "Stop" : "Auto") {
                            withAnimation(.spring(response: 0.3)) { isAnimating.toggle() }
                        }
                        .font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(isAnimating ? Color.animCoral : Color.spBlue)
                        .clipShape(Capsule()).buttonStyle(PressableButtonStyle())
                        .onReceive(timer) { _ in
                            if isAnimating {
                                withAnimation(.easeInOut(duration: 1.5)) {
                                    morphAmount = morphAmount < 0.5 ? 1.0 : 0.0
                                }
                            }
                        }
                    }
                case 1:
                    HStack(spacing: 8) {
                        sliderRow("amp", value: $waveAmp, range: 5...50, step: 1)
                        Button(isAnimating ? "Pause" : "Play") {
                            withAnimation(.spring(response: 0.3)) { isAnimating.toggle() }
                        }
                        .font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(isAnimating ? Color.animCoral : Color.spBlue)
                        .clipShape(Capsule()).buttonStyle(PressableButtonStyle())
                    }
                default:
                    Button(isAnimating ? "Morph back" : "Morph shapes") {
                        withAnimation(.spring(response: 0.7, dampingFraction: 0.5)) { isAnimating.toggle() }
                    }
                    .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 10)
                    .background(Color.spBlue).clipShape(RoundedRectangle(cornerRadius: 10))
                    .buttonStyle(PressableButtonStyle())
                }
            }
        }
    }

    func sliderRow(_ label: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>, step: CGFloat = 1, format: String = "%.0f") -> some View {
        HStack(spacing: 6) {
            Text(label).font(.system(size: 10)).foregroundStyle(.secondary).frame(width: 28)
            Slider(value: value, in: range, step: step).tint(.spBlue)
            Text(String(format: format, value.wrappedValue)).font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.spBlue).frame(width: 28)
        }
    }
}

struct AnimatableShapesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Animatable shapes")
            Text("SwiftUI can interpolate between shape states if you expose the changing values via the animatableData property. This lets SwiftUI smoothly morph a shape from one configuration to another during animations.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "var animatableData: CGFloat { get/set } - single animatable value. Returns and sets the changing property.", color: .spBlue)
                StepRow(number: 2, text: "AnimatablePair<CGFloat, CGFloat> - two values. Nest more pairs for additional animated properties.", color: .spBlue)
                StepRow(number: 3, text: "SwiftUI calls path(in:) many times per frame with interpolated animatableData during animation.", color: .spBlue)
                StepRow(number: 4, text: "Any withAnimation { } call that changes an animatableData value triggers the morph animation.", color: .spBlue)
            }

            CalloutBox(style: .success, title: "Animate shape parameters directly", contentBody: "Once animatableData is set up, just change the shape's parameter inside withAnimation { } - the path smoothly interpolates. No keyframes or custom transitions needed.")

            CodeBlock(code: """
struct FluidBlob: Shape {
    var morph: CGFloat   // 0 = circle, 1 = blob

    // Tell SwiftUI which property to interpolate
    var animatableData: CGFloat {
        get { morph }
        set { morph = newValue }
    }

    func path(in rect: CGRect) -> Path {
        // Use morph to adjust control points
        ...
    }
}

// Multiple animated values
struct WaveShape: Shape {
    var phase: CGFloat
    var amplitude: CGFloat

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(phase, amplitude) }
        set { phase = newValue.first; amplitude = newValue.second }
    }
}

// Animation just works
withAnimation(.easeInOut(duration: 1)) {
    blobMorph = 1.0   // smoothly morphs to blob
}
""")
        }
    }
}
