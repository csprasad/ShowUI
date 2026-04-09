//
//
//  5_SquareCells.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Square & Aspect Ratio Cells
struct SquareCellsVisual: View {
    @State private var selectedMethod = 0
    @State private var columnCount = 3
    @State private var aspectW: CGFloat = 1
    @State private var aspectH: CGFloat = 1
    @State private var spacing: CGFloat = 4

    let methods = ["aspectRatio(1)", "GeometryReader", "aspectRatio(W:H)"]
    let items = GridItem_Data.samples(12)

    var columns: [SwiftUI.GridItem] {
        Array(repeating: SwiftUI.GridItem(.flexible(), spacing: spacing), count: columnCount)
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Square & aspect ratio cells", systemImage: "square.grid.2x2.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gridPurple)

                HStack(spacing: 8) {
                    ForEach(methods.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedMethod = i }
                        } label: {
                            Text(methods[i])
                                .font(.system(size: 10, weight: selectedMethod == i ? .semibold : .regular))
                                .foregroundStyle(selectedMethod == i ? Color.gridPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedMethod == i ? Color.gridPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Controls
                HStack(spacing: 10) {
                    HStack(spacing: 6) {
                        Text("cols:").font(.system(size: 11)).foregroundStyle(.secondary)
                        ForEach([2, 3, 4, 5], id: \.self) { n in
                            Button("\(n)") { withAnimation(.spring(response: 0.3)) { columnCount = n } }
                                .font(.system(size: 12, weight: columnCount == n ? .semibold : .regular))
                                .foregroundStyle(columnCount == n ? .white : .secondary)
                                .frame(width: 26, height: 26)
                                .background(columnCount == n ? Color.gridPurple : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .buttonStyle(PressableButtonStyle())
                        }
                    }
                    sliderRow("gap", value: $spacing, range: 0...12)
                }

                if selectedMethod == 2 {
                    HStack(spacing: 8) {
                        sliderRow("W", value: $aspectW, range: 1...3)
                        sliderRow("H", value: $aspectH, range: 1...3)
                    }
                }

                // Live grid
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(items) { item in
                        switch selectedMethod {
                        case 0:
                            // aspectRatio(1) - simplest square method
                            RoundedRectangle(cornerRadius: 8)
                                .fill(gridCellColors[item.colorIndex])
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(Text(item.label).font(.system(size: 12, weight: .bold)).foregroundStyle(.white))

                        case 1:
                            // GeometryReader to get exact width
                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(gridCellColors[item.colorIndex])
                                    .frame(width: geo.size.width, height: geo.size.width)
                                    .overlay(
                                        VStack(spacing: 2) {
                                            Text(item.label).font(.system(size: 11, weight: .bold)).foregroundStyle(.white)
                                            Text("\(Int(geo.size.width))pt").font(.system(size: 8, design: .monospaced)).foregroundStyle(.white.opacity(0.7))
                                        }
                                    )
                            }
                            .aspectRatio(1, contentMode: .fit) // still need this for row height

                        default:
                            // Custom aspect ratio
                            RoundedRectangle(cornerRadius: 8)
                                .fill(gridCellColors[item.colorIndex])
                                .aspectRatio(aspectW / aspectH, contentMode: .fit)
                                .overlay(
                                    Text("\(Int(aspectW)):\(Int(aspectH))")
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundStyle(.white.opacity(0.9))
                                )
                        }
                    }
                }
                .animation(.spring(response: 0.4), value: columnCount)
                .animation(.easeInOut(duration: 0.15), value: spacing)
                .animation(.spring(response: 0.3), value: selectedMethod)
                .animation(.easeInOut(duration: 0.1), value: aspectW)
                .animation(.easeInOut(duration: 0.1), value: aspectH)
            }
        }
    }

    func sliderRow(_ label: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>) -> some View {
        HStack(spacing: 6) {
            Text(label).font(.system(size: 10)).foregroundStyle(.secondary).frame(width: 20)
            Slider(value: value, in: range, step: 0.5).tint(.gridPurple)
            Text(String(format: "%.1f", value.wrappedValue)).font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.gridPurple).frame(width: 24)
        }
    }
}

struct SquareCellsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Square and aspect-ratio cells")
            Text("Making grid cells square or a specific aspect ratio requires a small trick - the grid defines the width, so you derive height from that width using aspectRatio modifier. This is cleaner than GeometryReader for most cases.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".aspectRatio(1, contentMode: .fit) - the simplest square method. Width set by grid, height matches width.", color: .gridPurple)
                StepRow(number: 2, text: ".aspectRatio(16/9, contentMode: .fit) - widescreen cells. .aspectRatio(4/3) for portrait cards.", color: .gridPurple)
                StepRow(number: 3, text: "GeometryReader gives exact pixel width - useful when you need to pass the size to a child view.", color: .gridPurple)
                StepRow(number: 4, text: "contentMode: .fit - height derived from width. contentMode: .fill - width and height both flexible.", color: .gridPurple)
            }

            CalloutBox(style: .success, title: ".aspectRatio(1) is all you need", contentBody: "For square cells, .aspectRatio(1, contentMode: .fit) is the cleanest approach. SwiftUI sets the width from the column, then makes the height equal to the width. No GeometryReader needed.")

            CalloutBox(style: .info, title: "GeometryReader for exact dimensions", contentBody: "Use GeometryReader when you need to pass the cell size to a child view - for example, to size a Canvas drawing or position overlay elements precisely relative to cell size.")

            CodeBlock(code: """
// Simplest - square with aspectRatio
LazyVGrid(columns: columns, spacing: 8) {
    ForEach(items) { item in
        Color.blue
            .aspectRatio(1, contentMode: .fit)  // square
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// Custom aspect ratio
.aspectRatio(16/9, contentMode: .fit)  // widescreen
.aspectRatio(3/4, contentMode: .fit)   // portrait card

// GeometryReader - when you need the exact size
GeometryReader { geo in
    let size = geo.size.width
    Canvas { context, _ in
        // draw using exact 'size'
    }
    .frame(width: size, height: size)
}
.aspectRatio(1, contentMode: .fit)  // still needed
""")
        }
    }
}
