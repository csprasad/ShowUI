//
//
//  6_matchedGeometryEffect.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: matchedGeometryEffect
struct MatchedGeoVisual: View {
    @Namespace private var ns1
    @Namespace private var ns2
    @Namespace private var ns3

    @State private var expanded1    = false
    @State private var selectedCard = 0
    @State private var selectedDemo = 0

    let demos  = ["Expand / collapse", "Tab swap", "Grid → detail"]
    let colors: [Color] = [.geoGreen, Color(hex: "#0891B2"), Color(hex: "#7C3AED"), Color(hex: "#C2410C")]
    let items  = ["Swift", "SwiftUI", "Combine", "CoreData"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("matchedGeometryEffect", systemImage: "arrow.up.left.and.down.right.magnifyingglass")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.geoGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 10, weight: selectedDemo == i ? .semibold : .regular))
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
                    // Expand / collapse hero
                    VStack(spacing: 10) {
                        if expanded1 {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(LinearGradient(colors: [Color.geoGreen, Color(hex: "#4ADE80")],
                                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .matchedGeometryEffect(id: "hero", in: ns1)
                                    .frame(maxWidth: .infinity).frame(height: 160)
                                VStack(spacing: 8) {
                                    Text("Expanded").font(.system(size: 20, weight: .bold)).foregroundStyle(.white)
                                    Text("Tap to collapse").font(.system(size: 12)).foregroundStyle(.white.opacity(0.8))
                                }
                            }
                            .onTapGesture { withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) { expanded1 = false } }
                            .transition(.identity)
                        } else {
                            HStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.geoGreen)
                                    .frame(width: 60, height: 60)
                                    .matchedGeometryEffect(id: "hero", in: ns1)
                                    .onTapGesture { withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) { expanded1 = true } }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Tap card to expand").font(.system(size: 14, weight: .semibold))
                                    Text("matchedGeometryEffect animates the frame").font(.system(size: 11)).foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .transition(.identity)
                        }
                    }
                    .frame(height: 170, alignment: .top)

                case 1:
                    // Tab label sliding selector
                    VStack(spacing: 12) {
                        ZStack(alignment: .leading) {
                            // Sliding background pill
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.geoGreen)
                                .matchedGeometryEffect(id: "pill", in: ns2)
                                .frame(width: 80, height: 32)
                                .offset(x: CGFloat(selectedCard) * 86)
                                .animation(.spring(response: 0.3, dampingFraction: 0.75), value: selectedCard)

                            // Tab labels
                            HStack(spacing: 6) {
                                ForEach(items.indices, id: \.self) { i in
                                    Text(items[i])
                                        .font(.system(size: 12, weight: selectedCard == i ? .semibold : .regular))
                                        .foregroundStyle(selectedCard == i ? .white : .secondary)
                                        .frame(width: 80, height: 32)
                                        .onTapGesture { withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) { selectedCard = i } }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Selected: \(items[selectedCard])")
                            .font(.system(size: 12)).foregroundStyle(.secondary)
                    }

                default:
                    // Grid to detail
                    VStack(spacing: 10) {
                        if selectedCard >= 0 && selectedCard < 4 && expanded1 {
                            ZStack {
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(colors[selectedCard])
                                    .matchedGeometryEffect(id: "card_\(selectedCard)", in: ns3)
                                    .frame(maxWidth: .infinity).frame(height: 120)
                                VStack(spacing: 6) {
                                    Text(items[selectedCard]).font(.system(size: 22, weight: .bold)).foregroundStyle(.white)
                                    Button("Close") { withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) { expanded1 = false } }
                                        .font(.system(size: 12)).foregroundStyle(.white.opacity(0.9))
                                        .buttonStyle(PressableButtonStyle())
                                }
                            }
                            .transition(.identity)
                        } else {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                                ForEach(0..<4, id: \.self) { i in
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(colors[i])
                                        .matchedGeometryEffect(id: "card_\(i)", in: ns3)
                                        .frame(height: 55)
                                        .overlay(Text(items[i]).font(.system(size: 12, weight: .semibold)).foregroundStyle(.white))
                                        .onTapGesture {
                                            selectedCard = i
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) { expanded1 = true }
                                        }
                                }
                            }
                            .transition(.identity)
                        }
                    }
                }
            }
        }
    }
}

struct MatchedGeoExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "matchedGeometryEffect")
            Text(".matchedGeometryEffect animates a view's frame, size and position between two layout states. When the same ID exists in two different places in the view tree, SwiftUI interpolates the transition between them during animation.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@Namespace var ns - declare a namespace to group related matched effects.", color: .geoGreen)
                StepRow(number: 2, text: ".matchedGeometryEffect(id: \"hero\", in: ns) on both the source and destination views.", color: .geoGreen)
                StepRow(number: 3, text: "Wrap the state change in withAnimation - SwiftUI handles the frame interpolation.", color: .geoGreen)
                StepRow(number: 4, text: "Add .transition(.identity) to prevent default insertion/removal transitions conflicting.", color: .geoGreen)
                StepRow(number: 5, text: "isSource: true/false - control which view drives the geometry when both are in the tree.", color: .geoGreen)
            }

            CalloutBox(style: .warning, title: "Only one view active at a time", contentBody: "matchedGeometryEffect works best when exactly one view with a given ID is in the hierarchy at once - use if/else to swap between them. Two simultaneously-visible matching views can cause layout warnings.")

            CodeBlock(code: """
@Namespace private var ns
@State private var isExpanded = false

Group {
    if isExpanded {
        // Full-size destination
        RoundedRectangle(cornerRadius: 20)
            .fill(.blue)
            .matchedGeometryEffect(id: "card", in: ns)
            .frame(maxWidth: .infinity, maxHeight: 200)
            .transition(.identity)
    } else {
        // Thumbnail source
        RoundedRectangle(cornerRadius: 12)
            .fill(.blue)
            .matchedGeometryEffect(id: "card", in: ns)
            .frame(width: 60, height: 60)
            .transition(.identity)
    }
}
.onTapGesture {
    withAnimation(.spring(response: 0.5)) {
        isExpanded.toggle()
    }
}
""")
        }
    }
}

