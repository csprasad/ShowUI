//
//
//  2_LinearGradient.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Linear Gradient
struct LinearGradientVisual: View {
    @State private var selectedDemo   = 0
    @State private var angle: Double  = 45
    @State private var colorCount     = 2
    @State private var animating      = false

    let demos = ["Direction", "Custom angle", "Stops", "Animated"]

    let presetColors: [[Color]] = [
        [Color(hex: "#667EEA"), Color(hex: "#764BA2")],
        [Color(hex: "#F093FB"), Color(hex: "#F5576C")],
        [Color(hex: "#4FACFE"), Color(hex: "#00F2FE")],
        [Color(hex: "#43E97B"), Color(hex: "#38F9D7")],
        [Color(hex: "#FA709A"), Color(hex: "#FEE140")],
        [Color(hex: "#A18CD1"), Color(hex: "#FBC2EB")],
    ]
    @State private var selectedPalette = 0

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Linear gradient", systemImage: "arrow.up.right.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cgAmber)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(demos.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedDemo = i; animating = false }
                            } label: {
                                Text(demos[i])
                                    .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                    .foregroundStyle(selectedDemo == i ? Color.cgAmber : .secondary)
                                    .padding(.horizontal, 12).padding(.vertical, 7)
                                    .background(selectedDemo == i ? Color.cgAmberLight : Color(.systemFill))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }

                ZStack {
                    Color(.secondarySystemBackground)
                    linearDemo.padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 170)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedDemo)
                .animation(.easeInOut(duration: 0.15), value: angle)
                .animation(.spring(response: 0.3), value: selectedPalette)
            }
        }
    }

    @ViewBuilder
    private var linearDemo: some View {
        switch selectedDemo {
        case 0:
            // Direction presets
            let directions: [(name: String, start: UnitPoint, end: UnitPoint)] = [
                ("→ trailing",    .leading,      .trailing),
                ("↓ bottom",      .top,          .bottom),
                ("↗ topTrailing", .bottomLeading,.topTrailing),
                ("↘ bottomTrailing", .topLeading, .bottomTrailing),
                ("← leading",    .trailing,     .leading),
                ("↑ top",         .bottom,       .top),
            ]
            VStack(spacing: 8) {
                // Palette selector row
                HStack(spacing: 6) {
                    ForEach(presetColors.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.25)) { selectedPalette = i }
                        } label: {
                            LinearGradient(colors: presetColors[i], startPoint: .leading, endPoint: .trailing)
                                .frame(width: 28, height: 28).clipShape(Circle())
                                .overlay(Circle().stroke(.white, lineWidth: selectedPalette == i ? 2.5 : 0))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                    Spacer()
                }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 3), spacing: 6) {
                    ForEach(directions.indices, id: \.self) { i in
                        VStack(spacing: 3) {
                            LinearGradient(colors: presetColors[selectedPalette], startPoint: directions[i].start, endPoint: directions[i].end)
                                .frame(height: 36).clipShape(RoundedRectangle(cornerRadius: 8))
                            Text(directions[i].name).font(.system(size: 8)).foregroundStyle(.secondary)
                        }
                    }
                }
            }

        case 1:
            // Custom angle
            VStack(spacing: 12) {
                LinearGradient(colors: presetColors[selectedPalette], startPoint: angleToUnitPoint(angle), endPoint: angleToUnitPoint(angle + 180))
                    .frame(maxWidth: .infinity).frame(height: 80).clipShape(RoundedRectangle(cornerRadius: 12))
                HStack(spacing: 10) {
                    Text("angle").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 36)
                    Slider(value: $angle, in: 0...360, step: 5).tint(.cgAmber)
                    Text("\(Int(angle))°").font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.cgAmber).frame(width: 36)
                }
                // Palette row
                HStack(spacing: 6) {
                    ForEach(presetColors.indices, id: \.self) { i in
                        Button { withAnimation { selectedPalette = i } } label: {
                            LinearGradient(colors: presetColors[i], startPoint: .leading, endPoint: .trailing)
                                .frame(width: 24, height: 24).clipShape(Circle())
                                .overlay(Circle().stroke(.white, lineWidth: selectedPalette == i ? 2 : 0))
                        }.buttonStyle(PressableButtonStyle())
                    }
                    Spacer()
                }
            }

        case 2:
            // Color stops
            VStack(spacing: 10) {
                // Stops with explicit positions
                VStack(spacing: 4) {
                    Text("Explicit stops - position: 0.0…1.0").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                    LinearGradient(stops: [
                        .init(color: Color(hex: "#667EEA"), location: 0.0),
                        .init(color: Color(hex: "#764BA2"), location: 0.3),
                        .init(color: Color(hex: "#F5576C"), location: 0.7),
                        .init(color: Color(hex: "#FEE140"), location: 1.0),
                    ], startPoint: .leading, endPoint: .trailing)
                    .frame(height: 44).clipShape(RoundedRectangle(cornerRadius: 10))

                    // Stop markers
                    HStack(spacing: 0) {
                        ForEach([(0.0, "#667EEA"), (0.3, "#764BA2"), (0.7, "#F5576C"), (1.0, "#FEE140")], id: \.0) { pos, hex in
                            Spacer(minLength: 0)
                            VStack(spacing: 2) {
                                Text("|").font(.system(size: 8)).foregroundStyle(.secondary)
                                Text(String(format: "%.1f", pos)).font(.system(size: 7, design: .monospaced)).foregroundStyle(.secondary)
                            }
                            Spacer(minLength: 0)
                        }
                    }
                }

                // Uneven distribution
                VStack(spacing: 4) {
                    Text("Uneven - compressed end").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                    LinearGradient(stops: [
                        .init(color: Color(hex: "#4FACFE"), location: 0.0),
                        .init(color: Color(hex: "#00F2FE"), location: 0.85),
                        .init(color: .white, location: 1.0),
                    ], startPoint: .leading, endPoint: .trailing)
                    .frame(height: 36).clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }

        default:
            // Animated gradient
            VStack(spacing: 12) {
                LinearGradient(
                    colors: animating ? [Color(hex: "#F093FB"), Color(hex: "#4FACFE"), Color(hex: "#43E97B")] : [Color(hex: "#667EEA"), Color(hex: "#F5576C"), Color(hex: "#FEE140")],
                    startPoint: animating ? .bottomLeading : .topLeading,
                    endPoint: animating ? .topTrailing : .bottomTrailing
                )
                .frame(maxWidth: .infinity).frame(height: 80).clipShape(RoundedRectangle(cornerRadius: 12))
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animating)

                Button {
                    animating.toggle()
                } label: {
                    Text(animating ? "Stop animation" : "Animate gradient")
                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(Color.cgAmber).clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(PressableButtonStyle())
                Text("Animate colors, startPoint and endPoint for fluid gradient motion")
                    .font(.system(size: 10)).foregroundStyle(.secondary).multilineTextAlignment(.center)
            }
        }
    }

    func angleToUnitPoint(_ degrees: Double) -> UnitPoint {
        let rad = degrees * .pi / 180
        let x = 0.5 + 0.5 * sin(rad)
        let y = 0.5 - 0.5 * cos(rad)
        return UnitPoint(x: x, y: y)
    }
}

