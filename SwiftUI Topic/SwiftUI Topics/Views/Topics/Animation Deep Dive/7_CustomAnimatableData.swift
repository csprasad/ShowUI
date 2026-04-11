//
//
//  7_CustomAnimatableData.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Custom AnimatableData
struct AnimatingNumber: AnimatableModifier {
    var number: Double
    var format: (Double) -> String

    var animatableData: Double {
        get { number }
        set { number = newValue }
    }

    func body(content: Content) -> some View {
        content.overlay(
            Text(format(number))
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(Color.anAmber)
                .fixedSize()
        )
    }
}

struct WaveRingShape: Shape {
    var progress: Double    // 0 … 1
    var waves: Int = 6

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let center   = CGPoint(x: rect.midX, y: rect.midY)
        let baseR    = min(rect.width, rect.height) * 0.35
        let amplitude: CGFloat = 8
        var path = Path()
        let steps = 120
        for i in 0...steps {
            let angle = (Double(i) / Double(steps)) * 2 * .pi
            let wave  = amplitude * sin(Double(waves) * angle - progress * 2 * .pi)
            let r     = baseR + wave
            let x     = center.x + r * cos(angle)
            let y     = center.y + r * sin(angle)
            let pt    = CGPoint(x: x, y: y)
            if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
        }
        path.closeSubpath()
        return path
    }
}

struct CustomAnimDataVisual: View {
    @State private var targetValue: Double  = 0
    @State private var displayValue: Double = 0
    @State private var waveProgress: Double = 0
    @State private var morphProgress: Double = 0
    @State private var isAnimating           = false
    @State private var selectedDemo          = 0

    let demos = ["Number counter", "Wave ring", "Shape morph"]
    let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Custom AnimatableData", systemImage: "function")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.anAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; isAnimating = false; displayValue = 0 }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 12, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.anAmber : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.anAmberLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                ZStack {
                    Color(.secondarySystemBackground)

                    switch selectedDemo {
                    case 0:
                        // Animated number counter
                        VStack(spacing: 16) {
                            ZStack {
                                Color.clear.frame(width: 1, height: 1)
                                    .modifier(AnimatingNumber(number: displayValue, format: { String(format: "$%.0f", $0) }))
                                    .animation(.spring(duration: 1.2, bounce: 0.1), value: displayValue)
                            }
                            .frame(height: 40)

                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                                ForEach([100.0, 500.0, 1234.0, 9999.0, 42.0, 0.0], id: \.self) { val in
                                    Button {
                                        withAnimation(.spring(duration: 1.2, bounce: 0.1)) { displayValue = val }
                                    } label: {
                                        Text("$\(Int(val))")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundStyle(displayValue == val ? .white : .anAmber)
                                            .frame(maxWidth: .infinity).padding(.vertical, 8)
                                            .background(displayValue == val ? Color.anAmber : Color.anAmberLight)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }
                        }
                        .padding(12)

                    case 1:
                        // Animated wave ring
                        WaveRingShape(progress: waveProgress)
                            .fill(LinearGradient(colors: [Color.anAmber, Color(hex: "#F59E0B")], startPoint: .top, endPoint: .bottom))
                            .frame(width: 120, height: 120)
                            .overlay(
                                Text(isAnimating ? "Rippling" : "Tap play")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(.white)
                            )
                            .animation(.linear(duration: 0.03), value: waveProgress)
                            .onReceive(timer) { _ in
                                if isAnimating { waveProgress += 0.04 }
                            }

                    default:
                        // Polygon morph
                        HStack(spacing: 20) {
                            PolygonPath(sides: 3)
                                .fill(LinearGradient(colors: [Color.anAmber, Color(hex: "#F59E0B")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 80, height: 80)
                            Text("→").font(.system(size: 20)).foregroundStyle(.secondary)
                            PolygonPath(sides: isAnimating ? 8 : 3)
                                .fill(LinearGradient(colors: [Color(hex: "#7C3AED"), Color(hex: "#4F46E5")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 80, height: 80)
                                .animation(.spring(duration: 0.8, bounce: 0.2), value: isAnimating)
                        }
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Controls
                if selectedDemo != 0 {
                    Button {
                        withAnimation(.spring(response: 0.3)) { isAnimating.toggle() }
                        if selectedDemo == 2 { } // handled by view
                    } label: {
                        Text(isAnimating ? "Pause" : "Play")
                            .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(isAnimating ? Color.animCoral : Color.anAmber)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(PressableButtonStyle())
                }
            }
        }
    }
}

struct CustomAnimDataExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Custom AnimatableData")
            Text("Conform your Shape or ViewModifier to expose animatable properties via animatableData. SwiftUI calls body() many times per frame with interpolated values - the result is a smooth animation between any two states.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Shape: var animatableData: Double { get { prop } set { prop = newValue } }", color: .anAmber)
                StepRow(number: 2, text: "AnimatableModifier - same pattern as Shape but modifies views. Great for counter animations.", color: .anAmber)
                StepRow(number: 3, text: "AnimatablePair<A, B> - animate two values: var animatableData: AnimatablePair<Double, Double>", color: .anAmber)
                StepRow(number: 4, text: "SwiftUI interpolates between old and new animatableData values and calls body() for each frame.", color: .anAmber)
                StepRow(number: 5, text: "Any Animation works - spring, easeInOut, linear - applied to the animatable property.", color: .anAmber)
            }

            CalloutBox(style: .info, title: "AnimatingNumber pattern", contentBody: "An AnimatableModifier that wraps a Double and renders Text(format(number)) gives you a smooth counting animation. Trigger with withAnimation { displayValue = targetValue } - the number counts up smoothly.")

            CodeBlock(code: """
// Animated counter modifier
struct CountingNumber: AnimatableModifier {
    var number: Double

    var animatableData: Double {
        get { number }
        set { number = newValue }
    }

    func body(content: Content) -> some View {
        content.overlay(
            Text(String(format: "%.0f", number))
                .font(.largeTitle.bold())
        )
    }
}

// Usage
@State private var value: Double = 0

Color.clear
    .modifier(CountingNumber(number: value))
    .animation(.spring(duration: 1.2), value: value)

Button("Count to 1000") {
    withAnimation(.spring(duration: 1.2)) {
        value = 1000
    }
}

// Animated shape
struct WaveShape: Shape {
    var phase: CGFloat

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
    // path uses phase for position
}
""")
        }
    }
}
