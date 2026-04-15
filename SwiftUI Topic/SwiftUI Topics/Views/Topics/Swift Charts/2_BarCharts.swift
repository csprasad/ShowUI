//
//
//  2_BarCharts.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Charts

// MARK: - LESSON 2: Bar Charts
struct SCBarChartsVisual: View {
    @State private var selectedDemo = 0
    @State private var isHorizontal = false
    @State private var isStacked    = true
    let demos = ["Basic bar", "Grouped & stacked", "Annotations"]

    let data = SalesData.monthly
    let stacked = SalesData.stacked

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Bar charts", systemImage: "chart.bar.fill")
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
                    // Basic bar with orientation toggle
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Toggle(isHorizontal ? "Horizontal Chart" : "Verticle Chart", isOn: $isHorizontal.animation(.spring(response: 0.4))).tint(.scBlue).font(.system(size: 13, weight: .bold))
                        }

                        if isHorizontal {
                            Chart(data) { d in
                                BarMark(
                                    x: .value("Revenue", d.revenue),
                                    y: .value("Month", d.month)
                                )
                                .foregroundStyle(Color.scBlue.gradient)
                                .cornerRadius(4)
                            }
                            .frame(height: 160)
                            .chartXAxis {
                                AxisMarks(values: .automatic(desiredCount: 5))
                            }
                        } else {
                            Chart(data) { d in
                                BarMark(
                                    x: .value("Month", d.month),
                                    y: .value("Revenue", d.revenue)
                                )
                                .foregroundStyle(Color.scBlue.gradient)
                                .cornerRadius(4)
                            }
                            .frame(height: 160)
                            .chartYAxis {
                                AxisMarks(values: .automatic(desiredCount: 4)) { value in
                                    AxisGridLine()
                                    AxisValueLabel {
                                        if let v = value.as(Double.self) {
                                            Text("\(Int(v))k").font(.system(size: 9))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .animation(.spring(response: 0.4), value: isHorizontal)

                case 1:
                    // Grouped vs stacked
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Button(isStacked ? "Swith to Group" : "Swith to Stack") {
                                withAnimation(.spring(response: 0.4)) { isStacked.toggle() }
                            }
                            .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                            .padding(.horizontal, 14).padding(.vertical, 7)
                            .background(Color.scBlue).clipShape(Capsule())
                            .buttonStyle(PressableButtonStyle())
                            Spacer()
                        }

                        Chart(stacked) { d in
                            BarMark(
                                x: .value("Month",    d.month),
                                y: .value("Revenue",  d.revenue),
                                stacking: isStacked ? .standard : .unstacked
                            )
                            .foregroundStyle(by: .value("Platform", d.category))
                            .cornerRadius(3)
                        }
                        .chartForegroundStyleScale([
                            "iOS":     Color.scBlue,
                            "Android": Color(hex: "#0F766E"),
                        ])
                        .chartLegend(position: .bottom, alignment: .leading)
                        .frame(height: 160)
                        .animation(.spring(response: 0.5), value: isStacked)
                    }

                default:
                    // Annotations on bars
                    Chart(data) { d in
                        BarMark(
                            x: .value("Month",   d.month),
                            y: .value("Revenue", d.revenue)
                        )
                        .foregroundStyle(Color.scBlue.gradient)
                        .cornerRadius(4)
                        .annotation(position: .top, alignment: .center) {
                            Text("\(Int(d.revenue))")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundStyle(Color.scBlue)
                        }
                    }
                    .frame(height: 180)
                    .chartYAxis(.hidden)
                    .chartXAxis {
                        AxisMarks { _ in AxisValueLabel() }
                    }
                }
            }
        }
    }
}

struct SCBarChartsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "BarMark - bar charts")
            Text("BarMark creates bars from x and y values. Swap x/y for horizontal bars. Add .foregroundStyle(by:) for grouped or stacked series. .annotation() pins text or views to each bar.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "BarMark(x: .value(), y: .value()) - vertical bars. Swap axes for horizontal.", color: .scBlue)
                StepRow(number: 2, text: ".cornerRadius(n) - rounds the bar caps. Only works on the mark.", color: .scBlue)
                StepRow(number: 3, text: ".foregroundStyle(by: .value(\"Series\", item.series)) - colour by category for grouped/stacked.", color: .scBlue)
                StepRow(number: 4, text: "stacking: .standard - stacks bars. stacking: .unstacked - side by side (grouped).", color: .scBlue)
                StepRow(number: 5, text: ".annotation(position: .top) { Text(value) } - label above each bar.", color: .scBlue)
                StepRow(number: 6, text: ".chartForegroundStyleScale([\"A\": .blue, \"B\": .green]) - explicit series colours.", color: .scBlue)
            }

            CodeBlock(code: """
// Basic vertical bar
Chart(data) { point in
    BarMark(
        x: .value("Month",   point.month),
        y: .value("Revenue", point.revenue)
    )
    .foregroundStyle(Color.blue.gradient)
    .cornerRadius(4)
}

// Horizontal bar (swap axes)
BarMark(
    x: .value("Revenue", point.revenue),
    y: .value("Month",   point.month)
)

// Stacked bars
BarMark(x: .value("M", m), y: .value("R", r),
        stacking: .standard)  // or .unstacked (grouped)
    .foregroundStyle(by: .value("Platform", platform))

// Annotation on bar top
.annotation(position: .top, alignment: .center) {
    Text("\\(Int(revenue))").font(.caption2)
}
""")
        }
    }
}

