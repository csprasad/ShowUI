//
//
//  1_ScrollViewBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: ScrollView Basics
struct ScrollBasicsVisual: View {
    @State private var selectedAxis  = 0
    @State private var showIndicator = true
    @State private var bounceOn      = true
    @State private var selectedDemo  = 0

    let axes      = ["vertical", "horizontal", "both"]
    let demos     = ["Axis", "Indicators", "Nested"]
    let cards     = ScrollCard.samples(8)

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("ScrollView basics", systemImage: "scroll.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.scrollOrange)

                // Demo selector
                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.scrollOrange : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.scrollOrangeLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Axis demo
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            ForEach(axes.indices, id: \.self) { i in
                                Button {
                                    withAnimation(.spring(response: 0.3)) { selectedAxis = i }
                                } label: {
                                    Text(axes[i])
                                        .font(.system(size: 10, weight: selectedAxis == i ? .semibold : .regular))
                                        .foregroundStyle(selectedAxis == i ? Color.scrollOrange : .secondary)
                                        .padding(.horizontal, 8).padding(.vertical, 5)
                                        .background(selectedAxis == i ? Color.scrollOrangeLight : Color(.systemFill))
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                        if selectedAxis == 0 {
                            // Vertical
                            ScrollView(.vertical, showsIndicators: showIndicator) {
                                VStack(spacing: 6) {
                                    ForEach(cards.prefix(6)) { card in scrollCell(card, horizontal: false) }
                                }
                            }
                            .frame(height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else if selectedAxis == 1 {
                            // Horizontal
                            ScrollView(.horizontal, showsIndicators: showIndicator) {
                                HStack(spacing: 8) {
                                    ForEach(cards) { card in scrollCell(card, horizontal: true) }
                                }
                                .padding(.horizontal, 4)
                            }
                            .frame(height: 80)
                        } else {
                            // Both axes
                            ScrollView([.vertical, .horizontal], showsIndicators: showIndicator) {
                                VStack(alignment: .leading, spacing: 6) {
                                    ForEach(0..<5) { row in
                                        HStack(spacing: 6) {
                                            ForEach(0..<8) { col in
                                                let idx = (row * 8 + col) % 6
                                                RoundedRectangle(cornerRadius: 6)
                                                    .fill(scrollCardColors[idx])
                                                    .frame(width: 50, height: 36)
                                                    .overlay(Text("\(row),\(col)").font(.system(size: 8)).foregroundStyle(.white))
                                            }
                                        }
                                    }
                                }
                                .padding(4)
                            }
                            .frame(height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }

                case 1:
                    // Indicators & bounce
                    VStack(spacing: 10) {
                        HStack(spacing: 16) {
                            Toggle("Indicators", isOn: $showIndicator).tint(.scrollOrange).font(.system(size: 13))
                            Toggle("Bounce", isOn: $bounceOn).tint(.scrollOrange).font(.system(size: 13))
                        }
                        ScrollView(showsIndicators: showIndicator) {
                            VStack(spacing: 6) {
                                ForEach(cards.prefix(6)) { card in scrollCell(card, horizontal: false) }
                            }
                        }
                        .scrollBounceBehavior(bounceOn ? .automatic : .basedOnSize)
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                default:
                    // Nested scrolls
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Outer VScroll").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            // Horizontal carousel nested inside
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(cards) { card in scrollCell(card, horizontal: true) }
                                }
                                .padding(.horizontal, 2)
                            }
                            Text("More vertical content").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            ForEach(cards.prefix(4)) { card in scrollCell(card, horizontal: false) }
                        }
                    }
                    .frame(height: 230)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }

    func scrollCell(_ card: ScrollCard, horizontal: Bool) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(card.color)
            .frame(width: horizontal ? 80 : nil, height: horizontal ? 64 : 36)
            .overlay(Text(card.label).font(.system(size: 10, weight: .semibold)).foregroundStyle(.white))
    }
}

struct ScrollBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "ScrollView basics")
            Text("ScrollView is the foundational scroll container. It takes an axis (or set of axes), scrolls content in that direction, and optionally shows scroll indicators. Content inside doesn't clip - it expands to its full natural size.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "ScrollView(.vertical) - the default. Content stacks vertically and scrolls up/down.", color: .scrollOrange)
                StepRow(number: 2, text: "ScrollView(.horizontal) - content stacks horizontally and scrolls left/right.", color: .scrollOrange)
                StepRow(number: 3, text: "ScrollView([.vertical, .horizontal]) - scrolls in both directions. Useful for large data grids.", color: .scrollOrange)
                StepRow(number: 4, text: "showsIndicators: false - hides the scroll bar. Common for carousels and custom styled scrolls.", color: .scrollOrange)
                StepRow(number: 5, text: "Nested ScrollViews work - an HStack carousel inside a vertical ScrollView is a standard pattern.", color: .scrollOrange)
            }

            CalloutBox(style: .info, title: "ScrollView doesn't clip by default", contentBody: "Content inside a ScrollView expands to its natural size - there's no implicit clipping. This is why LazyVGrid and LazyHStack work: they're inside a ScrollView so they can be as tall/wide as needed.")

            CodeBlock(code: """
// Vertical (default)
ScrollView {
    VStack { content }
}

// Horizontal
ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: 12) { cards }
    .padding(.horizontal, 16)
}

// Both axes
ScrollView([.vertical, .horizontal]) {
    // Large data grid
}

// Nested - common pattern
ScrollView {
    VStack {
        Text("Featured")
        ScrollView(.horizontal, showsIndicators: false) {
            HStack { carouselCards }
        }
        // more vertical content
    }
}
""")
        }
    }
}
