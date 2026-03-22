//
//
//  4_Repeat.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Repeat & Autoreverse
struct RepeatVisual: View {
    @State private var isRunning = false
    @State private var selectedMode = 0
    @State private var repeatCount = 3
    @State private var autoreverses = true

    @State private var pulse = false
    @State private var rotate = false
    @State private var bounce = false

    let modes = ["repeatCount", "repeatForever", "Custom"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Repeat & autoreverse", systemImage: "repeat")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.animCoral)

                // Three simultaneous animated elements
                HStack(spacing: 0) {
                    // Pulsing circle
                    VStack(spacing: 8) {
                        Circle()
                            .fill(Color.animCoral)
                            .frame(width: 44, height: 44)
                            .scaleEffect(pulse ? 1.3 : 1.0)
                            .opacity(pulse ? 0.6 : 1.0)
                        Text("scale + opacity")
                            .font(.system(size: 9))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)

                    // Rotating square
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: "#993C1D"))
                            .frame(width: 40, height: 40)
                            .rotationEffect(.degrees(rotate ? 360 : 0))
                        Text("rotation")
                            .font(.system(size: 9))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)

                    // Bouncing dot
                    VStack(spacing: 8) {
                        Circle()
                            .fill(Color(hex: "#854F0B"))
                            .frame(width: 20, height: 20)
                            .offset(y: bounce ? -24 : 0)
                        Text("offset")
                            .font(.system(size: 9))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Play / Stop
                Button(isRunning ? "Stop" : "Start") {
                    isRunning ? stopAll() : startAll()
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isRunning ? Color(.systemFill) : Color.animCoral)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .buttonStyle(PressableButtonStyle())

                // Mode selector
                HStack(spacing: 8) {
                    ForEach(modes.indices, id: \.self) { i in
                        Button(modes[i]) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedMode = i
                                stopAll()
                            }
                        }
                        .font(.system(size: 11, weight: selectedMode == i ? .semibold : .regular))
                        .foregroundStyle(selectedMode == i ? Color.animCoral : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(selectedMode == i ? Color(hex: "#FAECE7") : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Options
                if selectedMode == 0 {
                    HStack(spacing: 10) {
                        Text("Count")
                            .font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 40)
                        Slider(value: Binding(get: { CGFloat(repeatCount) }, set: { repeatCount = Int($0) }),
                               in: 1...8, step: 1).tint(.animCoral)
                        Text("\(repeatCount)×")
                            .font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 28)
                    }
                }

                if selectedMode != 2 {
                    Toggle("Autoreverse", isOn: $autoreverses)
                        .font(.system(size: 13))
                        .tint(.animCoral)
                        .onChange(of: autoreverses) { stopAll() }
                }
            }
        }
    }

    func animation(for base: Animation) -> Animation {
        switch selectedMode {
        case 0: return base.repeatCount(repeatCount, autoreverses: autoreverses)
        case 1: return base.repeatForever(autoreverses: autoreverses)
        default: return base.repeatCount(2, autoreverses: true)
        }
    }

    func startAll() {
        isRunning = true
        withAnimation(animation(for: .easeInOut(duration: 0.7))) { pulse = true }
        withAnimation(animation(for: .linear(duration: 1.0))) { rotate = true }
        withAnimation(animation(for: .spring(duration: 0.4, bounce: 0.5))) { bounce = true }
    }

    func stopAll() {
        isRunning = false
        withAnimation(.easeOut(duration: 0.3)) {
            pulse = false; rotate = false; bounce = false
        }
    }
}

struct RepeatExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Repeating animations")
            Text("Any animation can be repeated a fixed number of times or looped forever. Autoreverse plays forward then backward, without it the animation jumps back to the start between repetitions.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".repeatCount(3) — plays 3 times then stops.", color: .animCoral)
                StepRow(number: 2, text: ".repeatForever() — loops until the view disappears or state resets.", color: .animCoral)
                StepRow(number: 3, text: "autoreverses: true — plays forward then backward, creating a smooth loop.", color: .animCoral)
                StepRow(number: 4, text: "autoreverses: false — snaps back to start between repeats. Useful for loaders.", color: .animCoral)
            }

            CalloutBox(style: .warning, title: "Stop repeatForever carefully", contentBody: "A repeatForever animation keeps running even if the trigger state changes. Set the animated value back to its original with a non-repeating animation to stop it cleanly.")

            CalloutBox(style: .info, title: "Pulse effect pattern", contentBody: "Scale + opacity with repeatForever and autoreverses: true is the standard way to build a heartbeat or notification pulse effect.")

            CodeBlock(code: """
// Fixed repeat
withAnimation(.easeInOut(duration: 0.5).repeatCount(3)) {
    scale = 1.2
}

// Infinite loop — smooth with autoreverse
withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
    isPulsing = true
}

// Spinner — linear, no autoreverse
withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
    rotation = 360
}
""")
        }
    }
}
