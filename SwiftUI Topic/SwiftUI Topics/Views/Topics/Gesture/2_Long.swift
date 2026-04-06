//
//
//  2_Long.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: LongPressGesture
struct LongPressGestureVisual: View {
    @State private var isPressed = false
    @State private var isActivated = false
    @State private var progress: CGFloat = 0
    @State private var activationCount = 0
    @State private var minimumDuration: Double = 0.8

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("LongPressGesture", systemImage: "hand.point.up.left.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gesturePink)

                // Hold duration slider
                HStack(spacing: 10) {
                    Text("duration").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 52)
                    Slider(value: $minimumDuration, in: 0.2...2.0, step: 0.2).tint(.gesturePink)
                    Text("\(minimumDuration, specifier: "%.1f")s")
                        .font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 32)
                }

                // Main hold target
                ZStack {
                    Color(.secondarySystemBackground)
                    // Progress ring
                    Circle()
                        .stroke(Color.gesturePink.opacity(0.2), lineWidth: 6)
                        .frame(width: 80, height: 80)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.gesturePink, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: minimumDuration), value: progress)

                    VStack(spacing: 4) {
                        Image(systemName: isActivated ? "checkmark.circle.fill" : "hand.point.up.left.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(isActivated ? Color.animTeal : (isPressed ? Color.gesturePink : Color(.systemGray3)))
                            .animation(.spring(duration: 0.3, bounce: 0.4), value: isActivated)
                        Text(isActivated ? "Activated! ✓" : isPressed ? "Hold…" : "Hold me")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(isActivated ? Color.animTeal : .secondary)
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .scaleEffect(isPressed ? 0.96 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                .gesture(
                    LongPressGesture(minimumDuration: minimumDuration)
                        .onChanged { isPressing in
                            isPressed = isPressing
                            progress = isPressing ? 1.0 : 0.0
                            if !isPressing { withAnimation(.easeOut(duration: 0.2)) { progress = 0 } }
                        }
                        .onEnded { _ in
                            isActivated = true
                            activationCount += 1
                            isPressed = false
                            progress = 0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                withAnimation { isActivated = false }
                            }
                        }
                )

                HStack(spacing: 8) {
                    Image(systemName: "hand.point.up.left.fill").font(.system(size: 12)).foregroundStyle(Color.gesturePink)
                    Text("Activated \(activationCount) time\(activationCount == 1 ? "" : "s")")
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                    Spacer()
                    if activationCount > 0 {
                        Button("Reset") { activationCount = 0 }
                            .font(.system(size: 12)).foregroundStyle(Color.gesturePink)
                    }
                }
                .padding(10).background(Color.gesturePinkLight).clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

struct LongPressGestureExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "LongPressGesture")
            Text("LongPressGesture recognises a press held for at least a minimum duration. It gives you two moments to respond: when pressing starts/stops (onChanged) and when the hold completes successfully (onEnded).")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "LongPressGesture(minimumDuration: 0.5) - fires after 0.5s. Default is 0.5s.", color: .gesturePink)
                StepRow(number: 2, text: ".onChanged { isPressing in } - called immediately when press starts (true) and when finger lifts before completion (false).", color: .gesturePink)
                StepRow(number: 3, text: ".onEnded { _ in } - called only when the hold duration is met successfully.", color: .gesturePink)
                StepRow(number: 4, text: "maximumDistance: - if the finger moves more than this distance, the gesture fails. Default is 10pt.", color: .gesturePink)
            }

            CalloutBox(style: .success, title: "Show progress during the hold", contentBody: "Use onChanged to start a progress animation when isPressing becomes true and cancel it when false. This gives the user feedback that something is happening - essential for any hold longer than ~0.3s.")

            CalloutBox(style: .info, title: "Combine with haptics", contentBody: "UIImpactFeedbackGenerator or sensoryFeedback(.impact) when the long press completes makes the interaction feel native. Trigger it in onEnded.")

            CodeBlock(code: """
@State private var isPressed = false

// Simple long press
.onLongPressGesture(minimumDuration: 0.5) {
    showContextMenu()
}

// With press feedback
.gesture(
    LongPressGesture(minimumDuration: 0.8)
        .onChanged { isPressing in
            withAnimation { isPressed = isPressing }
        }
        .onEnded { _ in
            triggerHaptic()
            activateFeature()
        }
)
.scaleEffect(isPressed ? 0.95 : 1.0)
.animation(.spring(response: 0.3), value: isPressed)

// With maximum distance
LongPressGesture(
    minimumDuration: 0.5,
    maximumDistance: 5  // fails if finger moves > 5pt
)
""")
        }
    }
}

