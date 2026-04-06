//
//
//  6_KeyframeAnimator.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Keyframe Animator
struct KeyframeAnimatorVisual: View {
    @State private var trigger = 0
    @State private var selectedDemo = 0

    let demos = ["Notification", "Like button", "Emoji pop"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("KeyframeAnimator", systemImage: "slider.horizontal.3")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.animTeal)
                    Spacer()
                    Text("iOS 17+")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.animTeal)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color(hex: "#E1F5EE"))
                        .clipShape(Capsule())
                }

                // Demo area
                ZStack {
                    Color(.secondarySystemBackground)
                    switch selectedDemo {
                    case 0: notificationDemo
                    case 1: likeButtonDemo
                    default: emojiPopDemo
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Trigger
                Button {
                    trigger += 1
                } label: {
                    Text("Trigger")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.animTeal)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PressableButtonStyle())

                // Demo selector
                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button(demos[i]) {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; trigger = 0 }
                        }
                        .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                        .foregroundStyle(selectedDemo == i ? Color.animTeal : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(selectedDemo == i ? Color(hex: "#E1F5EE") : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
        }
    }

    // MARK: - Notification pop
    var notificationDemo: some View {
        struct KFValues {
            var offsetY: CGFloat = -60
            var scale: CGFloat = 0.8
            var opacity: CGFloat = 0
        }

        return KeyframeAnimator(initialValue: KFValues(), trigger: trigger) { values in
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .frame(width: 240, height: 60)
                .overlay(
                    HStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.animTeal)
                            .frame(width: 36, height: 36)
                            .overlay(Image(systemName: "bell.fill").foregroundStyle(.white).font(.system(size: 16)))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("New message").font(.system(size: 12, weight: .semibold))
                            Text("Hey, are you free?").font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                )
                .shadow(color: .black.opacity(0.1), radius: 12, y: 4)
                .offset(y: values.offsetY)
                .scaleEffect(values.scale)
                .opacity(values.opacity)
        } keyframes: { _ in
            KeyframeTrack(\.offsetY) {
                SpringKeyframe(-60, duration: 0.01)
                SpringKeyframe(0, duration: 0.5, spring: .bouncy)
                LinearKeyframe(0, duration: 1.5)
                SpringKeyframe(-60, duration: 0.3, spring: .smooth)
            }
            KeyframeTrack(\.scale) {
                LinearKeyframe(0.8, duration: 0.01)
                SpringKeyframe(1.0, duration: 0.5, spring: .bouncy)
                LinearKeyframe(1.0, duration: 1.5)
                SpringKeyframe(0.8, duration: 0.3, spring: .smooth)
            }
            KeyframeTrack(\.opacity) {
                LinearKeyframe(0, duration: 0.01)
                LinearKeyframe(1, duration: 0.1)
                LinearKeyframe(1, duration: 1.7)
                LinearKeyframe(0, duration: 0.3)
            }
        }
    }

    // MARK: - Like button
    var likeButtonDemo: some View {
        struct KFValues {
            var scale: CGFloat = 1
            var rotation: CGFloat = 0
            var color: CGFloat = 0
        }

        return KeyframeAnimator(initialValue: KFValues(), trigger: trigger) { values in
            Image(systemName: values.color > 0.5 ? "heart.fill" : "heart")
                .font(.system(size: 60))
                .foregroundStyle(values.color > 0.5 ? Color.animCoral : Color(.systemGray3))
                .scaleEffect(values.scale)
                .rotationEffect(.degrees(values.rotation))
        } keyframes: { _ in
            KeyframeTrack(\.scale) {
                SpringKeyframe(0.7, duration: 0.15, spring: .snappy)
                SpringKeyframe(1.3, duration: 0.2, spring: .bouncy)
                SpringKeyframe(1.0, duration: 0.3, spring: .smooth)
            }
            KeyframeTrack(\.rotation) {
                LinearKeyframe(-15, duration: 0.1)
                LinearKeyframe(15, duration: 0.15)
                SpringKeyframe(0, duration: 0.25, spring: .bouncy)
            }
            KeyframeTrack(\.color) {
                LinearKeyframe(0, duration: 0.1)
                LinearKeyframe(1, duration: 0.1)
                LinearKeyframe(1, duration: 0.5)
            }
        }
    }

    // MARK: - Emoji pop
    var emojiPopDemo: some View {
        struct KFValues {
            var scale: CGFloat = 0
            var offsetY: CGFloat = 20
            var opacity: CGFloat = 0
            var rotation: CGFloat = -20
        }

        return KeyframeAnimator(initialValue: KFValues(), trigger: trigger) { values in
            Text("🎉")
                .font(.system(size: 60))
                .scaleEffect(values.scale)
                .offset(y: values.offsetY)
                .opacity(values.opacity)
                .rotationEffect(.degrees(values.rotation))
        } keyframes: { _ in
            KeyframeTrack(\.scale) {
                SpringKeyframe(0, duration: 0.01)
                SpringKeyframe(1.4, duration: 0.4, spring: .bouncy)
                SpringKeyframe(1.0, duration: 0.3, spring: .smooth)
                LinearKeyframe(1.0, duration: 0.5)
                SpringKeyframe(0, duration: 0.3, spring: .smooth)
            }
            KeyframeTrack(\.offsetY) {
                LinearKeyframe(20, duration: 0.01)
                SpringKeyframe(-10, duration: 0.4, spring: .bouncy)
                SpringKeyframe(0, duration: 0.3, spring: .smooth)
                LinearKeyframe(0, duration: 0.5)
                LinearKeyframe(-20, duration: 0.3)
            }
            KeyframeTrack(\.opacity) {
                LinearKeyframe(0, duration: 0.01)
                LinearKeyframe(1, duration: 0.1)
                LinearKeyframe(1, duration: 0.9)
                LinearKeyframe(0, duration: 0.3)
            }
            KeyframeTrack(\.rotation) {
                LinearKeyframe(-20, duration: 0.01)
                SpringKeyframe(0, duration: 0.4, spring: .bouncy)
                LinearKeyframe(0, duration: 0.8)
            }
        }
    }
}

