//
//
//  4_ImageModifiers.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Image Modifiers
struct ImageModifiersVisual: View {
    @State private var saturation: Double = 1.0
    @State private var contrast: Double = 1.0
    @State private var blur: Double = 0
    @State private var brightness: Double = 0
    @State private var selectedEffect = 0
    @State private var selectedPreset = 0

    let effects = ["Saturation", "Contrast", "Blur", "Brightness"]
    let presets: [(name: String, sat: Double, con: Double, blur: Double, bright: Double)] = [
        ("Original",   1.0, 1.0, 0,   0),
        ("Grayscale",  0.0, 1.0, 0,   0),
        ("Vivid",      1.8, 1.2, 0,   0.05),
        ("Faded",      0.6, 0.9, 0,   0.05),
        ("Dramatic",   1.2, 1.5, 0,  -0.05),
        ("Soft focus",  1.0, 1.0, 2.5, 0.02),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Image modifiers", systemImage: "wand.and.stars")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.imgIndigo)

                // Live preview
                HStack(spacing: 12) {
                    GradientPlaceholder(index: 4)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .saturation(saturation)
                        .contrast(contrast)
                        .blur(radius: blur)
                        .brightness(brightness)
                        .animation(.easeInOut(duration: 0.15), value: saturation)
                        .animation(.easeInOut(duration: 0.15), value: contrast)
                        .animation(.easeInOut(duration: 0.15), value: blur)
                        .animation(.easeInOut(duration: 0.15), value: brightness)

                    VStack(alignment: .leading, spacing: 5) {
                        modifierLabel("saturation", value: saturation)
                        modifierLabel("contrast", value: contrast)
                        modifierLabel("blur", value: blur)
                        modifierLabel("brightness", value: brightness)
                    }
                }

                // Effect sliders
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(effects.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedEffect = i }
                            } label: {
                                Text(effects[i])
                                    .font(.system(size: 11, weight: selectedEffect == i ? .semibold : .regular))
                                    .foregroundStyle(selectedEffect == i ? Color.imgIndigo : .secondary)
                                    .padding(.horizontal, 10).padding(.vertical, 6)
                                    .background(selectedEffect == i ? Color.imgIndigoLight : Color(.systemFill))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }

                // Active slider
                sliderForEffect

                // Presets
                VStack(alignment: .leading, spacing: 6) {
                    Text("Presets").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(presets.indices, id: \.self) { i in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        selectedPreset = i
                                        saturation = presets[i].sat
                                        contrast = presets[i].con
                                        blur = presets[i].blur
                                        brightness = presets[i].bright
                                    }
                                } label: {
                                    VStack(spacing: 4) {
                                        GradientPlaceholder(index: 4)
                                            .frame(width: 44, height: 44)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .saturation(presets[i].sat)
                                            .contrast(presets[i].con)
                                            .blur(radius: presets[i].blur)
                                            .brightness(presets[i].bright)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(selectedPreset == i ? Color.imgIndigo : Color.clear, lineWidth: 2)
                                            )
                                        Text(presets[i].name)
                                            .font(.system(size: 9, weight: selectedPreset == i ? .semibold : .regular))
                                            .foregroundStyle(selectedPreset == i ? Color.imgIndigo : .secondary)
                                    }
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var sliderForEffect: some View {
        switch selectedEffect {
        case 0:
            sliderRow("saturation", value: $saturation, range: 0...2)
        case 1:
            sliderRow("contrast", value: $contrast, range: 0...2)
        case 2:
            sliderRow("blur(radius:)", value: $blur, range: 0...10)
        default:
            sliderRow("brightness", value: $brightness, range: -0.5...0.5)
        }
    }

    func sliderRow(_ name: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack(spacing: 10) {
            Text(name).font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary).frame(width: 90, alignment: .leading)
            Slider(value: value, in: range).tint(.imgIndigo)
            Text(String(format: "%.2f", value.wrappedValue))
                .font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.imgIndigo).frame(width: 36)
        }
    }

    func modifierLabel(_ name: String, value: Double) -> some View {
        HStack(spacing: 4) {
            Text(".\(name)(")
                .font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
            Text(String(format: "%.2f", value))
                .font(.system(size: 9, weight: .semibold, design: .monospaced)).foregroundStyle(Color.imgIndigo)
            Text(")").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
        }
    }
}

struct ImageModifiersExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Visual image modifiers")
            Text("SwiftUI provides several modifiers for adjusting image appearance without Core Image or UIKit. They work on any view, not just images - making it easy to apply filters to entire view hierarchies.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".saturation(0) - grayscale. 1 = normal. 2 = vivid. Values between 0 and 2 work best.", color: .imgIndigo)
                StepRow(number: 2, text: ".contrast(1.5) - increase contrast. 0 = flat grey. 1 = normal. Above 1 = more contrast.", color: .imgIndigo)
                StepRow(number: 3, text: ".blur(radius: 4) - gaussian blur. Higher radius = more blur. Use for background overlays.", color: .imgIndigo)
                StepRow(number: 4, text: ".brightness(0.1) - range -1 to 1. Positive = lighter. Negative = darker.", color: .imgIndigo)
                StepRow(number: 5, text: ".colorMultiply(color) - multiplies each pixel by the color. Use for tinting. White = no effect.", color: .imgIndigo)
                StepRow(number: 6, text: ".grayscale(1.0) - similar to .saturation(0) but with explicit 0-1 control.", color: .imgIndigo)
            }

            CalloutBox(style: .success, title: "Modifiers apply to any view", contentBody: "These modifiers work on VStack, ZStack, or any container - not just Image. Apply .blur() to a background view, .saturation(0) to a disabled card, or .brightness(0.1) to a highlighted state.")

            CodeBlock(code: """
// Grayscale
image.saturation(0)

// Vivid
image
    .saturation(1.5)
    .contrast(1.2)

// Soft focus
image
    .blur(radius: 3)
    .brightness(0.05)

// Tint with colorMultiply
image.colorMultiply(.blue.opacity(0.3))

// Disabled state - whole card
CardView()
    .saturation(isEnabled ? 1 : 0)
    .opacity(isEnabled ? 1 : 0.5)
    .animation(.easeInOut, value: isEnabled)

// Blurred background
ZStack {
    BackgroundView()
        .blur(radius: 20)
        .ignoresSafeArea()
    ContentView()
}
""")
        }
    }
}

