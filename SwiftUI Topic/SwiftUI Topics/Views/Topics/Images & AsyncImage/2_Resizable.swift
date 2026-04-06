//
//
//  2_Resizable.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Resizable & Fit/Fill
struct ResizableVisual: View {
    @State private var selectedMode = 0
    @State private var containerWidth: CGFloat = 200
    @State private var containerHeight: CGFloat = 120

    let modes: [(name: String, desc: String)] = [
        (".scaledToFit", "Fits inside frame - may letterbox"),
        (".scaledToFill", "Fills frame - may crop"),
        (".aspectRatio(1:1, .fit)", "Force square, fit inside"),
        (".aspectRatio(16:9, .fill)", "Force widescreen, fill"),
        ("stretch (default)", "Ignores aspect ratio - distorts"),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Resizable & fit/fill", systemImage: "arrow.up.left.and.arrow.down.right.circle")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.imgIndigo)

                // Mode selector
                VStack(spacing: 5) {
                    ForEach(modes.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedMode = i }
                        } label: {
                            HStack(spacing: 8) {
                                Text(modes[i].name)
                                    .font(.system(size: 10, weight: selectedMode == i ? .semibold : .regular, design: .monospaced))
                                    .foregroundStyle(selectedMode == i ? Color.imgIndigo : .secondary)
                                Spacer()
                                Text(modes[i].desc)
                                    .font(.system(size: 9))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(selectedMode == i ? Color.imgIndigoLight : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Live demo frame + image
                VStack(spacing: 8) {
                    // Adjustable container
                    HStack(spacing: 10) {
                        Text("W").font(.system(size: 11)).foregroundStyle(.secondary).frame(width: 12)
                        Slider(value: $containerWidth, in: 60...280, step: 4).tint(.imgIndigo)
                        Text("\(Int(containerWidth))").font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary).frame(width: 28)
                    }
                    HStack(spacing: 10) {
                        Text("H").font(.system(size: 11)).foregroundStyle(.secondary).frame(width: 12)
                        Slider(value: $containerHeight, in: 40...200, step: 4).tint(.imgIndigo)
                        Text("\(Int(containerHeight))").font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary).frame(width: 28)
                    }

                    // Preview
                    ZStack {
                        Color(.secondarySystemBackground)
                        // Frame indicator
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.imgIndigo.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [4]))
                            .frame(width: containerWidth, height: containerHeight)

                        imagePreview
                            .frame(width: containerWidth, height: containerHeight)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.imgIndigo.opacity(0.5), lineWidth: 1))
                    }
                    .frame(maxWidth: .infinity).frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .animation(.spring(response: 0.35), value: containerWidth)
                    .animation(.spring(response: 0.35), value: containerHeight)
                    .animation(.spring(response: 0.35), value: selectedMode)
                }
            }
        }
    }

    @ViewBuilder
    private var imagePreview: some View {
        let base = GradientPlaceholder(index: 0)
        switch selectedMode {
        case 0: base.scaledToFit()
        case 1: base.scaledToFill()
        case 2: base.aspectRatio(1, contentMode: .fit)
        case 3: base.aspectRatio(16/9, contentMode: .fill)
        default: base  // stretch - no modifier
        }
    }
}

struct ResizableExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Resizable, fit and fill")
            Text("By default, Image views are fixed at their natural size. .resizable() enables scaling. Then .scaledToFit() or .scaledToFill() control how it fills the available space while maintaining aspect ratio.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".resizable() - required before any scaling modifier. Without it, the image ignores .frame().", color: .imgIndigo)
                StepRow(number: 2, text: ".scaledToFit() - fits entirely inside the frame. May leave empty space (letterboxing).", color: .imgIndigo)
                StepRow(number: 3, text: ".scaledToFill() - fills the entire frame. May crop edges. Always pair with .clipped().", color: .imgIndigo)
                StepRow(number: 4, text: ".aspectRatio(16/9, contentMode: .fit) - forces a specific ratio while fitting inside the frame.", color: .imgIndigo)
                StepRow(number: 5, text: ".resizable(capInsets:) - resizable with protected corner regions that don't stretch.", color: .imgIndigo)
            }

            CalloutBox(style: .warning, title: "Always .clipped() with .scaledToFill()", contentBody: ".scaledToFill() can make the image exceed its frame without clipping. Always add .clipped() after the frame modifier when using fill, or use .clipShape(RoundedRectangle(cornerRadius: n)) which clips as well.")

            CalloutBox(style: .info, title: "Order matters", contentBody: "The correct order: Image → .resizable() → content mode → .frame() → .clipped() / .clipShape(). Getting the order wrong is the most common image sizing mistake.")

            CodeBlock(code: """
// Correct order
Image("photo")
    .resizable()              // 1. enable scaling
    .scaledToFill()           // 2. content mode
    .frame(width: 300, height: 200)  // 3. frame
    .clipped()                // 4. clip overflow

// Fit - shows whole image
Image("photo")
    .resizable()
    .scaledToFit()
    .frame(maxWidth: .infinity)

// Specific aspect ratio
Image("photo")
    .resizable()
    .aspectRatio(16/9, contentMode: .fit)

// Square thumbnail
Image("photo")
    .resizable()
    .scaledToFill()
    .frame(width: 80, height: 80)
    .clipShape(RoundedRectangle(cornerRadius: 12))
""")
        }
    }
}

