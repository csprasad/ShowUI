//
//
//  4_ScrollPosition.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: ScrollPosition
struct ScrollPositionVisual: View {
    @State private var scrollPositionID: UUID?
    @State private var currentIndex = 0
    @State private var showOffsetLog = false
    let cards = ScrollCard.samples(8)

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("ScrollPosition", systemImage: "arrow.up.to.line.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.scrollOrange)

                // Programmatic controls
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Text("Scroll to:").font(.system(size: 12)).foregroundStyle(.secondary)
                        ForEach(cards.indices, id: \.self) { i in
                            Button("\(i + 1)") {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    scrollPositionID = cards[i].id
                                    currentIndex = i
                                }
                            }
                            .font(.system(size: 12, weight: currentIndex == i ? .semibold : .regular))
                            .foregroundStyle(currentIndex == i ? .white : .secondary)
                            .frame(width: 28, height: 28)
                            .background(currentIndex == i ? Color.scrollOrange : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }

                    HStack(spacing: 8) {
                        Button("↑ Top") {
                            withAnimation(.spring(response: 0.6)) {
                                scrollPositionID = cards.first?.id
                                currentIndex = 0
                            }
                        }
                        .scrollButton()

                        Button("↓ Bottom") {
                            withAnimation(.spring(response: 0.6)) {
                                scrollPositionID = cards.last?.id
                                currentIndex = cards.count - 1
                            }
                        }
                        .scrollButton()

                        Button("← Prev") {
                            withAnimation(.spring(response: 0.5)) {
                                let idx = max(0, currentIndex - 1)
                                scrollPositionID = cards[idx].id
                                currentIndex = idx
                            }
                        }
                        .scrollButton()

                        Button("→ Next") {
                            withAnimation(.spring(response: 0.5)) {
                                let idx = min(cards.count - 1, currentIndex + 1)
                                scrollPositionID = cards[idx].id
                                currentIndex = idx
                            }
                        }
                        .scrollButton()
                    }
                }

                // Scrollable list
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(cards) { card in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(currentIndex == card.index ? card.color : card.color.opacity(0.6))
                                .frame(maxWidth: .infinity).frame(height: 56)
                                .overlay(
                                    HStack {
                                        Text(card.label).font(.system(size: 14, weight: .semibold)).foregroundStyle(.white)
                                        Spacer()
                                        if currentIndex == card.index {
                                            Image(systemName: "arrow.left").font(.system(size: 12)).foregroundStyle(.white.opacity(0.8))
                                        }
                                    }.padding(.horizontal, 16)
                                )
                                .id(card.id)
                        }
                    }
                    .padding(.horizontal, 2)
                }
                .scrollPosition(id: $scrollPositionID)
                .onChange(of: scrollPositionID) { oldVal, newVal in
                    if let newVal, let index = cards.firstIndex(where: { $0.id == newVal }) {
                        currentIndex = index
                    }
                }
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Current position footer
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill").font(.system(size: 12)).foregroundStyle(Color.scrollOrange)
                    Text("Showing card \(currentIndex + 1) of \(cards.count)")
                        .font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                }
                .padding(8).background(Color.scrollOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}
private extension View {
    func scrollButton() -> some View {
        self
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(Color.scrollOrange)
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(Color.scrollOrangeLight)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .buttonStyle(PressableButtonStyle())
    }
}

struct ScrollPositionExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "ScrollPosition - iOS 17+")
            Text("ScrollPosition is a binding-based way to programmatically drive a scroll view. Attach it with .scrollPosition(), then call scrollTo(id:) to scroll to any view by its identity, or scrollTo(edge:) to jump to extremes.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@State var position = ScrollPosition(idType: UUID.self) - declare with your ID type.", color: .scrollOrange)
                StepRow(number: 2, text: ".scrollPosition($position) on the ScrollView - connects the position binding.", color: .scrollOrange)
                StepRow(number: 3, text: "position.scrollTo(id: item.id) - scrolls to the view with that ID. Wrap in withAnimation for smooth scrolling.", color: .scrollOrange)
                StepRow(number: 4, text: "position.scrollTo(edge: .top / .bottom) - jumps to the start or end of the scroll view.", color: .scrollOrange)
                StepRow(number: 5, text: "position.viewID - reads back the ID of the topmost visible item.", color: .scrollOrange)
            }

            CalloutBox(style: .info, title: "The older scrollTo via namespace", contentBody: "Before iOS 17, programmatic scrolling used ScrollViewReader { proxy in proxy.scrollTo(id, anchor:) }. Still works and is the approach for iOS 15/16 support. ScrollPosition is the modern iOS 17 replacement.")

            CodeBlock(code: """
// iOS 17+ approach
@State private var position = ScrollPosition(idType: UUID.self)

ScrollView {
    LazyVStack {
        ForEach(items) { item in
            ItemView(item: item)
        }
    }
}
.scrollPosition($position)

// Scroll to specific item
Button("Go to item") {
    withAnimation(.spring()) {
        position.scrollTo(id: targetItem.id)
    }
}

// Jump to top / bottom
position.scrollTo(edge: .top)
position.scrollTo(edge: .bottom)

// Read current position
if let id = position.viewID(type: UUID.self) {
    Text("Showing: \\(id)")
}

// iOS 16 fallback
ScrollViewReader { proxy in
    ScrollView { content }
    Button("Jump") {
        proxy.scrollTo(itemID, anchor: .top)
    }
}
""")
        }
    }
}
