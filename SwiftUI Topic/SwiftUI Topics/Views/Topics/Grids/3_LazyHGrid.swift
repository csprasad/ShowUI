//
//
//  3_LazyHGrid.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: LazyHGrid
struct LazyHGridBasicsVisual: View {
    @State private var rowCount = 2
    @State private var rowHeight: CGFloat = 80
    @State private var spacing: CGFloat = 10
    @State private var selectedLayout = 0

    let items = GridItem_Data.samples(16)
    let layouts = ["Fixed rows", "Flexible rows", "Shelf / carousel"]

    var rows: [SwiftUI.GridItem] {
        switch selectedLayout {
        case 0: return Array(repeating: SwiftUI.GridItem(.fixed(rowHeight)), count: rowCount)
        case 1: return Array(repeating: SwiftUI.GridItem(.flexible()), count: rowCount)
        default: return [SwiftUI.GridItem(.fixed(rowHeight))]
        }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("LazyHGrid basics", systemImage: "square.grid.3x3.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gridPurple)

                // Layout selector
                VStack(spacing: 6) {
                    ForEach(layouts.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedLayout = i }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: selectedLayout == i ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 14))
                                    .foregroundStyle(selectedLayout == i ? Color.gridPurple : .secondary)
                                Text(layouts[i])
                                    .font(.system(size: 12, weight: selectedLayout == i ? .semibold : .regular))
                                    .foregroundStyle(selectedLayout == i ? Color.gridPurple : .primary)
                                Spacer()
                            }
                            .padding(.horizontal, 10).padding(.vertical, 7)
                            .background(selectedLayout == i ? Color.gridPurpleLight : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Controls
                if selectedLayout == 0 {
                    HStack(spacing: 10) {
                        sliderRow("height", value: $rowHeight, range: 50...120)
                        HStack(spacing: 6) {
                            Text("rows:").font(.system(size: 11)).foregroundStyle(.secondary)
                            ForEach([1, 2, 3], id: \.self) { n in
                                Button("\(n)") { withAnimation(.spring(response: 0.3)) { rowCount = n } }
                                    .font(.system(size: 12, weight: rowCount == n ? .semibold : .regular))
                                    .foregroundStyle(rowCount == n ? .white : .secondary)
                                    .frame(width: 28, height: 28)
                                    .background(rowCount == n ? Color.gridPurple : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .buttonStyle(PressableButtonStyle())
                            }
                        }
                    }
                }

                // Live horizontal grid
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: rows, spacing: spacing) {
                        ForEach(items) { item in
                            if selectedLayout == 2 {
                                // Carousel cards
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(
                                        LinearGradient(
                                            colors: [gridCellColors[item.colorIndex], gridCellColors[(item.colorIndex + 2) % 9]],
                                            startPoint: .topLeading, endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: rowHeight)
                                    .overlay(
                                        VStack(spacing: 4) {
                                            Image(systemName: "photo.fill")
                                                .font(.system(size: 20)).foregroundStyle(.white.opacity(0.7))
                                            Text("Card \(item.label)")
                                                .font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
                                        }
                                    )
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(gridCellColors[item.colorIndex])
                                    .frame(width: rowHeight)
                                    .overlay(Text(item.label).font(.system(size: 12, weight: .semibold)).foregroundStyle(.white))
                            }
                        }
                    }
                    .padding(.horizontal, 2)
                }
                .frame(height: selectedLayout == 2 ? rowHeight + 20 : CGFloat(rowCount) * (rowHeight + spacing) + 10)
                .animation(.spring(response: 0.4), value: selectedLayout)
                .animation(.spring(response: 0.3), value: rowCount)
                .animation(.easeInOut(duration: 0.15), value: rowHeight)
            }
        }
    }

    func sliderRow(_ label: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>) -> some View {
        HStack(spacing: 6) {
            Text(label).font(.system(size: 10)).foregroundStyle(.secondary).frame(width: 36)
            Slider(value: value, in: range, step: 2).tint(.gridPurple)
            Text("\(Int(value.wrappedValue))").font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.gridPurple).frame(width: 24)
        }
    }
}

struct LazyHGridBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "LazyHGrid - horizontal grid")
            Text("LazyHGrid is the horizontal counterpart to LazyVGrid. Cells flow left to right and the grid scrolls horizontally. It takes rows instead of columns, and each GridItem in the rows array defines one row's height behavior.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "LazyHGrid(rows: rows, spacing: 10) - spacing is the column gap. Row gap is set per-GridItem.", color: .gridPurple)
                StepRow(number: 2, text: "Wrap in ScrollView(.horizontal) { } - content flows right and scrolls horizontally.", color: .gridPurple)
                StepRow(number: 3, text: "Single row = [GridItem(.fixed(80))] creates a horizontal shelf/carousel.", color: .gridPurple)
                StepRow(number: 4, text: "Multiple rows fill top to bottom, then advance to the next column.", color: .gridPurple)
                StepRow(number: 5, text: "Fixed width on each cell prevents infinite width - without it, cells expand to fill.", color: .gridPurple)
            }

            CalloutBox(style: .success, title: "Single-row LazyHGrid = shelf", contentBody: "A single-row LazyHGrid with fixed-width cells is the cleanest way to build a horizontally scrolling shelf. Much more efficient than HStack for large item counts - cells are lazy.")

            CodeBlock(code: """
// Single-row carousel / shelf
let rows = [GridItem(.fixed(120))]

ScrollView(.horizontal, showsIndicators: false) {
    LazyHGrid(rows: rows, spacing: 12) {
        ForEach(items) { item in
            CardView(item: item)
                .frame(width: 160)  // explicit width per cell
        }
    }
    .padding(.horizontal, 16)
}

// Two-row grid
let twoRows = Array(
    repeating: GridItem(.fixed(90), spacing: 8),
    count: 2
)

ScrollView(.horizontal) {
    LazyHGrid(rows: twoRows, spacing: 8) {
        ForEach(items) { item in
            ThumbnailView(item: item)
                .frame(width: 90)  // square cells
        }
    }
}
""")
        }
    }
}
