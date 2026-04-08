//
//
//  7_MixedLayouts.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Mixed Layouts
struct MixedLayoutVisual: View {
    @State private var selectedLayout = 0
    let layouts = ["Featured + grid", "Sidebar + grid", "Masonry-style"]
    let items = GridItem_Data.samples(12)

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Mixed layouts", systemImage: "rectangle.3.group.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gridPurple)

                HStack(spacing: 8) {
                    ForEach(layouts.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedLayout = i }
                        } label: {
                            Text(layouts[i])
                                .font(.system(size: 11, weight: selectedLayout == i ? .semibold : .regular))
                                .foregroundStyle(selectedLayout == i ? Color.gridPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedLayout == i ? Color.gridPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                ScrollView {
                    layoutContent
                }
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedLayout)
            }
        }
    }

    @ViewBuilder
    private var layoutContent: some View {
        switch selectedLayout {
        case 0:
            // Featured hero + 3-col grid below
            VStack(spacing: 8) {
                // Hero cell
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(colors: [Color(hex: "#7E22CE"), Color(hex: "#1D4ED8")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(maxWidth: .infinity).frame(height: 100)
                    .overlay(
                        VStack(spacing: 4) {
                            Text("Featured").font(.system(size: 18, weight: .bold)).foregroundStyle(.white)
                            Text("Full-width hero cell above the grid").font(.system(size: 11)).foregroundStyle(.white.opacity(0.8))
                        }
                    )

                // 3-col grid for remaining items
                LazyVGrid(columns: Array(repeating: SwiftUI.GridItem(.flexible(), spacing: 6), count: 3), spacing: 6) {
                    ForEach(items.prefix(9)) { item in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(gridCellColors[item.colorIndex])
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(Text(item.label).font(.system(size: 11, weight: .bold)).foregroundStyle(.white))
                    }
                }
            }
            .padding(.horizontal, 2)

        case 1:
            // Fixed sidebar + flexible grid
            HStack(alignment: .top, spacing: 8) {
                // Sidebar
                VStack(spacing: 6) {
                    ForEach(["All", "Art", "Photo", "Design", "Music"], id: \.self) { label in
                        Text(label)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Color.gridPurple)
                            .frame(maxWidth: .infinity).padding(.vertical, 7)
                            .background(label == "All" ? Color.gridPurpleLight : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                    }
                }
                .frame(width: 60)

                // Grid
                LazyVGrid(columns: Array(repeating: SwiftUI.GridItem(.flexible(), spacing: 5), count: 2), spacing: 5) {
                    ForEach(items.prefix(8)) { item in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(gridCellColors[item.colorIndex])
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(Text(item.label).font(.system(size: 11, weight: .bold)).foregroundStyle(.white))
                    }
                }
            }
            .padding(.horizontal, 2)

        default:
            // Masonry-style (two columns different heights)
            HStack(alignment: .top, spacing: 6) {
                // Left column
                VStack(spacing: 6) {
                    ForEach([0, 2, 4, 6, 8, 10].filter { $0 < items.count }, id: \.self) { i in
                        let item = items[i]
                        let height: CGFloat = [80, 110, 70, 100, 90, 80][i / 2 % 6]
                        RoundedRectangle(cornerRadius: 10)
                            .fill(gridCellColors[item.colorIndex])
                            .frame(maxWidth: .infinity).frame(height: height)
                            .overlay(Text(item.label).font(.system(size: 11, weight: .bold)).foregroundStyle(.white))
                    }
                }
                // Right column - offset heights
                VStack(spacing: 6) {
                    ForEach([1, 3, 5, 7, 9, 11].filter { $0 < items.count }, id: \.self) { i in
                        let item = items[i]
                        let height: CGFloat = [100, 80, 110, 70, 90, 100][i / 2 % 6]
                        RoundedRectangle(cornerRadius: 10)
                            .fill(gridCellColors[item.colorIndex])
                            .frame(maxWidth: .infinity).frame(height: height)
                            .overlay(Text(item.label).font(.system(size: 11, weight: .bold)).foregroundStyle(.white))
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }
}

struct MixedLayoutExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Mixed and custom grid layouts")
            Text("Real apps rarely use a single uniform grid. The most engaging layouts combine a hero element with a grid, use sidebar navigation with a content grid, or create a masonry layout with variable-height cells.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Hero + grid: place a full-width view above LazyVGrid inside a VStack inside a ScrollView.", color: .gridPurple)
                StepRow(number: 2, text: "Sidebar + grid: HStack with a fixed-width VStack sidebar and a LazyVGrid taking the remaining space.", color: .gridPurple)
                StepRow(number: 3, text: "Mixed columns: [GridItem(.fixed(60)), GridItem(.flexible())] - fixed sidebar column + flexible content.", color: .gridPurple)
                StepRow(number: 4, text: "Masonry (variable heights): two VStack columns in an HStack - not a real LazyVGrid but achieves the Pinterest look.", color: .gridPurple)
            }

            CalloutBox(style: .info, title: "True masonry requires custom Layout", contentBody: "SwiftUI's LazyVGrid doesn't support true masonry (variable-height cells filling space optimally). For production masonry, implement the Layout protocol in iOS 16+ which gives full control over cell placement.")

            CodeBlock(code: """
// Hero + grid pattern
ScrollView {
    VStack(spacing: 12) {
        // Hero
        HeroCard()
            .frame(maxWidth: .infinity, height: 200)

        // Grid below
        LazyVGrid(columns: threeColumns, spacing: 8) {
            ForEach(items) { item in CellView(item: item) }
        }
    }
    .padding(.horizontal, 16)
}

// Sidebar + grid
HStack(alignment: .top, spacing: 0) {
    // Fixed sidebar
    CategoryList()
        .frame(width: 80)

    // Flexible grid
    ScrollView {
        LazyVGrid(columns: twoColumns, spacing: 8) {
            ForEach(filteredItems) { item in CellView(item: item) }
        }
    }
}

// Masonry - two VStack columns
HStack(alignment: .top, spacing: 8) {
    VStack(spacing: 8) { ForEach(leftItems) { PinCard($0) } }
    VStack(spacing: 8) { ForEach(rightItems) { PinCard($0) } }
}
""")
        }
    }
}
