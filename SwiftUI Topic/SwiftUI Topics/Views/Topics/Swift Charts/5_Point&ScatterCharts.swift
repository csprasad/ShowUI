//
//
//  5_Point&ScatterCharts.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Charts

// MARK: - LESSON 5: Point & Scatter Charts
struct SCScatterVisual: View {
    @State private var selectedDemo = 0
    @State private var encodeSizes  = true
    let demos = ["Scatter basic", "Bubble chart", "Symbol shapes"]

    struct BubblePoint: Identifiable {
        let id = UUID()
        let x: Double; let y: Double; let size: Double; let category: String
    }

    let bubbles: [BubblePoint] = [
        BubblePoint(x: 20, y: 40, size: 15, category: "A"),
        BubblePoint(x: 45, y: 72, size: 28, category: "A"),
        BubblePoint(x: 60, y: 55, size: 20, category: "B"),
        BubblePoint(x: 80, y: 30, size: 35, category: "B"),
        BubblePoint(x: 35, y: 85, size: 12, category: "A"),
        BubblePoint(x: 70, y: 90, size: 22, category: "C"),
        BubblePoint(x: 55, y: 20, size: 30, category: "C"),
        BubblePoint(x: 90, y: 65, size: 18, category: "B"),
        BubblePoint(x: 15, y: 60, size: 25, category: "A"),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Point & scatter charts", systemImage: "point.3.connected.trianglepath.dotted")
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
                    // Basic scatter
                    Chart(bubbles) { p in
                        PointMark(x: .value("X", p.x), y: .value("Y", p.y))
                            .foregroundStyle(by: .value("Cat", p.category))
                            .symbolSize(300)
                    }
                    .chartForegroundStyleScale([
                        "A": Color.scBlue,
                        "B": Color(hex: "#0F766E"),
                        "C": Color(hex: "#7C3AED"),
                    ])
                    .chartLegend(position: .bottom, alignment: .leading)
                    .frame(height: 180)

                case 1:
                    // Bubble chart - size encodes 3rd dimension
                    VStack(spacing: 8) {
                        Toggle("Encode sizes", isOn: $encodeSizes.animation()).tint(.scBlue).font(.system(size: 13))

                        Chart(bubbles) { p in
                            PointMark(x: .value("X", p.x), y: .value("Y", p.y))
                                .symbolSize(encodeSizes ? p.size * p.size * 3 : 200)
                                .foregroundStyle(by: .value("Cat", p.category))
                                .opacity(0.8)
                        }
                        .chartForegroundStyleScale([
                            "A": Color.scBlue,
                            "B": Color(hex: "#0F766E"),
                            "C": Color(hex: "#7C3AED"),
                        ])
                        .frame(height: 160)
                        .animation(.spring(response: 0.5), value: encodeSizes)
                    }

                default:
                    // Symbol shapes
                    let symbolData: [(String, BasicChartSymbolShape, Color)] = [
                        ("Circle",   .circle,   Color.scBlue),
                        ("Square",   .square,   Color(hex: "#0F766E")),
                        ("Triangle", .triangle, Color(hex: "#C2410C")),
                        ("Diamond",  .diamond,  Color(hex: "#7C3AED")),
                        ("Cross",    .cross,    Color(hex: "#D97706")),
                    ]
                    Chart {
                        ForEach(symbolData.indices, id: \.self) { i in
                            let (_, symbol, color) = symbolData[i]
                            ForEach(0..<5, id: \.self) { j in
                                PointMark(
                                    x: .value("X", Double(i * 20 + j * 2 - 4)),
                                    y: .value("Y", Double(Int.random(in: 20...80)))
                                )
                                .symbol(symbol)
                                .foregroundStyle(color)
                                .symbolSize(80)
                            }
                        }
                    }
                    .chartXAxis(.hidden)
                    .frame(height: 160)
                }
            }
        }
    }
}

struct SCScatterExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "PointMark - scatter and bubble charts")
            Text("PointMark plots individual data points. .symbolSize() encodes a third quantitative dimension as circle size (bubble chart). .symbol() switches between circle, square, triangle, diamond for categorical encoding.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "PointMark(x:y:) - scatter plot. Each data point becomes a symbol.", color: .scBlue)
                StepRow(number: 2, text: ".symbolSize(value * value * k) - area-encode a third variable. Square the value for perceptually linear size.", color: .scBlue)
                StepRow(number: 3, text: ".symbol(.circle / .square / .triangle / .diamond) - categorical shape encoding.", color: .scBlue)
                StepRow(number: 4, text: ".foregroundStyle(by: .value(\"Cat\", cat)) - colour per category.", color: .scBlue)
                StepRow(number: 5, text: ".chartSymbolScale([\"A\": .circle, \"B\": .square]) - explicit symbol per category.", color: .scBlue)
            }

            CodeBlock(code: """
// Basic scatter
Chart(points) { p in
    PointMark(x: .value("X", p.x), y: .value("Y", p.y))
        .foregroundStyle(by: .value("Category", p.cat))
        .symbolSize(100)
}

// Bubble - size encodes 3rd dimension
Chart(bubbles) { b in
    PointMark(x: .value("Sales", b.sales),
              y: .value("Profit", b.profit))
        .symbolSize(b.marketShare * b.marketShare * 5)
        .foregroundStyle(by: .value("Region", b.region))
        .opacity(0.75)
}

// Custom symbol per series
.chartSymbolScale([
    "East": BasicChartSymbolShape.circle,
    "West": BasicChartSymbolShape.square,
])
""")
        }
    }
}
