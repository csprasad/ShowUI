//
//
//  3_ScrollTargetBehavior.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: scrollTargetBehavior
struct ScrollTargetVisual: View {
    @State private var selectedBehavior = 0
    @State private var selectedAxis     = 0
    let behaviors = ["viewAligned", "paging", "none (free)"]
    let cards     = ScrollCard.samples(8)

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("scrollTargetBehavior", systemImage: "hand.point.right.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.scrollOrange)

                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        ForEach(behaviors.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedBehavior = i }
                            } label: {
                                Text(behaviors[i])
                                    .font(.system(size: 10, weight: selectedBehavior == i ? .semibold : .regular))
                                    .foregroundStyle(selectedBehavior == i ? Color.scrollOrange : .secondary)
                                    .frame(maxWidth: .infinity).padding(.vertical, 7)
                                    .background(selectedBehavior == i ? Color.scrollOrangeLight : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                    HStack(spacing: 8) {
                        ForEach(["Horizontal", "Vertical"].indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedAxis = i }
                            } label: {
                                Text(["Horizontal", "Vertical"][i])
                                    .font(.system(size: 11, weight: selectedAxis == i ? .semibold : .regular))
                                    .foregroundStyle(selectedAxis == i ? Color.scrollOrange : .secondary)
                                    .frame(maxWidth: .infinity).padding(.vertical, 6)
                                    .background(selectedAxis == i ? Color.scrollOrangeLight : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }

                // Live demo
                if selectedAxis == 0 {
                    // Horizontal
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(cards) { card in
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(card.color)
                                    .frame(width: 180, height: 110)
                                    .overlay(
                                        VStack(spacing: 4) {
                                            Text(card.label).font(.system(size: 16, weight: .bold)).foregroundStyle(.white)
                                            if selectedBehavior == 0 {
                                                Text("viewAligned").font(.system(size: 10, design: .monospaced)).foregroundStyle(.white.opacity(0.7))
                                            } else if selectedBehavior == 1 {
                                                Text("paging").font(.system(size: 10, design: .monospaced)).foregroundStyle(.white.opacity(0.7))
                                            }
                                        }
                                    )
                                    .scrollTargetLayout()
                                    .containerRelativeFrame(selectedBehavior == 1 ? .horizontal : [])
                            }
                        }
                        .padding(.horizontal, 16)
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(behaviorForIndex(selectedBehavior))
                    .frame(height: 130)
                } else {
                    // Vertical
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            ForEach(cards) { card in
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(card.color)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: selectedBehavior == 1 ? 180 : 80)
                                    .overlay(Text(card.label).font(.system(size: 14, weight: .bold)).foregroundStyle(.white))
                                    .containerRelativeFrame(selectedBehavior == 1 ? .vertical : [])
                            }
                        }
                        .padding(.horizontal, 2)
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(behaviorForIndex(selectedBehavior))
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                behaviorNote
            }
        }
    }

    func behaviorForIndex(_ i: Int) -> some ScrollTargetBehavior {
        switch i {
        case 0: return AnyScrollTargetBehavior(.viewAligned)
        case 1: return AnyScrollTargetBehavior(.paging)
        default: return AnyScrollTargetBehavior(nil)
        }
    }

    var behaviorNote: some View {
        let notes = [
            "viewAligned - snaps to the nearest complete view after each scroll gesture.",
            "paging - snaps in full-screen pages. Each swipe advances exactly one page.",
            "No behavior - free-form scrolling, content decelerates naturally.",
        ]
        return HStack(spacing: 6) {
            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.scrollOrange)
            Text(notes[selectedBehavior]).font(.system(size: 11)).foregroundStyle(.secondary)
        }
        .padding(8).background(Color.scrollOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// Helper to erase ScrollTargetBehavior type
struct AnyScrollTargetBehavior: ScrollTargetBehavior {
    private let _updateTarget: (inout ScrollTarget, ScrollTargetBehaviorContext) -> Void

    init(_ behavior: (some ScrollTargetBehavior)?) {
        if let b = behavior {
            _updateTarget = { target, ctx in b.updateTarget(&target, context: ctx) }
        } else {
            _updateTarget = { _, _ in }
        }
    }

    func updateTarget(_ target: inout ScrollTarget, context: ScrollTargetBehaviorContext) {
        _updateTarget(&target, context)
    }
}

extension AnyScrollTargetBehavior {
    init(_ behavior: ViewAlignedScrollTargetBehavior) {
        _updateTarget = { target, ctx in behavior.updateTarget(&target, context: ctx) }
    }
    init(_ behavior: PagingScrollTargetBehavior) {
        _updateTarget = { target, ctx in behavior.updateTarget(&target, context: ctx) }
    }
    init(_ opt: Void?) {
        _updateTarget = { _, _ in }
    }
}

struct ScrollTargetExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "scrollTargetBehavior - iOS 17+")
            Text(".scrollTargetBehavior controls where the scroll view rests after the user releases. viewAligned snaps to view boundaries, paging snaps in screen-sized pages, or you can leave it free-scrolling.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".scrollTargetBehavior(.viewAligned) - snaps to the nearest view boundary. Requires .scrollTargetLayout() on the container.", color: .scrollOrange)
                StepRow(number: 2, text: ".scrollTargetBehavior(.paging) - snaps in screen-page increments. No need for .scrollTargetLayout().", color: .scrollOrange)
                StepRow(number: 3, text: ".scrollTargetLayout() - marks a stack as the source of scroll targets for .viewAligned.", color: .scrollOrange)
                StepRow(number: 4, text: ".containerRelativeFrame(.horizontal) - makes a cell fill the scroll container width for full-page paging.", color: .scrollOrange)
            }

            CalloutBox(style: .success, title: "viewAligned is the modern carousel", contentBody: ".scrollTargetBehavior(.viewAligned) with .scrollTargetLayout() is the correct iOS 17+ way to build a snapping carousel. Much cleaner than the old TabView(.page) hack.")

            CodeBlock(code: """
// Snapping carousel - iOS 17+
ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: 12) {
        ForEach(cards) { card in
            CardView(card: card)
                .frame(width: 280, height: 180)
        }
    }
    .padding(.horizontal, 16)
    .scrollTargetLayout()          // mark snap targets
}
.scrollTargetBehavior(.viewAligned)  // snap to views

// Full-page paging
ScrollView(.horizontal) {
    HStack(spacing: 0) {
        ForEach(pages) { page in
            PageView(page: page)
                .containerRelativeFrame(.horizontal) // fill width
        }
    }
    .scrollTargetLayout()
}
.scrollTargetBehavior(.paging)

// Custom snap behavior
struct SnapEveryThird: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget,
                       context: TargetedScrollView.Context) {
        // custom snap logic
    }
}
""")
        }
    }
}
