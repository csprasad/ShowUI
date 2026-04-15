//
//
//  3_Line&AreaCharts.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Charts

// MARK: - LESSON 3: Line & Area Charts
struct SCLineAreaVisual: View {
    @State private var selectedDemo  = 0
    @State private var showArea      = true
    @State private var curveType     = 0   // 0=linear, 1=catmullRom, 2=cardinal
    let demos = ["Line styles", "Multi-series", "Area fills"]

    // Mock data structures
    let data = SalesData.monthly
    let series1: [(String, Double)] = [
        ("Jan",42),("Feb",58),("Mar",71),("Apr",63),("May",89),("Jun",102)
    ]
    let series2: [(String, Double)] = [
        ("Jan",28),("Feb",35),("Mar",42),("Apr",55),("May",68),("Jun",74)
    ]

    var interpolation: InterpolationMethod {
        switch curveType {
        case 1: return .catmullRom(alpha: 0.5)
        case 2: return .cardinal(tension: 0.7)
        default: return .linear
        }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Line & area charts", systemImage: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.scBlue)

                // Navigation Header
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
                    // Line styles & interpolation
                    VStack(spacing: 12) {
                        HStack(spacing: 6) {
                            Text("Curve:").font(.system(size: 12)).foregroundStyle(.secondary)
                            ForEach(["Linear", "Catmull-Rom", "Cardinal"].indices, id: \.self) { idx in
                                let names = ["Linear", "Catmull-Rom", "Cardinal"]
                                Button(names[idx]) {
                                    withAnimation(.spring(response: 0.4)) {
                                        curveType = idx
                                    }
                                }
                                .font(.system(size: 11, weight: curveType == idx ? .semibold : .regular))
                                .foregroundStyle(curveType == idx ? .white : .scBlue)
                                .padding(.horizontal, 10).padding(.vertical, 5)
                                .background(curveType == idx ? Color.scBlue : Color.scBlueLight)
                                .clipShape(Capsule())
                            }
                        }

                        Chart(data) { d in
                            LineMark(
                                x: .value("Month", d.month),
                                y: .value("Revenue", d.revenue)
                            )
                            .interpolationMethod(interpolation)
                            .foregroundStyle(Color.scBlue)
                            .lineStyle(StrokeStyle(lineWidth: 2.5))
                            
                            PointMark(
                                x: .value("Month", d.month),
                                y: .value("Revenue", d.revenue)
                            )
                            .foregroundStyle(Color.scBlue)
                        }
                        .frame(height: 150)
                        .id("chart-curve-\(curveType)")
                    }

                case 1:
                    // Multi-series line chart
                    Chart {
                        ForEach(series1, id: \.0) { (m, v) in
                            LineMark(x: .value("Month", m), y: .value("Value", v), series: .value("Series", "iOS"))
                                .foregroundStyle(Color.scBlue)
                                .interpolationMethod(.catmullRom)
                                .lineStyle(StrokeStyle(lineWidth: 2.5))
                            AreaMark(x: .value("Month", m), y: .value("Value", v), series: .value("Series", "iOS"))
                                .foregroundStyle(Color.scBlue.opacity(0.12))
                                .interpolationMethod(.catmullRom)
                        }
                        ForEach(series2, id: \.0) { (m, v) in
                            LineMark(x: .value("Month", m), y: .value("Value", v), series: .value("Series", "Android"))
                                .foregroundStyle(Color(hex: "#0F766E"))
                                .interpolationMethod(.catmullRom)
                                .lineStyle(StrokeStyle(lineWidth: 2.5, dash: [5, 3]))
                            AreaMark(x: .value("Month", m), y: .value("Value", v), series: .value("Series", "Android"))
                                .foregroundStyle(Color(hex: "#0F766E").opacity(0.12))
                                .interpolationMethod(.catmullRom)
                        }
                    }
                    .chartLegend(position: .bottom, alignment: .leading)
                    .frame(height: 170)

                default:
                    // Area fills
                    VStack(spacing: 8) {
                        Toggle("Show area", isOn: $showArea.animation(.spring())).tint(.scBlue).font(.system(size: 13))

                        Chart(data) { d in
                            if showArea {
                                AreaMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(LinearGradient(
                                        colors: [Color.scBlue.opacity(0.4), Color.scBlue.opacity(0.02)],
                                        startPoint: .top, endPoint: .bottom))
                            }
                            LineMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(Color.scBlue)
                                .lineStyle(StrokeStyle(lineWidth: 2.5))
                        }
                        .frame(height: 140)
                    }
                }
            }
        }
    }
}

struct SCLineAreaExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "LineMark & AreaMark")
            Text("LineMark connects data points with a line. AreaMark fills the region under the line. Combine them in the same Chart for a line-with-fill effect. InterpolationMethod controls whether lines are straight or curved.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "LineMark(x:y:) - line chart. .lineStyle(StrokeStyle(lineWidth: 2)) to control thickness.", color: .scBlue)
                StepRow(number: 2, text: ".interpolationMethod(.catmullRom) - smooth curves. .linear - straight segments (default).", color: .scBlue)
                StepRow(number: 3, text: "AreaMark - fills below the line. Use gradient foregroundStyle for depth effect.", color: .scBlue)
                StepRow(number: 4, text: "series: .value(\"S\", \"name\") - tell Charts which points belong to the same series line.", color: .scBlue)
                StepRow(number: 5, text: ".lineStyle(StrokeStyle(lineWidth:dash:)) - dashed or solid line per series.", color: .scBlue)
            }

            CodeBlock(code: """
// Line + area combo
Chart(data) { point in
    AreaMark(
        x: .value("Date",  point.date),
        y: .value("Value", point.value)
    )
    .foregroundStyle(
        LinearGradient(
            colors: [.blue.opacity(0.4), .blue.opacity(0.02)],
            startPoint: .top, endPoint: .bottom
        )
    )
    .interpolationMethod(.catmullRom)

    LineMark(
        x: .value("Date",  point.date),
        y: .value("Value", point.value)
    )
    .foregroundStyle(Color.blue)
    .lineStyle(StrokeStyle(lineWidth: 2))
    .interpolationMethod(.catmullRom)
}

// Multi-series
LineMark(x: .value("M", m), y: .value("V", v),
         series: .value("Series", "A"))
    .foregroundStyle(Color.blue)
    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5,3]))
""")
        }
    }
}
