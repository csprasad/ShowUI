//
//
//  6_Axes&ScalesCharts.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Charts

// MARK: - LESSON 6: Axes & Scales
struct SCAxesScalesVisual: View {
    @State private var selectedDemo = 0
    @State private var useLog       = false
    @State private var domainMax: Double = 120
    let demos = ["Axis customisation", "Scale domain", "Log scale"]

    let data = SalesData.monthly

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Axes & scales", systemImage: "slider.horizontal.3")
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
                    // Full axis customisation
                    Chart(data) { d in
                        BarMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                            .foregroundStyle(Color.scBlue.gradient)
                            .cornerRadius(4)
                    }
                    .chartXAxis {
                        AxisMarks { value in
                            AxisTick(stroke: StrokeStyle(lineWidth: 1))
                            AxisValueLabel {
                                if let str = value.as(String.self) {
                                    Text(str).font(.system(size: 9, weight: .medium))
                                        .foregroundStyle(Color.scBlue)
                                }
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks(values: .stride(by: 25)) { value in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4, 3]))
                                .foregroundStyle(Color(.systemGray4))
                            AxisValueLabel {
                                if let v = value.as(Double.self) {
                                    Text("$\(Int(v))k")
                                        .font(.system(size: 9))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .frame(height: 180)

                case 1:
                    // Scale domain control
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Text("Y max: \(Int(domainMax))").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 72)
                            Slider(value: $domainMax, in: 100...200, step: 10).tint(.scBlue)
                        }

                        Chart(data) { d in
                            BarMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                .foregroundStyle(Color.scBlue.gradient)
                                .cornerRadius(4)
                        }
                        .chartYScale(domain: 0...domainMax)
                        .frame(height: 200)
                        .animation(.spring(response: 0.4), value: domainMax)

                        codeSnip(".chartYScale(domain: 0...120) - fix the Y axis domain\n.chartXScale(domain: [\"Jan\",\"Feb\",\"Mar\"]) - fix categorical X")
                    }

                default:
                    // Log scale
                    VStack(spacing: 8) {
                        Toggle("Logarithmic Y axis", isOn: $useLog.animation(.spring(response: 0.4))).tint(.scBlue).font(.system(size: 13))

                        let logData: [(String, Double)] = [
                            ("A",1),("B",10),("C",50),("D",200),("E",1000),("F",5000)
                        ]
                        
                        Chart(logData, id: \.0) { d in
                            BarMark(
                                x: .value("X", d.0),
                                yStart: .value("Baseline", useLog ? 1 : 0),
                                yEnd: .value("Y", d.1)
                            )
                            .foregroundStyle(Color.scBlue.gradient)
                            .cornerRadius(4)
                        }
                        .chartYScale(domain: useLog ? 1...5000 : 0...5000, type: useLog ? .log : .linear)
                                                .frame(height: 140)


                        Text(useLog ? "Logarithmic: 1, 10, 100, 1000 are equally spaced" : "Linear: large values dominate, small ones invisible")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                            .padding(7).background(Color.scBlueLight).clipShape(RoundedRectangle(cornerRadius: 7))
                    }
                }
            }
        }
    }

    func codeSnip(_ t: String) -> some View {
        Text(t).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.scBlue)
            .padding(7).background(Color.scBlueLight).clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

struct SCAxesScalesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Axes, scales and domains")
            Text("chartXAxis { } and chartYAxis { } replace the default axis rendering with fully custom AxisMarks. Control grid lines, ticks, value labels, and formatting. Scale modifiers set the visible domain and scale type.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "AxisMarks(values: .automatic(desiredCount: 5)) - hint the desired tick count.", color: .scBlue)
                StepRow(number: 2, text: "AxisGridLine() + AxisTick() + AxisValueLabel() - build each axis element.", color: .scBlue)
                StepRow(number: 3, text: ".chartYScale(domain: 0...100) - fix the visible Y range.", color: .scBlue)
                StepRow(number: 4, text: ".chartYScale(type: .log) - logarithmic scale for wide-range data.", color: .scBlue)
                StepRow(number: 5, text: ".chartXAxis(.hidden) / .chartYAxis(.hidden) - hide an axis entirely.", color: .scBlue)
            }

            CodeBlock(code: """
Chart(data) { ... }
// Custom Y axis
.chartYAxis {
    AxisMarks(values: .stride(by: 25)) { value in
        AxisGridLine(stroke: StrokeStyle(dash: [4, 3]))
        AxisTick()
        AxisValueLabel {
            if let v = value.as(Double.self) {
                Text("$\\(Int(v))k")
                    .font(.caption2)
            }
        }
    }
}
// Fixed domain
.chartYScale(domain: 0...150)

// Log scale
.chartYScale(type: .log)

// Hide axis
.chartXAxis(.hidden)
""")
        }
    }
}

