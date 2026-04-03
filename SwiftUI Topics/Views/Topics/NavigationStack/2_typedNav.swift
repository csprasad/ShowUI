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
    @State private var selectedView = 0
    let views = ["Eager (old)", "Lazy (new)", "Flow"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Typed navigation", systemImage: "arrow.right.square.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.navBlue)

                HStack(spacing: 8) {
                    ForEach(views.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.35)) { selectedView = i }
                        } label: {
                            Text(views[i])
                                .font(.system(size: 12, weight: selectedView == i ? .semibold : .regular))
                                .foregroundStyle(selectedView == i ? Color.navBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedView == i ? Color.navBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                ZStack {
                    Color(.secondarySystemBackground)
                    typedDiagram.padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedView)

                let descs = [
                    "NavigationLink(destination: DetailView(item)) creates DetailView for every row eagerly - even rows you've never visited. 1000 rows = 1000 views.",
                    "NavigationLink(value: item) pushes a value. .navigationDestination creates the view only when navigation happens - lazy and efficient.",
                    "The typed value flows: link pushes a value → stack matches it to a registered destination → destination view is created on demand.",
                ]
                Text(descs[selectedView])
                    .font(.system(size: 12)).foregroundStyle(.secondary).lineSpacing(2)
                    .animation(.easeInOut(duration: 0.2), value: selectedView)
            }
        }
    }

    @ViewBuilder
    private var typedDiagram: some View {
        switch selectedView {
        case 0:
            VStack(spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Color(hex: "#E24B4A")).font(.system(size: 12))
                    Text("Eager - destination created for EVERY row")
                        .font(.system(size: 10, weight: .semibold)).foregroundStyle(Color(hex: "#E24B4A"))
                }
                HStack(spacing: 6) {
                    ForEach(["Row 1", "Row 2", "Row 3", "..."], id: \.self) { row in
                        VStack(spacing: 3) {
                            Text(row).font(.system(size: 9)).foregroundStyle(.secondary)
                            if row != "..." {
                                Image(systemName: "arrow.down").font(.system(size: 8)).foregroundStyle(.tertiary)
                                RoundedRectangle(cornerRadius: 4).fill(Color(hex: "#FCEBEB"))
                                    .frame(width: 52, height: 24)
                                    .overlay(Text("DetailView").font(.system(size: 7)).foregroundStyle(Color(hex: "#E24B4A")))
                            } else {
                                Text("more\nviews").font(.system(size: 8)).foregroundStyle(.tertiary).multilineTextAlignment(.center)
                            }
                        }
                    }
                }
            }

        case 1:
            VStack(spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Color(hex: "#1D9E75")).font(.system(size: 12))
                    Text("Lazy - destination created only on navigation")
                        .font(.system(size: 10, weight: .semibold)).foregroundStyle(Color(hex: "#1D9E75"))
                }
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(["Row 1 → value", "Row 2 → value", "Row 3 → value"], id: \.self) { row in
                            Text(row).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.navBlue)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Color.navBlueLight).clipShape(RoundedRectangle(cornerRadius: 3))
                        }
                    }
                    Image(systemName: "arrow.right").font(.system(size: 10)).foregroundStyle(.secondary)
                    VStack(alignment: .leading, spacing: 3) {
                        navCodeChip(".navigationDestination", color: Color(hex: "#1D9E75"))
                        navCodeChip("(for: Item.self)", color: Color(hex: "#1D9E75"))
                        Text("→ ItemDetail(item)")
                            .font(.system(size: 9)).foregroundStyle(Color(hex: "#1D9E75"))
                        Text("(on demand ✓)").font(.system(size: 9)).foregroundStyle(Color(hex: "#1D9E75"))
                    }
                }
            }

        default:
            VStack(spacing: 8) {
                HStack(spacing: 0) {
                    flowBox("NavigationLink\n(value: item)", color: .navBlue)
                    Image(systemName: "arrow.right").font(.system(size: 10)).foregroundStyle(.secondary).frame(width: 20)
                    flowBox("Stack\nroutes by\ntype", color: .animAmber)
                    Image(systemName: "arrow.right").font(.system(size: 10)).foregroundStyle(.secondary).frame(width: 20)
                    flowBox("Destination\ncreated\nlazily ✓", color: Color(hex: "#1D9E75"))
                }
                Text("path.append(value) also works · types must be Hashable")
                    .font(.system(size: 9)).foregroundStyle(.tertiary)
            }
        }
    }

    func flowBox(_ text: String, color: Color) -> some View {
        Text(text).font(.system(size: 9, weight: .semibold)).foregroundStyle(color)
            .multilineTextAlignment(.center)
            .frame(width: 72, height: 48)
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
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
 
