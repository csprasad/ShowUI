//
//
//  5_ScrollOffset.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Scroll Offset
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ScrollOffsetVisual: View {
    @State private var offset: CGFloat   = 0
    @State private var selectedDemo      = 0
    let demos  = ["Read offset", "Sticky header", "Progress bar"]
    let cards  = ScrollCard.samples(10)

    // Collapsed state based on offset
    var isCompact: Bool { offset < -60 }
    var progressFraction: CGFloat { min(1, max(0, -offset / 300)) }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Scroll offset", systemImage: "gauge.with.dots.needle.67percent")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.scrollOrange)

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
                    // Raw offset readout
                    VStack(spacing: 8) {
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Current offset").font(.system(size: 11)).foregroundStyle(.secondary)
                                Text("\(Int(offset))pt")
                                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                                    .foregroundStyle(offset < 0 ? Color.scrollOrange : .secondary)
                                    .contentTransition(.numericText(countsDown: offset < 0))
                                    .animation(.spring(duration: 0.2), value: Int(offset))
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("Direction").font(.system(size: 11)).foregroundStyle(.secondary)
                                Text(offset < -5 ? "↑ Up" : offset > 5 ? "↓ Down" : "Still")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(offset < 0 ? Color.scrollOrange : .secondary)
                            }
                        }
                        .padding(10).background(Color(.systemBackground)).clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                        scrollListWithOffset(height: 160)
                    }

                case 1:
                    // Sticky collapsing header
                    VStack(spacing: 0) {
                        // Animated header
                        VStack(spacing: isCompact ? 0 : 6) {
                            Text("Scrollable Content")
                                .font(.system(size: isCompact ? 14 : 18, weight: .bold))
                                .animation(.spring(response: 0.3), value: isCompact)
                            if !isCompact {
                                Text("Scroll up to collapse")
                                    .font(.system(size: 11)).foregroundStyle(.secondary)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: isCompact ? 40 : 64)
                        .padding(.horizontal, 12)
                        .background(Color.scrollOrangeLight)
                        .animation(.spring(response: 0.35), value: isCompact)

                        scrollListWithOffset(height: 170)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                default:
                    // Progress bar
                    VStack(spacing: 8) {
                        HStack(spacing: 10) {
                            Text("Read progress:").font(.system(size: 12)).foregroundStyle(.secondary)
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(Color(.systemFill)).frame(height: 8)
                                    Capsule().fill(Color.scrollOrange)
                                        .frame(width: max(0, geo.size.width * progressFraction), height: 8)
                                        .animation(.easeOut(duration: 0.1), value: progressFraction)
                                }
                            }
                            .frame(height: 8)
                            Text("\(Int(progressFraction * 100))%")
                                .font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.scrollOrange)
                                .frame(width: 36)
                        }
                        scrollListWithOffset(height: 190)
                    }
                }
            }
        }
    }

    func scrollListWithOffset(height: CGFloat) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 8) {
                // Anchor for offset reading
                GeometryReader { geo in
                    Color.clear.preference(
                        key: ScrollOffsetKey.self,
                        value: geo.frame(in: .named("scrollArea")).minY
                    )
                }
                .frame(height: 0)

                ForEach(cards) { card in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(card.color.opacity(0.85))
                        .frame(maxWidth: .infinity).frame(height: 52)
                        .overlay(Text(card.label).font(.system(size: 13, weight: .semibold)).foregroundStyle(.white))
                }
            }
            .padding(.horizontal, 2)
        }
        .coordinateSpace(name: "scrollArea")
        .onPreferenceChange(ScrollOffsetKey.self) { offset = $0 }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ScrollOffsetExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Reading scroll offset")
            Text("SwiftUI doesn't expose scroll offset directly. The standard technique uses a GeometryReader inside the scroll content with a PreferenceKey to read the content's position relative to a named coordinate space on the ScrollView.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Name the coordinate space: .coordinateSpace(name: \"scroll\") on the ScrollView.", color: .scrollOrange)
                StepRow(number: 2, text: "Place GeometryReader { geo in Color.clear.preference(key: OffsetKey.self, value: geo.frame(in: .named(\"scroll\")).minY) } at the top of the scroll content.", color: .scrollOrange)
                StepRow(number: 3, text: ".onPreferenceChange(OffsetKey.self) { offset = $0 } reads the offset every frame.", color: .scrollOrange)
                StepRow(number: 4, text: "Offset is 0 at top, negative as you scroll down (content moves up).", color: .scrollOrange)
                StepRow(number: 5, text: "iOS 17+: .onScrollGeometryChange gives direct access to scroll geometry without PreferenceKey.", color: .scrollOrange)
            }

            CalloutBox(style: .info, title: "iOS 17: onScrollGeometryChange", contentBody: ".onScrollGeometryChange(for: CGRect.self) { geo in geo.visibleRect } action: { old, new in } is the modern direct approach. No PreferenceKey or GeometryReader needed. Use it when targeting iOS 17+.")

            CodeBlock(code: """
// PreferenceKey approach (iOS 14+)
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat,
                        nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

@State private var scrollOffset: CGFloat = 0

ScrollView {
    VStack {
        GeometryReader { geo in
            Color.clear.preference(
                key: OffsetKey.self,
                value: geo.frame(in: .named("scroll")).minY
            )
        }
        .frame(height: 0)

        // content...
    }
}
.coordinateSpace(name: "scroll")
.onPreferenceChange(OffsetKey.self) { offset in
    scrollOffset = offset
}

// iOS 17+ direct approach
ScrollView {
    content
}
.onScrollGeometryChange(for: CGFloat.self) { geo in
    geo.contentOffset.y
} action: { _, newOffset in
    scrollOffset = newOffset
}
""")
        }
    }
}
