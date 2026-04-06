//
//
//  Blendcategoryvisual.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Generic Category Visual (used by lessons 2–7)
struct BlendCategoryVisual: View {
    let category: BlendCategory
    @State private var overlayColor = Color(hex: "#E24B4A")
    @State private var selectedIndex = 0

    var modes: [(name: String, mode: BlendMode, description: String)] {
        category.modes
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {

                // Header
                HStack {
                    Label(category.title, systemImage: "square.2.layers.3d")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(category.accentColor)
                    Spacer()
                    HStack(spacing: 6) {
                        Text("Overlay color")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                        ColorPicker("", selection: $overlayColor)
                            .labelsHidden()
                            .frame(width: 28, height: 28)
                    }
                }

                // Large live preview
                GeometryReader { geo in
                    ZStack {
                        // Base layer fills full width
                        LinearGradient(
                            colors: [
                                Color(hex: "#B5D4F4"),
                                Color(hex: "#9FE1CB"),
                                Color(hex: "#FAC775"),
                                Color(hex: "#F5C4B3"),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(width: geo.size.width, height: 140)

                        // Overlay - sized to card width so it doesn't bleed out
                        Rectangle()
                            .fill(overlayColor)
                            .frame(width: geo.size.width * 0.75, height: 120)
                            .rotationEffect(.degrees(-15))
                            .blendMode(modes[selectedIndex].mode)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(alignment: .bottomLeading) {
                        Text(".\(modes[selectedIndex].name.lowercased().replacingOccurrences(of: " ", with: ""))")
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.black.opacity(0.35))
                            .clipShape(Capsule())
                            .padding(10)
                    }
                }
                .frame(height: 140)
                .animation(.easeInOut(duration: 0.2), value: selectedIndex)
                .animation(.easeInOut(duration: 0.2), value: overlayColor)

                // Mode selector chips - tap to switch the preview above
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: min(modes.count, 2))
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(modes.indices, id: \.self) { i in
                        modeChip(modes[i], index: i)
                    }
                }

                // Description of selected mode
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(category.accentColor)
                        .font(.system(size: 12))
                    Text(modes[selectedIndex].description)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(10)
                .background(category.accentColor.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut(duration: 0.15), value: selectedIndex)
            }
        }
    }

    func modeChip(_ info: (name: String, mode: BlendMode, description: String), index: Int) -> some View {
        let isSelected = selectedIndex == index

        return Button {
            withAnimation(.spring(response: 0.25)) {
                selectedIndex = index
            }
        } label: {
            HStack(spacing: 8) {
                // Mini swatch - still shows the mode at small scale
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "#B5D4F4"), Color(hex: "#FAC775")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    Rectangle()
                        .fill(overlayColor)
                        .blendMode(info.mode)
                }
                .frame(width: 28, height: 28)
                .clipShape(RoundedRectangle(cornerRadius: 6))

                Text(info.name)
                    .font(.system(size: 12, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? category.accentColor : .primary)
                    .lineLimit(1)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(category.accentColor)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? category.accentColor.opacity(0.1) : Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? category.accentColor.opacity(0.4) : Color(.systemFill), lineWidth: isSelected ? 1 : 0.5)
            )
        }
        .buttonStyle(PressableButtonStyle())
    }
}

