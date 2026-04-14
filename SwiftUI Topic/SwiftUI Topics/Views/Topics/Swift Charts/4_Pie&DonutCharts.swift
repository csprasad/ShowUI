//
//
//  4_Pie&DonutCharts.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Charts

// MARK: - LESSON 4: Pie & Donut Charts
struct SCPieDonutVisual: View {
    @State private var selectedDemo   = 0
    @State private var holeRadius     = 0.5
    @State private var cornerRadius   = 6.0
    @State private var selectedSlice: String? = nil

    struct PieSegment: Identifiable {
        let id = UUID()
        let label: String
        let value: Double
        let color: Color
    }

    let segments: [PieSegment] = [
        PieSegment(label: "iOS",     value: 45, color: Color.scBlue),
        PieSegment(label: "Android", value: 30, color: Color(hex: "#0F766E")),
        PieSegment(label: "Web",     value: 15, color: Color(hex: "#7C3AED")),
        PieSegment(label: "Other",   value: 10, color: Color(hex: "#D97706")),
    ]

    let demos = ["Pie chart", "Donut chart", "Custom styling"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Pie & donut charts", systemImage: "chart.pie.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.scBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; selectedSlice = nil }
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
                    // Pie chart
                    HStack(spacing: 16) {
                        Chart(segments) { seg in
                            SectorMark(
                                angle: .value("Value", seg.value),
                                innerRadius: .ratio(0.0),
                                angularInset: 2
                            )
                            .foregroundStyle(seg.color)
                            .cornerRadius(4)
                            .opacity(selectedSlice == nil || selectedSlice == seg.label ? 1 : 0.4)
                        }
                        .chartAngleSelection(value: $selectedSlice)
                        .frame(width: 140, height: 140)

                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(segments) { seg in
                                HStack(spacing: 6) {
                                    Circle().fill(seg.color).frame(width: 8, height: 8)
                                    Text(seg.label).font(.system(size: 11))
                                    Spacer()
                                    Text("\(Int(seg.value))%").font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }

                case 1:
                    // Donut with hole slider
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Text("Hole:").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 32)
                            Slider(value: $holeRadius, in: 0...0.8, step: 0.05).tint(.scBlue)
                            Text("\(Int(holeRadius * 100))%").font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.scBlue).frame(width: 36)
                        }

                        HStack(spacing: 16) {
                            ZStack {
                                Chart(segments) { seg in
                                    SectorMark(
                                        angle: .value("Value", seg.value),
                                        innerRadius: .ratio(holeRadius),
                                        angularInset: 2
                                    )
                                    .foregroundStyle(seg.color)
                                    .cornerRadius(4)
                                }
                                .frame(width: 130, height: 130)
                                .animation(.spring(response: 0.4), value: holeRadius)

                                if holeRadius > 0.2 {
                                    VStack(spacing: 2) {
                                        Text("Total").font(.system(size: 9)).foregroundStyle(.secondary)
                                        Text("100%").font(.system(size: 14, weight: .bold)).foregroundStyle(Color.scBlue)
                                    }
                                    .transition(.opacity)
                                }
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(segments) { seg in
                                    HStack(spacing: 6) {
                                        RoundedRectangle(cornerRadius: 2).fill(seg.color).frame(width: 14, height: 8)
                                        Text(seg.label).font(.system(size: 11))
                                        Spacer()
                                        Text("\(Int(seg.value))%").font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .animation(.spring(response: 0.4), value: holeRadius)

                default:
                    // Corner radius + explode style
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Text("Corner:").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 46)
                            Slider(value: $cornerRadius, in: 0...20, step: 1).tint(.scBlue)
                            Text("\(Int(cornerRadius))").font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.scBlue).frame(width: 24)
                        }

                        Chart(segments) { seg in
                            SectorMark(
                                angle: .value("Value", seg.value),
                                innerRadius: .ratio(0.45),
                                outerRadius: selectedSlice == seg.label ? .ratio(1.0) : .ratio(0.9),
                                angularInset: 3
                            )
                            .foregroundStyle(seg.color)
                            .cornerRadius(cornerRadius)
                            .opacity(selectedSlice == nil || selectedSlice == seg.label ? 1 : 0.5)
                        }
                        .frame(height: 170)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedSlice)
                        .animation(.spring(response: 0.3), value: cornerRadius)
                        .chartAngleSelection(value: $selectedSlice)

                        Text("Tap a slice to expand it")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

struct SCPieDonutExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "SectorMark - pie and donut charts")
            Text("SectorMark (iOS 17+) creates pie and donut chart segments. innerRadius creates the donut hole, outerRadius controls segment size for explode effects. angularInset adds gaps between slices.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "SectorMark(angle: .value(\"Label\", value)) - basic pie slice.", color: .scBlue)
                StepRow(number: 2, text: "innerRadius: .ratio(0.5) - creates the donut hole. 0 = full pie, 0.5 = 50% hole.", color: .scBlue)
                StepRow(number: 3, text: "outerRadius: .ratio(1.0 or 0.9) - expand selected slice for explode effect.", color: .scBlue)
                StepRow(number: 4, text: "angularInset: 2 - gap in degrees between slices.", color: .scBlue)
                StepRow(number: 5, text: ".cornerRadius() on SectorMark - rounds the slice edges.", color: .scBlue)
                StepRow(number: 6, text: ".chartAngleSelection(value: $selected) - interactive slice selection.", color: .scBlue)
            }

            CodeBlock(code: """
struct Segment: Identifiable {
    let id = UUID()
    let label: String; let value: Double
}

Chart(segments) { seg in
    SectorMark(
        angle: .value("Value", seg.value),
        innerRadius: .ratio(0.55),   // donut hole
        outerRadius: selectedSlice == seg.label
            ? .ratio(1.0)    // exploded
            : .ratio(0.9),   // normal
        angularInset: 2      // gap between slices
    )
    .foregroundStyle(seg.color)
    .cornerRadius(6)
    .opacity(selectedSlice == seg.label ? 1 : 0.7)
}
.chartAngleSelection(value: $selectedSlice)
""")
        }
    }
}

