//
//
//  12_AnimatableShapes.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 12: Animatable Shapes
struct AnimatableShapesVisual: View {
    @State private var progress: CGFloat = 0.5
    @State private var cornerRadius: CGFloat = 20
    @State private var sides: CGFloat = 3
    @State private var selectedDemo = 0

    let demos = ["Morph corners", "Polygon", "Progress ring"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Animatable shapes", systemImage: "scribble.variable")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.animCoral)

                // Demo selector
                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button(demos[i]) {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        }
                        .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                        .foregroundStyle(selectedDemo == i ? Color.animCoral : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(selectedDemo == i ? Color(hex: "#FAECE7") : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Live preview
                ZStack {
                    Color(.secondarySystemBackground)
                    switch selectedDemo {
                    case 0: morphDemo
                    case 1: polygonDemo
                    default: ringDemo
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Controls
                switch selectedDemo {
                case 0:
                    sliderRow(label: "Radius", value: $cornerRadius, range: 0...80, format: "%.0fpt") {
                        withAnimation(.spring(duration: 0.5, bounce: 0.3)) {}
                    }
                case 1:
                    sliderRow(label: "Sides", value: $sides, range: 3...12, format: "%.0f") {
                        withAnimation(.spring(duration: 0.5, bounce: 0.3)) {}
                    }
                default:
                    sliderRow(label: "Progress", value: $progress, range: 0...1, format: "%.0f%%", scale: 100) {
                        withAnimation(.spring(duration: 0.5, bounce: 0.3)) {}
                    }
                }
            }
        }
    }

    var morphDemo: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color.animCoral)
            .frame(width: 110, height: 110)
            .animation(.spring(duration: 0.5, bounce: 0.3), value: cornerRadius)
    }

    var polygonDemo: some View {
        PolygonShape(sides: Int(sides))
            .fill(
                LinearGradient(colors: [Color.animCoral, Color(hex: "#712B13")],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .frame(width: 110, height: 110)
            .animation(.spring(duration: 0.6, bounce: 0.4), value: sides)
    }

    var ringDemo: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemFill), lineWidth: 12)
                .frame(width: 100, height: 100)
            ProgressRingShape(progress: progress)
                .stroke(Color.animCoral, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(-90))
                .animation(.spring(duration: 0.6, bounce: 0.2), value: progress)
            Text("\(Int(progress * 100))%")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.animCoral)
        }
    }

    func sliderRow(label: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>, format: String, scale: CGFloat = 1, action: @escaping () -> Void) -> some View {
        HStack(spacing: 10) {
            Text(label).font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 60, alignment: .leading)
            Slider(value: value, in: range).tint(.animCoral)
            Text(String(format: format, value.wrappedValue * scale))
                .font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 40)
        }
    }
}

// MARK: - Polygon Shape (Animatable)
struct PolygonShape: Shape {
    var sides: Int
    var animatableData: CGFloat {
        get { CGFloat(sides) }
        set { sides = Int(newValue.rounded()) }
    }
    func path(in rect: CGRect) -> Path {
        let n = max(3, sides)
        let cx = rect.midX, cy = rect.midY
        let r = min(rect.width, rect.height) / 2
        var path = Path()
        for i in 0..<n {
            let angle = CGFloat(i) * 2 * .pi / CGFloat(n) - .pi / 2
            let pt = CGPoint(x: cx + r * cos(angle), y: cy + r * sin(angle))
            i == 0 ? path.move(to: pt) : path.addLine(to: pt)
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Progress Ring Shape (Animatable)
struct ProgressRingShape: Shape {
    var progress: CGFloat
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: min(rect.width, rect.height) / 2,
                startAngle: .degrees(0),
                endAngle: .degrees(360 * progress),
                clockwise: false
            )
        }
    }
}

struct AnimatableShapesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Animatable shapes")
            Text("Any custom Shape can be animated by conforming animatableData to Animatable. SwiftUI interpolates the data between states, and for every intermediate value drives a redrawn path, producing smooth morphing animations.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Conform your Shape to Animatable and implement animatableData.", color: .animCoral)
                StepRow(number: 2, text: "animatableData is the value SwiftUI interpolates - expose whichever properties drive your path.", color: .animCoral)
                StepRow(number: 3, text: "When animatableData changes, path(in:) is called on every frame with the interpolated value.", color: .animCoral)
                StepRow(number: 4, text: "For multiple animated properties, use AnimatablePair<A, B> as the animatableData type.", color: .animCoral)
            }

            CalloutBox(style: .info, title: "AnimatablePair for multiple values", contentBody: "animatableData can only be one value. To animate two properties simultaneously, use AnimatablePair<CGFloat, CGFloat> they nest: AnimatablePair<A, AnimatablePair<B, C>> for three.")

            CodeBlock(code: """
struct ProgressRingShape: Shape {
    var progress: CGFloat  // 0.0 to 1.0

    // Tell SwiftUI what to interpolate
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        Path { p in
            p.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.width / 2,
                startAngle: .degrees(0),
                endAngle: .degrees(360 * progress),
                clockwise: false
            )
        }
    }
}

// Animate it like any shape
ProgressRingShape(progress: progress)
    .stroke(.blue, lineWidth: 8)
    .animation(.spring(duration: 0.6), value: progress)
""")
        }
    }
}
