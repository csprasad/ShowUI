//
//
//  7_TextMask.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `19/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Text Mask
struct TextMaskVisual: View {
    @State private var text = "Swift"
    @State private var fontSize: CGFloat = 56
    @State private var gradientAngle = 0  // 0=horizontal, 1=vertical, 2=diagonal

    let presets = ["Swift", "iOS", "SwiftUI", "Hello"]

    var gradient: LinearGradient {
        switch gradientAngle {
        case 0: return LinearGradient(colors: [Color(hex: "#B5D4F4"), Color(hex: "#9FE1CB"), Color(hex: "#FAC775")], startPoint: .leading, endPoint: .trailing)
        case 1: return LinearGradient(colors: [Color(hex: "#CECBF6"), Color(hex: "#F5C4B3")], startPoint: .top, endPoint: .bottom)
        default: return LinearGradient(colors: [Color(hex: "#B5D4F4"), Color(hex: "#FAC775"), Color(hex: "#F5C4B3")], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Text mask", systemImage: "textformat")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#993C1D"))

                // Live preview
                ZStack {
                    Color(.secondarySystemBackground)
                    gradient
                        .mask {
                            Text(text)
                                .font(.system(size: fontSize, weight: .black, design: .rounded))
                        }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.3), value: text)
                .animation(.easeInOut(duration: 0.2), value: gradientAngle)

                // Text presets
                HStack(spacing: 8) {
                    ForEach(presets, id: \.self) { preset in
                        Button(preset) {
                            withAnimation(.spring(response: 0.3)) { text = preset }
                        }
                        .font(.system(size: 12, weight: text == preset ? .semibold : .regular, design: .monospaced))
                        .foregroundStyle(text == preset ? Color(hex: "#993C1D") : .secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(text == preset ? Color(hex: "#FAECE7") : Color(.systemFill))
                        .clipShape(Capsule())
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Font size slider
                HStack(spacing: 10) {
                    Text("Size")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Slider(value: $fontSize, in: 32...80, step: 4)
                        .tint(Color(hex: "#993C1D"))
                    Text("\(Int(fontSize))pt")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .frame(width: 40)
                }

                // Gradient direction
                HStack(spacing: 8) {
                    ForEach(["Horizontal", "Vertical", "Diagonal"], id: \.self) { dir in
                        let i = ["Horizontal", "Vertical", "Diagonal"].firstIndex(of: dir) ?? 0
                        Button(dir) {
                            withAnimation(.easeInOut(duration: 0.2)) { gradientAngle = i }
                        }
                        .font(.system(size: 11, weight: gradientAngle == i ? .semibold : .regular))
                        .foregroundStyle(gradientAngle == i ? Color(hex: "#993C1D") : .secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(gradientAngle == i ? Color(hex: "#FAECE7") : Color(.systemFill))
                        .clipShape(Capsule())
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
        }
    }
}

struct TextMaskExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Image through text")
            Text("Apply a gradient, image, or any content as the base layer, then mask it to the shape of text. The result is a gradient-filled or image-filled title, a common design pattern in iOS apps and marketing screens.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Place your gradient or image as the content layer.", color: Color(hex: "#993C1D"))
                StepRow(number: 2, text: "Apply .mask { Text(...) }, so the text shape becomes the visibility map.", color: Color(hex: "#993C1D"))
                StepRow(number: 3, text: "Use a heavy font weight (.black, .heavy), or add some padding to make sure the thin strokes disappear.", color: Color(hex: "#993C1D"))
            }

            CalloutBox(style: .success, title: "Works with any content", contentBody: "Not just gradients, you can also use an Image, a live camera feed, an animated gradient, or even another view as the content behind the text shape.")

            CalloutBox(style: .warning, title: "Background matters", contentBody: "The masked text is transparent outside the letters. Put a dark background behind it so the gradient text is legible.")

            CodeBlock(code: """
// Gradient text
LinearGradient(
    colors: [.blue, .purple, .pink],
    startPoint: .leading,
    endPoint: .trailing
)
.mask {
    Text("Swift")
        .font(.system(size: 64, weight: .black))
}

// Image through text
Image("landscape")
    .resizable()
    .scaledToFill()
    .frame(width: 300, height: 100)
    .mask {
        Text("Hello")
            .font(.system(size: 80, weight: .black))
    }
""")
        }
    }
}
