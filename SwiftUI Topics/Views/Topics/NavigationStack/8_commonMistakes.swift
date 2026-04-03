//
//
//  8_CommonMistakes.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `03/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Common Mistakes
struct NavMistakesVisual: View {
    @State private var selectedMistake = 0

    struct Mistake {
        let title: String
        let problem: String
        let fix: String
        let severity: String
    }

    let mistakes: [Mistake] = [
        Mistake(title: "Using NavigationView",
                problem: "NavigationView is deprecated in iOS 16. It has bugs with modifiers, programmatic navigation, and misses all modern APIs.",
                fix: "Replace with NavigationStack for single-column. NavigationSplitView for sidebar layouts.",
                severity: "critical"),
        Mistake(title: "Eager destination in List",
                problem: "NavigationLink(destination: DetailView(item: item)) creates DetailView for every row - including ones never visited. Slow for large lists.",
                fix: "Use NavigationLink(value: item) + .navigationDestination(for:). Destination is created lazily on navigation.",
                severity: "performance"),
        Mistake(title: "Modifiers on NavigationStack",
                problem: ".navigationTitle, .toolbar, .sheet applied to the NavigationStack wrapper have no effect. Easy mistake to make.",
                fix: "These modifiers must be on the content view inside NavigationStack, not on NavigationStack itself.",
                severity: "bug"),
        Mistake(title: "Nested NavigationStacks",
                problem: "Putting a NavigationStack inside another NavigationStack causes conflicting navigation behaviour and visual glitches.",
                fix: "Only one NavigationStack per navigation hierarchy. Sheets can have their own independent NavigationStack.",
                severity: "bug"),
        Mistake(title: "Path buried too deep",
                problem: "NavigationPath declared inside a child view means URL handlers and notification delegates can't reach it to drive navigation.",
                fix: "Keep NavigationPath at the App or scene level - somewhere that all external navigation triggers can access it.",
                severity: "architecture"),
    ]

    let severityColors: [String: Color] = [
        "critical": Color(hex: "#E24B4A"),
        "performance": Color.animAmber,
        "bug": Color.animCoral,
        "architecture": Color.navBlue,
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {
                Label("Common mistakes", systemImage: "exclamationmark.triangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sbOrange)

                VStack(spacing: 6) {
                    ForEach(mistakes.indices, id: \.self) { i in
                        let isSelected = selectedMistake == i
                        let color = severityColors[mistakes[i].severity] ?? .secondary

                        VStack(alignment: .leading, spacing: 0) {
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedMistake = i }
                            } label: {
                                HStack(spacing: 10) {
                                    Text(mistakes[i].severity.uppercased())
                                        .font(.system(size: 8, weight: .bold))
                                        .foregroundStyle(color)
                                        .padding(.horizontal, 5).padding(.vertical, 2)
                                        .background(color.opacity(0.12))
                                        .clipShape(Capsule())
                                    Text(mistakes[i].title)
                                        .font(.system(size: 12, weight: isSelected ? .semibold : .regular))
                                        .foregroundStyle(isSelected ? color : .primary)
                                    Spacer()
                                    Image(systemName: isSelected ? "chevron.up" : "chevron.down")
                                        .font(.system(size: 9)).foregroundStyle(.secondary)
                                }
                                .padding(.horizontal, 12).padding(.vertical, 9)
                            }
                            .buttonStyle(PressableButtonStyle())

                            if isSelected {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(alignment: .top, spacing: 6) {
                                        Image(systemName: "xmark.circle.fill").font(.system(size: 11)).foregroundStyle(Color(hex: "#E24B4A"))
                                        Text(mistakes[i].problem).font(.system(size: 11)).foregroundStyle(.secondary).lineSpacing(2)
                                    }
                                    HStack(alignment: .top, spacing: 6) {
                                        Image(systemName: "checkmark.circle.fill").font(.system(size: 11)).foregroundStyle(Color(hex: "#1D9E75"))
                                        Text(mistakes[i].fix).font(.system(size: 11)).foregroundStyle(.secondary).lineSpacing(2)
                                    }
                                }
                                .padding(.horizontal, 12).padding(.bottom, 10)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .background(isSelected ? color.opacity(0.06) : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
}

struct NavMistakesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Navigation pitfalls to avoid")
            Text("Most NavigationStack bugs fall into one of five categories. Knowing them upfront saves hours of debugging.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "NavigationView is deprecated - replace with NavigationStack immediately. It fixes many latent bugs.", color: .sbOrange)
                StepRow(number: 2, text: "Eager destination creation - always use value-based NavigationLink + navigationDestination for any list with more than a few items.", color: .sbOrange)
                StepRow(number: 3, text: "Modifiers on wrong view - navigationTitle, toolbar, sheet, alert all go INSIDE NavigationStack on the content, never on NavigationStack itself.", color: .sbOrange)
                StepRow(number: 4, text: "Nested NavigationStacks - only one NavigationStack per navigation hierarchy. Sheets can have their own, but don't put a stack inside a stack.", color: .sbOrange)
                StepRow(number: 5, text: "Path in wrong scope - NavigationPath for deep linking must live high enough in the tree that notification and URL handlers can reach it.", color: .sbOrange)
            }
 
            CalloutBox(style: .danger, title: "The deprecated NavigationLink(destination:) in a List", contentBody: "In a List of 1,000 items, NavigationLink(destination: DetailView(item: item)) constructs 1,000 DetailView instances before any navigation happens. This is a major performance issue. Always use value-based links in lists.")
 
            CodeBlock(code: """
// ✗ Deprecated - don't use NavigationView
NavigationView { ... }
 
// ✓ Current
NavigationStack { ... }
 
// ✗ Eager - creates ALL destinations upfront
List(items) { item in
    NavigationLink(destination: DetailView(item: item)) {
        Text(item.name)
    }
}
 
// ✓ Lazy - destination created only on navigation
List(items) { item in
    NavigationLink(value: item) {
        Text(item.name)
    }
}
.navigationDestination(for: Item.self) { item in
    DetailView(item: item)  // created only when navigating
}
 
// ✗ Wrong - modifiers on NavigationStack itself
NavigationStack { ... }
    .navigationTitle("Wrong")  // has no effect
    .sheet(isPresented: $show) { ... }  // causes issues
 
// ✓ Correct - modifiers on content inside
NavigationStack {
    ContentView()
        .navigationTitle("Correct")
        .sheet(isPresented: $show) { ... }
}
""")
        }
    }
}
 
