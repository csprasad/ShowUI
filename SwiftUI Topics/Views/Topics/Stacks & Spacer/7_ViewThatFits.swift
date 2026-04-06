//
//
//  7_ViewThatFits.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `05/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: ViewThatFits
struct ViewThatFitsVisual: View {
    @State private var availableWidth: CGFloat = 320
    @State private var selectedScenario = 0

    let scenarios = ["Button label", "Navigation", "Card layout"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("ViewThatFits", systemImage: "arrow.down.left.and.arrow.up.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.ssPurple)

                // Scenario selector
                HStack(spacing: 8) {
                    ForEach(scenarios.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedScenario = i }
                        } label: {
                            Text(scenarios[i])
                                .font(.system(size: 11, weight: selectedScenario == i ? .semibold : .regular))
                                .foregroundStyle(selectedScenario == i ? Color.ssPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedScenario == i ? Color.ssPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Width slider
                HStack(spacing: 10) {
                    Image(systemName: "arrow.left.and.right").font(.system(size: 11)).foregroundStyle(.secondary)
                    Slider(value: $availableWidth, in: 80...340, step: 4).tint(.ssPurple)
                    Text("\(Int(availableWidth))pt").font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 40)
                }

                // Live demo container
                ZStack(alignment: .leading) {
                    Color(.secondarySystemBackground)
                    // Available space indicator
                    HStack(spacing: 0) {
                        liveDemo
                            .frame(width: max(availableWidth - 24, 40))
                            .clipped()
                        Spacer(minLength: 0)
                    }
                    .padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.ssPurple.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [4]))
                )
                .animation(.spring(response: 0.35), value: availableWidth)
                .animation(.spring(response: 0.35), value: selectedScenario)

                // Which variant is active
                HStack(spacing: 6) {
                    Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.ssPurple)
                    Text(currentVariantLabel).font(.system(size: 12)).foregroundStyle(.secondary)
                }
                .padding(10).background(Color.ssPurpleLight).clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut(duration: 0.2), value: availableWidth)
            }
        }
    }

    @ViewBuilder
    private var liveDemo: some View {
        switch selectedScenario {
        case 0:
            // Button label shrinks
            ViewThatFits {
                // Full label - needs ~200pt
                HStack(spacing: 6) {
                    Image(systemName: "arrow.right.circle.fill").foregroundStyle(Color.ssPurple)
                    Text("Continue to payment").font(.system(size: 14, weight: .semibold)).foregroundStyle(Color.ssPurple)
                }
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(Color.ssPurpleLight).clipShape(RoundedRectangle(cornerRadius: 10))

                // Medium label - needs ~140pt
                HStack(spacing: 6) {
                    Image(systemName: "arrow.right.circle.fill").foregroundStyle(Color.ssPurple)
                    Text("Continue").font(.system(size: 14, weight: .semibold)).foregroundStyle(Color.ssPurple)
                }
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(Color.ssPurpleLight).clipShape(RoundedRectangle(cornerRadius: 10))

                // Icon only - needs ~44pt
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 24)).foregroundStyle(Color.ssPurple)
                    .frame(width: 44, height: 44)
                    .background(Color.ssPurpleLight).clipShape(RoundedRectangle(cornerRadius: 10))
            }

        case 1:
            // Navigation tabs collapse
            ViewThatFits {
                // Full tabs
                HStack(spacing: 0) {
                    ForEach(["Home", "Search", "Library", "Profile"], id: \.self) { tab in
                        Text(tab).font(.system(size: 13, weight: .medium)).foregroundStyle(Color.ssPurple)
                            .frame(maxWidth: .infinity).padding(.vertical, 6)
                    }
                }
                .background(Color.ssPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))

                // Icons only
                HStack(spacing: 0) {
                    ForEach(zip(["house.fill","magnifyingglass","books.vertical.fill","person.fill"],
                                ["Home","Search","Library","Profile"]).map { $0 }, id: \.1) { icon, label in
                        Image(systemName: icon).font(.system(size: 16)).foregroundStyle(Color.ssPurple)
                            .frame(maxWidth: .infinity).padding(.vertical, 8)
                    }
                }
                .background(Color.ssPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
            }

        default:
            // Card layout changes
            ViewThatFits(in: .horizontal) {
                // Wide - side by side
                HStack(spacing: 10) {
                    Circle().fill(Color.ssPurple).frame(width: 40, height: 40)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Alice Chen").font(.system(size: 13, weight: .semibold))
                        Text("iOS Engineer").font(.system(size: 11)).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("Follow").font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                        .padding(.horizontal, 12).padding(.vertical, 5)
                        .background(Color.ssPurple).clipShape(Capsule())
                }

                // Narrow - stacked
                VStack(spacing: 6) {
                    Circle().fill(Color.ssPurple).frame(width: 32, height: 32)
                    Text("Alice Chen").font(.system(size: 11, weight: .semibold))
                    Text("Follow").font(.system(size: 10, weight: .semibold)).foregroundStyle(.white)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.ssPurple).clipShape(Capsule())
                }
            }
        }
    }

    private var currentVariantLabel: String {
        switch selectedScenario {
        case 0:
            if availableWidth > 230 { return "Showing full label - width fits" }
            else if availableWidth > 140 { return "Showing short label - full didn't fit" }
            else { return "Showing icon only - short label didn't fit" }
        case 1:
            return availableWidth > 220 ? "Showing text tabs - width fits" : "Showing icon tabs - text didn't fit"
        default:
            return availableWidth > 200 ? "Showing horizontal layout - width fits" : "Showing stacked layout - horizontal didn't fit"
        }
    }
}

struct ViewThatFitsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "ViewThatFits - iOS 16+")
            Text("ViewThatFits tries each child view in order and displays the first one that fits in the available space. It's the declarative solution for adaptive layouts - define multiple variants, let SwiftUI pick the right one.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "List views from most detailed to least. ViewThatFits picks the first that fits without clipping.", color: .ssPurple)
                StepRow(number: 2, text: "ViewThatFits(in: .horizontal) only checks width. ViewThatFits(in: .vertical) only checks height.", color: .ssPurple)
                StepRow(number: 3, text: "If no variant fits, the last view is shown - make your last variant the smallest possible fallback.", color: .ssPurple)
                StepRow(number: 4, text: "Works beautifully with Dynamic Type - the text-heavy version shows at default sizes, the compact version at large accessibility sizes.", color: .ssPurple)
            }

            CalloutBox(style: .success, title: "Great for Dynamic Type", contentBody: "Use ViewThatFits to show a full label at default text sizes and an icon-only variant at the largest accessibility sizes. The adaptation is automatic and requires no conditional logic.")

            CalloutBox(style: .info, title: "All variants are measured, only one is shown", contentBody: "SwiftUI measures all variants but only renders the chosen one. There's no performance cost for defining many alternatives.")

            CodeBlock(code: """
// Adaptive button label
ViewThatFits {
    // Most detailed - shown if it fits
    HStack {
        Image(systemName: "cart.fill")
        Text("Add to Cart - \\(price)")
    }

    // Medium
    HStack {
        Image(systemName: "cart.fill")
        Text("Add to Cart")
    }

    // Last resort - always fits
    Image(systemName: "cart.badge.plus")
}

// Check only one axis
ViewThatFits(in: .horizontal) {
    HStack { ... }   // side by side
    VStack { ... }   // stacked if too narrow
}
""")
        }
    }
}
