//
//
//  2_typedNav.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `03/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Typed Navigation
 
struct TypedNavVisual: View {
    @State private var path = NavigationPath()
    @State private var selectedDemo = 0
 
    let demos = ["Value-based link", "Programmatic push", "Multiple types"]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Typed navigation", systemImage: "arrow.right.square.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.navBlue)
 
                // Demo selector
                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 10, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.navBlue : .secondary)
                                .padding(.horizontal, 8).padding(.vertical, 5)
                                .background(selectedDemo == i ? Color.navBlueLight : Color(.systemFill))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
 
                // Live demo
                NavigationStack(path: $path) {
                    VStack(spacing: 10) {
                        switch selectedDemo {
                        case 0:
                            // Value-based links — no destination: parameter
                            ForEach(NavCategory.samples) { cat in
                                NavigationLink(value: cat) {
                                    HStack(spacing: 10) {
                                        Image(systemName: cat.icon)
                                            .foregroundStyle(cat.color).frame(width: 24)
                                        Text(cat.name).font(.system(size: 14, weight: .medium))
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12)).foregroundStyle(.tertiary)
                                    }
                                    .padding(10)
                                    .background(Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .buttonStyle(.plain)
                            }
                        case 1:
                            // Programmatic push via path
                            ForEach(NavCategory.samples) { cat in
                                Button {
                                    path.append(cat)
                                } label: {
                                    HStack(spacing: 10) {
                                        Image(systemName: cat.icon).foregroundStyle(cat.color).frame(width: 24)
                                        Text("Push \(cat.name) programmatically")
                                            .font(.system(size: 13))
                                        Spacer()
                                        Image(systemName: "arrow.right.circle.fill")
                                            .foregroundStyle(Color.navBlue)
                                    }
                                    .padding(10)
                                    .background(Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        default:
                            // Multiple value types
                            VStack(spacing: 8) {
                                NavigationLink(value: NavCategory.samples[0]) {
                                    typedRow("Category", "NavCategory", color: .animCoral)
                                }
                                .buttonStyle(.plain)
                                NavigationLink(value: NavCategory.samples[0].items[0]) {
                                    typedRow("Item", "NavItem", color: .navBlue)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(10)
                    .navigationTitle("Typed Nav")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        if !path.isEmpty {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Root") { path = NavigationPath() }
                                    .font(.system(size: 13))
                            }
                        }
                    }
                    .navigationDestination(for: NavCategory.self) { cat in
                        TypedCategoryDetail(category: cat, path: $path)
                    }
                    .navigationDestination(for: NavItem.self) { item in
                        TypedItemDetail(item: item)
                    }
                }
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemFill), lineWidth: 1))
 
                // Path depth indicator
                HStack(spacing: 6) {
                    Image(systemName: "rectangle.stack")
                        .font(.system(size: 12)).foregroundStyle(Color.navBlue)
                    Text("Stack depth: \(path.count + 1)")
                        .font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary)
                    if path.count > 0 {
                        Button("Pop all") { withAnimation { path = NavigationPath() } }
                            .font(.system(size: 12)).foregroundStyle(Color.navBlue)
                    }
                }
            }
        }
    }
 
    func typedRow(_ title: String, _ type: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Text(type)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(color)
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(color.opacity(0.1))
                .clipShape(Capsule())
            Text("Push a \(title)")
                .font(.system(size: 13))
            Spacer()
            Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(.tertiary)
        }
        .padding(10)
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
 
struct TypedCategoryDetail: View {
    let category: NavCategory
    @Binding var path: NavigationPath
 
    var body: some View {
        List(category.items) { item in
            NavigationLink(value: item) {
                Label(item.name, systemImage: item.icon)
                    .foregroundStyle(category.color)
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
 
struct TypedItemDetail: View {
    let item: NavItem
 
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: item.icon)
                .font(.system(size: 48)).foregroundStyle(Color.navBlue)
            Text(item.name).font(.system(size: 24, weight: .bold))
            Text(item.description).font(.system(size: 16)).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
 
struct TypedNavExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Typed navigation - iOS 16+")
            Text("navigationDestination(for:) separates the link from its destination. Instead of NavigationLink(destination: SomeView()), you push a typed value and declare how that value maps to a destination at the stack level - once.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "NavigationLink(value:) pushes a typed Hashable value onto the stack - no destination view needed at the link.", color: .navBlue)
                StepRow(number: 2, text: ".navigationDestination(for: MyType.self) declares how to display that type - registered once on the stack.", color: .navBlue)
                StepRow(number: 3, text: "Multiple .navigationDestination modifiers handle different types - categories, items, users, etc.", color: .navBlue)
                StepRow(number: 4, text: "path.append(value) pushes programmatically - same as tapping a NavigationLink.", color: .navBlue)
            }
 
            CalloutBox(style: .success, title: "Why this pattern is better", contentBody: "With NavigationLink(destination:), the destination view is created eagerly for every row in a List - even before navigation. With value-based links, the destination is only created when navigation actually happens. Much more efficient for large lists.")
 
            CalloutBox(style: .info, title: "Types must be Hashable", contentBody: "The value you push must conform to Hashable (and ideally Codable for path restoration). Structs conforming to Hashable work perfectly. Add id, name, and a manual hash if needed.")
 
            CodeBlock(code: """
// Register destinations once at the stack
NavigationStack(path: $path) {
    List(categories) { category in
        // Just push the value - no destination here
        NavigationLink(value: category) {
            Text(category.name)
        }
    }
    // Destination declared once for the whole stack
    .navigationDestination(for: Category.self) { cat in
        CategoryDetail(category: cat)
    }
    .navigationDestination(for: Item.self) { item in
        ItemDetail(item: item)
    }
}
 
// Programmatic push - same result as tapping a link
Button("Go to Swift") {
    path.append(swiftCategory)
}
""")
        }
    }
}
 