struct KeyframeAnimatorExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "KeyframeAnimator - iOS 17+")
            Text("KeyframeAnimator gives you frame-by-frame control over multiple properties simultaneously on a precise timeline. Each property has its own track with independent keyframes and timing like a proper animation timeline editor.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Define a value type holding all animatable properties.", color: .animTeal)
                StepRow(number: 2, text: "The content closure receives the current interpolated values, and you can use them to style your view.", color: .animTeal)
                StepRow(number: 3, text: "The keyframes closure defines a KeyframeTrack per property, with one or more keyframes for each with its own timing.", color: .animTeal)
                StepRow(number: 4, text: "SpringKeyframe, LinearKeyframe, CubicKeyframe mix them per track.", color: .animTeal)
            }

            CalloutBox(style: .success, title: "PhaseAnimator vs KeyframeAnimator", contentBody: "PhaseAnimator for sequential multi-step effects with the same properties each phase. KeyframeAnimator for simultaneous multi-property animations with precise timing per property.")

            CodeBlock(code: """
struct KFValues {
    var scale: CGFloat = 1
    var opacity: CGFloat = 1
    var offsetY: CGFloat = 0
}

KeyframeAnimator(initialValue: KFValues(), trigger: tapped) { values in
    Circle()
        .scaleEffect(values.scale)
        .opacity(values.opacity)
        .offset(y: values.offsetY)
} keyframes: { _ in
    KeyframeTrack(\\.scale) {
        SpringKeyframe(1.4, duration: 0.2, spring: .bouncy)
        SpringKeyframe(1.0, duration: 0.3, spring: .smooth)
    }
    KeyframeTrack(\\.opacity) {
        LinearKeyframe(1, duration: 0.4)
        LinearKeyframe(0, duration: 0.3)
    }
    KeyframeTrack(\\.offsetY) {
        SpringKeyframe(-20, duration: 0.3, spring: .bouncy)
        SpringKeyframe(0, duration: 0.4, spring: .smooth)
    }
}
""")
        }
    }
}
