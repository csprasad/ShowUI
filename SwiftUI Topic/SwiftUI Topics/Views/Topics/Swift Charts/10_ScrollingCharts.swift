//
//
//  10_ScrollingCharts.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Charts

// MARK: - LESSON 10: Scrolling Charts
struct SCScrollingVisual: View {
    @State private var selectedDemo = 0
    @State private var isStreaming  = false
    @State private var streamData: [(Int, Double)] = (0..<20).map { i in
        (i, Double.random(in: 20...80))
    }
    @State private var timer: Timer?
    @State private var scrollPosition: String = ""

    let demos = ["chartScrollableAxes", "Visible domain", "Live streaming"]

    // Long dataset for scrolling demo
    let longData: [SalesData] = {
        let months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec",
                      "Jan'24","Feb'24","Mar'24","Apr'24","May'24","Jun'24"]
        return months.enumerated().map { i, m in
            SalesData(month: m, revenue: Double.random(in: 40...120), category: "A")
        }
    }()

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Scrolling charts", systemImage: "scroll.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.scBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; stopStream() }
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
                    // chartScrollableAxes
                    VStack(spacing: 8) {
                        Chart(longData) { d in
                            BarMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                .foregroundStyle(Color.scBlue.gradient)
                                .cornerRadius(3)
                        }
                        .chartScrollableAxes(.horizontal)
                        .chartXVisibleDomain(length: 6)
                        .frame(height: 160)

                        HStack(spacing: 6) {
                            Image(systemName: "arrow.left.and.right").foregroundStyle(Color.scBlue).font(.system(size: 11))
                            Text("Swipe horizontally - shows 6 months at a time. 18 months total.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(7).background(Color.scBlueLight).clipShape(RoundedRectangle(cornerRadius: 7))
                    }

                case 1:
                    // Visible domain with control
                    VStack(spacing: 8) {
                        Chart(longData) { d in
                            LineMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                .foregroundStyle(Color.scBlue)
                                .interpolationMethod(.catmullRom)
                                .lineStyle(StrokeStyle(lineWidth: 2.5))
                            AreaMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                .foregroundStyle(Color.scBlue.opacity(0.12))
                                .interpolationMethod(.catmullRom)
                        }
                        .chartScrollableAxes(.horizontal)
                        .chartXVisibleDomain(length: 4)
                        .chartScrollPosition(x: $scrollPosition)
//                        .chartScrollPosition(x: .value("Start", longData.first?.month ?? ""))
                        .frame(height: 150)

                        codeSnip(".chartScrollableAxes(.horizontal)\n.chartXVisibleDomain(length: 6)  // show 6 items\n.chartScrollPosition(x: .value(\"Month\", currentMonth))")
                    }

                default:
                    // Live streaming
                    VStack(spacing: 8) {
                        Chart(streamData, id: \.0) { point in
                            LineMark(x: .value("T", point.0), y: .value("V", point.1))
                                .foregroundStyle(Color.scBlue)
                                .lineStyle(StrokeStyle(lineWidth: 2))
                            AreaMark(x: .value("T", point.0), y: .value("V", point.1))
                                .foregroundStyle(Color.scBlue.opacity(0.15))
                        }
                        .chartYScale(domain: 0...100)
                        .chartXAxis {
                            AxisMarks(values: .stride(by: 5)) { _ in AxisValueLabel() }
                        }
                        .frame(height: 140)
                        .animation(.easeInOut(duration: 0.15), value: streamData.map(\.1))

                        Button(isStreaming ? "Stop stream" : "▶ Start live stream") {
                            isStreaming ? stopStream() : startStream()
                        }
                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(isStreaming ? Color.animCoral : Color.scBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
        }
        .onAppear {
            scrollPosition = longData.first?.month ?? ""
        }
    }

    func startStream() {
        isStreaming = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.15)) {
                let next = (streamData.last?.0 ?? 0) + 1
                let val  = Double.random(in: 20...80)
                streamData.append((next, val))
                if streamData.count > 25 { streamData.removeFirst() }
            }
        }
    }

    func stopStream() {
        isStreaming = false
        timer?.invalidate()
        timer = nil
    }

    func codeSnip(_ t: String) -> some View {
        Text(t).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.scBlue)
            .padding(7).background(Color.scBlueLight).clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

struct SCScrollingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Scrolling and live-updating charts")
            Text(".chartScrollableAxes(.horizontal) enables swipe-to-scroll on the chart's x axis. .chartXVisibleDomain(length:) controls how many items are visible at once. For live data, mutate the array and let Swift Charts re-render.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".chartScrollableAxes(.horizontal) - enable horizontal swipe scrolling.", color: .scBlue)
                StepRow(number: 2, text: ".chartXVisibleDomain(length: 6) - show exactly 6 items in the viewport at once.", color: .scBlue)
                StepRow(number: 3, text: ".chartScrollPosition(x: .value(\"M\", month)) - bind scroll position to control programmatically.", color: .scBlue)
                StepRow(number: 4, text: "Live data: append to @State array, Charts re-renders with animation.", color: .scBlue)
                StepRow(number: 5, text: "Slide window: array.append(new); if array.count > max { array.removeFirst() }", color: .scBlue)
            }

            CodeBlock(code: """
// Scrollable bar chart - 6 visible items
Chart(allMonths) { d in
    BarMark(x: .value("Month", d.month),
            y: .value("Value", d.value))
}
.chartScrollableAxes(.horizontal)
.chartXVisibleDomain(length: 6)

// Programmatic scroll position
@State private var visibleMonth = "Jan"
Chart(data) { ... }
    .chartScrollableAxes(.horizontal)
    .chartScrollPosition(
        x: .value("Month", visibleMonth)
    )

// Live-updating data
@State private var liveData = [(Int, Double)]()
let timer = Timer.publish(every: 0.5, ...)

// On tick:
liveData.append((tick, newValue))
if liveData.count > 30 { liveData.removeFirst() }
""")
        }
    }
}

