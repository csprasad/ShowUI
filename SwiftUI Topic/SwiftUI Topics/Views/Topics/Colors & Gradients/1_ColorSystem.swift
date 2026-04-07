//
//
//  1_ColorSystem.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: Color System
struct ColorSystemVisual: View {
    @State private var selectedDemo = 0
    @State private var opacity: Double = 1.0
    @Environment(\.colorScheme) var scheme

    let demos = ["Semantic", "Hex & RGB", "Opacity"]

    // Semantic color groups
    let semanticColors: [(name: String, color: Color, desc: String)] = [
        (".primary",           .primary,                "Text - auto dark/light"),
        (".secondary",         .secondary,              "Secondary text"),
        (".accentColor",       .accentColor,            "App tint"),
        (".red",               .red,                    "System red"),
        (".blue",              .blue,                   "System blue"),
        (".green",             .green,                  "System green"),
        (".orange",            .orange,                 "System orange"),
        (".purple",            .purple,                 "System purple"),
        ("systemBackground",   Color(.systemBackground),"Background - adaptive"),
        ("secondarySystemBg",  Color(.secondarySystemBackground), "Card bg - adaptive"),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Color system", systemImage: "circle.hexagongrid.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cgAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
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
                    // Semantic color grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), alignment: .leading, spacing: 8) {
                        ForEach(semanticColors, id: \.name) { item in
                            HStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(item.color)
                                    .frame(width: 28, height: 28)
                                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(.systemFill), lineWidth: 0.5))
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(item.name)
                                        .font(.system(size: 9, weight: .semibold, design: .monospaced))
                                        .foregroundStyle(.primary)
                                        .lineLimit(1).minimumScaleFactor(0.7)
                                    Text(item.desc)
                                        .font(.system(size: 8))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(6)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }

                case 1:
                    // Hex & RGB demos
                    VStack(alignment: .leading, spacing: 8) {
                        colorRow("Color(hex: \"#FF5733\")", color: Color(hex: "#FF5733"))
                        colorRow("Color(hex: \"#2ECC71\")", color: Color(hex: "#2ECC71"))
                        colorRow("Color(hex: \"#3498DB\")", color: Color(hex: "#3498DB"))
                        colorRow("Color(red: 0.8, green: 0.2, blue: 0.5)", color: Color(red: 0.8, green: 0.2, blue: 0.5))
                        colorRow("Color(hue: 0.55, sat: 0.8, bright: 0.9)", color: Color(hue: 0.55, saturation: 0.8, brightness: 0.9))
                        colorRow("Color(white: 0.6)", color: Color(white: 0.6))
                    }

                default:
                    // Opacity demo
                    VStack(alignment: .leading,spacing: 12) {
                        HStack(spacing: 6) {
                            Text("opacity").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 50)
                            Slider(value: $opacity, in: 0...1).tint(.cgAmber)
                            Text(String(format: "%.2f", opacity))
                                .font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.cgAmber).frame(width: 36)
                        }

                        HStack(spacing: 10) {
                            ForEach([Color.cgAmber, Color.blue, Color.formGreen, Color.animCoral], id: \.self) { color in
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(color.opacity(opacity))
                                    .frame(height: 52)
                                    .animation(.easeInOut(duration: 0.05), value: opacity)
                            }
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            codeChip(".opacity(\(String(format: "%.2f", opacity)))")
                            codeChip("color.opacity(\(String(format: "%.2f", opacity)))")
                            codeChip(".foregroundStyle(.blue.opacity(\(String(format: "%.2f", opacity))))")
                        }
                    }
                }
            }
        }
    }

    func colorRow(_ code: String, color: Color) -> some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 6).fill(color).frame(width: 28, height: 28)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(.systemFill), lineWidth: 0.5))
            Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary).lineLimit(1).minimumScaleFactor(0.7)
        }
        .padding(6).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func codeChip(_ text: String) -> some View {
        Text(text).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.cgAmber)
            .padding(.horizontal, 8).padding(.vertical, 4).background(Color.cgAmberLight).clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

struct ColorSystemExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "The color system")
            Text("SwiftUI's Color type wraps UIColor and works in light and dark mode automatically. System colors adapt to the current appearance. Always prefer semantic colors over hardcoded hex values for UI elements that need dark mode support.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Semantic colors (.primary, .secondary, .red) adapt to dark/light mode automatically.", color: .cgAmber)
                StepRow(number: 2, text: "Color(.systemBackground) reads UIColor system colors - fully adaptive at all appearance levels.", color: .cgAmber)
                StepRow(number: 3, text: "Color(hex: \"#RRGGBB\") requires a custom init (not built in). Useful for brand colors.", color: .cgAmber)
                StepRow(number: 4, text: "Color(red:green:blue:) - values 0–1. Color(hue:saturation:brightness:) - HSB model.", color: .cgAmber)
                StepRow(number: 5, text: ".opacity(n) on a Color or .foregroundStyle(color.opacity(n)) - 0 = transparent, 1 = fully opaque.", color: .cgAmber)
            }

            CalloutBox(style: .warning, title: "Hardcoded hex doesn't adapt", contentBody: "Color(hex: \"#FFFFFF\") is always white - even in dark mode. For UI elements that should adapt, use Color(.systemBackground) or Color(.label) which flip between light and dark values automatically.")

            CalloutBox(style: .info, title: "Asset catalog colors are the best of both", contentBody: "Define colors in the asset catalog with light and dark variants. Access them with Color(\"MyColorName\") - they adapt to dark mode like semantic colors but let you use any specific hex values you need.")

            CodeBlock(code: """
// Adaptive semantic colors - always prefer these for UI
Text("Hello").foregroundStyle(.primary)
Rectangle().fill(Color(.systemBackground))
Rectangle().fill(Color(.secondarySystemBackground))

// Named system colors
Color.red / .blue / .green / .orange / .purple

// Hex (custom init - not built in)
Color(hex: "#FF5733")    // needs extension

// RGB and HSB
Color(red: 0.9, green: 0.3, blue: 0.1)
Color(hue: 0.55, saturation: 0.8, brightness: 0.9)

// Opacity variants
color.opacity(0.5)
Color.blue.opacity(0.15)   // great for tinted backgrounds
.foregroundStyle(.red.opacity(0.7))
""")
        }
    }
}
