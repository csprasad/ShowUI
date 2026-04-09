//
//
//  4_Grid(non-lazy).swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Grid (non-lazy, iOS 16)
struct GridNonLazyVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Aligned table", "Column span", "Mixed widths"]

    // Table data
    struct Row { let name: String; let value: String; let trend: String; let isUp: Bool }
    let tableData: [Row] = [
        Row(name: "Revenue",   value: "$24.5K",  trend: "+12%", isUp: true),
        Row(name: "Users",     value: "1,847",   trend: "+8%",  isUp: true),
        Row(name: "Churn",     value: "2.1%",    trend: "-0.3%",isUp: false),
        Row(name: "NPS",       value: "72",      trend: "+4",   isUp: true),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Grid (non-lazy)", systemImage: "tablecells.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.gridPurple)
                    Spacer()
                    Text("iOS 16+")
                        .font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.gridPurple)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.gridPurpleLight).clipShape(Capsule())
                }

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.gridPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.gridPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Aligned data table
                    Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 0) {
                        // Header
                        GridRow {
                            Text("Metric").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            Text("Value").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            Text("Trend").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                        }
                        .padding(8)
                        .background(Color(.systemFill))

                        Divider()

                        ForEach(tableData, id: \.name) { row in
                            GridRow {
                                Text(row.name).font(.system(size: 13))
                                Text(row.value).font(.system(size: 13, weight: .semibold, design: .monospaced))
                                HStack(spacing: 3) {
                                    Image(systemName: row.isUp ? "arrow.up" : "arrow.down")
                                        .font(.system(size: 9, weight: .bold))
                                    Text(row.trend).font(.system(size: 12))
                                }
                                .foregroundStyle(row.isUp ? Color.formGreen : Color.animCoral)
                            }
                            .padding(.vertical, 7)
                            Divider()
                        }
                    }
                    .padding(10).background(Color(.systemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                case 1:
                    // Column spanning
                    Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                        GridRow {
                            cellBox("A", color: gridCellColors[0])
                            cellBox("B", color: gridCellColors[1])
                            cellBox("C", color: gridCellColors[2])
                        }
                        GridRow {
                            cellBox("D spans 2 cols", color: gridCellColors[3])
                                .gridCellColumns(2)
                            cellBox("E", color: gridCellColors[4])
                        }
                        GridRow {
                            cellBox("F", color: gridCellColors[5])
                            cellBox("G spans 2 cols", color: gridCellColors[6])
                                .gridCellColumns(2)
                        }
                        GridRow {
                            cellBox("H spans all 3", color: gridCellColors[7])
                                .gridCellColumns(3)
                        }
                    }

                default:
                    // Mixed column alignment
                    Grid(alignment: .center, horizontalSpacing: 8, verticalSpacing: 8) {
                        GridRow(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Title").font(.system(size: 14, weight: .semibold))
                                Text("Subtitle text").font(.system(size: 11)).foregroundStyle(.secondary)
                            }
                            .gridCellAnchor(.leading)
                            .padding(8).background(Color.gridPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))

                            VStack(spacing: 4) {
                                Text("42").font(.system(size: 14, weight: .bold, design: .rounded)).foregroundStyle(Color.gridPurple)
                                Text("points").font(.system(size: 10)).foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        GridRow {
                            Text("Full-width footer note spanning both columns")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                                .gridCellColumns(2)
                        }
                    }
                }

                Text(["Grid aligns columns perfectly - each column takes the width of its widest cell. Columns stay aligned across all rows.", "gridCellColumns(n) makes a cell span n columns - like colspan in HTML tables.", "gridCellAnchor controls alignment within the cell. Mix row-level and cell-level alignment."][selectedDemo])
                    .font(.system(size: 11)).foregroundStyle(.secondary)
            }
        }
    }

    func cellBox(_ label: String, color: Color) -> some View {
        Text(label)
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity).frame(height: 36)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct GridNonLazyExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Grid - aligned layout (iOS 16+)")
            Text("Grid (non-lazy) is designed for tabular data where columns need to align perfectly across rows - like a table or a stat panel. Unlike LazyVGrid, Grid ensures each column's width matches its widest cell across all rows.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Grid { GridRow { ... } } - each GridRow is a row. Cells in the same column automatically align.", color: .gridPurple)
                StepRow(number: 2, text: ".gridCellColumns(2) - span a cell across multiple columns (like HTML colspan).", color: .gridPurple)
                StepRow(number: 3, text: ".gridCellAnchor(.leading) - custom alignment within a cell, overriding the grid default.", color: .gridPurple)
                StepRow(number: 4, text: "Grid(alignment:horizontalSpacing:verticalSpacing:) - set default alignment and gaps.", color: .gridPurple)
                StepRow(number: 5, text: "GridRow(alignment:) - per-row vertical alignment override.", color: .gridPurple)
            }

            CalloutBox(style: .info, title: "Grid vs LazyVGrid", contentBody: "LazyVGrid is for large data sets with repeating cell types - it's lazy and efficient. Grid is for small, structured layouts where column alignment matters - like a stats panel or custom table. Grid is not lazy - don't use it for long lists.")

            CodeBlock(code: """
// Aligned data table
Grid(alignment: .leading, horizontalSpacing: 12) {
    // Header row
    GridRow {
        Text("Name").font(.caption).foregroundStyle(.secondary)
        Text("Value").font(.caption).foregroundStyle(.secondary)
        Text("Change").font(.caption).foregroundStyle(.secondary)
    }
    Divider()
    // Data rows - columns stay aligned
    ForEach(items) { item in
        GridRow {
            Text(item.name)
            Text(item.value).fontWeight(.semibold)
            Text(item.change).foregroundStyle(item.isPositive ? .green : .red)
        }
        Divider()
    }
}

// Column spanning
GridRow {
    Text("Spans two columns")
        .gridCellColumns(2)
    Text("Single cell")
}
""")
        }
    }
}

