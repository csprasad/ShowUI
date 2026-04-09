//
//
//  2_LazyVGrid.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: LazyVGrid Basics
struct LazyVGridBasicsVisual: View {
    @State private var columnCount = 3
    @State private var spacing: CGFloat = 8
    @State private var gridSpacing: CGFloat = 8
    @State private var useAdaptive = false
    @State private var adaptiveMin: CGFloat = 80

    let items = GridItem_Data.samples(18)

    var columns: [SwiftUI.GridItem] {
        if useAdaptive {
            return [SwiftUI.GridItem(.adaptive(minimum: adaptiveMin), spacing: spacing)]
        }
        return Array(repeating: SwiftUI.GridItem(.flexible(), spacing: spacing), count: columnCount)
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("LazyVGrid basics", systemImage: "square.grid.3x3.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gridPurple)

                // Controls
                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        Toggle("Adaptive", isOn: $useAdaptive).tint(.gridPurple)
                            .font(.system(size: 12)).frame(width: 120)
                        if !useAdaptive {
                            HStack(spacing: 6) {
                                Text("cols:").font(.system(size: 11)).foregroundStyle(.secondary)
                                ForEach([2, 3, 4, 5], id: \.self) { n in
                                    Button("\(n)") { withAnimation(.spring(response: 0.3)) { columnCount = n } }
                                        .font(.system(size: 12, weight: columnCount == n ? .semibold : .regular))
                                        .foregroundStyle(columnCount == n ? .white : .secondary)
                                        .frame(width: 28, height: 28)
                                        .background(columnCount == n ? Color.gridPurple : Color(.systemFill))
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                        .buttonStyle(PressableButtonStyle())
                                }
                            }
                        } else {
                            sliderRow("min", value: $adaptiveMin, range: 40...140)
                        }
                    }
                    HStack(spacing: 8) {
                        sliderRow("cell gap", value: $spacing, range: 0...20)
                        sliderRow("row gap", value: $gridSpacing, range: 0...20)
                    }
                }

                // Grid in scroll view
                ScrollView {
                    LazyVGrid(columns: columns, spacing: gridSpacing) {
                        ForEach(items) { item in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(gridCellColors[item.colorIndex])
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(
                                    Text(item.label)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(.white)
                                )
                        }
                    }
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .animation(.spring(response: 0.4), value: columnCount)
                .animation(.easeInOut(duration: 0.15), value: spacing)
                .animation(.easeInOut(duration: 0.15), value: gridSpacing)
                .animation(.spring(response: 0.35), value: useAdaptive)
                .animation(.easeInOut(duration: 0.15), value: adaptiveMin)

                // Column count display
                HStack(spacing: 6) {
                    Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.gridPurple)
                    Text(useAdaptive ? "Adaptive - column count adjusts to available width" : "\(columnCount) flexible columns - each ≈ \(Int(UIScreen.main.bounds.width / CGFloat(columnCount)))pt wide")
                        .font(.system(size: 11)).foregroundStyle(.secondary)
                }
                .padding(8).background(Color.gridPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    func sliderRow(_ label: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>) -> some View {
        HStack(spacing: 6) {
            Text(label).font(.system(size: 10)).foregroundStyle(.secondary).frame(width: 44, alignment: .leading)
            Slider(value: value, in: range, step: 1).tint(.gridPurple)
            Text("\(Int(value.wrappedValue))").font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.gridPurple).frame(width: 20)
        }
    }
}

struct LazyVGridBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "LazyVGrid")
            Text("LazyVGrid creates a vertically scrolling grid that renders cells lazily - only those visible on screen. It takes a columns array of GridItems that defines the column structure, and a spacing value for the gap between rows.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "LazyVGrid(columns: columns, spacing: 8) - spacing is the row gap. Column gap is set per-GridItem.", color: .gridPurple)
                StepRow(number: 2, text: "Wrap in ScrollView { } - LazyVGrid expands to fit all content. Without ScrollView it clips.", color: .gridPurple)
                StepRow(number: 3, text: "ForEach inside the grid generates cells. Each view in the ForEach becomes one cell.", color: .gridPurple)
                StepRow(number: 4, text: ".aspectRatio(1, contentMode: .fit) on the cell makes it square - width driven by column.", color: .gridPurple)
                StepRow(number: 5, text: "alignment: on LazyVGrid controls how cells align within their row when heights differ.", color: .gridPurple)
            }

            CalloutBox(style: .warning, title: "Always wrap in ScrollView", contentBody: "LazyVGrid doesn't scroll by itself - it just lays out content vertically. Wrap it in ScrollView { LazyVGrid { } } to make it scrollable. The LazyVGrid will expand to fit all its content inside the ScrollView.")

            CodeBlock(code: """
let columns = Array(
    repeating: GridItem(.flexible(), spacing: 8),
    count: 3
)

ScrollView {
    LazyVGrid(columns: columns, spacing: 8) {
        ForEach(items) { item in
            // Cell content
            RoundedRectangle(cornerRadius: 12)
                .fill(item.color)
                .aspectRatio(1, contentMode: .fit)  // square
                .overlay(Text(item.title))
        }
    }
    .padding(.horizontal, 16)
}

// Adaptive - fills width with minimum-80pt cells
let adaptive = [GridItem(.adaptive(minimum: 80), spacing: 8)]

ScrollView {
    LazyVGrid(columns: adaptive, spacing: 8) {
        ForEach(items) { item in CellView(item: item) }
    }
}
""")
        }
    }
}

