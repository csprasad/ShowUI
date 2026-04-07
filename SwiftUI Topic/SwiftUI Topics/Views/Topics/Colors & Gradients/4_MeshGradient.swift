//
//
//  4_MeshGradient.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Mesh Gradient
struct MeshGradientVisual: View {
    @State private var animating = false
    @State private var selectedPreset = 0
    @State private var phase: Float = 0

    let presets = ["Aurora", "Ocean", "Sunset", "Forest"]

    var timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Mesh gradient", systemImage: "waveform.path")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.cgAmber)
                    Spacer()
                    Text("iOS 18+")
                        .font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.cgAmber)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.cgAmberLight).clipShape(Capsule())
                }

                // Preset selector
                HStack(spacing: 8) {
                    ForEach(presets.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.4)) { selectedPreset = i }
                        } label: {
                            Text(presets[i])
                                .font(.system(size: 11, weight: selectedPreset == i ? .semibold : .regular))
                                .foregroundStyle(selectedPreset == i ? Color.cgAmber : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedPreset == i ? Color.cgAmberLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Mesh gradient preview
                if #available(iOS 18, *) {
                    meshPreview
                        .frame(maxWidth: .infinity).frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: selectedPreset)
                        .onReceive(timer) { _ in
                            if animating { phase += 0.02 }
                        }
                } else {
                    // Fallback for older iOS
                    ZStack {
                        LinearGradient(colors: presetColors[selectedPreset], startPoint: .topLeading, endPoint: .bottomTrailing)
                        VStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(.white.opacity(0.7))
                            Text("MeshGradient requires iOS 18")
                                .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white.opacity(0.9))
                        }
                    }
                    .frame(maxWidth: .infinity).frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                // Animate button
                Button {
                    withAnimation(.spring(response: 0.3)) { animating.toggle() }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: animating ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 16))
                        Text(animating ? "Pause animation" : "Animate mesh")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 10)
                    .background(Color.cgAmber)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
    }

    let presetColors: [[Color]] = [
        [Color(hex: "#00C9FF"), Color(hex: "#92FE9D"), Color(hex: "#667EEA")],
        [Color(hex: "#0575E6"), Color(hex: "#021B79"), Color(hex: "#00C9FF")],
        [Color(hex: "#F7971E"), Color(hex: "#FFD200"), Color(hex: "#FF512F")],
        [Color(hex: "#11998E"), Color(hex: "#38EF7D"), Color(hex: "#1D976C")],
    ]

    @available(iOS 18, *)
    var meshPreview: some View {
        let p = phase
        switch selectedPreset {
        case 0: // Aurora
            return AnyView(MeshGradient(width: 3, height: 3, points: [
                .init(0, 0), .init(0.5, 0), .init(1, 0),
                .init(0, 0.5 + sin(p) * 0.1), .init(0.5 + cos(p) * 0.1, 0.5), .init(1, 0.5 + sin(p + 1) * 0.1),
                .init(0, 1), .init(0.5, 1), .init(1, 1),
            ], colors: [
                Color(hex: "#00C9FF"), Color(hex: "#92FE9D"), Color(hex: "#667EEA"),
                Color(hex: "#667EEA"), Color(hex: "#00C9FF"), Color(hex: "#92FE9D"),
                Color(hex: "#92FE9D"), Color(hex: "#667EEA"), Color(hex: "#00C9FF"),
            ]))
        case 1: // Ocean
            return AnyView(MeshGradient(width: 3, height: 3, points: [
                .init(0, 0), .init(0.5, 0), .init(1, 0),
                .init(0 + sin(p) * 0.05, 0.5), .init(0.5, 0.5 + cos(p) * 0.08), .init(1 + sin(p + 2) * 0.05, 0.5),
                .init(0, 1), .init(0.5, 1), .init(1, 1),
            ], colors: [
                Color(hex: "#021B79"), Color(hex: "#0575E6"), Color(hex: "#00C9FF"),
                Color(hex: "#0575E6"), Color(hex: "#021B79"), Color(hex: "#0575E6"),
                Color(hex: "#00C9FF"), Color(hex: "#0575E6"), Color(hex: "#021B79"),
            ]))
        case 2: // Sunset
            return AnyView(MeshGradient(width: 3, height: 3, points: [
                .init(0, 0), .init(0.5, 0), .init(1, 0),
                .init(0, 0.5 + cos(p) * 0.08), .init(0.5 + sin(p) * 0.08, 0.5), .init(1, 0.5),
                .init(0, 1), .init(0.5, 1), .init(1, 1),
            ], colors: [
                Color(hex: "#FF512F"), Color(hex: "#F09819"), Color(hex: "#FFD200"),
                Color(hex: "#F7971E"), Color(hex: "#FF512F"), Color(hex: "#F09819"),
                Color(hex: "#FFD200"), Color(hex: "#F7971E"), Color(hex: "#FF512F"),
            ]))
        default: // Forest
            return AnyView(MeshGradient(width: 3, height: 3, points: [
                .init(0, 0), .init(0.5, 0), .init(1, 0),
                .init(0, 0.5), .init(0.5 + cos(p) * 0.06, 0.5 + sin(p) * 0.06), .init(1, 0.5),
                .init(0, 1), .init(0.5, 1), .init(1, 1),
            ], colors: [
                Color(hex: "#1D976C"), Color(hex: "#11998E"), Color(hex: "#38EF7D"),
                Color(hex: "#11998E"), Color(hex: "#38EF7D"), Color(hex: "#1D976C"),
                Color(hex: "#38EF7D"), Color(hex: "#1D976C"), Color(hex: "#11998E"),
            ]))
        }
    }
}

