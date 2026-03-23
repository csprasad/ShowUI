//
//
//  3_variablecolor.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `23/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Variable Color

struct VariableColorVisual: View {
    @State private var value: Double = 0.6
    @State private var isAnimating = false
    @State private var selectedSymbol = 0

    let symbolSets: [(name: String, symbols: [String])] = [
        ("Volume",  ["speaker.wave.1.fill", "speaker.wave.2.fill", "speaker.wave.3.fill"]),
        ("Signal",  ["wifi", "wifi", "wifi"]),
        ("Battery", ["battery.25.bolt", "battery.50.bolt", "battery.75.bolt", "battery.100.bolt"]),
        ("Loading", ["slowmo", "mediummo", "fastmo"]),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Variable color", systemImage: "speaker.wave.3.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sfGreen)

                // Big live preview
                ZStack {
                    Color(.secondarySystemBackground)
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.system(size: 72))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(Color.sfGreen)
                        .symbolVariant(.fill)
                        // Variable value drives which layers are "active"
                        .environment(\.symbolVariants, .fill)
                    Text(String(format: "%.0f%%", value * 100))
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .offset(y: 50)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Slider to drive value
                HStack(spacing: 10) {
                    Image(systemName: "speaker.fill")
                        .font(.system(size: 13)).foregroundStyle(.secondary)
                    Slider(value: $value, in: 0...1, step: 0.01)
                        .tint(.sfGreen)
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.system(size: 13)).foregroundStyle(.secondary)
                }

                // Show the correct symbol for this value
                HStack(spacing: 16) {
                    ForEach([0.0, 0.33, 0.66, 1.0], id: \.self) { v in
                        VStack(spacing: 4) {
                            Image(systemName: symbolForVolume(v))
                                .font(.system(size: 24))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(Color.sfGreen)
                                .frame(width: 36, height: 36)
                                .background(abs(value - v) < 0.2 ? Color.sfGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Text("\(Int(v * 100))%")
                                .font(.system(size: 9)).foregroundStyle(.tertiary)
                        }
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Current symbol")
                            .font(.system(size: 10)).foregroundStyle(.tertiary)
                        Text(symbolForVolume(value))
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(Color.sfGreen)
                    }
                }
            }
        }
    }

    func symbolForVolume(_ v: Double) -> String {
        switch v {
        case 0..<0.01: return "speaker.fill"
        case 0.01..<0.4: return "speaker.wave.1.fill"
        case 0.4..<0.7: return "speaker.wave.2.fill"
        default: return "speaker.wave.3.fill"
        }
    }
}

struct VariableColorExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Variable color")
            Text("Variable color is a special layer property where each layer has a threshold value between 0 and 1. When your variable value crosses a layer's threshold, that layer becomes fully opaque — creating a fill effect that responds to a numeric value.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Variable color symbols have layers with thresholds — speaker.wave.3.fill has 3 layers at ~0.33, 0.66, 1.0.", color: .sfGreen)
                StepRow(number: 2, text: "Image(systemName:variableValue:) accepts a Double 0–1 that activates layers progressively.", color: .sfGreen)
                StepRow(number: 3, text: "Combine with hierarchical or palette rendering for the best visual result.", color: .sfGreen)
                StepRow(number: 4, text: "Animate the value with a Timer or state change — the layers animate smoothly.", color: .sfGreen)
            }

            CalloutBox(style: .success, title: "Common use cases", contentBody: "Volume controls, signal strength indicators, battery meters, progress indicators, upload/download progress.")

            CalloutBox(style: .info, title: "variableValue vs symbolEffect", contentBody: "Image(systemName:variableValue:) sets a static value. .symbolEffect(.variableColor) animates the value automatically in a loop — use the effect for looping animations, the parameter for data-driven display.")

            CodeBlock(code: """
// Data-driven — show actual value
Image(systemName: "speaker.wave.3.fill", variableValue: volume)
    .symbolRenderingMode(.hierarchical)
    .foregroundStyle(.green)

// Animated loop — iOS 17+
Image(systemName: "wifi")
    .symbolEffect(.variableColor.iterative, options: .repeating)

// Bind to a slider
Slider(value: $volume, in: 0...1)
Image(systemName: "speaker.wave.3.fill", variableValue: volume)
    .animation(.easeOut(duration: 0.1), value: volume)
""")
        }
    }
}
