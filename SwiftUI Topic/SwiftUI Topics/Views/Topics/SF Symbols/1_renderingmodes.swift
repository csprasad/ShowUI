//
//
//  1_renderingmodes.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `23/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: Rendering Modes

struct RenderingModesVisual: View {
    @State private var selectedMode = 0
    @State private var selectedSymbol = "sun.max.fill"

    let symbols = ["sun.max.fill", "cloud.bolt.rain.fill", "wifi", "battery.100.bolt",
                   "heart.text.square.fill", "person.crop.circle.badge.checkmark"]

    struct ModeOption {
        let name: String
        let description: String
        let code: String
    }

    let modes: [ModeOption] = [
        ModeOption(name: "Monochrome",    description: "Single color - the default. Uses foregroundStyle.",              code: ".symbolRenderingMode(.monochrome)"),
        ModeOption(name: "Hierarchical",  description: "Single color with opacity per layer - depth without complexity.", code: ".symbolRenderingMode(.hierarchical)"),
        ModeOption(name: "Palette",       description: "Independent color per layer - full creative control.",            code: ".symbolRenderingMode(.palette)"),
        ModeOption(name: "Multicolor",    description: "Apple's preset colors - the symbol's intended look.",             code: ".symbolRenderingMode(.multicolor)"),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Rendering modes", systemImage: "circle.hexagongrid.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sfGreen)

                // All 4 modes shown simultaneously
                HStack(spacing: 0) {
                    ForEach(modes.indices, id: \.self) { i in
                        VStack(spacing: 8) {
                            modePreview(i)
                            Text(modes[i].name)
                                .font(.system(size: 10, weight: selectedMode == i ? .semibold : .regular))
                                .foregroundStyle(selectedMode == i ? Color.sfGreen : .secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedMode == i ? Color.sfGreenLight : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onTapGesture { withAnimation(.spring(response: 0.3)) { selectedMode = i } }
                    }
                }

                // Selected mode description
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 12)).foregroundStyle(Color.sfGreen)
                    Text(modes[selectedMode].description)
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(10)
                .background(Color.sfGreenLight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut(duration: 0.2), value: selectedMode)

                // Code chip
                Text(modes[selectedMode].code)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(Color.sfGreen)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Color.sfGreenLight)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .animation(.easeInOut(duration: 0.15), value: selectedMode)

                // Symbol switcher
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(symbols, id: \.self) { sym in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedSymbol = sym }
                            } label: {
                                Image(systemName: sym)
                                    .font(.system(size: 20))
                                    .foregroundStyle(selectedSymbol == sym ? Color.sfGreen : .secondary)
                                    .frame(width: 40, height: 40)
                                    .background(selectedSymbol == sym ? Color.sfGreenLight : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    func modePreview(_ mode: Int) -> some View {
        let sym = selectedSymbol
        let size: CGFloat = 36
        switch mode {
        case 0:
            Image(systemName: sym)
                .font(.system(size: size))
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(Color.sfGreen)
        case 1:
            Image(systemName: sym)
                .font(.system(size: size))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.sfGreen)
        case 2:
            Image(systemName: sym)
                .font(.system(size: size))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.sfGreen, Color(hex: "#9FE1CB"), Color(hex: "#C0DD97"))
        default:
            Image(systemName: sym)
                .font(.system(size: size))
                .symbolRenderingMode(.multicolor)
        }
    }
}

struct RenderingModesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "The four rendering modes")
            Text("SF Symbols have a layered structure primary, secondary, and tertiary layers. Rendering modes control how those layers are colored. The same symbol looks completely different across the four modes.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Monochrome - single foregroundStyle color fills the whole symbol. Simple, consistent, the default.", color: .sfGreen)
                StepRow(number: 2, text: "Hierarchical - one color with automatic opacity per layer. Primary=full, secondary=60%, tertiary=30%. Great for depth with no extra work.", color: .sfGreen)
                StepRow(number: 3, text: "Palette - you supply a color per layer. Full control, most expressive. Requires 2–3 foregroundStyle values.", color: .sfGreen)
                StepRow(number: 4, text: "Multicolor - Apple's intended colors for the symbol. Use when you want the standard look (e.g. red heart, blue wifi).", color: .sfGreen)
            }

            CalloutBox(style: .info, title: "Palette needs multiple foregroundStyle values", contentBody: "Pass colors separated by commas: .foregroundStyle(.blue, .green, .red). First = primary layer, second = secondary, third = tertiary.")

            CalloutBox(style: .success, title: "Not all symbols support all modes", contentBody: "Multicolor and hierarchical only work on symbols that have defined layer structure. Check SF Symbols app it shows which modes each symbol supports.")

            CodeBlock(code: """
// Monochrome - default
Image(systemName: "sun.max.fill")
    .foregroundStyle(.yellow)

// Hierarchical - depth with one color
Image(systemName: "sun.max.fill")
    .symbolRenderingMode(.hierarchical)
    .foregroundStyle(.orange)

// Palette - full layer control
Image(systemName: "sun.max.fill")
    .symbolRenderingMode(.palette)
    .foregroundStyle(.yellow, .orange)

// Multicolor - Apple's preset
Image(systemName: "sun.max.fill")
    .symbolRenderingMode(.multicolor)
""")
        }
    }
}
