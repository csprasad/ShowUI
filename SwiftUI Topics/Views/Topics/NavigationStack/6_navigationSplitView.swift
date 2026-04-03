//
//
//  6_navigationSplitView.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `03/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: NavigationSplitView
 
struct SplitViewVisual: View {
    @State private var selectedCategory: NavCategory? = NavCategory.samples.first
    @State private var selectedItem: NavItem? = nil
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    @State private var selectedLayout = 0
 
    let layouts = ["Two-column", "Three-column"]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("NavigationSplitView", systemImage: "sidebar.left")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.navBlue)
                    Spacer()
                    Text("iPad / Mac")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.navBlue)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.navBlueLight).clipShape(Capsule())
                }
 
                // Layout selector
                HStack(spacing: 8) {
                    ForEach(layouts.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedLayout = i }
                        } label: {
                            Text(layouts[i])
                                .font(.system(size: 12, weight: selectedLayout == i ? .semibold : .regular))
                                .foregroundStyle(selectedLayout == i ? Color.navBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 8)
                                .background(selectedLayout == i ? Color.navBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
 
                // Split view demo
                if selectedLayout == 0 {
                    // Two-column
                    NavigationSplitView {
                        List(NavCategory.samples, selection: $selectedCategory) { cat in
                            Label(cat.name, systemImage: cat.icon)
                                .foregroundStyle(cat.color)
                                .tag(cat)
                        }
                        .navigationTitle("Sidebar")
                        .navigationBarTitleDisplayMode(.inline)
                    } detail: {
                        if let cat = selectedCategory {
                            List(cat.items) { item in
                                Label(item.name, systemImage: item.icon)
                            }
                            .navigationTitle(cat.name)
                            .navigationBarTitleDisplayMode(.inline)
                        } else {
                            Text("Select a category")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemFill), lineWidth: 1))
                } else {
                    // Three-column
                    NavigationSplitView {
                        List(NavCategory.samples, selection: $selectedCategory) { cat in
                            Label(cat.name, systemImage: cat.icon)
                                .foregroundStyle(cat.color)
                                .tag(cat)
                        }
                        .navigationTitle("Topics")
                        .navigationBarTitleDisplayMode(.inline)
                    } content: {
                        if let cat = selectedCategory {
                            List(cat.items, selection: $selectedItem) { item in
                                Text(item.name).tag(item)
                            }
                            .navigationTitle(cat.name)
                            .navigationBarTitleDisplayMode(.inline)
                        } else {
                            Text("Pick a topic").foregroundStyle(.secondary)
                        }
                    } detail: {
                        if let item = selectedItem {
                            VStack(spacing: 8) {
                                Image(systemName: item.icon)
                                    .font(.system(size: 32)).foregroundStyle(Color.navBlue)
                                Text(item.name).font(.system(size: 18, weight: .bold))
                                Text(item.description).font(.system(size: 13)).foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .navigationTitle(item.name)
                            .navigationBarTitleDisplayMode(.inline)
                        } else {
                            Text("Pick an item").foregroundStyle(.secondary)
                        }
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemFill), lineWidth: 1))
                }
 
                // Selection state
                HStack(spacing: 8) {
                    if let cat = selectedCategory {
                        selectionChip(cat.name, color: cat.color)
                    }
                    if let item = selectedItem, selectedLayout == 1 {
                        Image(systemName: "chevron.right").font(.system(size: 10)).foregroundStyle(.tertiary)
                        selectionChip(item.name, color: .navBlue)
                    }
                }
                .animation(.spring(response: 0.3), value: selectedCategory?.id)
                .animation(.spring(response: 0.3), value: selectedItem?.id)
            }
        }
    }
 
    func selectionChip(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 10).padding(.vertical, 4)
            .background(color.opacity(0.1))
            .clipShape(Capsule())
    }
}
 
struct SplitViewExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "NavigationSplitView")
            Text("NavigationSplitView provides the sidebar/detail layout used by apps like Mail and Notes. On iPad it shows columns side by side. On iPhone it collapses into a NavigationStack automatically - one API, both platforms.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "Two-column: sidebar { } detail { } - sidebar lists categories, detail shows selected content.", color: .navBlue)
                StepRow(number: 2, text: "Three-column: sidebar { } content { } detail { } - adds a middle column for sub-lists.", color: .navBlue)
                StepRow(number: 3, text: "Use List(selection: $selectedItem) to drive the detail panel from sidebar selection.", color: .navBlue)
                StepRow(number: 4, text: "NavigationSplitViewVisibility controls column visibility - .all, .detailOnly, .doubleColumn.", color: .navBlue)
                StepRow(number: 5, text: "On iPhone, NavigationSplitView collapses to a stack - the sidebar becomes the root, detail is pushed.", color: .navBlue)
            }
 
            CalloutBox(style: .success, title: "One layout for all platforms", contentBody: "NavigationSplitView collapses gracefully on iPhone into a NavigationStack. Build once and it behaves correctly on iPhone, iPad, and Mac without any platform checks.")
 
            CalloutBox(style: .info, title: "Selection drives detail", contentBody: "The pattern is: optional @State var selected: Item? The sidebar sets this on tap, the detail reads it. When nil, show a placeholder - 'Select an item'. When non-nil, show the content.")
 
            CodeBlock(code: """
@State private var selectedCategory: Category?
@State private var selectedItem: Item?
 
// Two-column
NavigationSplitView {
    List(categories, selection: $selectedCategory) { cat in
        Text(cat.name).tag(cat)
    }
    .navigationTitle("Categories")
} detail: {
    if let cat = selectedCategory {
        CategoryDetail(category: cat)
    } else {
        Text("Select a category")
            .foregroundStyle(.secondary)
    }
}
 
// Control sidebar visibility
NavigationSplitView(columnVisibility: $visibility) {
    // sidebar
} detail: {
    // detail
}
Button("Show sidebar") {
    visibility = .all
}
""")
        }
    }
}
 