struct LinearGradientExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "LinearGradient")
            Text("LinearGradient blends colors along a straight line between two points. The gradient is defined by its colors (or stops with positions), a start point, and an end point - both specified as UnitPoint values from 0 to 1.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "LinearGradient(colors: [.red, .blue], startPoint: .leading, endPoint: .trailing)", color: .cgAmber)
                StepRow(number: 2, text: "UnitPoint presets: .leading, .trailing, .top, .bottom, .topLeading, .topTrailing, .bottomLeading, .bottomTrailing", color: .cgAmber)
                StepRow(number: 3, text: "Custom UnitPoint(x: 0.2, y: 0.8) - any point in 0–1 space for diagonal angles.", color: .cgAmber)
                StepRow(number: 4, text: "Gradient.Stop(color:location:) - explicit color positions. location: 0 = start, 1 = end.", color: .cgAmber)
                StepRow(number: 5, text: "Animate colors and points by wrapping changes in withAnimation - gradient morphs smoothly.", color: .cgAmber)
            }

            CalloutBox(style: .success, title: "Use .gradient on Color", contentBody: "Color.blue.gradient returns a lightweight gradient that goes from the color to a slightly lighter version. Great for subtle backgrounds without needing to specify a full LinearGradient.")

            CodeBlock(code: """
// Basic
LinearGradient(
    colors: [.purple, .blue],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

// With explicit stops
LinearGradient(stops: [
    .init(color: .purple, location: 0.0),
    .init(color: .purple, location: 0.3),  // hold
    .init(color: .blue,   location: 1.0),
], startPoint: .leading, endPoint: .trailing)

// Shorthand .gradient on Color
Rectangle().fill(.blue.gradient)

// Animated gradient
LinearGradient(
    colors: isActive ? activeColors : idleColors,
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
.animation(.easeInOut(duration: 1.5)
    .repeatForever(), value: isActive)
""")
        }
    }
}

