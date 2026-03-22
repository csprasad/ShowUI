//
//
//  9_MatchedGeometry.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: matchedGeometryEffect
struct MatchedGeometryVisual: View {
    @Namespace private var ns
    @State private var selectedCard: Int? = nil
    @State private var selectedDemo = 0

    let colors: [Color] = [
        Color(hex: "#B5D4F4"), Color(hex: "#9FE1CB"),
        Color(hex: "#FAC775"), Color(hex: "#F5C4B3")
    ]
    let icons = ["star.fill", "heart.fill", "bolt.fill", "moon.fill"]
    let labels = ["Favorites", "Liked", "Featured", "Tonight"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("matchedGeometryEffect", systemImage: "rectangle.2.swap")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.animCoral)
                    Spacer()
                }

                if let selected = selectedCard {
                    // Expanded card
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(colors[selected])
                            .matchedGeometryEffect(id: "card-\(selected)", in: ns)
                            .frame(maxWidth: .infinity)
                            .frame(height: 160)
                            .overlay(
                                VStack(spacing: 8) {
                                    Image(systemName: icons[selected])
                                        .font(.system(size: 36))
                                        .foregroundStyle(.white)
                                    Text(labels[selected])
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(.white)
                                    Text("Tap to collapse")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                            )
                            .onTapGesture {
                                withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
                                    selectedCard = nil
                                }
                            }
                    }
                    .transition(.identity)
                } else {
                    // Grid of cards
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(0..<4) { i in
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(colors[i])
                                .matchedGeometryEffect(id: "card-\(i)", in: ns)
                                .frame(height: 70)
                                .overlay(
                                    HStack(spacing: 6) {
                                        Image(systemName: icons[i])
                                            .font(.system(size: 14))
                                            .foregroundStyle(.white)
                                        Text(labels[i])
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundStyle(.white)
                                    }
                                )
                                .onTapGesture {
                                    withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
                                        selectedCard = i
                                    }
                                }
                        }
                    }
                }

                Text(selectedCard == nil ? "Tap any card to expand it" : "Tap the card to collapse")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

struct MatchedGeometryExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "matchedGeometryEffect")
            Text("matchedGeometryEffect tells SwiftUI that two views in different locations share the same visual identity. During a state change, SwiftUI smoothly morphs one into the other, animating position, size, and shape in one fluid motion.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Create a @Namespace — a shared coordinate space for the effect.", color: .animCoral)
                StepRow(number: 2, text: "Apply .matchedGeometryEffect(id:in:) to both views with the same id and namespace.", color: .animCoral)
                StepRow(number: 3, text: "Use an if/else to show one view OR the other based on state.", color: .animCoral)
                StepRow(number: 4, text: "Wrap the state change in withAnimation — SwiftUI handles the morph.", color: .animCoral)
            }

            CalloutBox(style: .warning, title: "Only one view active at a time", contentBody: "Both views with the same matchedGeometryEffect id must not be visible simultaneously. Use if/else or isSource: false to control which is the source of truth.")

            CalloutBox(style: .info, title: "Common uses", contentBody: "Grid-to-detail expansion, tab bar icon to full page, list item to card, search bar to full screen search.")

            CodeBlock(code: """
@Namespace private var ns

// Source view (grid item)
if !isExpanded {
    RoundedRectangle(cornerRadius: 12)
        .matchedGeometryEffect(id: "card", in: ns)
        .frame(width: 80, height: 80)
        .onTapGesture {
            withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
                isExpanded = true
            }
        }
}

// Destination view (expanded detail)
if isExpanded {
    RoundedRectangle(cornerRadius: 24)
        .matchedGeometryEffect(id: "card", in: ns)
        .frame(maxWidth: .infinity, minHeight: 300)
        .onTapGesture {
            withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
                isExpanded = false
            }
        }
}
""")
        }
    }
}
