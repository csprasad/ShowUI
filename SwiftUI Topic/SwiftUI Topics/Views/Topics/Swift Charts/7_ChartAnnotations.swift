//
//
//  7_ChartAnnotations.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Charts

// MARK: - LESSON 7: Chart Annotations
struct SCAnnotationsVisual: View {
    @State private var selectedDemo   = 0
    @State private var threshold: Double = 70
    let demos = ["RuleMark", "Threshold line", "Value labels"]

    let data = SalesData.monthly

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Chart annotations", systemImage: "text.badge.plus")
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
                    // RuleMark - horizontal and vertical
                    VStack(spacing: 6) {
                        Chart {
                            // Data bars
                            ForEach(data) { d in
                                BarMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                    .foregroundStyle(Color.scBlue.opacity(0.7))
                                    .cornerRadius(3)
                            }
                            // Average RuleMark
                            let avg = data.map(\.revenue).reduce(0, +) / Double(data.count)
                            RuleMark(y: .value("Average", avg))
                                .foregroundStyle(Color.animCoral)
                                .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [6, 3]))
                                .annotation(position: .top, alignment: .trailing) {
                                    Text("Avg: \(Int(avg))")
                                        .font(.system(size: 9, weight: .semibold))
                                        .foregroundStyle(Color.animCoral)
                                        .padding(.horizontal, 5).padding(.vertical, 2)
                                        .background(Color.animCoral.opacity(0.1))
                                        .clipShape(Capsule())
                                }
                            // Vertical rule
                            RuleMark(x: .value("Month", "Apr"))
                                .foregroundStyle(Color(hex: "#7C3AED").opacity(0.6))
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                                .annotation(position: .top) {
                                    Text("Launch")
                                        .font(.system(size: 8, weight: .semibold))
                                        .foregroundStyle(Color(hex: "#7C3AED"))
                                }
                        }
                        .frame(height: 170)
                    }

                case 1:
                    // Threshold with slider
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Text("Target: \(Int(threshold))").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 72)
                            Slider(value: $threshold, in: 30...110, step: 5).tint(.scBlue)
                        }

                        Chart {
                            ForEach(data) { d in
                                BarMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                    .foregroundStyle(d.revenue >= threshold ? Color.formGreen.gradient : Color.animCoral.gradient)
                                    .cornerRadius(3)
                            }
                            RuleMark(y: .value("Target", threshold))
                                .foregroundStyle(Color.animAmber)
                                .lineStyle(StrokeStyle(lineWidth: 2))
                                .annotation(position: .top, alignment: .leading) {
                                    Label("Target", systemImage: "target")
                                        .font(.system(size: 9, weight: .semibold))
                                        .foregroundStyle(Color.animAmber)
                                }
                        }
                        .frame(height: 150)
                        .animation(.spring(response: 0.3), value: threshold)
                    }

                default:
                    // Per-bar value labels
                    Chart(data) { d in
                        BarMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                            .foregroundStyle(Color.scBlue.gradient)
                            .cornerRadius(4)
                            .annotation(position: .top, alignment: .center, spacing: 4) {
                                Text("\(Int(d.revenue))")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundStyle(Color.scBlue)
                            }
                        PointMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                            .symbolSize(0) // invisible - used for overlay positioning
                    }
                    .frame(height: 180)
                    .chartYAxis(.hidden)
                }
            }
        }
    }
}

struct SCAnnotationsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Annotations - RuleMark and overlays")
            Text("RuleMark draws reference lines - horizontal thresholds, vertical event markers, or average lines. .annotation() pins any SwiftUI view to a mark's position in chart coordinates.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "RuleMark(y: .value(\"Target\", 70)) - horizontal reference line across full chart.", color: .scBlue)
                StepRow(number: 2, text: "RuleMark(x: .value(\"Event\", \"Apr\")) - vertical marker at a categorical value.", color: .scBlue)
                StepRow(number: 3, text: ".annotation(position: .top, alignment: .trailing) { view } - pin a SwiftUI view to the mark.", color: .scBlue)
                StepRow(number: 4, text: ".lineStyle(StrokeStyle(lineWidth:dash:)) - dashed or solid reference line.", color: .scBlue)
                StepRow(number: 5, text: "BarMark .annotation(position: .top) - per-bar value labels.", color: .scBlue)
            }

            CodeBlock(code: """
Chart {
    ForEach(data) { d in
        BarMark(x: .value("M", d.month), y: .value("R", d.revenue))
            .cornerRadius(4)
            // Per-bar label
            .annotation(position: .top, alignment: .center) {
                Text("\\(Int(d.revenue))")
                    .font(.caption2.weight(.semibold))
            }
    }

    // Average line
    let avg = data.map(\\.revenue).reduce(0,+) / Double(data.count)
    RuleMark(y: .value("Average", avg))
        .foregroundStyle(.red)
        .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [5,3]))
        .annotation(position: .top, alignment: .trailing) {
            Text("Avg")
                .font(.caption2)
                .foregroundStyle(.red)
        }

    // Event marker
    RuleMark(x: .value("Launch", "Apr"))
        .foregroundStyle(.purple.opacity(0.5))
        .annotation(position: .top) {
            Image(systemName: "star.fill")
                .foregroundStyle(.purple)
        }
}
""")
        }
    }
}
