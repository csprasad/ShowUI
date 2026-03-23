//
//
//  9_customSymbol.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `23/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 9: Custom Symbols
struct CustomSymbolVisual: View {
    @State private var selectedStep = 0

    let steps = [
        (icon: "square.and.arrow.down", title: "Design in SF Symbols app",   description: "Start from an existing symbol or draw from scratch using the SF Symbols app's canvas. Export as SVG template."),
        (icon: "pencil.and.outline",    title: "Draw in vector tool",         description: "Open the SVG template in Figma, Sketch or Illustrator. Draw your symbol using the provided guides for optical sizing."),
        (icon: "arrow.up.doc",          title: "Import into Xcode",           description: "Drag the .svg into your Xcode asset catalog. Set the Symbol tab, assign rendering layers, and set the symbol name."),
        (icon: "checkmark.circle.fill", title: "Use like any symbol",         description: "Image(systemName: \"your.custom.symbol\") — it inherits font weight, rendering modes and symbol effects automatically."),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Custom symbols", systemImage: "square.and.pencil")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sfGreen)

                // Step flow
                VStack(spacing: 8) {
                    ForEach(steps.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedStep = i }
                        } label: {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(selectedStep == i ? Color.sfGreen : Color(.systemFill))
                                        .frame(width: 32, height: 32)
                                    if selectedStep == i {
                                        Image(systemName: steps[i].icon)
                                            .font(.system(size: 14))
                                            .foregroundStyle(.white)
                                    } else {
                                        Text("\(i + 1)")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(.secondary)
                                    }
                                }

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(steps[i].title)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(selectedStep == i ? Color.sfGreen : .primary)
                                    if selectedStep == i {
                                        Text(steps[i].description)
                                            .font(.system(size: 11))
                                            .foregroundStyle(.secondary)
                                            .lineSpacing(2)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .transition(.opacity.combined(with: .move(edge: .top)))
                                    }
                                }
                                Spacer()
                            }
                            .padding(12)
                            .background(selectedStep == i ? Color.sfGreenLight : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
        }
    }
}

struct CustomSymbolExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Creating custom symbols")
            Text("Custom SF Symbols are SVG files imported into your Xcode asset catalog. Once imported, they behave identically to system symbols, except for the fact that they support all rendering modes, weights, scales and symbol effects.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Download the SF Symbols app (free from Apple). Use File → Export Template to get the SVG guide.", color: .sfGreen)
                StepRow(number: 2, text: "Draw in the template. Adhere to the optical alignment guides, they ensure your symbol looks correct at all weights.", color: .sfGreen)
                StepRow(number: 3, text: "In Xcode: Assets.xcassets → + → New Symbol Image Set. Drag in your SVG.", color: .sfGreen)
                StepRow(number: 4, text: "Use Image(systemName: \"your.symbol.name\") the name matches the asset catalog entry.", color: .sfGreen)
                StepRow(number: 5, text: "Assign layers in the Symbol inspector in Xcode, and use the .symbolRenderingMode modifier to mark which paths are primary, secondary, tertiary for palette/hierarchical modes.", color: .sfGreen)
            }

            CalloutBox(style: .info, title: "Weight variants", contentBody: "You can provide 27 weight/scale variants (9 weights × 3 scales) for pixel-perfect rendering. At minimum provide Regular-Medium. Xcode interpolates the rest, so your app will look consistent across all weights. Note that the visual results vary in quality.")

            CalloutBox(style: .warning, title: "Name conflicts", contentBody: "Custom symbol names shadow system symbol names if they match. Use a unique prefix like \"custom.\" or your app prefix to avoid accidental conflicts across iOS versions.")

            CodeBlock(code: """
// In asset catalog: named "app.chart.line"
Image(systemName: "app.chart.line")
    .font(.system(size: 24, weight: .semibold))
    .symbolRenderingMode(.hierarchical)
    .foregroundStyle(.blue)

// Custom symbols support all the same modifiers
Image(systemName: "app.chart.line")
    .symbolEffect(.bounce, value: tapCount)
    .symbolVariant(.fill)
    .imageScale(.large)
""")
        }
    }
}

