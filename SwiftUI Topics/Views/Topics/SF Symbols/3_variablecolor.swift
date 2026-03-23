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
    @State private var value: Double = 0.5
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

                    VStack(spacing: 12) {
                        // variableValue: is the correct API — drives layer activation
                        Image(systemName: "speaker.wave.3.fill", variableValue: value)
                            .font(.system(size: 72))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(Color.sfGreen)
                            .animation(.easeOut(duration: 0.1), value: value)

                        Text(String(format: "variableValue: %.2f", value))
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 150)
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

                // Other variable color symbols responding to the same value
                let variableSymbols = ["wifi", "chart.bar.fill", "cellularbars", "battery"]

                HStack(spacing: 10) {
                    ForEach(variableSymbols, id: \.self) { sym in
                        VStack(spacing: 4) {
                            let symbolName = sym == "battery" ? getBatteryName(for: value) : sym
                            
                            Image(systemName: symbolName, variableValue: value)
                                .font(.system(size: 24))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(Color.sfGreen)
                                .frame(width: 40, height: 40)
                                .background(Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Text(symbolName.components(separatedBy: ".").first ?? symbolName)
                                .font(.system(size: 9))
                                .foregroundStyle(Color(.tertiaryLabel))
                        }
                    }
                    Spacer()
                }

                Text("Drag the slider — all symbols respond to the same variableValue")
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
            }
        }
    }
    
    // Logic to map 0.0-1.0 to SF Symbol battery steps
    func getBatteryName(for value: Double) -> String {
        switch value {
        case 0..<0.15: return "battery.0"
        case 0.15..<0.35: return "battery.25"
        case 0.35..<0.65: return "battery.50"
        case 0.65..<0.85: return "battery.75"
        default: return "battery.100"
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
            Text("Variable color is a special layer property where each layer has a threshold value between 0 and 1. When your variable value crosses a layer's threshold, that layer becomes fully opaque, and all others become transparent. This allows you to dynamically change the appearance of an image or symbol based on a numeric value. It's like creating a fill effect that responds to a numeric value.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Variable color symbols have layers with thresholds, like speaker.wave.3.fill has 3 layers at ~0.33, 0.66, 1.0.", color: .sfGreen)
                StepRow(number: 2, text: "Image(systemName:variableValue:) accepts a Double 0–1 that activates layers progressively.", color: .sfGreen)
                StepRow(number: 3, text: "Combine with hierarchical or palette rendering for the best visual result.", color: .sfGreen)
                StepRow(number: 4, text: "Animate the value with a Timer or state change, and watch the layers animate smoothly.", color: .sfGreen)
            }

            CalloutBox(style: .success, title: "Common use cases", contentBody: "Volume controls, signal strength indicators, battery meters, progress indicators, upload/download progress.")

            CalloutBox(style: .info, title: "variableValue vs symbolEffect", contentBody: "Image(systemName:variableValue:) sets a static value. .symbolEffect(.variableColor) animates the value automatically in a loop, or you can use the effect for looping animations, the parameter for data-driven display.")

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
