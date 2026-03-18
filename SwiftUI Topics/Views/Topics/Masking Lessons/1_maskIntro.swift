//
//
//  1_maskIntro.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `19/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: What is a mask?

struct MaskIntroVisual: View {
    @State private var showMask = true

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("How masking works", systemImage: "square.on.square")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#993C1D"))
                    Spacer()
                    Toggle("Apply mask", isOn: $showMask)
                        .labelsHidden()
                        .tint(Color(hex: "#993C1D"))
                }

                // Three-column diagram: content + mask = result
                HStack(spacing: 8) {
                    layerBox(label: "Content", color: true)
                    Text("+")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(.secondary)
                    layerBox(label: "Mask", color: false)
                    Text("=")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(.secondary)
                    resultBox(masked: showMask)
                }
                .animation(.spring(response: 0.4), value: showMask)

                // Explanation chip
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: "#993C1D"))
                    Text(showMask
                        ? "White areas in the mask = visible. Black areas = transparent."
                        : "Without a mask, the full content is visible.")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                .padding(10)
                .background(Color(hex: "#FAECE7"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut(duration: 0.2), value: showMask)
            }
        }
    }

    func layerBox(label: String, color: Bool) -> some View {
        VStack(spacing: 6) {
            ZStack {
                if color {
                    MaskBaseGradient()
                } else {
                    // Mask layer — shows white circle on black
                    Color.black
                    Circle()
                        .fill(Color.white)
                        .padding(14)
                }
            }
            .frame(height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemFill), lineWidth: 0.5))

            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    func resultBox(masked: Bool) -> some View {
        VStack(spacing: 6) {
            ZStack {
                // Checkerboard bg to show transparency
                checkerboard
                if masked {
                    MaskBaseGradient()
                        .mask { Circle().padding(14) }
                } else {
                    MaskBaseGradient()
                }
            }
            .frame(height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemFill), lineWidth: 0.5))

            Text("Result")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    var checkerboard: some View {
        Canvas { context, size in
            let tile: CGFloat = 8
            for row in 0...Int(size.height / tile) {
                for col in 0...Int(size.width / tile) {
                    let isLight = (row + col) % 2 == 0
                    context.fill(
                        Path(CGRect(x: CGFloat(col) * tile, y: CGFloat(row) * tile, width: tile, height: tile)),
                        with: .color(isLight ? Color(.systemGray5) : Color(.systemGray4))
                    )
                }
            }
        }
    }
}

struct MaskIntroExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "How masking works")
            Text("A mask uses the alpha (transparency) channel of one view to control the visibility of another. Where the mask is white and fully opaque the content shows through. Where it's black and fully transparent the content disappears.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "The content layer is your actual view, like an image, gradient, text, anything.", color: Color(hex: "#993C1D"))
                StepRow(number: 2, text: "The mask layer defines the shape. Only its alpha channel matters, the actual content is hidden by default and shown when the alpha is not its color.", color: Color(hex: "#993C1D"))
                StepRow(number: 3, text: "White in the mask = fully visible. Black = fully transparent. Gray = partially transparent.", color: Color(hex: "#993C1D"))
                StepRow(number: 4, text: "SwiftUI multiplies the content's alpha by the mask's alpha pixel by pixel.", color: Color(hex: "#993C1D"))
            }

            CalloutBox(style: .info, title: "Mask vs clip", contentBody: "Clipping (.clipShape) cuts content to a hard edge. Masking (.mask) supports soft edges, gradients, and any shape, making it's more powerful but slightly heavier.")

            CodeBlock(code: """
// Content layer
MaskBaseGradient()
    .mask {
        // Mask layer — white = visible, black = hidden
        Circle()
    }
""")
        }
    }
}
