//
//
//  11_ChartStyling.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Charts

// MARK: - LESSON 11: Chart Styling
struct SCStylingVisual: View {
    @State private var selectedDemo   = 0
    @State private var selectedPalette = 0
    let demos = ["Series colours", "Gradient fills", "Dark mode ready"]

    let data = SalesData.stacked

    let palettes: [[Color]] = [
        [Color.scBlue, Color(hex: "#0F766E"), Color(hex: "#7C3AED"), Color(hex: "#D97706")],
        [Color(hex: "#EC4899"), Color(hex: "#8B5CF6"), Color(hex: "#06B6D4"), Color(hex: "#10B981")],
        [Color(hex: "#F97316"), Color(hex: "#EAB308"), Color(hex: "#84CC16"), Color(hex: "#22C55E")],
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Chart styling", systemImage: "paintpalette.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.scBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.scBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.scBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Series colour palettes
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Text("Palette:").font(.system(size: 12)).foregroundStyle(.secondary)
                            ForEach(palettes.indices, id: \.self) { i in
                                Button {
                                    withAnimation(.spring(response: 0.3)) { selectedPalette = i }
                                } label: {
                                    HStack(spacing: 2) {
                                        ForEach(palettes[i].prefix(3), id: \.self) { c in
                                            Circle().fill(c).frame(width: 8, height: 8)
                                        }
                                    }
                                    .padding(.horizontal, 8).padding(.vertical, 5)
                                    .background(selectedPalette == i ? Color(.systemFill) : Color.clear)
                                    .clipShape(Capsule())
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }

                        Chart(data) { d in
                            BarMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue), stacking: .standard)
                                .foregroundStyle(by: .value("Platform", d.category))
                                .cornerRadius(3)
                        }
                        .chartForegroundStyleScale([
                            "iOS":     palettes[selectedPalette][0],
                            "Android": palettes[selectedPalette][1],
                        ])
                        .chartLegend(position: .bottom, alignment: .leading)
                        .frame(height: 150)
                        .animation(.spring(response: 0.4), value: selectedPalette)
                    }

                case 1:
                    // Gradient fills
                    let data2 = SalesData.monthly
                    VStack(spacing: 8) {
                        Chart(data2) { d in
                            BarMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(hex: "#7C3AED"), Color.scBlue],
                                        startPoint: .bottom, endPoint: .top
                                    )
                                )
                                .cornerRadius(5)
                        }
                        .frame(height: 100)

                        Chart(data2) { d in
                            AreaMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.scBlue.opacity(0.5), Color.scBlue.opacity(0.02)],
                                        startPoint: .top, endPoint: .bottom
                                    )
                                )
                            LineMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(Color.scBlue)
                                .lineStyle(StrokeStyle(lineWidth: 2.5))
                        }
                        .frame(height: 80)
                    }

                default:
                    // Dark mode ready
                    let darkSafeData = SalesData.monthly
                    VStack(spacing: 6) {
                        ForEach(["Light mode", "Dark mode"], id: \.self) { mode in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(mode).font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                                Chart(darkSafeData) { d in
                                    LineMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                        .foregroundStyle(Color.accentColor)
                                        .interpolationMethod(.catmullRom)
                                        .lineStyle(StrokeStyle(lineWidth: 2.5))
                                    AreaMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                        .foregroundStyle(Color.accentColor.opacity(0.15))
                                        .interpolationMethod(.catmullRom)
                                }
                                .frame(height: 65)
                                .chartXAxis { AxisMarks { _ in AxisValueLabel().font(.system(size: 8)) } }
                                .chartYAxis(.hidden)
                                .environment(\.colorScheme, mode == "Dark mode" ? .dark : .light)
                                .padding(8)
                                .background(mode == "Dark mode" ? Color(hex: "#1C1C1E") : Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.formGreen).font(.system(size: 11))
                            Text("Use Color.accentColor, .primary, semantic colors - they adapt automatically to dark mode.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(7).background(Color(hex: "#E1F5EE")).clipShape(RoundedRectangle(cornerRadius: 7))
                    }
                }
            }
        }
    }
}

struct SCStylingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Chart styling and colour scales")
            Text(".foregroundStyle(by: .value()) automatically assigns colours per series. Override with .chartForegroundStyleScale() for explicit mapping. Gradients on marks add depth. Semantic colours make charts dark-mode-ready automatically.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".foregroundStyle(by: .value(\"S\", series)) - auto colour by series.", color: .scBlue)
                StepRow(number: 2, text: ".chartForegroundStyleScale([\"A\": .blue, \"B\": .green]) - explicit series → colour map.", color: .scBlue)
                StepRow(number: 3, text: "LinearGradient on mark - vertical gradient on bars or area fills.", color: .scBlue)
                StepRow(number: 4, text: "Color.accentColor / .primary - adapt automatically between light and dark mode.", color: .scBlue)
                StepRow(number: 5, text: ".chartForegroundStyleScale(range: Gradient(colors:)) - map numeric value to gradient.", color: .scBlue)
            }

            CodeBlock(code: """
// Explicit series colour map
.chartForegroundStyleScale([
    "iOS":     Color.blue,
    "Android": Color.green,
    "Web":     Color.purple,
])

// Gradient on a bar
BarMark(...)
    .foregroundStyle(
        LinearGradient(
            colors: [.blue.opacity(0.4), .blue],
            startPoint: .bottom, endPoint: .top
        )
    )

// Heatmap: value → gradient colour
.chartForegroundStyleScale(
    range: Gradient(colors: [.yellow, .red])
)

// Dark mode safe: use semantic colors
.foregroundStyle(Color.accentColor)
.foregroundStyle(Color.primary)
""")
        }
    }
}
