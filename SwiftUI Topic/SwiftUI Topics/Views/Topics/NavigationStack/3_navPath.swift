//
//
//  3_navPath.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `03/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
 
// MARK: - LESSON 3: Navigation Path
struct NavPathVisual: View {
    @State private var stackDepth = 1
    @State private var selectedOp = 0
    let ops = ["Push", "Pop", "Jump to root", "Replace"]

    var stackScreens: [String] {
        var screens = ["Root"]
        if stackDepth >= 2 { screens.append("Categories") }
        if stackDepth >= 3 { screens.append("Swift") }
        if stackDepth >= 4 { screens.append("Protocols") }
        return screens
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Navigation path", systemImage: "list.bullet.rectangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.navBlue)

                // Stack visualizer
                VStack(alignment: .leading, spacing: 8) {
                    Text("NavigationPath - \(stackDepth - 1) item\(stackDepth == 2 ? "" : "s") above root")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)

                    // Visual stack
                    HStack(spacing: 4) {
                        ForEach(stackScreens.indices, id: \.self) { i in
                            HStack(spacing: 4) {
                                if i > 0 {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 9)).foregroundStyle(.tertiary)
                                }
                                Text(stackScreens[i])
                                    .font(.system(size: 11, weight: i == stackScreens.count - 1 ? .semibold : .regular))
                                    .foregroundStyle(i == stackScreens.count - 1 ? Color.navBlue : .secondary)
                                    .padding(.horizontal, 8).padding(.vertical, 4)
                                    .background(i == stackScreens.count - 1 ? Color.navBlueLight : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
                        Spacer()
                    }
                    .padding(10)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .animation(.spring(response: 0.4), value: stackDepth)

                    // path state display
                    HStack(spacing: 6) {
                        Text("path.count =")
                            .font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                        Text("\(stackDepth - 1)")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.navBlue)
                    }
                }

                // Operation buttons
                let cols = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
                LazyVGrid(columns: cols, spacing: 8) {
                    opButton("Push", icon: "arrow.right.circle.fill", color: .navBlue) {
                        if stackDepth < 4 { withAnimation(.spring(response: 0.35)) { stackDepth += 1 } }
                    }
                    opButton("Pop one", icon: "arrow.left.circle.fill", color: .animAmber) {
                        if stackDepth > 1 { withAnimation(.spring(response: 0.35)) { stackDepth -= 1 } }
                    }
                    opButton("Pop to root", icon: "house.fill", color: Color(hex: "#E24B4A")) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { stackDepth = 1 }
                    }
                    opButton("Replace stack", icon: "arrow.triangle.2.circlepath", color: Color(hex: "#1D9E75")) {
                        withAnimation(.spring(response: 0.4)) { stackDepth = Int.random(in: 2...4) }
                    }
                }

                // Code for current operation
                codeForState
            }
        }
    }

    func opButton(_ title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 14)).foregroundStyle(color)
                Text(title).font(.system(size: 12, weight: .semibold)).foregroundStyle(color)
                Spacer()
            }
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(color.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(PressableButtonStyle())
    }

    @ViewBuilder
    private var codeForState: some View {
        let snippets: [String: String] = [
            "1": "// At root\npath = NavigationPath()  // empty",
            "2": "// One level deep\npath.append(categoriesValue)",
            "3": "// Two levels deep\npath.append(categoriesValue)\npath.append(swiftCategory)",
            "4": "// Three levels deep\npath.append(categoriesValue)\npath.append(swiftCategory)\npath.append(protocolsItem)",
        ]
        Text(snippets["\(stackDepth)"] ?? "")
            .font(.system(size: 11, design: .monospaced))
            .foregroundStyle(Color.navBlue)
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.navBlueLight)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .animation(.easeInOut(duration: 0.2), value: stackDepth)
    }
}

struct PathDetailView: View {
    let category: NavCategory
    @Binding var path: NavigationPath
    @Binding var log: [String]
 
    var body: some View {
        List(category.items) { item in
            NavigationLink(value: item) {
                Label(item.name, systemImage: item.icon).foregroundStyle(category.color)
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Root") {
                    path = NavigationPath()
                    log.insert("Jumped to root from \(category.name)", at: 0)
                }
                .font(.system(size: 13))
            }
        }
        .navigationDestination(for: NavItem.self) { item in
            TypedItemDetail(item: item)
        }
    }
}
 
struct NavPathExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "NavigationPath")
            Text("NavigationPath is a type-erased stack that drives navigation programmatically. Instead of SwiftUI managing the stack internally, you hold the path in @State and manipulate it directly - push, pop, jump to root, or replace the entire stack.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "NavigationStack(path: $path) - binds the stack to your NavigationPath.", color: .navBlue)
                StepRow(number: 2, text: "path.append(value) - pushes a new screen. Equivalent to tapping a NavigationLink.", color: .navBlue)
                StepRow(number: 3, text: "path.removeLast() - pops the top screen. path.removeLast(n) pops n screens.", color: .navBlue)
                StepRow(number: 4, text: "path = NavigationPath() - resets to root immediately. No animation unless wrapped in withAnimation.", color: .navBlue)
                StepRow(number: 5, text: "path.count - the number of screens above root. 0 means you're at the root.", color: .navBlue)
            }
 
            CalloutBox(style: .success, title: "When to use NavigationPath", contentBody: "Whenever you need programmatic navigation - 'Go to root after login', 'Jump to a specific screen after a push notification', or 'Build a wizard that skips steps'. Without a path binding, SwiftUI controls the stack and you can't drive it.")
 
            CalloutBox(style: .info, title: "Codable path restoration", contentBody: "If all your navigation values are Codable, NavigationPath can be encoded and decoded. Store the encoded path in UserDefaults or SceneStorage to restore the user's exact navigation state when they reopen the app.")
 
            CodeBlock(code: """
@State private var path = NavigationPath()
 
NavigationStack(path: $path) {
    RootView()
        .navigationDestination(for: User.self) { user in
            UserProfile(user: user)
        }
}
 
// Push
path.append(selectedUser)
 
// Pop one
path.removeLast()
 
// Pop multiple
path.removeLast(2)
 
// Jump to root
path = NavigationPath()
 
// Replace entire stack (skip history)
path = NavigationPath([user, user.posts.first])
 
// Restore from storage
if let data = UserDefaults.standard.data(forKey: "navPath"),
   let restored = try? JSONDecoder().decode(
       NavigationPath.CodableRepresentation.self, from: data
   ) {
    path = NavigationPath(restored)
}
""")
        }
    }
}
