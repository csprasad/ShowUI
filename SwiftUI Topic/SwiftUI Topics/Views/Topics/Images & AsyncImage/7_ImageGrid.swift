//
//
//  7_ImageGrid.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Image Grid
struct ImageGridVisual: View {
    @State private var selectedImage: Int? = nil
    @State private var columns = 3
    @State private var spacing: CGFloat = 3
    @Namespace private var ns

    let items = Array(0..<12)

    var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns)
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Image grid", systemImage: "square.grid.3x3.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.imgIndigo)

                // Grid controls
                HStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Text("Cols:").font(.system(size: 12)).foregroundStyle(.secondary)
                        ForEach([2, 3, 4], id: \.self) { n in
                            Button("\(n)") {
                                withAnimation(.spring(response: 0.35)) { columns = n }
                            }
                            .font(.system(size: 13, weight: columns == n ? .semibold : .regular))
                            .foregroundStyle(columns == n ? Color.imgIndigo : .secondary)
                            .frame(width: 28, height: 28)
                            .background(columns == n ? Color.imgIndigoLight : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                    Spacer()
                    HStack(spacing: 6) {
                        Text("gap:").font(.system(size: 12)).foregroundStyle(.secondary)
                        Slider(value: $spacing, in: 0...8, step: 1)
                            .tint(.imgIndigo)
                            .frame(width: 80)
                        Text("\(Int(spacing))").font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary).frame(width: 14)
                    }
                }

                // Grid
                GeometryReader { geo in
                    let size = (geo.size.width - spacing * CGFloat(columns - 1)) / CGFloat(columns)
                    LazyVGrid(columns: gridColumns, spacing: spacing) {
                        ForEach(items, id: \.self) { i in
                            GradientPlaceholder(index: i)
                                .frame(width: size, height: size)
                                .clipShape(RoundedRectangle(cornerRadius: columns == 4 ? 6 : 10))
                                .matchedGeometryEffect(id: i, in: ns)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                                        selectedImage = i
                                    }
                                }
                                .scaleEffect(selectedImage == i ? 0.95 : 1.0)
                                .animation(.spring(response: 0.3), value: selectedImage)
                        }
                    }
                    .animation(.spring(response: 0.35), value: columns)
                    .animation(.spring(response: 0.25), value: spacing)
                }
                .frame(height: 180)

                // Selected indicator
                if let sel = selectedImage {
                    HStack(spacing: 8) {
                        GradientPlaceholder(index: sel).frame(width: 24, height: 24)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Text("Image \(sel + 1) selected").font(.system(size: 12)).foregroundStyle(.secondary)
                        Spacer()
                        Button("Deselect") {
                            withAnimation { selectedImage = nil }
                        }
                        .font(.system(size: 12)).foregroundStyle(Color.imgIndigo)
                        .buttonStyle(PressableButtonStyle())
                    }
                    .padding(8).background(Color.imgIndigoLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
    }
}

struct ImageGridExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Image grid")
            Text("LazyVGrid with flexible columns is the standard pattern for photo grids. LazyVGrid only renders visible cells, making it efficient for hundreds of images. Combined with GeometryReader, you can make perfectly square cells that adapt to any screen width.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "LazyVGrid(columns: [GridItem(.flexible())...]) - n flexible columns that fill available width equally.", color: .imgIndigo)
                StepRow(number: 2, text: "Square cells: use GeometryReader to get parent width, divide by column count and subtract spacing.", color: .imgIndigo)
                StepRow(number: 3, text: ".aspectRatio(1, contentMode: .fill) - alternative to GeometryReader for square cells.", color: .imgIndigo)
                StepRow(number: 4, text: ".matchedGeometryEffect - animate a cell expanding to full-screen using namespace + transition.", color: .imgIndigo)
                StepRow(number: 5, text: "spacing on GridItem controls gap between columns. spacing on LazyVGrid controls row gap.", color: .imgIndigo)
            }

            CalloutBox(style: .success, title: "Square cells without GeometryReader", contentBody: ".aspectRatio(1, contentMode: .fit) on the cell content makes each cell square without needing GeometryReader. The cell width is determined by the grid, height matches width automatically.")

            CalloutBox(style: .info, title: "LazyVGrid vs LazyHGrid", contentBody: "LazyVGrid creates a grid that scrolls vertically. LazyHGrid creates a grid that scrolls horizontally - useful for carousels of fixed-height rows. Both are lazy and only render visible cells.")

            CodeBlock(code: """
// Square photo grid
let columns = Array(
    repeating: GridItem(.flexible(), spacing: 2),
    count: 3
)

ScrollView {
    LazyVGrid(columns: columns, spacing: 2) {
        ForEach(photos) { photo in
            AsyncImage(url: photo.url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .aspectRatio(1, contentMode: .fit)  // square
            .clipped()
            .onTapGesture { selected = photo }
        }
    }
}

// Variable columns
@State private var columnCount = 3
let dynamicColumns = Array(
    repeating: GridItem(.flexible(), spacing: 1),
    count: columnCount
)
""")
        }
    }
}

