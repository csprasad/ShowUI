//
//
//  12_Real-WorldPatterns.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Charts

// MARK: - LESSON 12: Real-World Patterns
struct SCRealWorldVisual: View {
    @State private var selectedDemo = 0
    @State private var animTrigger  = false
    @State private var chartType    = 0
    let demos = ["Dashboard", "Animated entry", "Accessibility"]

    let kpiData: [(String, Double, Color)] = [
        ("Revenue",  87,  Color.scBlue),
        ("Users",    64,  Color(hex: "#0F766E")),
        ("Sessions", 92,  Color(hex: "#7C3AED")),
        ("Churn",    18,  Color.animCoral),
    ]

    let data = SalesData.monthly

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Real-world patterns", systemImage: "rectangle.3.group.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.scBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; animTrigger = false }
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
                    // Mini dashboard
                    VStack(spacing: 8) {
                        // KPI sparklines row
                        HStack(spacing: 8) {
                            ForEach(kpiData, id: \.0) { name, val, color in
                                sparklineCard(name: name, value: val, color: color)
                            }
                        }

                        // Main chart with type toggle
                        HStack(spacing: 6) {
                            Picker("Type", selection: $chartType) {
                                Image(systemName: "chart.bar.fill").tag(0)
                                Image(systemName: "chart.line.uptrend.xyaxis").tag(1)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 80)
                            Text("Monthly revenue").font(.system(size: 12, weight: .semibold))
                            Spacer()
                        }

                        Chart(data) { d in
                            if chartType == 0 {
                                BarMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                    .foregroundStyle(Color.scBlue.gradient).cornerRadius(4)
                            } else {
                                AreaMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                    .foregroundStyle(Color.scBlue.opacity(0.2)).interpolationMethod(.catmullRom)
                                LineMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                    .foregroundStyle(Color.scBlue).lineStyle(StrokeStyle(lineWidth: 2.5))
                                    .interpolationMethod(.catmullRom)
                            }
                        }
                        .frame(height: 100)
                        .animation(.spring(response: 0.4), value: chartType)
                        .chartYAxis {
                            AxisMarks(values: .automatic(desiredCount: 3)) { v in
                                AxisGridLine(); AxisValueLabel()
                            }
                        }
                    }

                case 1:
                    // Animated entry
                    VStack(spacing: 8) {
                        Chart(data) { d in
                            BarMark(x: .value("Month", d.month), y: .value("Revenue", animTrigger ? d.revenue : 0))
                                .foregroundStyle(Color.scBlue.gradient)
                                .cornerRadius(4)
                        }
                        .frame(height: 150)
                        .animation(
                            .spring(response: 0.5, dampingFraction: 0.75)
                            .delay(Double(data.firstIndex(where: { $0.month == data[0].month }) ?? 0) * 0.05),
                            value: animTrigger
                        )

                        Button(animTrigger ? "Reset" : "▶ Animate chart entry") {
                            if animTrigger {
                                animTrigger = false
                            } else {
                                withAnimation { animTrigger = true }
                            }
                        }
                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(animTrigger ? Color.animCoral : Color.scBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .buttonStyle(PressableButtonStyle())

                        codeSnip("// Animate by starting at 0 and transitioning to real value\ny: .value(\"R\", isAnimated ? d.revenue : 0)\n.animation(.spring().delay(Double(i) * 0.05), value: isAnimated)")
                    }

                default:
                    // Accessibility
                    VStack(spacing: 8) {
                        Chart(data) { d in
                            BarMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                .foregroundStyle(Color.scBlue.gradient)
                                .cornerRadius(4)
                                .accessibilityLabel(d.month)
                                .accessibilityValue("Revenue: \(Int(d.revenue)) thousand dollars")
                        }
                        .accessibilityChartDescriptor(RevenueChartDescriptor(data: data))
                        .frame(height: 130)

                        ForEach([
                            (".accessibilityLabel(\"Month\")", "Per-mark spoken label"),
                            (".accessibilityValue(\"$87k\")", "Per-mark spoken value"),
                            ("AccessibilityChartDescriptor", "Full chart description via protocol"),
                            (".chartAccessibilityEnabled(false)", "Opt out of default chart accessibility"),
                        ], id: \.0) { code, desc in
                            HStack(spacing: 8) {
                                Text(code).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.scBlue)
                                Spacer()
                                Text(desc).font(.system(size: 9)).foregroundStyle(.secondary)
                            }
                            .padding(6).background(Color.scBlueLight.opacity(0.6)).clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
            }
        }
    }

    func sparklineCard(name: String, value: Double, color: Color) -> some View {
        VStack(spacing: 3) {
            Text(name).font(.system(size: 8, weight: .semibold)).foregroundStyle(.secondary)
            Text("\(Int(value))%")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(color)
            // Mini sparkline
            Chart(SalesData.monthly.prefix(4).map { ($0.month, Double.random(in: 30...90)) }, id: \.0) { d in
                LineMark(x: .value("M", d.0), y: .value("V", d.1))
                    .foregroundStyle(color)
                    .lineStyle(StrokeStyle(lineWidth: 1.5))
                    .interpolationMethod(.catmullRom)
            }
            .chartXAxis(.hidden).chartYAxis(.hidden)
            .frame(height: 24)
        }
        .frame(maxWidth: .infinity)
        .padding(6)
        .background(color.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func codeSnip(_ t: String) -> some View {
        Text(t).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.scBlue)
            .padding(7).background(Color.scBlueLight).clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

// Accessibility descriptor stub
struct RevenueChartDescriptor: AXChartDescriptorRepresentable {
    let data: [SalesData]

    func makeChartDescriptor() -> AXChartDescriptor {
        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Month",
            categoryOrder: data.map(\.month)
        )
        let yAxis = AXNumericDataAxisDescriptor(
            title: "Revenue (thousands)",
            range: 0...150,
            gridlinePositions: [25, 50, 75, 100, 125]
        ) { _ in "\\($0)k" }

        let series = AXDataSeriesDescriptor(
            name: "Monthly Revenue",
            isContinuous: true,
            dataPoints: data.map { .init(x: $0.month, y: $0.revenue) }
        )

        return AXChartDescriptor(
            title: "Monthly Revenue Chart",
            summary: "Revenue grew from $42k in January to $102k in June",
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
}

struct SCRealWorldExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Real-world chart patterns")
            Text("Production charts combine sparklines for KPI dashboards, entry animations for polished data reveals, AXChartDescriptor for full VoiceOver accessibility, and toggle between chart types for user flexibility.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Sparklines: hide axes, reduce frame height, use lightweight marks - tiny summary charts.", color: .scBlue)
                StepRow(number: 2, text: "Entry animation: start y at 0, set to real value in .onAppear - charts animate from zero.", color: .scBlue)
                StepRow(number: 3, text: "Staggered entry: .animation(curve.delay(Double(i) * 0.05)) - bars grow in sequence.", color: .scBlue)
                StepRow(number: 4, text: ".accessibilityLabel() + .accessibilityValue() per mark - VoiceOver reads each data point.", color: .scBlue)
                StepRow(number: 5, text: "AXChartDescriptorRepresentable - full structured chart description for assistive tech.", color: .scBlue)
            }

            CalloutBox(style: .success, title: "Always implement accessibility", contentBody: "Swift Charts generates basic VoiceOver by default, but add .accessibilityLabel() and .accessibilityValue() to each mark for meaningful spoken values. AXChartDescriptorRepresentable provides a full tabular data summary for users who can't see charts.")

            CodeBlock(code: """
// Entry animation
@State private var appeared = false
Chart(data) { d in
    BarMark(x: .value("M", d.month),
            y: .value("R", appeared ? d.revenue : 0))
        .animation(
            .spring(response: 0.5).delay(Double(i) * 0.06),
            value: appeared
        )
}
.onAppear { appeared = true }

// Accessibility
Chart(data) { d in
    BarMark(...)
        .accessibilityLabel(d.month)
        .accessibilityValue("\\(Int(d.revenue)) thousand dollars")
}
.accessibilityChartDescriptor(MyDescriptor(data: data))

// Sparkline
Chart(sparkData) { d in
    LineMark(x: .value("T", d.t), y: .value("V", d.v))
}
.chartXAxis(.hidden).chartYAxis(.hidden)
.frame(height: 30)
""")
        }
    }
}

