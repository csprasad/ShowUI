//
//
//  9_ChartsInteractivity.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Charts

// MARK: - LESSON 9: Interactivity

struct SCInteractiveVisual: View {
    @State private var selectedDemo      = 0
    @State private var selectedMonth: String? = nil
    @State private var selectedValue: Double? = nil
    @State private var plotLocation: CGPoint  = .zero
    let demos = ["Selection", "Crosshair / tooltip", "Range selection"]

    let data = SalesData.monthly

    // Range selection state
    @State private var rangeStart: String? = nil
    @State private var rangeEnd: String?   = nil

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Interactivity", systemImage: "hand.point.up.left.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.scBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; selectedMonth = nil; selectedValue = nil; rangeStart = nil; rangeEnd = nil }
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
                    // Bar selection
                    VStack(spacing: 8) {
                        Chart(data) { d in
                            BarMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                .foregroundStyle(selectedMonth == d.month ? Color.scBlue : Color.scBlue.opacity(0.4))
                                .cornerRadius(4)
                        }
                        .chartXSelection(value: $selectedMonth)
                        .frame(height: 150)
                        .animation(.easeInOut(duration: 0.1), value: selectedMonth)

                        if let m = selectedMonth, let d = data.first(where: { $0.month == m }) {
                            HStack(spacing: 10) {
                                Image(systemName: "calendar.circle.fill").foregroundStyle(Color.scBlue).font(.system(size: 18))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(d.month).font(.system(size: 13, weight: .semibold))
                                    Text("Revenue: $\(Int(d.revenue))k").font(.system(size: 11)).foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(10).background(Color.scBlueLight)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                        } else {
                            Text("Tap a bar to select").font(.system(size: 11)).foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .animation(.spring(response: 0.3), value: selectedMonth)

                case 1:
                    // Crosshair drag tooltip
                    VStack(spacing: 8) {
                        Chart(data) { d in
                            AreaMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(Color.scBlue.opacity(0.15))
                            LineMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(Color.scBlue)
                                .lineStyle(StrokeStyle(lineWidth: 2.5))

                            if let m = selectedMonth {
                                RuleMark(x: .value("Selected", m))
                                    .foregroundStyle(Color.scBlue.opacity(0.5))
                                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                                    .annotation(position: .top) {
                                        if let d2 = data.first(where: { $0.month == m }) {
                                            VStack(spacing: 2) {
                                                Text(d2.month).font(.system(size: 9, weight: .semibold)).foregroundStyle(Color.scBlue)
                                                Text("$\(Int(d2.revenue))k").font(.system(size: 10, weight: .bold)).foregroundStyle(Color.scBlue)
                                            }
                                            .padding(.horizontal, 8).padding(.vertical, 4)
                                            .background(Color.scBlueLight)
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                            .shadow(color: .black.opacity(0.1), radius: 4)
                                        }
                                    }
                            }
                        }
                        .chartXSelection(value: $selectedMonth)
                        .frame(height: 160)

                        Text(selectedMonth != nil ? "Drag to move crosshair" : "Tap/drag to see tooltip")
                            .font(.system(size: 11)).foregroundStyle(.secondary)
                    }

                default:
                    // Range selection
                    VStack(spacing: 8) {
                        Chart(data) { d in
                            BarMark(x: .value("Month", d.month), y: .value("Revenue", d.revenue))
                                .foregroundStyle(isInRange(d.month) ? Color.scBlue : Color.scBlue.opacity(0.3))
                                .cornerRadius(3)
                        }
                        .chartXSelection(range: Binding(
                            get: {
                                if let s = rangeStart, let e = rangeEnd { return s...e }
                                return nil
                            },
                            set: { range in
                                rangeStart = range?.lowerBound
                                rangeEnd   = range?.upperBound
                            }
                        ))
                        .frame(height: 150)

                        if let s = rangeStart, let e = rangeEnd {
                            let filtered = data.filter { isInRange($0.month) }
                            let total = filtered.map(\.revenue).reduce(0, +)
                            HStack(spacing: 8) {
                                Image(systemName: "selection.pin.in.out").foregroundStyle(Color.scBlue)
                                Text("\(s)–\(e): \(filtered.count) months, total $\(Int(total))k")
                                    .font(.system(size: 11)).foregroundStyle(.secondary)
                            }
                            .padding(8).background(Color.scBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            Text("Drag across bars to select a range").font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    func isInRange(_ month: String) -> Bool {
        guard let s = rangeStart, let e = rangeEnd else { return false }
        let months = ["Jan","Feb","Mar","Apr","May","Jun"]
        guard let si = months.firstIndex(of: s), let ei = months.firstIndex(of: e), let mi = months.firstIndex(of: month) else { return false }
        return mi >= min(si, ei) && mi <= max(si, ei)
    }
}

struct SCInteractiveExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Interactive charts")
            Text(".chartXSelection and .chartYSelection bind chart touch/drag to a data value. When the user taps or drags, the binding updates to the nearest matching data value - no gesture math needed.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".chartXSelection(value: $selectedMonth) - binds a String? to the tapped X category.", color: .scBlue)
                StepRow(number: 2, text: ".chartXSelection(value: $selectedDate) - works with Date, Int, Double on quantitative axes.", color: .scBlue)
                StepRow(number: 3, text: "RuleMark + .annotation() when selected - creates crosshair tooltip effect.", color: .scBlue)
                StepRow(number: 4, text: ".chartXSelection(range: $range) - drag to select a range of values.", color: .scBlue)
                StepRow(number: 5, text: "Change mark opacity based on selection - highlight selected, dim others.", color: .scBlue)
            }

            CodeBlock(code: """
@State private var selectedMonth: String? = nil

Chart(data) { d in
    BarMark(x: .value("Month", d.month),
            y: .value("Revenue", d.revenue))
        .foregroundStyle(
            selectedMonth == d.month
                ? Color.blue
                : Color.blue.opacity(0.4)
        )

    // Crosshair line at selection
    if let m = selectedMonth {
        RuleMark(x: .value("M", m))
            .foregroundStyle(.blue.opacity(0.5))
            .annotation(position: .top) {
                tooltipView(for: m)
            }
    }
}
.chartXSelection(value: $selectedMonth)

// Range selection
@State private var range: ClosedRange<String>?
Chart { ... }
    .chartXSelection(range: $range)
""")
        }
    }
}
