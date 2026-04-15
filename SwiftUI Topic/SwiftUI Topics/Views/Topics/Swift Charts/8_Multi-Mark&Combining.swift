//
//
//  8_Multi-Mark&Combining.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Charts

// MARK: - LESSON 8: Multi-Mark & Combining
struct SCMultiMarkVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Line + Bar", "Candlestick", "RectangleMark"]

    let data = SalesData.monthly

    struct CandleData: Identifiable {
        let id = UUID()
        let day: String
        let open, close, low, high: Double
        var isGreen: Bool { close > open }
    }

    let candles: [CandleData] = [
        CandleData(day: "Mon", open: 100, close: 115, low: 95,  high: 120),
        CandleData(day: "Tue", open: 115, close: 108, low: 102, high: 118),
        CandleData(day: "Wed", open: 108, close: 125, low: 105, high: 128),
        CandleData(day: "Thu", open: 125, close: 118, low: 112, high: 130),
        CandleData(day: "Fri", open: 118, close: 132, low: 115, high: 135),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Multi-mark & combining", systemImage: "chart.bar.doc.horizontal.fill")
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
                    // Bar + Line overlay (combo chart)
                    let targets: [SalesData] = [
                        SalesData(month: "Jan", revenue: 50, category: "t"),
                        SalesData(month: "Feb", revenue: 65, category: "t"),
                        SalesData(month: "Mar", revenue: 80, category: "t"),
                        SalesData(month: "Apr", revenue: 75, category: "t"),
                        SalesData(month: "May", revenue: 95, category: "t"),
                        SalesData(month: "Jun", revenue: 110, category: "t"),
                    ]
                    Chart {
                        ForEach(data) { d in
                            BarMark(x: .value("Month", d.month), y: .value("Actual", d.revenue))
                                .foregroundStyle(Color.scBlue.opacity(0.7))
                                .cornerRadius(3)
                        }
                        ForEach(targets) { d in
                            LineMark(x: .value("Month", d.month), y: .value("Target", d.revenue), series: .value("S", "Target"))
                                .foregroundStyle(Color.animCoral)
                                .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 3]))
                                .interpolationMethod(.catmullRom)
                            PointMark(x: .value("Month", d.month), y: .value("Target", d.revenue))
                                .foregroundStyle(Color.animCoral)
                                .symbolSize(30)
                        }
                    }
                    .chartLegend(position: .bottom, alignment: .leading)
                    .frame(height: 180)

                case 1:
                    // Candlestick - body + wick
                    Chart(candles) { c in
                        // Wick (high-low range)
                        RectangleMark(
                            x: .value("Day", c.day),
                            yStart: .value("Low", c.low),
                            yEnd: .value("High", c.high),
                            width: 3
                        )
                        .foregroundStyle(c.isGreen ? Color.formGreen : Color.animCoral)

                        // Body (open-close range)
                        RectangleMark(
                            x: .value("Day", c.day),
                            yStart: .value("Open", min(c.open, c.close)),
                            yEnd: .value("Close", max(c.open, c.close))
                        )
                        .foregroundStyle(c.isGreen ? Color.formGreen : Color.animCoral)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    }
                    .frame(height: 180)
                    .chartXAxis {
                        AxisMarks { v in AxisValueLabel() }
                    }

                default:
                    // RectangleMark - heatmap style
                    let heatData: [(x: String, y: String, v: Double)] = [
                        ("Mon","AM",80),("Tue","AM",60),("Wed","AM",90),("Thu","AM",45),("Fri","AM",70),
                        ("Mon","PM",40),("Tue","PM",85),("Wed","PM",55),("Thu","PM",95),("Fri","PM",35),
                    ]
                    Chart(heatData, id: \.x) { d in
                        RectangleMark(x: .value("Day", d.x), y: .value("Period", d.y))
                            .foregroundStyle(by: .value("Value", d.v))
                            .cornerRadius(4)
                    }
                    .chartForegroundStyleScale(range: Gradient(colors: [
                        Color.scBlue.opacity(0.15), Color.scBlue
                    ]))
                    .frame(height: 130)
                    .chartXAxis {
                        AxisMarks { v in AxisValueLabel() }
                    }
                }
            }
        }
    }
}

struct SCMultiMarkExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Combining multiple mark types")
            Text("Multiple mark types in one Chart view create combo charts - bar+line, wick+body (candlestick), heatmaps. Each mark layer renders in declaration order. Use series: parameter to keep line series separate.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Nest multiple ForEach or mark calls in Chart { } - they stack visually.", color: .scBlue)
                StepRow(number: 2, text: "series: .value(\"S\", \"name\") on LineMark - prevents lines from joining across unrelated series.", color: .scBlue)
                StepRow(number: 3, text: "RectangleMark(x:yStart:yEnd:) - vertical range rectangles. Use for candlestick wicks and bodies.", color: .scBlue)
                StepRow(number: 4, text: "RectangleMark for heatmaps - fill x/y cells with colour encoding the value.", color: .scBlue)
                StepRow(number: 5, text: ".chartForegroundStyleScale(range: Gradient(colors:)) - map quantitative value to a colour gradient.", color: .scBlue)
            }

            CodeBlock(code: """
// Combo: Bar (actual) + Line (target)
Chart {
    ForEach(actuals) { d in
        BarMark(x: .value("M", d.month), y: .value("A", d.actual))
            .foregroundStyle(Color.blue.opacity(0.7))
    }
    ForEach(targets) { d in
        LineMark(x: .value("M", d.month), y: .value("T", d.target),
                 series: .value("S", "Target"))
            .foregroundStyle(Color.red)
            .lineStyle(StrokeStyle(lineWidth: 2, dash: [5,3]))
    }
}

// Candlestick wick + body
RectangleMark(x: .value("D", day),
              yStart: .value("Low", low),
              yEnd:   .value("High", high),
              width: 3)
    .foregroundStyle(close > open ? .green : .red)
RectangleMark(x: .value("D", day),
              yStart: .value("Open", min(open,close)),
              yEnd:   .value("Close", max(open,close)))
    .foregroundStyle(close > open ? .green : .red)
""")
        }
    }
}

