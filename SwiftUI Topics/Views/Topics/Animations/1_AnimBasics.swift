//
//
//  1_AnimBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: Animation Basics
struct AnimBasicsVisual: View {
    @State private var isOn = false
    @State private var duration: CGFloat = 0.4
    @State private var delay: CGFloat = 0.0
    @State private var selectedCurve = 0

    let curves: [(name: String, anim: (Double) -> Animation)] = [
        ("easeInOut", { .easeInOut(duration: $0) }),
        ("easeIn",    { .easeIn(duration: $0) }),
        ("easeOut",   { .easeOut(duration: $0) }),
        ("linear",    { .linear(duration: $0) }),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Animation basics", systemImage: "play.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.animPurple)

                // Animated subject - a card that moves, scales, changes color
                ZStack {
                    Color(.secondarySystemBackground)
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(isOn ? Color.animTeal : Color.animPurple)
                        .frame(width: isOn ? 120 : 60, height: isOn ? 120 : 60)
                        .offset(x: isOn ? 60 : -60)
                        .scaleEffect(isOn ? 1.1 : 1.0)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Reverse & Animate button
                Button {
                    withAnimation(
                        curves[selectedCurve].anim(duration).delay(delay)
                    ) { isOn.toggle() }
                } label: {
                    Text(isOn ? "Reverse" : "Animate")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.animPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PressableButtonStyle())

                // Duration slider
                HStack(spacing: 10) {
                    Text("Duration")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .frame(width: 60, alignment: .leading)
                    Slider(value: $duration, in: 0.1...2.0, step: 0.1)
                        .tint(.animPurple)
                    Text("\(duration, specifier: "%.1f")s")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .frame(width: 36)
                }

                // Delay slider
                HStack(spacing: 10) {
                    Text("Delay")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .frame(width: 60, alignment: .leading)
                    Slider(value: $delay, in: 0.0...1.0, step: 0.1)
                        .tint(.animPurple)
                    Text("\(delay, specifier: "%.1f")s")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .frame(width: 36)
                }

                // Curve selector
                HStack(spacing: 8) {
                    ForEach(curves.indices, id: \.self) { i in
                        Button(curves[i].name) {
                            selectedCurve = i
                        }
                        .font(.system(size: 10, weight: selectedCurve == i ? .semibold : .regular))
                        .foregroundStyle(selectedCurve == i ? Color.animPurple : .secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(selectedCurve == i ? Color(hex: "#EEEDFE") : Color(.systemFill))
                        .clipShape(Capsule())
                        .buttonStyle(PressableButtonStyle())
                    }
                }            }
        }
    }
}

struct AnimBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "How SwiftUI animations work")
            Text("SwiftUI animations are driven by state changes. When a @State value changes inside withAnimation { }, SwiftUI automatically interpolates all animatable properties like position, size, color, opacity between the old and new values.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Change state inside withAnimation { }. SwiftUI handles the rest.", color: .animPurple)
                StepRow(number: 2, text: "Set duration to control how long the animation takes.", color: .animPurple)
                StepRow(number: 3, text: "Set delay to wait before the animation starts.", color: .animPurple)
                StepRow(number: 4, text: "The .animation() modifier attaches an animation directly to a view, and it fires whenever the bound value changes.", color: .animPurple)
            }

            CalloutBox(style: .info, title: "withAnimation vs .animation()", contentBody: "withAnimation applies to a whole state change. .animation(_, value:) is scoped to one view and one value more precise, preferred in SwiftUI.")

            CodeBlock(code: """
// withAnimation - applies to all changes in the block
Button("Animate") {
    withAnimation(.easeInOut(duration: 0.4)) {
        isOn.toggle()
    }
}

// .animation modifier - scoped to this view + value
RoundedRectangle(cornerRadius: 12)
    .offset(x: isOn ? 60 : -60)
    .animation(.easeInOut(duration: 0.4), value: isOn)

// With delay
withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
    isOn.toggle()
}
""")
        }
    }
}
