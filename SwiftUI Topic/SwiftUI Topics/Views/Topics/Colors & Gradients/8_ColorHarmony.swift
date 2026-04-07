//
//
//  8_ColorHarmony.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Color Harmony
struct ColorHarmonyVisual: View {
    @State private var baseHue: Double = 0.6
    @State private var selectedHarmony = 0
    @State private var selectedDemo = 0

    let harmonies = ["Complementary", "Triadic", "Analogous", "Monochromatic"]
    let demos = ["Palette builder", "Tints & shades", "Contrast check"]

    var baseColor: Color { Color(hue: baseHue, saturation: 0.75, brightness: 0.85) }

    var harmonyColors: [Color] {
        switch selectedHarmony {
        case 0: // Complementary
            return [baseColor, Color(hue: (baseHue + 0.5).truncatingRemainder(dividingBy: 1), saturation: 0.75, brightness: 0.85)]
        case 1: // Triadic
            return [
                baseColor,
                Color(hue: (baseHue + 0.333).truncatingRemainder(dividingBy: 1), saturation: 0.75, brightness: 0.85),
                Color(hue: (baseHue + 0.667).truncatingRemainder(dividingBy: 1), saturation: 0.75, brightness: 0.85),
            ]
        case 2: // Analogous
            return [
                Color(hue: (baseHue - 0.083).truncatingRemainder(dividingBy: 1), saturation: 0.7, brightness: 0.8),
                baseColor,
                Color(hue: (baseHue + 0.083).truncatingRemainder(dividingBy: 1), saturation: 0.7, brightness: 0.8),
            ]
        default: // Monochromatic
            return [
                Color(hue: baseHue, saturation: 0.9, brightness: 0.5),
                Color(hue: baseHue, saturation: 0.75, brightness: 0.75),
                baseColor,
                Color(hue: baseHue, saturation: 0.4, brightness: 0.95),
            ]
        }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Color harmony", systemImage: "swatchpalette.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cgAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 10, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.cgAmber : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.cgAmberLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Palette builder
                    VStack(spacing: 10) {
                        // Hue wheel / slider
                        
                        HStack(spacing: 10) {
                            Text("Hue")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                                .frame(width: 35, alignment: .leading)
                            
                            GeometryReader { geometry in
                                let width = geometry.size.width
                                
                                ZStack(alignment: .leading) {
                                    // The Track
                                    LinearGradient(
                                        colors: stride(from: 0.0, through: 1.0, by: 0.05).map { Color(hue: $0, saturation: 0.8, brightness: 0.9) },
                                        startPoint: .leading, endPoint: .trailing
                                    )
                                    .frame(height: 20)
                                    .clipShape(Capsule())
                                    
                                    // The Knob
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 22, height: 22)
                                        .shadow(color: .black.opacity(0.2), radius: 2)
                                        .offset(x: (baseHue * (width - 22)))
                                        .gesture(
                                            DragGesture(minimumDistance: 0)
                                                .onChanged { v in
                                                    let percent = v.location.x / width
                                                    baseHue = min(max(percent, 0), 1)
                                                }
                                        )
                                }
                                .frame(height: 22)
                            }
                            .frame(width: 240, height: 22)
                        }

                        // Harmony type selector
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(harmonies.indices, id: \.self) { i in
                                    Button {
                                        withAnimation(.spring(response: 0.3)) { selectedHarmony = i }
                                    } label: {
                                        Text(harmonies[i])
                                            .font(.system(size: 10, weight: selectedHarmony == i ? .semibold : .regular))
                                            .foregroundStyle(selectedHarmony == i ? .white : .secondary)
                                            .padding(.horizontal, 8).padding(.vertical, 5)
                                            .background(selectedHarmony == i ? baseColor : Color(.systemFill))
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }
                        }

                        // Harmony swatches
                        HStack(spacing: 6) {
                            ForEach(harmonyColors.indices, id: \.self) { i in
                                VStack(spacing: 4) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(harmonyColors[i])
                                        .frame(height: 44)
                                    Text("color \(i+1)")
                                        .font(.system(size: 8)).foregroundStyle(.secondary)
                                }
                            }
                        }
                        .animation(.spring(response: 0.35), value: harmonyColors.count)
                        .animation(.easeInOut(duration: 0.1), value: baseHue)
                    }

                case 1:
                    // Tints & shades
                    VStack(spacing: 8) {
                        Text("Tints (+ white) and shades (+ black)")
                            .font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                        HStack(spacing: 3) {
                            ForEach([0.95, 0.85, 0.75, 0.65, 0.55, 0.45, 0.35, 0.25, 0.15], id: \.self) { brightness in
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(hue: baseHue, saturation: 0.7, brightness: brightness))
                                    .frame(maxWidth: .infinity).frame(height: 48)
                                    .animation(.easeInOut(duration: 0.1), value: baseHue)
                            }
                        }
                        HStack(spacing: 3) {
                            ForEach([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9], id: \.self) { saturation in
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(hue: baseHue, saturation: saturation, brightness: 0.85))
                                    .frame(maxWidth: .infinity).frame(height: 48)
                                    .animation(.easeInOut(duration: 0.1), value: baseHue)
                            }
                        }
                        Text("Drag hue slider above to shift the base color")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                        HStack(spacing: 10) {
                            Text("Hue").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 28)
                            Slider(value: $baseHue, in: 0...1).tint(baseColor)
                        }
                    }

                default:
                    // Contrast check
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Text contrast - WCAG guidelines")
                            .font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        let combos: [(bg: Color, fg: Color, bgName: String, fgName: String, passes: Bool)] = [
                            (baseColor, .white, "base", "white", true),
                            (baseColor, .black, "base", "black", true),
                            (baseColor, Color(hue: baseHue, saturation: 0.3, brightness: 0.95), "base", "light tint", false),
                            (Color.white, Color(hue: baseHue, saturation: 0.8, brightness: 0.5), "white", "dark shade", true),
                            (Color(hex: "#F5F5F5"), Color(hex: "#CCCCCC"), "light gray", "mid gray", false),
                        ]

                        ForEach(combos.indices, id: \.self) { i in
                            HStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(combos[i].bg)
                                    .frame(width: 140, height: 28)
                                    .overlay(
                                        Text("Aa Text sample")
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundStyle(combos[i].fg)
                                    )
                                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(.systemFill), lineWidth: 0.5))

                                Image(systemName: combos[i].passes ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(combos[i].passes ? Color.formGreen : Color.animCoral)
                                Text(combos[i].passes ? "Passes" : "Fails WCAG")
                                    .font(.system(size: 10))
                                    .foregroundStyle(combos[i].passes ? Color.formGreen : Color.animCoral)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ColorHarmonyExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Color harmony & palettes")
            Text("Good color palettes follow harmonic relationships on the color wheel. Complementary colors create contrast, analogous colors create cohesion, triadic creates vibrancy. Tints and shades of a single hue create a cohesive system.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Complementary - colors 180° apart. High contrast, energetic. Primary + accent button color.", color: .cgAmber)
                StepRow(number: 2, text: "Triadic - three colors 120° apart. Balanced and colorful. Good for data visualizations.", color: .cgAmber)
                StepRow(number: 3, text: "Analogous - three adjacent colors (±30°). Harmonious and calming. Good for backgrounds.", color: .cgAmber)
                StepRow(number: 4, text: "Monochromatic - one hue at different saturations/brightnesses. Sophisticated and cohesive.", color: .cgAmber)
                StepRow(number: 5, text: "WCAG AA requires 4.5:1 contrast ratio for normal text, 3:1 for large text.", color: .cgAmber)
            }

            CalloutBox(style: .info, title: "Color in HSB is more intuitive", contentBody: "When building palettes programmatically, use HSB (hue, saturation, brightness) rather than RGB. It's easy to create tints (lower saturation), shades (lower brightness), or harmony colors (shift hue) by adjusting individual components.")

            CalloutBox(style: .success, title: "Build semantic color tokens", contentBody: "Define your palette as named tokens - brand.primary, brand.secondary, surface.background, text.primary. This makes dark mode, rebranding, and accessibility easy. Store them in the asset catalog with light/dark variants.")

            CodeBlock(code: """
// Generate tints and shades
let baseHue = 0.6  // blue

// Tints (increasing brightness)
let tint1 = Color(hue: baseHue, saturation: 0.8, brightness: 0.6)
let tint2 = Color(hue: baseHue, saturation: 0.6, brightness: 0.8)
let tint3 = Color(hue: baseHue, saturation: 0.3, brightness: 0.95)

// Complementary (shift by 0.5)
let complement = Color(hue: (baseHue + 0.5).truncatingRemainder(dividingBy: 1),
                        saturation: 0.75, brightness: 0.85)

// Triadic (shift by 1/3 and 2/3)
let triadic1 = Color(hue: (baseHue + 0.333).truncatingRemainder(dividingBy: 1),
                      saturation: 0.75, brightness: 0.85)
let triadic2 = Color(hue: (baseHue + 0.667).truncatingRemainder(dividingBy: 1),
                      saturation: 0.75, brightness: 0.85)

// Semantic tokens in asset catalog
Color("Brand/Primary")
Color("Brand/Secondary")
Color("Surface/Background")
""")
        }
    }
}
