//
//
//  6_MatchedGeometry.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Matched Geometry Effect
struct MatchedGeoAnim: View {
    @Namespace private var ns1
    @Namespace private var ns2
    @Namespace private var ns3

    @State private var expanded1    = false
    @State private var selectedChip: String? = nil
    @State private var selectedCard = 0
    @State private var gridExpanded = false
    @State private var selectedDemo = 0

    let demos  = ["Expand card", "Chip to bar", "Grid hero"]
    let colors: [Color] = [.anAmber, Color(hex: "#7C3AED"), Color(hex: "#0F766E"), Color(hex: "#C2410C")]
    let chips  = ["Swift", "SwiftUI", "Combine", "CoreData", "Async"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("matchedGeometryEffect", systemImage: "arrow.up.left.and.down.right.magnifyingglass")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.anAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; expanded1 = false; selectedChip = nil; gridExpanded = false }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 12, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.anAmber : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.anAmberLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                ZStack {
                    Color(.secondarySystemBackground)

                    switch selectedDemo {
                    case 0:
                        // Card expand
                        if expanded1 {
                            ZStack(alignment: .topTrailing) {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(LinearGradient(colors: [Color.anAmber, Color(hex: "#F59E0B")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .matchedGeometryEffect(id: "card", in: ns1)
                                    .frame(maxWidth: .infinity).frame(height: 130)
                                    .overlay(
                                        VStack(spacing: 4) {
                                            Text("Expanded").font(.system(size: 18, weight: .bold)).foregroundStyle(.white)
                                            Text("Tap to collapse").font(.system(size: 11)).foregroundStyle(.white.opacity(0.8))
                                        }
                                    )
                                Button {
                                    withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) { expanded1 = false }
                                } label: {
                                    Image(systemName: "xmark.circle.fill").font(.system(size: 20)).foregroundStyle(.white.opacity(0.8))
                                }.buttonStyle(PressableButtonStyle()).padding(10)
                            }
                            .transition(.identity)
                        } else {
                            HStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color.anAmber)
                                    .frame(width: 56, height: 56)
                                    .matchedGeometryEffect(id: "card", in: ns1)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) { expanded1 = true }
                                    }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Tap card to expand").font(.system(size: 13, weight: .semibold))
                                    Text("matchedGeometryEffect animates the frame").font(.system(size: 11)).foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .transition(.identity)
                        }

                    case 1:
                        // Chips to active bar
                        VStack(spacing: 14) {
                            // Active chip in top bar
                            HStack {
                                if let chip = selectedChip {
                                    Text(chip)
                                        .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                                        .padding(.horizontal, 14).padding(.vertical, 6)
                                        .background(Color.anAmber.matchedGeometryEffect(id: chip, in: ns2))
                                        .clipShape(Capsule())
                                        .transition(.identity)
                                } else {
                                    Text("Select a tag below")
                                        .font(.system(size: 11)).foregroundStyle(.secondary)
                                }
                                Spacer()
                                if selectedChip != nil {
                                    Button { withAnimation(.spring(response: 0.4)) { selectedChip = nil } } label: {
                                        Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                                    }.buttonStyle(PressableButtonStyle())
                                }
                            }
                            .frame(height: 36)
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(Color(.systemBackground)).clipShape(RoundedRectangle(cornerRadius: 10))

                            // Chip list
                            FlowLayout(spacing: 8) {
                                ForEach(chips, id: \.self) { chip in
                                    if selectedChip != chip {
                                        Button {
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) { selectedChip = chip }
                                        } label: {
                                            Text(chip)
                                                .font(.system(size: 12, weight: .medium)).foregroundStyle(Color.anAmber)
                                                .padding(.horizontal, 12).padding(.vertical, 6)
                                                .background(Color.anAmberLight.matchedGeometryEffect(id: chip, in: ns2))
                                                .clipShape(Capsule())
                                                .overlay(Capsule().strokeBorder(Color.anAmber.opacity(0.3), lineWidth: 1))
                                        }
                                        .buttonStyle(PressableButtonStyle())
                                        .transition(.identity)
                                    }
                                }
                            }
                        }
                        .padding(12)

                    default:
                        // Grid to detail
                        VStack {
                            if gridExpanded {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(colors[selectedCard])
                                        .matchedGeometryEffect(id: "card_\(selectedCard)", in: ns3)
                                        .frame(maxWidth: .infinity).frame(height: 120)
                                    VStack(spacing: 6) {
                                        Text("Detail view").font(.system(size: 16, weight: .bold)).foregroundStyle(.white)
                                        Button { withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) { gridExpanded = false } } label: {
                                            Text("Close").font(.system(size: 12)).foregroundStyle(.white.opacity(0.9))
                                        }.buttonStyle(PressableButtonStyle())
                                    }
                                }
                                .transition(.identity)
                            } else {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                                    ForEach(0..<4, id: \.self) { i in
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(colors[i])
                                            .matchedGeometryEffect(id: "card_\(i)", in: ns3)
                                            .frame(height: 52)
                                            .overlay(Text("Card \(i+1)").font(.system(size: 11, weight: .semibold)).foregroundStyle(.white))
                                            .onTapGesture {
                                                selectedCard = i
                                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) { gridExpanded = true }
                                            }
                                    }
                                }
                                .transition(.identity)
                                .padding(12)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }
}

struct MatchedGeoAnimExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "matchedGeometryEffect")
            Text(".matchedGeometryEffect tells SwiftUI that two views with the same ID represent the same logical element. When the layout changes, SwiftUI smoothly interpolates the frame, size, and position between their two positions.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@Namespace private var ns - creates an animation namespace to group related effects.", color: .anAmber)
                StepRow(number: 2, text: ".matchedGeometryEffect(id: \"hero\", in: ns) on both source and destination views.", color: .anAmber)
                StepRow(number: 3, text: "Wrap state change in withAnimation - SwiftUI interpolates between the two positions.", color: .anAmber)
                StepRow(number: 4, text: ".transition(.identity) on both views - prevents default insertion/removal transitions.", color: .anAmber)
                StepRow(number: 5, text: "isSource: true/false - when both views exist simultaneously, isSource: false makes one defer to the other.", color: .anAmber)
            }

            CalloutBox(style: .warning, title: "Only one view active at a time", contentBody: "Avoid having both matched views visible simultaneously - it causes layout conflicts. Use if/else to ensure only one is in the hierarchy at once, or use isSource: false on the secondary view.")

            CodeBlock(code: """
@Namespace private var ns
@State private var isExpanded = false

// Source
if !isExpanded {
    Card()
        .matchedGeometryEffect(id: "card", in: ns)
        .onTapGesture {
            withAnimation(.spring()) { isExpanded = true }
        }
        .transition(.identity)
}

// Destination
if isExpanded {
    ExpandedCard()
        .matchedGeometryEffect(id: "card", in: ns)
        .onTapGesture {
            withAnimation(.spring()) { isExpanded = false }
        }
        .transition(.identity)
}
""")
        }
    }
}
