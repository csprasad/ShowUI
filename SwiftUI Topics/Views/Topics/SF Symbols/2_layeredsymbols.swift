//
//
//  2_ layeredsymbols.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `23/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Layered Symbols

struct LayeredSymbolsVisual: View {
    @State private var showPrimary   = true
    @State private var showSecondary = true
    @State private var showTertiary  = true
    @State private var selectedSymbol = "cloud.bolt.rain.fill"

    let symbols = ["cloud.bolt.rain.fill", "wifi", "battery.100.bolt",
                   "figure.run.circle.fill", "moon.stars.fill", "heart.text.square.fill"]

    var primaryOpacity:   Double { showPrimary   ? 1.0 : 0.1 }
    var secondaryOpacity: Double { showSecondary ? 1.0 : 0.1 }
    var tertiaryOpacity:  Double { showTertiary  ? 1.0 : 0.1 }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Layered symbols", systemImage: "square.3.layers.3d.top.filled")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sfGreen)

                // Big symbol preview
                ZStack {
                    Color(.secondarySystemBackground)
                    Image(systemName: selectedSymbol)
                        .font(.system(size: 80))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(
                            Color.sfGreen.opacity(primaryOpacity),
                            Color(hex: "#639922").opacity(secondaryOpacity),
                            Color(hex: "#C0DD97").opacity(tertiaryOpacity)
                        )
                        .animation(.easeInOut(duration: 0.25), value: showPrimary)
                        .animation(.easeInOut(duration: 0.25), value: showSecondary)
                        .animation(.easeInOut(duration: 0.25), value: showTertiary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Layer toggles
                VStack(spacing: 8) {
                    layerToggle("Primary layer",   color: Color.sfGreen,           isOn: $showPrimary)
                    layerToggle("Secondary layer", color: Color(hex: "#639922"),   isOn: $showSecondary)
                    layerToggle("Tertiary layer",  color: Color(hex: "#C0DD97"),   isOn: $showTertiary)
                }

                // Symbol switcher
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(symbols, id: \.self) { sym in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedSymbol = sym }
                            } label: {
                                Image(systemName: sym)
                                    .font(.system(size: 20))
                                    .symbolRenderingMode(.multicolor)
                                    .frame(width: 40, height: 40)
                                    .background(selectedSymbol == sym ? Color.sfGreenLight : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }

                Text("Toggle layers to see which parts of the symbol each layer controls")
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
            }
        }
    }

    func layerToggle(_ title: String, color: Color, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 10) {
            Circle().fill(color).frame(width: 10, height: 10)
            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(.primary)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(.sfGreen)
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
        .background(isOn.wrappedValue ? color.opacity(0.08) : Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .animation(.easeInOut(duration: 0.2), value: isOn.wrappedValue)
    }
}

struct LayeredSymbolsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "How layers work")
            Text("Every SF Symbol is a vector image composed of up to three named layers — primary, secondary, and tertiary. Each layer is a separate shape. Rendering modes and palette colors are applied per layer, not to the symbol as a whole.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Primary — the most prominent element. Always receives the first foregroundStyle color.", color: .sfGreen)
                StepRow(number: 2, text: "Secondary — supporting elements. Receives the second color, or 60% opacity in hierarchical mode.", color: .sfGreen)
                StepRow(number: 3, text: "Tertiary — background fill or decoration. Receives the third color, or 30% opacity in hierarchical mode.", color: .sfGreen)
                StepRow(number: 4, text: "Not every symbol uses all three layers — check the SF Symbols app to see the layer structure for a specific symbol.", color: .sfGreen)
            }

            CalloutBox(style: .info, title: "SF Symbols app", contentBody: "Download the free SF Symbols app from Apple. Select any symbol and switch to the Layers inspector to see exactly how many layers it has and what each one contains.")

            CalloutBox(style: .warning, title: "Layer assignment varies by symbol", contentBody: "There's no universal rule for which part of a symbol is primary vs secondary. A cloud symbol might have the lightning as primary and the cloud as secondary — or the reverse. Always check.")

            CodeBlock(code: """
// Palette mode — one color per layer
Image(systemName: "cloud.bolt.rain.fill")
    .symbolRenderingMode(.palette)
    .foregroundStyle(
        .yellow,   // primary   — lightning bolt
        .gray,     // secondary — cloud
        .blue      // tertiary  — rain drops
    )

// Hierarchical — automatic opacity per layer
Image(systemName: "cloud.bolt.rain.fill")
    .symbolRenderingMode(.hierarchical)
    .foregroundStyle(.blue)
    // primary=100%, secondary=60%, tertiary=30%
""")
        }
    }
}
