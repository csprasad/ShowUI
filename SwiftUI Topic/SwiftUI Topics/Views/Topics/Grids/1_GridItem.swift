//
//
//  1_GridItem.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: GridItem Column Types

struct GridItemVisual: View {
    @State private var selectedType = 0
    @State private var fixedWidth: CGFloat = 80
    @State private var flexibleMin: CGFloat = 60
    @State private var flexibleMax: CGFloat = 120
    @State private var adaptiveMin: CGFloat = 70
    @State private var columnCount = 3

    let types = ["fixed", "flexible", "adaptive"]

    let items = GridItem_Data.samples(9)

    var columns: [SwiftUI.GridItem] {
        switch selectedType {
        case 0: return Array(repeating: SwiftUI.GridItem(.fixed(fixedWidth)), count: columnCount)
        case 1: return Array(repeating: SwiftUI.GridItem(.flexible(minimum: flexibleMin, maximum: flexibleMax)), count: columnCount)
        default: return [SwiftUI.GridItem(.adaptive(minimum: adaptiveMin))]
        }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("GridItem column types", systemImage: "rectangle.split.3x1.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gridPurple)

                // Type selector
                HStack(spacing: 8) {
                    ForEach(types.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedType = i }
                        } label: {
                            Text(".\(types[i])")
                                .font(.system(size: 11, weight: selectedType == i ? .semibold : .regular, design: .monospaced))
                                .foregroundStyle(selectedType == i ? Color.gridPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedType == i ? Color.gridPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Controls
                switch selectedType {
                case 0:
                    VStack(spacing: 6) {
                        sliderRow("width", value: $fixedWidth, range: 40...140)
                        sliderRow("cols", value: Binding(get: { CGFloat(columnCount) }, set: { columnCount = Int($0) }), range: 2...5, format: "%.0f")
                    }
                case 1:
                    VStack(spacing: 6) {
                        sliderRow("min", value: $flexibleMin, range: 30...120)
                        sliderRow("max", value: $flexibleMax, range: 80...200)
                        sliderRow("cols", value: Binding(get: { CGFloat(columnCount) }, set: { columnCount = Int($0) }), range: 2...5, format: "%.0f")
                    }
                default:
                    sliderRow("min", value: $adaptiveMin, range: 40...160)
                }

                // Live grid preview
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(items) { item in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(gridCellColors[item.colorIndex].opacity(0.85))
                            .frame(height: 36)
                            .overlay(Text(item.label).font(.system(size: 11, weight: .semibold)).foregroundStyle(.white))
                    }
                }
                .animation(.spring(response: 0.4), value: selectedType)
                .animation(.spring(response: 0.3), value: columns.count)
                .animation(.easeInOut(duration: 0.15), value: fixedWidth)
                .animation(.easeInOut(duration: 0.15), value: adaptiveMin)

                // Live code
                codePreview
            }
        }
    }

    @ViewBuilder
    private var codePreview: some View {
        Text(generatedCodeString)
            .font(.system(size: 10, design: .monospaced))
            .foregroundStyle(Color.gridPurple)
            .padding(8)
            .background(Color.gridPurpleLight)
            .clipShape(RoundedRectangle(cornerRadius: 7))
    }

    // Helper property to handle the logic
    private var generatedCodeString: String {
        switch selectedType {
        case 0:
            return "GridItem(.fixed(\(Int(fixedWidth))))"
        case 1:
            return "GridItem(.flexible(minimum: \(Int(flexibleMin)), maximum: \(Int(flexibleMax))))"
        default:
            return "GridItem(.adaptive(minimum: \(Int(adaptiveMin))))"
        }
    }

    func sliderRow(_ label: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>, format: String = "%.0f") -> some View {
        HStack(spacing: 8) {
            Text(label).font(.system(size: 11)).foregroundStyle(.secondary).frame(width: 28)
            Slider(value: value, in: range, step: 1).tint(.gridPurple)
            Text(String(format: format, value.wrappedValue))
                .font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.gridPurple).frame(width: 28)
        }
    }
}

struct GridItemExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "GridItem - three column types")
            Text("GridItem defines a single column's sizing behavior. Arrays of GridItems define the full column layout for a grid. Three types cover every layout need: fixed size, flexible within a range, and adaptive count.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".fixed(80) - always exactly 80pt wide. Use for known-size content like icons or thumbnails.", color: .gridPurple)
                StepRow(number: 2, text: ".flexible(minimum:maximum:) - expands to fill available space, constrained within min/max. Most common type.", color: .gridPurple)
                StepRow(number: 3, text: ".adaptive(minimum:maximum:) - packs as many columns as fit, each at least minimum wide. One GridItem = many columns.", color: .gridPurple)
                StepRow(number: 4, text: "Mix types in one array: [.fixed(60), .flexible(), .fixed(60)] - fixed sidebars with flexible center.", color: .gridPurple)
                StepRow(number: 5, text: "GridItem spacing controls horizontal gap between cells in that column.", color: .gridPurple)
            }

            CalloutBox(style: .success, title: ".adaptive is the responsive grid", contentBody: "GridItem(.adaptive(minimum: 100)) automatically adjusts column count as screen width changes - 3 columns on iPhone, 5 on iPad, 8 on Mac. One line of code for a fully responsive grid.")

            CodeBlock(code: """
// 3 fixed columns - always 80pt wide
let fixed = Array(repeating: GridItem(.fixed(80)), count: 3)

// 3 flexible columns - share available width
let flexible = Array(
    repeating: GridItem(.flexible()),
    count: 3
)

// Adaptive - fills space with min-80pt columns
let adaptive = [GridItem(.adaptive(minimum: 80))]

// Mixed - fixed sidebar + flexible center
let mixed = [
    GridItem(.fixed(60)),
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.fixed(60)),
]

// With spacing
GridItem(.flexible(), spacing: 8)
""")
        }
    }
}
