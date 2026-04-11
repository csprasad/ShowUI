//
//
//  6_SliderPatterns.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Slider Patterns
struct SliderPatternsVisual: View {
    @State private var lowValue: Double  = 20
    @State private var highValue: Double = 80
    @State private var hue: Double       = 0.55
    @State private var saturation: Double = 0.8
    @State private var brightness: Double = 0.9
    @State private var blurRadius: Double = 0
    @State private var selectedDemo       = 0
    let demos = ["Range slider", "Color mixer", "Live preview"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Slider patterns", systemImage: "slider.horizontal.below.square.filled.and.square")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cdPurple)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.cdPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.cdPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Range slider (two independent sliders with constrained values)
                    VStack(spacing: 12) {
                        Text("Price range").font(.system(size: 13, weight: .semibold))

                        // Visual range track
                        GeometryReader { geo in
                            let w = geo.size.width
                            let lowX  = CGFloat(lowValue  / 100) * w
                            let highX = CGFloat(highValue / 100) * w
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color(.systemFill)).frame(height: 4)
                                Capsule().fill(Color.cdPurple).frame(width: max(0, highX - lowX), height: 4).offset(x: lowX)
                                Circle().fill(Color.cdPurple).frame(width: 20, height: 20)
                                    .shadow(color: Color.cdPurple.opacity(0.3), radius: 4).offset(x: lowX - 10)
                                Circle().fill(Color.cdPurple).frame(width: 20, height: 20)
                                    .shadow(color: Color.cdPurple.opacity(0.3), radius: 4).offset(x: highX - 10)
                            }
                        }
                        .frame(height: 20)
                        .padding(.horizontal, 10)
                        .animation(.easeInOut(duration: 0.05), value: lowValue)
                        .animation(.easeInOut(duration: 0.05), value: highValue)

                        HStack {
                            Text("$\(Int(lowValue))").font(.system(size: 14, weight: .semibold)).foregroundStyle(Color.cdPurple)
                            Spacer()
                            Text("$\(Int(highValue))").font(.system(size: 14, weight: .semibold)).foregroundStyle(Color.cdPurple)
                        }

                        // Two sliders, constrained
                        VStack(spacing: 6) {
                            HStack(spacing: 6) {
                                Text("Min").font(.system(size: 11)).foregroundStyle(.secondary).frame(width: 26)
                                Slider(value: $lowValue, in: 0...100).tint(.cdPurple)
                                    .onChange(of: lowValue) { _, newValue in
                                        if newValue > highValue - 5 {
                                            highValue = min(100, newValue + 5)
                                        }
                                    }
                                Text("$\(Int(lowValue))").font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.cdPurple).frame(width: 36)
                            }
                            
