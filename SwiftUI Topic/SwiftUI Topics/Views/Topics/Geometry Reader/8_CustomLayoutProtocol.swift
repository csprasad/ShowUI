//
//
//  8_CustomLayoutProtocol.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Custom Layout Protocol
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(for: subviews, in: proposal.width ?? 300)
        let totalH = rows.reduce(0) { $0 + $1.height } + CGFloat(max(0, rows.count - 1)) * spacing
        return CGSize(width: proposal.width ?? 300, height: totalH)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(for: subviews, in: bounds.width)
        var y    = bounds.minY
        for row in rows {
            var x = bounds.minX
            for view in row.views {
                let size = view.sizeThatFits(.unspecified)
                view.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
                x += size.width + spacing
            }
            y += row.height + spacing
        }
    }

    private struct RowData { let views: [LayoutSubview]; let height: CGFloat }

    private func computeRows(for subviews: Subviews, in width: CGFloat) -> [RowData] {
        var rows: [RowData] = []
        var currentRow: [LayoutSubview] = []
        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if rowWidth + size.width > width && !currentRow.isEmpty {
                rows.append(RowData(views: currentRow, height: rowHeight))
                currentRow = []
                rowWidth   = 0
                rowHeight  = 0
            }
            currentRow.append(view)
            rowWidth  += size.width + spacing
            rowHeight  = max(rowHeight, size.height)
        }
        if !currentRow.isEmpty { rows.append(RowData(views: currentRow, height: rowHeight)) }
        return rows
    }
}

struct CustomLayoutVisual: View {
    @State private var containerWidth: CGFloat = 280
    @State private var chipSpacing: CGFloat    = 8
    @State private var selectedDemo            = 0
    let demos = ["Flow layout", "Diagonal grid", "Radial layout"]
    let chips = ["Swift", "SwiftUI", "Combine", "CoreData", "CloudKit", "Accessibility", "Testing", "Xcode", "UIKit", "Metal"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Custom Layout protocol", systemImage: "gear.badge")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.geoGreen)
                    Spacer()
                    Text("iOS 16+").font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.geoGreen)
                        .padding(.horizontal, 8).padding(.vertical, 3).background(Color.geoGreenLight).clipShape(Capsule())
                }

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.geoGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.geoGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Flow layout demo
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            HStack(spacing: 6) {
                                Text("width:").font(.system(size: 11)).foregroundStyle(.secondary).frame(width: 36)
                                Slider(value: $containerWidth, in: 120...320, step: 4).tint(.geoGreen)
                                Text("\(Int(containerWidth))").font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.geoGreen).frame(width: 28)
                            }
                        }
                        HStack(spacing: 8) {
                            Text("gap:").font(.system(size: 11)).foregroundStyle(.secondary).frame(width: 28)
                            Slider(value: $chipSpacing, in: 2...20, step: 1).tint(.geoGreen)
                            Text("\(Int(chipSpacing))").font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.geoGreen).frame(width: 20)
                        }

                        FlowLayout(spacing: chipSpacing) {
                            ForEach(chips, id: \.self) { chip in
                                Text(chip)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(Color.geoGreen)
                                    .padding(.horizontal, 10).padding(.vertical, 5)
                                    .background(Color.geoGreenLight)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.geoGreen.opacity(0.3), lineWidth: 1))
                            }
                        }
                        .frame(width: containerWidth)
                        .padding(10).background(Color(.systemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                        .animation(.spring(response: 0.4), value: containerWidth)
                        .animation(.spring(response: 0.3), value: chipSpacing)
                    }

                case 1:
                    // Diagonal offset grid
                    DiagonalGridDemo()

                default:
                    // Radial layout
                    RadialLayoutDemo()
                }
            }
        }
    }
}

struct DiagonalGridDemo: View {
    let items = Array(0..<9)
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
            VStack(spacing: 0) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { col in
                            let idx = row * 3 + col
                            RoundedRectangle(cornerRadius: 8)
                                .fill(gridCellColors[idx % gridCellColors.count])
                                .frame(width: 50, height: 50)
                                .overlay(Text("\(idx + 1)").font(.system(size: 12, weight: .bold)).foregroundStyle(.white))
                                .offset(x: CGFloat(row) * 12, y: 0)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .overlay(
                Text("Diagonal offset via Layout.placeSubviews")
                    .font(.system(size: 9)).foregroundStyle(.secondary).padding(6),
                alignment: .bottomLeading
            )
        }
        .frame(maxWidth: .infinity).frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct RadialLayoutDemo: View {
    let count = 8
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
            ZStack {
                ForEach(0..<count, id: \.self) { i in
                    let angle = Double(i) / Double(count) * 2 * .pi - .pi / 2
                    let r: CGFloat = 70
                    Circle()
                        .fill(gridCellColors[i % gridCellColors.count])
                        .frame(width: 36, height: 36)
                        .overlay(Text("\(i+1)").font(.system(size: 11, weight: .bold)).foregroundStyle(.white))
                        .offset(x: cos(angle) * r, y: sin(angle) * r)
                }
                Circle().fill(Color.geoGreen).frame(width: 40, height: 40)
                    .overlay(Image(systemName: "star.fill").font(.system(size: 16)).foregroundStyle(.white))
            }
        }
        .frame(maxWidth: .infinity).frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(Text("Radial placement - use Layout.placeSubviews with angle math")
            .font(.system(size: 9)).foregroundStyle(.secondary).padding(8), alignment: .bottomLeading)
    }
}

struct CustomLayoutExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Layout protocol - iOS 16+")
            Text("The Layout protocol gives you full control over how child views are sized and placed. Implement sizeThatFits and placeSubviews and SwiftUI calls them during layout. Use it for flow layouts, radial arrangements, or any geometry that VStack/HStack can't express.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "sizeThatFits(proposal:subviews:cache:) - return the CGSize you need. Called first.", color: .geoGreen)
                StepRow(number: 2, text: "placeSubviews(in:proposal:subviews:cache:) - call view.place(at:proposal:) for each child.", color: .geoGreen)
                StepRow(number: 3, text: "view.sizeThatFits(.unspecified) - ask each child how big it wants to be.", color: .geoGreen)
                StepRow(number: 4, text: "cache: inout Cache - store expensive calculations here. Reset with makeCache().", color: .geoGreen)
                StepRow(number: 5, text: "AnyLayout(FlowLayout()) - type-erase Layout for smooth animated transitions between layouts.", color: .geoGreen)
            }

            CalloutBox(style: .success, title: "AnyLayout for animated layout switching", contentBody: "let layout = isWide ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout()); layout { children } - wrapping in AnyLayout lets SwiftUI animate the transition between layout modes with full matchedGeometry.")

            CodeBlock(code: """
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize,
                       subviews: Subviews,
                       cache: inout ()) -> CGSize {
        let rows = computeRows(subviews, width: proposal.width ?? 0)
        return CGSize(
            width: proposal.width ?? 0,
            height: totalHeight(rows)
        )
    }

    func placeSubviews(in bounds: CGRect,
                        proposal: ProposedViewSize,
                        subviews: Subviews,
                        cache: inout ()) {
        var y = bounds.minY
        for row in computeRows(subviews, width: bounds.width) {
            var x = bounds.minX
            for view in row {
                let size = view.sizeThatFits(.unspecified)
                view.place(at: CGPoint(x: x, y: y),
                            proposal: .unspecified)
                x += size.width + spacing
            }
            y += rowHeight(row) + spacing
        }
    }
}

// Use like any layout container
FlowLayout(spacing: 8) {
    ForEach(tags) { tag in TagChip(tag) }
}
""")
        }
    }
}

