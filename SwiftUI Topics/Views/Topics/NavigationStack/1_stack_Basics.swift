//
//
//  1_stack_Basics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `03/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
 
// MARK: - LESSON 1: Stack Basics
 
struct NavBasicsVisual: View {
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Stack basics", systemImage: "rectangle.stack.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.navBlue)
 
                // Live NavigationStack demo embedded in card
                NavigationStack {
                    List(NavCategory.samples) { category in
                        NavigationLink(destination: CategoryDetailView(category: category)) {
                            Label(category.name, systemImage: category.icon)
                                .foregroundStyle(category.color)
                        }
                    }
                    .navigationTitle("Topics")
                    .navigationBarTitleDisplayMode(.inline)
                }
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(.systemFill), lineWidth: 1)
                )
 
                // Code anatomy
                VStack(alignment: .leading, spacing: 6) {
                    codeRow("NavigationStack { ... }", desc: "The root container - manages the stack")
                    codeRow("NavigationLink(destination:)", desc: "Pushes destination onto the stack")
                    codeRow(".navigationTitle(\"...\")", desc: "Sets the bar title for this view")
                    codeRow(".navigationBarTitleDisplayMode(.large)", desc: "Large or inline title style")
                }
            }
        }
    }
 
    func codeRow(_ code: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(code)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(Color.navBlue)
                .frame(width: 180, alignment: .leading)
            Text(desc)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(Color.navBlueLight)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
 
struct CategoryDetailView: View {
    let category: NavCategory
 
    var body: some View {
        List(category.items) { item in
            Label(item.name, systemImage: item.icon)
                .foregroundStyle(category.color)
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
 
struct NavBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "NavigationStack basics")
            Text("NavigationStack is the root container for stack-based navigation in SwiftUI. Views are pushed onto the stack and popped off. The stack tracks navigation history and provides the back button automatically.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "Wrap your root view in NavigationStack { }. Only one per navigation hierarchy.", color: .navBlue)
                StepRow(number: 2, text: "NavigationLink(destination:) pushes a view. Tapping it navigates forward.", color: .navBlue)
                StepRow(number: 3, text: ".navigationTitle() sets the title for that screen - applied inside the destination, not on the link.", color: .navBlue)
                StepRow(number: 4, text: ".navigationBarTitleDisplayMode(.large) shows a large title. .inline is compact. .automatic lets the system decide.", color: .navBlue)
            }
 
            CalloutBox(style: .info, title: "NavigationStack replaced NavigationView", contentBody: "NavigationView is deprecated. Always use NavigationStack for single-column navigation. It fixes many bugs and adds typed navigation support.")
 
            CalloutBox(style: .warning, title: ".navigationTitle goes inside, not outside", contentBody: "Apply .navigationTitle to the view inside NavigationStack - not to the NavigationStack itself. Same for .toolbar and .navigationBarTitleDisplayMode.")
 
            CodeBlock(code: """
struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(items) { item in
                NavigationLink(destination: DetailView(item: item)) {
                    Text(item.name)
                }
            }
            .navigationTitle("Items")                    // ← inside
            .navigationBarTitleDisplayMode(.large)       // ← inside
        }
    }
}
 
struct DetailView: View {
    let item: Item
 
    var body: some View {
        Text(item.description)
            .navigationTitle(item.name)                  // ← inside detail
            .navigationBarTitleDisplayMode(.inline)
    }
}
""")
        }
    }
}
