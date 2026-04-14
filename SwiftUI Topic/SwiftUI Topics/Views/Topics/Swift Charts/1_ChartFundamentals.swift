//
//
//  1_ChartFundamentals.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Charts

// MARK: - LESSON 1: Chart Fundamentals
struct SCFundamentalsVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Mark types", "Anatomy", "Data model"]

    let data = SalesData.monthly

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Chart fundamentals", systemImage: "chart.bar.xaxis")
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
                    // Mark types gallery
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            miniChart(title: "BarMark") {
                                Chart(data) { d in
                                    BarMark(x: .value("M", d.month), y: .value("R", d.revenue))
                                        .foregroundStyle(Color.scBlue.gradient)
                                }
                            }
                            miniChart(title: "LineMark") {
                                Chart(data) { d in
                                    LineMark(x: .value("M", d.month), y: .value("R", d.revenue))
                                        .foregroundStyle(Color.scBlue)
                                    AreaMark(x: .value("M", d.month), y: .value("R", d.revenue))
                                        .foregroundStyle(Color.scBlue.opacity(0.15))
                                }
                            }
                        }
                        HStack(spacing: 8) {
                            miniChart(title: "PointMark") {
                                Chart(data) { d in
                                    PointMark(x: .value("M", d.month), y: .value("R", d.revenue))
                                        .foregroundStyle(Color.scBlue)
                                }
                            }
                            miniChart(title: "AreaMark") {
                                Chart(data) { d in
                                    AreaMark(x: .value("M", d.month), y: .value("R", d.revenue))
                                        .foregroundStyle(Color.scBlue.gradient)
                                }
                            }
                        }
                    }

                case 1:
                    // Anatomy diagram
                    VStack(spacing: 6) {
                        anatomyRow(icon: "chart.bar.xaxis",           color: .scBlue,   label: "Chart { }",                 desc: "Container view - provides coordinate space and rendering")
                        anatomyRow(icon: "squareshape.fill",          color: Color(hex: "#7C3AED"), label: "BarMark / LineMark / …",  desc: "Mark types define visual representation of each data point")
                        anatomyRow(icon: "x.squareroot",              color: Color(hex: "#0F766E"), label: ".value(\"Label\", value)", desc: "Typed channel binding - maps data to x/y/colour/size/etc.")
                        anatomyRow(icon: "arrow.left.and.right",      color: Color(hex: "#C2410C"), label: "AxisMarks { }",            desc: "Customise grid lines, labels, and ticks on each axis")
                        anatomyRow(icon: "paintpalette.fill",         color: Color(hex: "#D97706"), label: ".foregroundStyle(…)",      desc: "Colour, gradient, or style scale for marks")
                        anatomyRow(icon: "arrow.up.right.and.arrow.down.left", color: Color(hex: "#4D7C0F"), label: ".chartXScale / .chartYScale", desc: "Control domain, range, and scale type")
                    }

                default:
                    // Data model pattern
                    VStack(spacing: 8) {
                        PlainCodeBlock(fgColor: Color.scBlue, bgColor: Color.scBlueLight, code: """
// 1. Define an Identifiable data model
struct SalesPoint: Identifiable {
    let id = UUID()
    let month: String   // → x axis (category)
    let revenue: Double // → y axis (quantitative)
    let team: String    // → foregroundStyle (series)
}

// 2. Populate your data
let data = [
    SalesPoint(month: "Jan", revenue: 42, team: "iOS"),
    SalesPoint(month: "Jan", revenue: 28, team: "Android"),
    // …
]

// 3. Build the chart
Chart(data) { point in
    BarMark(
        x: .value("Month", point.month),
        y: .value("Revenue", point.revenue)
    )
    .foregroundStyle(by: .value("Team", point.team))
}
""")

                        HStack(spacing: 6) {
                            Image(systemName: "lightbulb.fill").foregroundStyle(Color.scBlue).font(.system(size: 12))
                            Text("The data model drives everything. Each property maps to a chart channel: position, colour, size, or symbol.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.scBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    func miniChart<C: View>(title: String, @ViewBuilder content: () -> C) -> some View {
        VStack(spacing: 4) {
            Text(title).font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
            content()
                .frame(height: 70)
                .padding(.horizontal, 4)
                .chartXAxis(.hidden).chartYAxis(.hidden)
        }
        .frame(maxWidth: .infinity)
        .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func anatomyRow(icon: String, color: Color, label: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon).font(.system(size: 12)).foregroundStyle(color).frame(width: 16)
            VStack(alignment: .leading, spacing: 1) {
                Text(label).font(.system(size: 9, weight: .semibold, design: .monospaced)).foregroundStyle(color)
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(7).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

struct SCFundamentalsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Swift Charts - composable charts in SwiftUI")
            Text("Swift Charts (iOS 16+) builds charts from mark types: BarMark, LineMark, AreaMark, PointMark, RuleMark, RectangleMark, SectorMark. Each mark maps data properties to visual channels via .value(). Charts are fully composable - mix any marks in one Chart view.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "import Charts - Swift Charts is built into the SDK, no package needed.", color: .scBlue)
                StepRow(number: 2, text: "Chart(data) { item in MarkType(x: .value(), y: .value()) } - the core pattern.", color: .scBlue)
                StepRow(number: 3, text: ".value(\"Label\", property) - maps a data property to a typed chart channel.", color: .scBlue)
                StepRow(number: 4, text: "Multiple marks in one Chart { } - combine LineMark + AreaMark, BarMark + RuleMark, etc.", color: .scBlue)
                StepRow(number: 5, text: "Data model: any Identifiable collection - arrays of structs are most common.", color: .scBlue)
            }

            CodeBlock(code: """
import Charts

struct RevenuePoint: Identifiable {
    let id = UUID()
    let month: String
    let amount: Double
}

let data = [
    RevenuePoint(month: "Jan", amount: 42),
    RevenuePoint(month: "Feb", amount: 58),
]

Chart(data) { point in
    BarMark(
        x: .value("Month",   point.month),
        y: .value("Revenue", point.amount)
    )
}
.frame(height: 200)
""")
        }
    }
}
