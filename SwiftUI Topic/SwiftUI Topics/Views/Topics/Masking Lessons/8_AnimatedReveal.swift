//
//
//  8_AnimatedReveal.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `19/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Animated Reveal
struct AnimatedRevealVisual: View {
    @State private var progress: CGFloat = 0
    @State private var isAnimating = false
    @State private var direction = 0  // 0=left-right, 1=top-bottom, 2=radial

    let directionNames = ["Left → Right", "Top → Bottom", "Radial"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Animated reveal", systemImage: "play.rectangle.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#993C1D"))
                    Spacer()
                    Button(isAnimating ? "Reset" : "Play") {
                        if isAnimating {
                            isAnimating = false
                            withAnimation(.easeOut(duration: 0.3)) { progress = 0 }
                        } else {
                            isAnimating = true
                            withAnimation(.easeInOut(duration: 2.0)) { progress = 1 }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) { isAnimating = false }
                        }
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 7)
                    .background(isAnimating ? Color(.systemFill) : Color(hex: "#993C1D"))
                    .clipShape(Capsule())
                    .buttonStyle(PressableButtonStyle())
                }

                // Live preview
                GeometryReader { geo in
                    ZStack {
                        Color(.secondarySystemBackground)
                        MaskBaseGradient()
                            .mask {
                                revealMask(size: geo.size)
                            }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .frame(height: 140)
                .animation(.easeInOut(duration: 0.2), value: direction)

                // Progress slider
                HStack(spacing: 10) {
                    Text("Progress")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Slider(value: $progress, in: 0...1)
                        .tint(Color(hex: "#993C1D"))
                        .disabled(isAnimating)
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .frame(width: 36)
                }

                // Direction selector
                HStack(spacing: 8) {
                    ForEach(directionNames.indices, id: \.self) { i in
                        Button(directionNames[i]) {
                            withAnimation(.easeInOut) { direction = i; progress = 0 }
                        }
                        .font(.system(size: 11, weight: direction == i ? .semibold : .regular))
                        .foregroundStyle(direction == i ? Color(hex: "#993C1D") : .secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(direction == i ? Color(hex: "#FAECE7") : Color(.systemFill))
                        .clipShape(Capsule())
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
        }
    }

    @ViewBuilder
    func revealMask(size: CGSize) -> some View {
        switch direction {
        case 0:
            Rectangle()
                .frame(width: size.width * progress)
                .frame(maxWidth: .infinity, alignment: .leading)
        case 1:
            Rectangle()
                .frame(height: size.height * progress)
                .frame(maxHeight: .infinity, alignment: .top)
        default:
            Circle()
                .scale(progress * 2.0)
                .frame(width: size.width, height: size.height)
        }
    }
}

struct AnimatedRevealExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Animating a mask")
            Text("Because masks are just SwiftUI views, they respond to @State changes and animations. Drive a progress value and use it to resize a Rectangle or scale a Circle inside the mask, and watch the content reveals as the mask grows.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Store a @State progress value from 0 to 1.", color: Color(hex: "#993C1D"))
                StepRow(number: 2, text: "Use progress to set the frame of a Rectangle inside the mask.", color: Color(hex: "#993C1D"))
                StepRow(number: 3, text: "Animate progress with withAnimation, and watch as the mask animates, revealing content.", color: Color(hex: "#993C1D"))
                StepRow(number: 4, text: "Use .scale() on a Circle for a radial reveal from the center.", color: Color(hex: "#993C1D"))
            }

            CalloutBox(style: .success, title: "Useful for onboarding", contentBody: "Animate a reveal on first appearance to draw attention to content. Combine with a spring animation for a satisfying elastic feel.")

            CodeBlock(code: """
@State private var progress: CGFloat = 0

// Trigger reveal
withAnimation(.easeInOut(duration: 1.5)) {
    progress = 1.0
}

// Left-to-right reveal mask
content
    .mask {
        GeometryReader { geo in
            Rectangle()
                .frame(width: geo.size.width * progress)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

// Radial reveal
content
    .mask {
        Circle()
            .scale(progress * 2)
    }
""")
        }
    }
}