// MARK: - Generic Category Explanation (used by lessons 2–7)
struct BlendCategoryExplanation: View {
    let category: BlendCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: category.title)

            categoryIntro

            VStack(spacing: 12) {
                ForEach(category.modes.indices, id: \.self) { i in
                    let mode = category.modes[i]
                    StepRow(number: i + 1, text: "\(mode.name) - \(mode.description)", color: category.accentColor)
                }
            }

            categoryCallout

            CodeBlock(code: categoryCode)
        }
    }

    @ViewBuilder
    private var categoryIntro: some View {
        switch category {
        case .darken:
            Text("Darken modes make the result equal to or darker than the original. They look at both layers and always push the output toward black. White has no effect. Only colors darker than the base change the result.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
        case .lighten:
            Text("Lighten modes make the result equal to or lighter than the original. They always push the output toward white. Black has no effect. Only colors lighter than the base change the result.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
        case .contrast:
            Text("Contrast modes amplify differences, making light and dark areas stand out more. dark areas get darker, light areas get lighter. The midpoint (50% gray) has no effect. They're commonly used for dramatic photo treatments and light/shadow overlays.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
        case .inversion:
            Text("Inversion modes subtract colors and invert based on the difference. White inverts the base completely, black has no effect. They produce psychedelic, high-contrast results that flip as colors change.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
        case .component:
            Text("Component modes split color into its HSL components, such as hue, saturation, and luminance and apply only one component from the blend layer while keeping the others from the base. They're precise color-grading tools.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
        case .compositing:
            Text("Compositing modes control layer visibility based on alpha channels and layer order. They're used for masking, cutouts, and precise layer control rather than color effects.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
        }
    }

    @ViewBuilder
    private var categoryCallout: some View {
        switch category {
        case .darken:
            CalloutBox(style: .info, title: "Common use", contentBody: "Multiply is the most used darken mode. It's perfect for shadows, ink effects on paper textures, and darkening photos with a color wash.")
        case .lighten:
            CalloutBox(style: .info, title: "Common use", contentBody: "Screen is the lighten equivalent of Multiply. Use it for light leaks, glows, and brightening effects. Combining Screen and Multiply gives you Overlay.")
        case .contrast:
            CalloutBox(style: .info, title: "Common use", contentBody: "Overlay is the go-to for adding texture to photos. Soft Light is subtler,  great for skin tones. Hard Light is the same as Overlay but with source and destination swapped.")
        case .inversion:
            CalloutBox(style: .warning, title: "Context sensitive", contentBody: "Difference and Exclusion produce very different results depending on your colors. The same mode can look dramatic or nearly invisible, depending on the images you experiment with the color picker.")
        case .component:
            CalloutBox(style: .success, title: "Color grading", contentBody: "Use Color mode to colorize a grayscale image. Use Luminosity to apply the brightness of one layer to the color of another, like in a classic photo editing technique.")
        case .compositing:
            CalloutBox(style: .warning, title: "Requires transparency", contentBody: "Compositing modes depend on alpha channels. They have little visible effect on fully opaque solid colors, so it's best to pair them with views that have transparency.")
        }
    }

    private var categoryCode: String {
        switch category {
        case .darken:
            return """
// Multiply - classic shadow effect
Rectangle()
    .fill(.black.opacity(0.5))
    .blendMode(.multiply)

// Color Burn - intense darkening
Image("texture")
    .blendMode(.colorBurn)
"""
        case .lighten:
            return """
// Screen - glow / light leak effect
Circle()
    .fill(.white.opacity(0.8))
    .blendMode(.screen)

// Color Dodge - extreme brightening
Rectangle()
    .fill(.yellow)
    .blendMode(.colorDodge)
"""
        case .contrast:
            return """
// Overlay - adds texture to photos
Image("grunge_texture")
    .blendMode(.overlay)

// Soft Light - subtle mood shift
Rectangle()
    .fill(.orange.opacity(0.4))
    .blendMode(.softLight)
"""
        case .inversion:
            return """
// Difference - psychedelic inversion
Rectangle()
    .fill(.white)
    .blendMode(.difference)  // fully inverts base

// Exclusion - softer version
Rectangle()
    .fill(color)
    .blendMode(.exclusion)
"""
        case .component:
            return """
// Color - colorize a grayscale image
Rectangle()
    .fill(.blue)
    .blendMode(.color)

// Luminosity - apply brightness only
Image("bright_layer")
    .blendMode(.luminosity)
"""
        case .compositing:
            return """
// Source Atop - clip to destination shape
Circle()
    .fill(.red)
    .blendMode(.sourceAtop)

// Destination Out - punch a hole in dest
Circle()
    .fill(.white)
    .blendMode(.destinationOut)
"""
        }
    }
}