struct MeshGradientExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "MeshGradient - iOS 18")
            Text("MeshGradient is a new gradient type in iOS 18 that places colors at arbitrary points on a 2D grid, then smoothly interpolates between them. It enables organic, fluid color fields impossible with linear or radial gradients.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "MeshGradient(width: 3, height: 3, points: [...], colors: [...]) - 3×3 grid = 9 control points.", color: .cgAmber)
                StepRow(number: 2, text: "points: array of SIMD2<Float> - each point's position in 0…1 space. width×height total points.", color: .cgAmber)
                StepRow(number: 3, text: "colors: array of Color - one per point, in row-major order (left to right, top to bottom).", color: .cgAmber)
                StepRow(number: 4, text: "Animate by mutating point positions over time - move interior points to create flowing motion.", color: .cgAmber)
                StepRow(number: 5, text: "smoothsColors: false - disable bicubic smoothing for harder color boundaries.", color: .cgAmber)
            }

            CalloutBox(style: .info, title: "iOS 18+ only", contentBody: "MeshGradient requires iOS 18. Use #available(iOS 18, *) checks and provide a LinearGradient fallback for older devices.")

            CalloutBox(style: .success, title: "Animate for living backgrounds", contentBody: "Move the interior mesh points slightly over time using sin/cos with a phase value for an organic flowing animation. Keep movement subtle (±0.05 to 0.1) for best results.")

            CodeBlock(code: """
if #available(iOS 18, *) {
    MeshGradient(
        width: 3,
        height: 3,
        points: [
            // Top row - fixed
            [0, 0], [0.5, 0], [1, 0],
            // Middle row - animate these
            [0, 0.5], [0.5, 0.5], [1, 0.5],
            // Bottom row - fixed
            [0, 1], [0.5, 1], [1, 1],
        ],
        colors: [
            .purple, .blue, .cyan,
            .blue,   .teal, .blue,
            .cyan,   .blue, .purple,
        ]
    )
}

// Animated version
@State private var phase: Float = 0

// In a Timer or task:
phase += 0.02

// Use phase in points:
[0.5 + sin(phase) * 0.08, 0.5 + cos(phase) * 0.06]
""")
        }
    }
}

