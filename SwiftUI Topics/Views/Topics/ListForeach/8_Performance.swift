//
//
//  8_Performance.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Performance
struct ListPerformanceVisual: View {
    @State private var selectedComparison = 0
    @State private var itemCount = 50
    @State private var useList = true

    let comparisons = ["List vs VStack", "When to use each", "Lazy loading"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Performance", systemImage: "speedometer")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.lfBlue)

                HStack(spacing: 8) {
                    ForEach(comparisons.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedComparison = i }
                        } label: {
                            Text(comparisons[i])
                                .font(.system(size: 11, weight: selectedComparison == i ? .semibold : .regular))
                                .foregroundStyle(selectedComparison == i ? Color.lfBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedComparison == i ? Color.lfBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedComparison {
                case 0: listVsVStackDiagram
                case 1: whenToUseDiagram
                default: lazyLoadingDiagram
                }
            }
        }
    }

    // MARK: - List vs VStack diagram
    private var listVsVStackDiagram: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                // List column
                VStack(spacing: 6) {
                    Text("List")
                        .font(.system(size: 12, weight: .semibold)).foregroundStyle(Color(hex: "#1D9E75"))
                        .padding(.horizontal, 10).padding(.vertical, 3)
                        .background(Color(hex: "#E1F5EE")).clipShape(Capsule())

                    renderingDiagram(isLazy: true)

                    VStack(alignment: .leading, spacing: 3) {
                        featureRow("✓ Lazy rendering", good: true)
                        featureRow("✓ System row style", good: true)
                        featureRow("✓ Swipe actions", good: true)
                        featureRow("✓ Edit / reorder", good: true)
                        featureRow("✗ Limited layout", good: false)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // VStack column
                VStack(spacing: 6) {
                    Text("VStack + ForEach")
                        .font(.system(size: 12, weight: .semibold)).foregroundStyle(Color.animAmber)
                        .padding(.horizontal, 10).padding(.vertical, 3)
                        .background(Color(hex: "#FAEEDA")).clipShape(Capsule())

                    renderingDiagram(isLazy: false)

                    VStack(alignment: .leading, spacing: 3) {
                        featureRow("✗ Eager — all rows", good: false)
                        featureRow("✓ Full layout control", good: true)
                        featureRow("✗ No swipe actions", good: false)
                        featureRow("✗ No edit mode", good: false)
                        featureRow("✓ Custom design", good: true)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    // MARK: - When to use diagram
    private var whenToUseDiagram: some View {
        VStack(spacing: 6) {
            decisionRow(
                question: "Dynamic data that can grow?",
                answer: "List",
                answerColor: Color(hex: "#1D9E75"),
                detail: "Lazy rendering handles hundreds of rows"
            )
            decisionRow(
                question: "Swipe actions or edit mode?",
                answer: "List",
                answerColor: Color(hex: "#1D9E75"),
                detail: "Only List supports these natively"
            )
            decisionRow(
                question: "Fixed short content (<20 items)?",
                answer: "VStack",
                answerColor: .animAmber,
                detail: "Simpler, full layout control"
            )
            decisionRow(
                question: "Custom card-style layout?",
                answer: "ScrollView + LazyVStack",
                answerColor: .lfBlue,
                detail: "Lazy + full layout freedom"
            )
            decisionRow(
                question: "Settings / form UI?",
                answer: "Form or List",
                answerColor: Color(hex: "#1D9E75"),
                detail: "Use Form for standard settings look"
            )
        }
    }

    // MARK: - Lazy loading diagram
    private var lazyLoadingDiagram: some View {
        VStack(spacing: 8) {
            // Visual showing which rows are rendered
            HStack(alignment: .top, spacing: 12) {
                VStack(spacing: 4) {
                    Text("100 items in array")
                        .font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                    VStack(spacing: 2) {
                        ForEach(0..<8, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 3)
                                .fill(i < 5 ? Color.lfBlue : Color(.systemGray5))
                                .frame(height: 10)
                                .overlay(
                                    Text(i < 5 ? "Rendered" : i == 5 ? "..." : "Not yet")
                                        .font(.system(size: 6))
                                        .foregroundStyle(i < 5 ? .white : .secondary)
                                )
                        }
                    }
                    Text("Only visible rows")
                        .font(.system(size: 9)).foregroundStyle(Color(hex: "#1D9E75"))
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("How lazy rendering works:")
                        .font(.system(size: 11, weight: .semibold)).foregroundStyle(.primary)
                    Text("• List and LazyVStack render rows on demand")
                        .font(.system(size: 10)).foregroundStyle(.secondary)
                    Text("• Rows are created as they scroll into view")
                        .font(.system(size: 10)).foregroundStyle(.secondary)
                    Text("• Off-screen rows may be deallocated")
                        .font(.system(size: 10)).foregroundStyle(.secondary)
                    Text("• VStack renders ALL rows immediately")
                        .font(.system(size: 10)).foregroundStyle(Color(hex: "#E24B4A"))
                    Text("• LazyVStack = VStack layout + lazy rendering")
                        .font(.system(size: 10)).foregroundStyle(Color.lfBlue)
                }
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    func renderingDiagram(isLazy: Bool) -> some View {
        VStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { i in
                RoundedRectangle(cornerRadius: 3)
                    .fill(isLazy ? (i < 3 ? Color(hex: "#1D9E75") : Color(.systemGray5))
                                : Color.animAmber.opacity(0.7))
                    .frame(height: 8)
            }
        }
    }

    func featureRow(_ text: String, good: Bool) -> some View {
        Text(text)
            .font(.system(size: 10))
            .foregroundStyle(good ? Color(hex: "#1D9E75") : Color(hex: "#E24B4A"))
    }

    func decisionRow(question: String, answer: String, answerColor: Color, detail: String) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(question).font(.system(size: 11, weight: .semibold)).foregroundStyle(.primary)
                Text(detail).font(.system(size: 10)).foregroundStyle(.secondary)
            }
            Spacer()
            Text(answer)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(answerColor)
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(answerColor.opacity(0.1))
                .clipShape(Capsule())
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ListPerformanceExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "List vs VStack — performance")
            Text("The choice between List, VStack + ForEach, and LazyVStack comes down to what you need: system styling and editing features, full layout control, or lazy rendering with custom layout.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "List — lazy, system styling, swipe actions, edit mode. Best for data-driven rows of variable or large count.", color: .lfBlue)
                StepRow(number: 2, text: "VStack + ForEach — eager, full layout control, no system styling. Best for short fixed lists or custom card layouts.", color: .lfBlue)
                StepRow(number: 3, text: "LazyVStack + ForEach in ScrollView — lazy, full layout control, no system styling. Best for custom layouts with many items.", color: .lfBlue)
                StepRow(number: 4, text: "LazyHStack — same as LazyVStack but horizontal. Use for horizontal carousels of many items.", color: .lfBlue)
            }

            CalloutBox(style: .warning, title: "VStack with many rows is a common mistake", contentBody: "Putting 200 rows in a VStack renders all 200 immediately, even the ones far below the fold. This causes slow initial load and high memory. Use List or LazyVStack for anything that could grow beyond 20 rows.")

            CalloutBox(style: .info, title: "When LazyVStack beats List", contentBody: "LazyVStack inside ScrollView when you need: custom spacing between items, no separator lines, horizontal padding that List won't give, or views mixed with non-row content above and below.")

            CodeBlock(code: """
// List — system styling, lazy, editing support
List(items) { item in
    ItemRow(item: item)
}
.listStyle(.insetGrouped)

// LazyVStack — lazy + custom layout
ScrollView {
    LazyVStack(spacing: 12) {
        ForEach(items) { item in
            CustomCard(item: item)   // full layout control
        }
    }
    .padding(.horizontal, 16)
}

// VStack — only for short, fixed lists
VStack(spacing: 8) {
    ForEach(tabs) { tab in  // e.g. 5 navigation tabs
        TabRow(tab: tab)
    }
}

// LazyHStack — horizontal carousel
ScrollView(.horizontal) {
    LazyHStack(spacing: 12) {
        ForEach(featuredItems) { item in
            FeaturedCard(item: item)
        }
    }
    .padding(.horizontal, 16)
}
""")
        }
    }
}

