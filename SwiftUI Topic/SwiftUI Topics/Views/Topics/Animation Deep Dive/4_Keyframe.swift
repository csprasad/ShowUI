//
//
//  4_Keyframe.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Keyframe Animations
struct KeyframeVisual: View {
    @State private var trigger      = false
    @State private var selectedDemo = 0
    let demos = ["Bounce", "Elastic pull", "Multi-track"]

    struct BounceValues {
        var scale: CGFloat    = 1
        var offsetY: CGFloat  = 0
        var rotation: Double  = 0
        var opacity: Double   = 1
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Keyframe animations", systemImage: "timeline.selection")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.anAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; trigger = false }
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
                        // Bounce keyframes
                        KeyframeAnimator(initialValue: BounceValues(), trigger: trigger) { values in
                            ZStack {
                                Ellipse()
                                    .fill(Color.anAmber.opacity(0.3))
                                    .frame(width: 50 * values.scale, height: 8)
                                    .offset(y: 36)
                                    .scaleEffect(x: 1 / max(values.scale, 0.5))
                                Circle()
                                    .fill(LinearGradient(colors: [Color.anAmber, Color(hex: "#F59E0B")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 50, height: 50)
                                    .scaleEffect(values.scale)
                                    .offset(y: values.offsetY)
                            }
                        } keyframes: { _ in
                            KeyframeTrack(\.offsetY) {
                                LinearKeyframe(0, duration: 0.05)
                                SpringKeyframe(-60, duration: 0.25, spring: .bouncy)
                                SpringKeyframe(0, duration: 0.3, spring: .bouncy(extraBounce: 0.1))
                                SpringKeyframe(-20, duration: 0.2, spring: .bouncy)
                                SpringKeyframe(0, duration: 0.2, spring: .bouncy)
                            }
                            KeyframeTrack(\.scale) {
                                LinearKeyframe(1, duration: 0.05)
                                LinearKeyframe(0.8, duration: 0.1)
                                LinearKeyframe(1.15, duration: 0.2)
                                LinearKeyframe(0.95, duration: 0.15)
                                LinearKeyframe(1, duration: 0.1)
                            }
                        }

                    case 1:
                        // Elastic pull
                        KeyframeAnimator(initialValue: BounceValues(), trigger: trigger) { values in
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(LinearGradient(colors: [Color(hex: "#7C3AED"), Color(hex: "#4F46E5")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 80, height: 60)
                                .scaleEffect(x: values.scale, y: 1 / max(values.scale * 0.6, 0.5))
                                .rotationEffect(.degrees(values.rotation))
                        } keyframes: { _ in
                            KeyframeTrack(\.scale) {
                                LinearKeyframe(1, duration: 0.05)
                                SpringKeyframe(1.5, duration: 0.15, spring: .snappy)
                                SpringKeyframe(0.7, duration: 0.2, spring: .bouncy)
                                SpringKeyframe(1.2, duration: 0.2, spring: .bouncy)
                                SpringKeyframe(1, duration: 0.25, spring: .smooth)
                            }
                            KeyframeTrack(\.rotation) {
                                LinearKeyframe(0, duration: 0.1)
                                CubicKeyframe(-15, duration: 0.2)
                                CubicKeyframe(15, duration: 0.2)
                                CubicKeyframe(-8, duration: 0.15)
                                CubicKeyframe(0, duration: 0.15)
                            }
                        }

                    default:
                        // Multi-track - all properties
                        KeyframeAnimator(initialValue: BounceValues(), trigger: trigger) { values in
                            HStack(spacing: 12) {
                                ForEach(0..<3, id: \.self) { i in
                                    Circle()
                                        .fill(gridCellColors[i])
                                        .frame(width: 40, height: 40)
                                        .scaleEffect(values.scale)
                                        .offset(y: values.offsetY * (i == 1 ? 1.5 : 1))
                                        .opacity(values.opacity)
                                        .rotationEffect(.degrees(values.rotation * (i == 0 ? -1 : 1)))
                                }
                            }
                        } keyframes: { _ in
                            // TRACK 1: Y-OFFSET (Total: 0.7s)
                            KeyframeTrack(\.offsetY) {
                                SpringKeyframe(-50, duration: 0.3, spring: .bouncy)
                                SpringKeyframe(10, duration: 0.2, spring: .bouncy)
                                SpringKeyframe(0, duration: 0.2, spring: .smooth)
                            }
                            
                            // TRACK 2: SCALE (Total: 0.7s)
                            KeyframeTrack(\.scale) {
                                LinearKeyframe(1.0, duration: 0.1) // Hold briefly
                                CubicKeyframe(1.3, duration: 0.2)  // Stretch
                                CubicKeyframe(0.8, duration: 0.2)  // Squash
                                SpringKeyframe(1.0, duration: 0.2, spring: .smooth)
                            }
                            
                            // TRACK 3: ROTATION (Total: 0.7s)
                            KeyframeTrack(\.rotation) {
                                LinearKeyframe(0, duration: 0.1)
                                CubicKeyframe(30, duration: 0.3)
                                CubicKeyframe(0, duration: 0.3)
                            }
                            
                            // TRACK 4: OPACITY (Total: 0.7s)
                            KeyframeTrack(\.opacity) {
                                LinearKeyframe(1.0, duration: 0.2)
                                CubicKeyframe(0.4, duration: 0.2)
                                CubicKeyframe(1.0, duration: 0.3)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                Button {
                    trigger.toggle()
                } label: {
                    Text("Play keyframe")
                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(Color.anAmber).clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
    }
}

struct KeyframeExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "KeyframeAnimator - iOS 17+")
            Text("KeyframeAnimator lets you define multi-step animations with independent tracks per property. Each KeyframeTrack controls one property through a series of keyframes with different timing and spring characteristics.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "KeyframeAnimator(initialValue:trigger:) { values in view } keyframes: { _ in tracks }", color: .anAmber)
                StepRow(number: 2, text: "KeyframeTrack(\\.property) { keyframes } - one track per animated property.", color: .anAmber)
                StepRow(number: 3, text: "LinearKeyframe(value, duration:) - jumps to value linearly over duration.", color: .anAmber)
                StepRow(number: 4, text: "SpringKeyframe(value, duration:, spring:) - spring physics to reach value.", color: .anAmber)
                StepRow(number: 5, text: "CubicKeyframe(value, duration:) - cubic Bézier easing between keyframes.", color: .anAmber)
                StepRow(number: 6, text: "Tracks run in parallel - different properties animate simultaneously but independently.", color: .anAmber)
            }

            CalloutBox(style: .success, title: "Keyframes for realistic motion", contentBody: "Real physical motion squashes and stretches, overshoots and settles. Keyframes let you choreograph this precisely - scale up on launch, squash on impact, bounce back. Much more expressive than a single spring.")

            CodeBlock(code: """
struct BallValues {
    var offsetY: CGFloat = 0
    var scale: CGFloat = 1
}

KeyframeAnimator(
    initialValue: BallValues(),
    trigger: isBouncing
) { values in
    Circle()
        .scaleEffect(y: values.scale)
        .offset(y: values.offsetY)
} keyframes: { _ in
    KeyframeTrack(\\.offsetY) {
        LinearKeyframe(0, duration: 0.05)
        SpringKeyframe(-60, duration: 0.3, spring: .bouncy)
        SpringKeyframe(0, duration: 0.3,
                       spring: .bouncy(extraBounce: 0.1))
    }
    KeyframeTrack(\\.scale) {
        LinearKeyframe(1, duration: 0.1)
        CubicKeyframe(1.3, duration: 0.2)  // stretch up
        CubicKeyframe(0.7, duration: 0.1)  // squash on land
        SpringKeyframe(1, duration: 0.2, spring: .smooth)
    }
}
""")
        }
    }
}

