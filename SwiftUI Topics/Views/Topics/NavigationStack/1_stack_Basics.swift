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
    @State private var selectedStep = 0
    let steps = ["Structure", "Push", "Pop"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Stack basics", systemImage: "rectangle.stack.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.navBlue)

                HStack(spacing: 8) {
                    ForEach(steps.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.35)) { selectedStep = i }
                        } label: {
                            Text(steps[i])
                                .font(.system(size: 12, weight: selectedStep == i ? .semibold : .regular))
                                .foregroundStyle(selectedStep == i ? Color.navBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedStep == i ? Color.navBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                ZStack {
                    Color(.secondarySystemBackground)
                    stepDiagram.padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedStep)

                let descs = [
                    "NavigationStack wraps your root view. NavigationLink defines what to push. .navigationTitle sets the bar title on each screen.",
                    "Tapping a NavigationLink pushes the destination onto the stack. SwiftUI adds a back button automatically.",
                    "Tapping the back button pops the top screen. The stack returns to the previous state.",
                ]
                Text(descs[selectedStep])
                    .font(.system(size: 12)).foregroundStyle(.secondary).lineSpacing(2)
                    .animation(.easeInOut(duration: 0.2), value: selectedStep)
            }
        }
    }

    @ViewBuilder
    private var stepDiagram: some View {
        switch selectedStep {
        case 0:
            HStack(alignment: .top, spacing: 14) {
                NavScreenMock(title: "Root", color: .navBlue, isTop: true, items: ["Item A", "Item B", "Item C"])
                VStack(alignment: .leading, spacing: 5) {
                    navCodeChip("NavigationStack { }")
                    navCodeChip("NavigationLink(destination:)")
                    navCodeChip(".navigationTitle(\"Root\")")
                    navCodeChip(".navigationBarTitleDisplayMode")
                }
            }

        case 1:
            HStack(spacing: 8) {
                NavScreenMock(title: "Root", color: .navBlue, isTop: false, items: ["Item A ›", "Item B"])
                VStack(spacing: 6) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 20)).foregroundStyle(Color.navBlue)
                    Text("push").font(.system(size: 9)).foregroundStyle(.secondary)
                }
                NavScreenMock(title: "Detail", color: .navBlue, isTop: true, hasBackButton: true)
                VStack(alignment: .leading, spacing: 4) {
                    Label("Auto back button", systemImage: "checkmark.circle.fill")
                        .font(.system(size: 9, weight: .semibold)).foregroundStyle(Color(hex: "#1D9E75"))
                    Text("Stack depth: 2")
                        .font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                }
            }

        default:
            HStack(spacing: 8) {
                NavScreenMock(title: "Root", color: .navBlue, isTop: true, items: ["Item A", "Item B"])
                VStack(spacing: 6) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.system(size: 20)).foregroundStyle(.secondary)
                    Text("pop").font(.system(size: 9)).foregroundStyle(.secondary)
                }
                NavScreenMock(title: "Detail", color: Color(.systemGray4), isTop: false, hasBackButton: true)
                    .opacity(0.35)
                Text("Removed\nfrom stack")
                    .font(.system(size: 9)).foregroundStyle(.tertiary).multilineTextAlignment(.center)
            }
        }
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