                            HStack(spacing: 6) {
                                Text("Max").font(.system(size: 11)).foregroundStyle(.secondary).frame(width: 26)
                                Slider(value: $highValue, in: 0...100).tint(.cdPurple)
                                    .onChange(of: highValue) { _, newValue in
                                        if newValue < lowValue + 5 {
                                            lowValue = max(0, newValue - 5)
                                        }
                                    }
                                Text("$\(Int(highValue))").font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.cdPurple).frame(width: 36)
                            }
                        }
                    }
                    .padding(12).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 12))

                case 1:
                    // Color mixer with gradient tracks
                    VStack(spacing: 12) {
                        // Swatch
                        Color(hue: hue, saturation: saturation, brightness: brightness)
                            .frame(maxWidth: .infinity).frame(height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                Text("H:\(Int(hue*360))° S:\(Int(saturation*100))% B:\(Int(brightness*100))%")
                                    .font(.system(size: 10, design: .monospaced)).foregroundStyle(.white.opacity(0.9))
                            )
                            .animation(.easeInOut(duration: 0.05), value: hue)
                            .animation(.easeInOut(duration: 0.05), value: saturation)
                            .animation(.easeInOut(duration: 0.05), value: brightness)

                        // Hue track
                        gradientSlider("H", value: $hue, range: 0...1,
                                       gradient: LinearGradient(colors: stride(from: 0.0, through: 1.0, by: 0.1).map { Color(hue: $0, saturation: 0.9, brightness: 0.9) }, startPoint: .leading, endPoint: .trailing))

                        gradientSlider("S", value: $saturation, range: 0...1,
                                       gradient: LinearGradient(colors: [Color(hue: hue, saturation: 0, brightness: brightness), Color(hue: hue, saturation: 1, brightness: brightness)], startPoint: .leading, endPoint: .trailing))

                        gradientSlider("B", value: $brightness, range: 0...1,
                                       gradient: LinearGradient(colors: [.black, Color(hue: hue, saturation: saturation, brightness: 1)], startPoint: .leading, endPoint: .trailing))
                    }

                default:
                    // Live visual preview
                    VStack(spacing: 10) {
                        sliderRow("Hue",  value: $hue,        range: 0...1,   label: String(format: "%.2f", hue))
                        sliderRow("Blur", value: $blurRadius, range: 0...15,  label: String(format: "%.1f", blurRadius))

                        ZStack {
                            LinearGradient(colors: [
                                Color(hue: hue, saturation: 0.8, brightness: 0.9),
                                Color(hue: (hue + 0.3).truncatingRemainder(dividingBy: 1), saturation: 0.8, brightness: 0.9),
                            ], startPoint: .topLeading, endPoint: .bottomTrailing)

                            VStack(spacing: 6) {
                                Image(systemName: "wand.and.stars").font(.system(size: 32)).foregroundStyle(.white)
                                Text("Live preview").font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
                                Text("Adjust sliders above").font(.system(size: 11)).foregroundStyle(.white.opacity(0.8))
                            }
                        }
                        .frame(maxWidth: .infinity).frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .blur(radius: blurRadius)
                        .animation(.easeInOut(duration: 0.05), value: hue)
                        .animation(.easeInOut(duration: 0.05), value: blurRadius)
                    }
                }
            }
        }
    }

    func gradientSlider(_ label: String, value: Binding<Double>, range: ClosedRange<Double>, gradient: LinearGradient) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.secondary)
                .frame(width: 14)

            ZStack {
                gradient.frame(height: 6).background(Color.red.opacity(0.3)).clipShape(Capsule())
                Slider(value: value, in: range).padding(.vertical, 10).accentColor(.clear)
            }
            .frame(height: 32)
        }
    }
    
    func sliderRow(_ label: String, value: Binding<Double>, range: ClosedRange<Double>, label str: String) -> some View {
        HStack(spacing: 8) {
            Text(label).font(.system(size: 11)).foregroundStyle(.secondary).frame(width: 28)
            Slider(value: value, in: range).tint(.cdPurple)
            Text(str).font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.cdPurple).frame(width: 36)
        }
    }
}

struct SliderPatternsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Slider patterns")
            Text("Two sliders with constrained ranges build a range selector. Custom gradient tracks make sliders communicate their value visually. Real-time previews give immediate feedback as the user drags.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Range slider: low in 0...high-gap, high in low+gap...max - constraints prevent overlap.", color: .cdPurple)
                StepRow(number: 2, text: "Gradient track: overlay a LinearGradient on the track area, put an invisible Slider on top with opacity ~0.015.", color: .cdPurple)
                StepRow(number: 3, text: "Live preview: update the preview view directly from slider binding - no debounce for visual-only updates.", color: .cdPurple)
                StepRow(number: 4, text: "Custom thumb: hide the Slider with opacity and overlay your own Circle positioned via GeometryReader.", color: .cdPurple)
            }

            CalloutBox(style: .info, title: "Gradient track trick", contentBody: "SwiftUI doesn't support custom track colors natively. The trick: overlay a gradient on the track area, then place a nearly-invisible (opacity 0.015) standard Slider on top to capture all drag gestures. The thumb stays invisible; overlay your own.")

            CodeBlock(code: """
// Range slider - constrained
@State private var low: Double = 20
@State private var high: Double = 80

Slider(value: $low, in: 0...high - 5)
Slider(value: $high, in: low + 5...100)

// Gradient track + invisible slider
ZStack {
    // Colorful track
    LinearGradient(colors: hueColors, ...)
        .frame(height: 6)
        .clipShape(Capsule())

    // Invisible slider captures touch
    Slider(value: $hue, in: 0...1)
        .opacity(0.015)

    // Custom thumb
    GeometryReader { geo in
        Circle().fill(.white)
            .frame(width: 20, height: 20)
            .offset(x: hue * geo.size.width - 10)
    }
}

// Real-time preview
Color(hue: hue, saturation: sat, brightness: bri)
    .animation(.easeInOut(duration: 0.05), value: hue)
""")
        }
    }
}

