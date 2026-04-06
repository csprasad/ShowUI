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
    @State private var selectedCategory: Int = 0
    @State private var selectedItem: Int? = nil
    @State private var selectedLayout = 0

    let categories = ["Swift", "SwiftUI", "Xcode"]
    let categoryIcons = ["swift", "rectangle.3.group.fill", "hammer.fill"]
    let categoryColors: [Color] = [.animCoral, .navBlue, .animAmber]
    let items = [["Protocols", "Generics", "Concurrency"], ["State", "Layout", "Animations"], ["Instruments", "Previews", "Debugger"]]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("NavigationSplitView", systemImage: "sidebar.left")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.navBlue)
                    Spacer()
                    Text("iPad / Mac")
                        .font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.navBlue)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.navBlueLight).clipShape(Capsule())
                }

                HStack(spacing: 8) {
                    ForEach(["Two-column", "Three-column"].indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedLayout = i; selectedItem = nil }
                        } label: {
                            Text(["Two-column", "Three-column"][i])
                                .font(.system(size: 12, weight: selectedLayout == i ? .semibold : .regular))
                                .foregroundStyle(selectedLayout == i ? Color.navBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedLayout == i ? Color.navBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Split view mockup
                ZStack {
                    Color(.secondarySystemBackground)
                    splitMock
                }
                .frame(maxWidth: .infinity).frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.35), value: selectedCategory)
                .animation(.spring(response: 0.35), value: selectedItem)

                // On iPhone note
                HStack(spacing: 6) {
                    Image(systemName: "iphone").font(.system(size: 12)).foregroundStyle(Color.navBlue)
                    Text("On iPhone, NavigationSplitView collapses into a NavigationStack automatically - one codebase, all screen sizes")
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                }
                .padding(10).background(Color.navBlueLight).clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    @ViewBuilder
    private var splitMock: some View {
        if selectedLayout == 0 {
            // Two-column
            HStack(spacing: 0) {
                // Sidebar
                VStack(spacing: 0) {
                    Text("Sidebar").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                        .padding(.horizontal, 8).padding(.top, 8).padding(.bottom, 4)
                    ForEach(categories.indices, id: \.self) { i in
                        HStack(spacing: 6) {
                            Image(systemName: categoryIcons[i]).font(.system(size: 11)).foregroundStyle(categoryColors[i])
                            Text(categories[i]).font(.system(size: 11))
                            Spacer()
                        }
                        .padding(.horizontal, 8).padding(.vertical, 5)
                        .background(selectedCategory == i ? Color.navBlueLight : Color.clear)
                        .onTapGesture { withAnimation { selectedCategory = i } }
                    }
                    Spacer()
                }
                .frame(width: 110)
                .background(Color(.systemBackground))
                Divider()
                // Detail
                VStack(spacing: 0) {
                    Text(categories[selectedCategory]).font(.system(size: 12, weight: .semibold))
                        .padding(.horizontal, 10).padding(.top, 8).padding(.bottom, 4)
                    ForEach(items[selectedCategory].indices, id: \.self) { j in
                        HStack {
                            Text(items[selectedCategory][j]).font(.system(size: 11))
                            Spacer()
                        }
                        .padding(.horizontal, 10).padding(.vertical, 4)
                        Divider().padding(.leading, 10)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
            }
        } else {
            // Three-column
            HStack(spacing: 0) {
                // Sidebar
                VStack(spacing: 0) {
                    Text("Topics").font(.system(size: 9, weight: .semibold)).foregroundStyle(.secondary)
                        .padding(.horizontal, 6).padding(.top, 6).padding(.bottom, 3)
                    ForEach(categories.indices, id: \.self) { i in
                        HStack(spacing: 4) {
                            Image(systemName: categoryIcons[i]).font(.system(size: 10)).foregroundStyle(categoryColors[i])
                            Text(categories[i]).font(.system(size: 10))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 6).padding(.vertical, 4)
                        .background(selectedCategory == i ? Color.navBlueLight : Color.clear)
                        .onTapGesture { withAnimation { selectedCategory = i; selectedItem = nil } }
                    }
                    Spacer()
                }
                .frame(width: 80)
                .background(Color(.systemBackground))
                Divider()
                // Content
                VStack(spacing: 0) {
                    Text(categories[selectedCategory]).font(.system(size: 9, weight: .semibold)).foregroundStyle(.secondary)
                        .padding(.horizontal, 6).padding(.top, 6).padding(.bottom, 3)
                    ForEach(items[selectedCategory].indices, id: \.self) { j in
                        Text(items[selectedCategory][j]).font(.system(size: 10))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 6).padding(.vertical, 4)
                            .background(selectedItem == j ? Color.navBlueLight : Color.clear)
                            .onTapGesture { withAnimation { selectedItem = j } }
                        Divider().padding(.leading, 6)
                    }
                    Spacer()
                }
                .frame(width: 90)
                .background(Color(.systemBackground))
                Divider()
                // Detail
                VStack {
                    if let item = selectedItem {
                        VStack(spacing: 6) {
                            Image(systemName: "doc.text.fill").font(.system(size: 20)).foregroundStyle(Color.navBlue)
                            Text(items[selectedCategory][item]).font(.system(size: 11, weight: .semibold))
                            Text("Detail view").font(.system(size: 9)).foregroundStyle(.secondary)
                        }
                    } else {
                        Text("Select an item").font(.system(size: 10)).foregroundStyle(.tertiary)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
            }
        }
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
 
