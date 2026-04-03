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
    @State private var path = NavigationPath()
    @State private var log: [String] = []
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Navigation path", systemImage: "list.bullet.rectangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.navBlue)
 
                // Path visualizer
                HStack(spacing: 0) {
                    pathStep("Root", isActive: true, isFirst: true)
                    ForEach(0..<path.count, id: \.self) { i in
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10)).foregroundStyle(.tertiary)
                        pathStep("Level \(i+1)", isActive: i == path.count - 1, isFirst: false)
                    }
                    Spacer()
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
 
                // Navigation stack
                NavigationStack(path: $path) {
                    List {
                        ForEach(NavCategory.samples) { cat in
                            NavigationLink(value: cat) {
                                Label(cat.name, systemImage: cat.icon).foregroundStyle(cat.color)
                            }
                        }
                    }
                    .navigationTitle("Root")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(for: NavCategory.self) { cat in
                        PathDetailView(category: cat, path: $path, log: $log)
                    }
                }
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemFill), lineWidth: 1))
 
                // Path controls
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Button {
                            path.append(NavCategory.samples[Int.random(in: 0..<3)])
                            log.insert("Pushed programmatically", at: 0)
                        } label: {
                            Text("Push random")
                                .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 9)
                                .background(Color.navBlue).clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PressableButtonStyle())
 
                        Button {
                            if !path.isEmpty {
                                path.removeLast()
                                log.insert("Popped one level", at: 0)
                            }
                        } label: {
                            Text("Pop one")
                                .font(.system(size: 13, weight: .semibold)).foregroundStyle(Color.navBlue)
                                .frame(maxWidth: .infinity).padding(.vertical, 9)
                                .background(Color.navBlueLight).clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PressableButtonStyle())
                        .disabled(path.isEmpty)
 
                        Button {
                            path = NavigationPath()
                            log.insert("Popped to root", at: 0)
                        } label: {
                            Text("Root")
                                .font(.system(size: 13, weight: .semibold)).foregroundStyle(Color(.systemRed))
                                .frame(maxWidth: .infinity).padding(.vertical, 9)
                                .background(Color(.systemRed).opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PressableButtonStyle())
                        .disabled(path.isEmpty)
                    }
 
                    // Log
                    if !log.isEmpty {
                        VStack(alignment: .leading, spacing: 3) {
                            ForEach(Array(log.prefix(3).enumerated()), id: \.offset) { _, entry in
                                Text(entry)
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }
 
    func pathStep(_ label: String, isActive: Bool, isFirst: Bool) -> some View {
        Text(label)
            .font(.system(size: 10, weight: isActive ? .semibold : .regular))
            .foregroundStyle(isActive ? Color.navBlue : .secondary)
            .padding(.horizontal, 6).padding(.vertical, 3)
            .background(isActive ? Color.navBlueLight : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 5))
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
