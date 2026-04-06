//
//
//  1_ImageBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: Image Basics
struct ImageBasicsVisual: View {
    @State private var selectedDemo = 0
    @State private var renderingMode = 0
    let demos = ["SF Symbols", "Rendering modes", "Tinting"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Image basics", systemImage: "photo")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.imgIndigo)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.imgIndigo : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.imgIndigoLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                ZStack {
                    Color(.secondarySystemBackground)
                    demoDiagram.padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedDemo)
                .animation(.spring(response: 0.3), value: renderingMode)
            }
        }
    }

    @ViewBuilder
    private var demoDiagram: some View {
        switch selectedDemo {
        case 0:
            // SF Symbols showcase
            let symbols = [
                ("star.fill", "star.fill"), ("heart.fill", "heart.fill"),
                ("bell.fill", "bell.fill"), ("gear", "gear"),
                ("person.fill", "person.fill"), ("house.fill", "house.fill"),
            ]
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 14) {
                ForEach(symbols, id: \.0) { sym in
                    VStack(spacing: 5) {
                        Image(systemName: sym.0)
                            .font(.system(size: 24))
                            .foregroundStyle(Color.imgIndigo)
                            .frame(width: 40, height: 40)
                            .background(Color.imgIndigoLight)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text(sym.0)
                            .font(.system(size: 6, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }

        case 1:
            // Rendering modes
            HStack(spacing: 0) {
                ForEach([
                    ("monochrome", "Monochrome\nforeground color", Color.imgIndigo),
                    ("hierarchical", "Hierarchical\ndepth layers", Color.imgIndigo),
                    ("palette", "Palette\ncustom colors", Color.animCoral),
                    ("multicolor", "Multicolor\nsystem colors", Color.clear),
                ], id: \.0) { name, desc, color in
                    VStack(spacing: 6) {
                        Group {
                            if name == "hierarchical" {
                                Image(systemName: "person.3.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(color)
                                    .font(.system(size: 26))
                            } else if name == "palette" {
                                Image(systemName: "person.crop.circle.badge.checkmark")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(color, Color.animTeal)
                                    .font(.system(size: 26))
                            } else if name == "multicolor" {
                                Image(systemName: "globe.americas.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.system(size: 26))
                            } else {
                                Image(systemName: "square.stack.3d.up.fill")
                                    .symbolRenderingMode(.monochrome)
                                    .foregroundStyle(color)
                                    .font(.system(size: 26))
                            }
                        }
                        .frame(width: 52, height: 52)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        Text(desc)
                            .font(.system(size: 7, weight: .medium))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
            }

        default:
            // Tinting & foregroundStyle
            HStack(spacing: 14) {
                ForEach([
                    ("heart.fill", Color.animCoral),
                    ("leaf.fill", Color.formGreen),
                    ("bolt.fill", Color.animAmber),
                    ("moon.stars.fill", Color.ssPurple),
                ], id: \.0) { sym, color in
                    VStack(spacing: 6) {
                        Image(systemName: sym)
                            .font(.system(size: 28))
                            .foregroundStyle(color)
                            .frame(width: 52, height: 52)
                            .background(color.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        Text(".foregroundStyle")
                            .font(.system(size: 7, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

struct ImageBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Image basics")
            Text("SwiftUI has two main image sources: SF Symbols via Image(systemName:) and asset catalog images via Image(\"name\"). SF Symbols are vector-based and scale perfectly. Asset images need .resizable() to scale.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Image(systemName: \"star.fill\") - SF Symbol. Scales with Dynamic Type automatically. No assets needed.", color: .imgIndigo)
                StepRow(number: 2, text: "Image(\"photo-name\") - asset catalog image. Fixed size by default - needs .resizable() to scale.", color: .imgIndigo)
                StepRow(number: 3, text: ".foregroundStyle(color) - tints SF Symbols. For images, use .colorMultiply or .tint.", color: .imgIndigo)
                StepRow(number: 4, text: ".symbolRenderingMode(.hierarchical / .palette / .multicolor) - controls SF Symbol color rendering.", color: .imgIndigo)
                StepRow(number: 5, text: ".font(.system(size: n)) - controls SF Symbol size. Or .imageScale(.small / .medium / .large).", color: .imgIndigo)
            }

            CalloutBox(style: .info, title: "SF Symbols scale with text", contentBody: "When placed alongside Text with the same font, SF Symbols automatically match the text size and weight. Use .imageScale() for finer control or an explicit .font() size.")

            CalloutBox(style: .success, title: "symbolRenderingMode rendering", contentBody: ".monochrome - single foreground color. .hierarchical - depth via opacity layers. .palette - specify colors for each layer explicitly. .multicolor - uses the symbol's designed system colors.")

            CodeBlock(code: """
// SF Symbol - scales with font
Image(systemName: "star.fill")
    .foregroundStyle(.yellow)
    .font(.system(size: 32))

// Symbol with rendering mode
Image(systemName: "person.crop.circle.badge.checkmark")
    .symbolRenderingMode(.palette)
    .foregroundStyle(.blue, .green)

// Hierarchical depth
Image(systemName: "person.3.fill")
    .symbolRenderingMode(.hierarchical)
    .foregroundStyle(.indigo)

// Asset image (needs resizable to scale)
Image("hero-photo")
    .resizable()
    .scaledToFill()

// Template mode - tint asset image
Image("logo")
    .renderingMode(.template)
    .foregroundStyle(.blue)
""")
        }
    }
}
