//
//
//  3_Radial&Angular.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Radial & Angular
struct RadialAngularVisual: View {
    @State private var selectedType = 0
    @State private var centerX: CGFloat = 0.5
    @State private var centerY: CGFloat = 0.5
    @State private var startRadius: CGFloat = 0
    @State private var endRadius: CGFloat = 100
    @State private var startAngle: CGFloat = 0
    @State private var selectedPalette = 0

    let types = ["Radial", "Angular", "Elliptical"]
    let palettes: [[Color]] = [
        [Color(hex: "#667EEA"), Color(hex: "#764BA2"), Color(hex: "#F5576C")],
        [Color(hex: "#43E97B"), Color(hex: "#38F9D7"), Color(hex: "#667EEA")],
        [Color(hex: "#FA709A"), Color(hex: "#FEE140"), Color(hex: "#4FACFE")],
        [Color(hex: "#F093FB"), Color(hex: "#F5576C"), Color(hex: "#43E97B")],
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Radial & Angular", systemImage: "circle.dashed.inset.filled")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cgAmber)

                HStack(spacing: 8) {
                    ForEach(types.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedType = i }
                        } label: {
                            Text(types[i])
                                .font(.system(size: 12, weight: selectedType == i ? .semibold : .regular))
                                .foregroundStyle(selectedType == i ? Color.cgAmber : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedType == i ? Color.cgAmberLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Palette selector
                HStack(spacing: 8) {
                    Text("Palette:").font(.system(size: 11)).foregroundStyle(.secondary)
                    ForEach(palettes.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedPalette = i }
                        } label: {
                            LinearGradient(colors: palettes[i], startPoint: .leading, endPoint: .trailing)
                                .frame(width: 32, height: 20).clipShape(Capsule())
                                .overlay(Capsule().stroke(.white, lineWidth: selectedPalette == i ? 2 : 0))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                    Spacer()
                }

                // Live gradient preview
                ZStack {
                    gradientPreview.clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .frame(maxWidth: .infinity).frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.easeInOut(duration: 0.1), value: centerX)
                .animation(.easeInOut(duration: 0.1), value: centerY)
                .animation(.easeInOut(duration: 0.1), value: startAngle)
                .animation(.spring(response: 0.3), value: selectedType)
                .animation(.spring(response: 0.3), value: selectedPalette)

                // Controls
                switch selectedType {
                case 0:
                    VStack(spacing: 6) {
                        sliderRow("center X", value: $centerX, range: 0...1)
                        sliderRow("center Y", value: $centerY, range: 0...1)
                        sliderRow("start r", value: $startRadius, range: 0...80)
                        sliderRow("end r",   value: $endRadius,   range: 30...200)
                    }
                case 1:
                    sliderRow("start angle", value: $startAngle, range: 0...360)
                default:
                    sliderRow("center X", value: $centerX, range: 0...1)
                    sliderRow("center Y", value: $centerY, range: 0...1)
                }
            }
        }
    }

    @ViewBuilder
    private var gradientPreview: some View {
        let colors = palettes[selectedPalette]
        switch selectedType {
        case 0:
            RadialGradient(
                colors: colors,
                center: UnitPoint(x: centerX, y: centerY),
                startRadius: startRadius,
                endRadius: endRadius
            )
        case 1:
            AngularGradient(
                colors: colors,
                center: .center,
                startAngle: .degrees(startAngle),
                endAngle: .degrees(startAngle + 360)
            )
        default:
            EllipticalGradient(
                colors: colors,
                center: UnitPoint(x: centerX, y: centerY)
            )
        }
    }

    func sliderRow(_ label: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>) -> some View {
        HStack(spacing: 8) {
            Text(label).font(.system(size: 11)).foregroundStyle(.secondary).frame(width: 56, alignment: .leading)
            Slider(value: value, in: range).tint(.cgAmber)
            Text(String(format: range.upperBound > 2 ? "%.0f" : "%.2f", value.wrappedValue))
                .font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.cgAmber).frame(width: 32)
        }
    }
}

struct RadialAngularExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Radial, Angular & Elliptical")
            Text("SwiftUI provides three non-linear gradient types. RadialGradient radiates outward from a center point. AngularGradient (conic) sweeps colors around a center. EllipticalGradient combines both - an ellipse that fades outward.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "RadialGradient(colors:center:startRadius:endRadius:) - solid at center, fading outward.", color: .cgAmber)
                StepRow(number: 2, text: "AngularGradient(colors:center:startAngle:endAngle:) - sweeps colors in a circle. Great for pie charts and knobs.", color: .cgAmber)
                StepRow(number: 3, text: "EllipticalGradient(colors:center:) - ellipse shape. Colors radiate from center to edges.", color: .cgAmber)
                StepRow(number: 4, text: "All gradients accept Gradient.Stop for explicit color positions along the gradient path.", color: .cgAmber)
            }

            CalloutBox(style: .success, title: "Angular gradient for progress rings", contentBody: "AngularGradient is perfect for progress indicators - sweep from 0° to 360° * progress. Combine with .trim on a Circle stroke and .rotationEffect(-.degrees(90)) for the standard clockface orientation.")

            CodeBlock(code: """
// Radial - spotlight effect
RadialGradient(
    colors: [.yellow, .orange, .clear],
    center: .center,
    startRadius: 0,
    endRadius: 120
)

// Angular - conic sweep
AngularGradient(
    colors: [.red, .orange, .yellow, .green, .blue, .purple, .red],
    center: .center
)

// Elliptical - soft background glow
EllipticalGradient(
    colors: [Color.purple.opacity(0.6), .clear],
    center: .center,
    startRadiusFraction: 0,
    endRadiusFraction: 0.8
)

// With stops
RadialGradient(stops: [
    .init(color: .white, location: 0),
    .init(color: .white, location: 0.3),
    .init(color: .clear, location: 1),
], center: .center, startRadius: 0, endRadius: 100)
""")
        }
    }
}
