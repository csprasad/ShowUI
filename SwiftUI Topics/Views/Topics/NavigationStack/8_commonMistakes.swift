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
        let icon: String
    }
 
    let mistakes: [Mistake] = [
        Mistake(
            title: "NavigationView (deprecated)",
            problem: "NavigationView is deprecated in iOS 16. Using it causes visual glitches and misses all new navigation APIs.",
            fix: "Replace with NavigationStack for single-column, NavigationSplitView for sidebar layouts.",
            icon: "xmark.circle.fill"
        ),
        Mistake(
            title: "NavigationLink(destination:) in List",
            problem: "NavigationLink(destination: DetailView(item: item)) creates the destination view eagerly for every row - even before navigation. Expensive for large lists.",
            fix: "Use NavigationLink(value: item) and .navigationDestination(for:) to create destination views lazily.",
            icon: "bolt.slash.fill"
        ),
        Mistake(
            title: "NavigationStack inside a sheet",
            problem: "Wrapping a sheet's full content in NavigationStack and then also having an outer NavigationStack causes navigation conflicts.",
            fix: "A sheet is an independent context. Only add NavigationStack inside a sheet if the sheet needs its own navigation. Don't nest stacks.",
            icon: "rectangle.on.rectangle.slash.fill"
        ),
        Mistake(
            title: ".sheet on NavigationStack",
            problem: "Attaching .sheet or .alert to the NavigationStack view instead of its content causes presentation issues during navigation transitions.",
            fix: "Always attach .sheet, .alert, .confirmationDialog to the content view inside NavigationStack - not to NavigationStack itself.",
            icon: "arrow.triangle.merge"
        ),
        Mistake(
            title: "Modifiers on NavigationStack",
            problem: ".navigationTitle, .toolbar, .navigationBarTitleDisplayMode applied to NavigationStack have no effect.",
            fix: "These modifiers must be applied inside NavigationStack - on the root content view or pushed destination views.",
            icon: "exclamationmark.triangle.fill"
        ),
    ]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Common mistakes", systemImage: "exclamationmark.triangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sbOrange)
 
                // Mistake selector
                VStack(spacing: 6) {
                    ForEach(mistakes.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedMistake = i }
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: mistakes[i].icon)
                                    .font(.system(size: 14))
                                    .foregroundStyle(selectedMistake == i ? Color(hex: "#E24B4A") : .secondary)
                                    .frame(width: 20)
                                Text(mistakes[i].title)
                                    .font(.system(size: 12, weight: selectedMistake == i ? .semibold : .regular))
                                    .foregroundStyle(selectedMistake == i ? Color(hex: "#E24B4A") : .primary)
                                    .lineLimit(1)
                                Spacer()
                                if selectedMistake == i {
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 10)).foregroundStyle(.secondary)
                                }
                            }
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(selectedMistake == i ? Color(hex: "#FCEBEB") : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PressableButtonStyle())
 
                        if selectedMistake == i {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Problem", systemImage: "xmark.circle")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(Color(hex: "#E24B4A"))
                                Text(mistakes[i].problem)
                                    .font(.system(size: 12)).foregroundStyle(.secondary).lineSpacing(2)
 
                                Label("Fix", systemImage: "checkmark.circle")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(Color(hex: "#1D9E75"))
                                Text(mistakes[i].fix)
                                    .font(.system(size: 12)).foregroundStyle(.secondary).lineSpacing(2)
                            }
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
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
 
