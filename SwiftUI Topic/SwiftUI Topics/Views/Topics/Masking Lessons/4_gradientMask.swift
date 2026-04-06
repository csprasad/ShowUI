//
//
//  4_GradientMask.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `19/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Gradient Mask
struct GradientMaskVisual: View {
    @State private var direction = 0  // 0=bottom fade, 1=top fade, 2=left, 3=right, 4=centre
    @State private var fadePoint: CGFloat = 0.5

    let directions = ["Bottom fade", "Top fade", "Left fade", "Right fade", "Centre fade"]

    var startPoint: UnitPoint {
        switch direction {
        case 0: return .bottom
        case 1: return .top
        case 2: return .trailing
        case 3: return .leading
        default: return .center
        }
    }
    var endPoint: UnitPoint {
        switch direction {
        case 0: return .top
        case 1: return .bottom
        case 2: return .leading
        case 3: return .trailing
        default: return .top
        }
    }

    var maskGradient: some View {
        Group {
            if direction == 4 {
                RadialGradient(
                    colors: [.white, .black],
                    center: .center,
                    startRadius: 20,
                    endRadius: 100
                )
            } else {
                LinearGradient(
                    stops: [
                        .init(color: .black, location: 0),
                        .init(color: .black, location: max(0, fadePoint - 0.15)),
                        .init(color: .white, location: min(1, fadePoint + 0.15)),
                        .init(color: .white, location: 1),
                    ],
                    startPoint: startPoint,
                    endPoint: endPoint
                )
            }
        }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Gradient mask", systemImage: "rectangle.bottomthird.inset.filled")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#993C1D"))

                // Live preview
                ZStack {
                    Color(.secondarySystemBackground)
                    MaskBaseGradient()
                        .mask { maskGradient }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.easeInOut(duration: 0.3), value: direction)
                .animation(.easeInOut(duration: 0.1), value: fadePoint)

                // Fade point slider (only for linear)
                if direction != 4 {
                    HStack(spacing: 10) {
                        Text("Fade point")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                        Slider(value: $fadePoint, in: 0.15...0.85, step: 0.05)
                            .tint(Color(hex: "#993C1D"))
                        Text("\(Int(fadePoint * 100))%")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .frame(width: 36)
                    }
                }

                // Direction selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(directions.indices, id: \.self) { i in
                            Button(directions[i]) {
                                withAnimation(.spring(response: 0.3)) { direction = i }
                            }
                            .font(.system(size: 11, weight: direction == i ? .semibold : .regular))
                            .foregroundStyle(direction == i ? Color(hex: "#993C1D") : .secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(direction == i ? Color(hex: "#FAECE7") : Color(.systemFill))
                            .clipShape(Capsule())
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }
            }
        }
    }
}

struct GradientMaskExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Fading with gradient masks")
            Text("A gradient mask uses brightness to control transparency. Where the gradient is black, content is hidden. Where it's white, content is fully visible. In between, you get smooth partial transparency.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Create a LinearGradient from .black to .white (or .clear to .black for the opposite).", color: Color(hex: "#993C1D"))
                StepRow(number: 2, text: "Apply it as the mask, and as the gradient's brightness becomes the content's opacity.", color: Color(hex: "#993C1D"))
                StepRow(number: 3, text: "Use stops to control exactly where the fade starts and ends.", color: Color(hex: "#993C1D"))
                StepRow(number: 4, text: "RadialGradient creates a circular fade, which can be useful for vignette effects.", color: Color(hex: "#993C1D"))
            }

            CalloutBox(style: .success, title: "Common use case", contentBody: "Fading the bottom of a list or image into the background, or vice versa, is a common use case. This is why SwiftUI ships with GradientMask, which makes it easy to apply a black-to-white gradient mask from bottom to top so content fades out naturally.")

            CodeBlock(code: """
// Fade bottom of image into background
Image("photo")
    .resizable()
    .mask {
        LinearGradient(
            colors: [.black, .white],
            startPoint: .top,
            endPoint: .bottom
        )
    }

// Precise fade with stops
LinearGradient(
    stops: [
        .init(color: .black, location: 0),
        .init(color: .black, location: 0.6),
        .init(color: .white, location: 0.9),
    ],
    startPoint: .top,
    endPoint: .bottom
)
""")
        }
    }
}
