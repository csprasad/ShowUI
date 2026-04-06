//
//
//  1_blendintro.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Lesson 1: What is blending?

struct BlendIntroVisual: View {
    @State private var blendOn = true
    @State private var overlayColor = Color(hex: "#E24B4A")

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Blending", systemImage: "square.2.layers.3d")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#993556"))
                    Spacer()
                    Toggle("", isOn: $blendOn)
                        .labelsHidden()
                        .tint(Color(hex: "#993556"))
                }

                // Side by side - no blend vs blend
                HStack(spacing: 12) {
                    layerDemo(label: "No blend", useBlend: false)
                    layerDemo(label: blendOn ? ".multiply" : ".normal", useBlend: blendOn)
                }

                // Color picker
                HStack(spacing: 8) {
                    ColorPicker("", selection: $overlayColor)
                        .labelsHidden()
                        .frame(width: 28, height: 28)
                    Text("Change overlay color")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    func layerDemo(label: String, useBlend: Bool) -> some View {
        VStack(spacing: 8) {
            ZStack {
                // Base layer - checkerboard-like gradient
                LinearGradient(
                    colors: [Color(hex: "#B5D4F4"), Color(hex: "#9FE1CB"), Color(hex: "#FAC775")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Overlay layer
                Rectangle()
                    .fill(overlayColor)
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-15))
                    .blendMode(useBlend ? .multiply : .normal)
            }
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemFill), lineWidth: 0.5)
            )

            Text(label)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct BlendIntroExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "How blending works")
            Text("Every view in SwiftUI is a layer. Blend modes control how a layer's pixels combine with whatever is behind it. Without a blend mode, the top layer simply covers everything below.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "SwiftUI renders views in order. Each sits on top of the previous one.", color: Color(hex: "#993556"))
                StepRow(number: 2, text: "Apply .blendMode() to any view to change how it composites with layers below.", color: Color(hex: "#993556"))
                StepRow(number: 3, text: "The result depends on both the source color (your view) and the destination color (what's behind).", color: Color(hex: "#993556"))
                StepRow(number: 4, text: "Blend modes are grouped by what they do, like darken, lighten, contrast, inversion, component, compositing.", color: Color(hex: "#993556"))
            }

            CalloutBox(style: .info, title: "Where it's used", contentBody: "Blend modes are used for image effects, text overlays on photos, light/shadow effects in game UI, and creative visual treatments, anywhere you composite two layers.")

            CalloutBox(style: .warning, title: "Requires something behind it", contentBody: "A blend mode on a view with nothing behind it has no visible effect. The mode only activates when pixels from two layers overlap.")

            CodeBlock(code: """
ZStack {
    Image("photo")
        .resizable()

    Rectangle()
        .fill(.red)
        .blendMode(.multiply)  // darkens the photo
}
""")
        }
    }
}
