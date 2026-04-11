//
//
//  5_TabwithNavigationStack.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Tab with NavigationStack
struct TVWithNavVisual: View {
    @State private var selectedTab   = 0
    @State private var showPushInfo  = false
    @State private var selectedDemo  = 0
    let demos = ["Navigation per tab", "State isolation", "Back to root"]

    // Separate navigation paths per tab
    @State private var homePath:    NavigationPath = .init()
    @State private var searchPath:  NavigationPath = .init()
    @State private var profilePath: NavigationPath = .init()

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Tab + NavigationStack", systemImage: "rectangle.stack.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tvBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.tvBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.tvBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Architecture diagram
                    VStack(spacing: 8) {
                        archRow("TabView", level: 0, color: .tvBlue)
                        archRow("├── HomeTab", level: 1, color: .tvBlue)
                        archRow("│   └── NavigationStack(path: $homePath)", level: 2, color: Color(hex: "#0F766E"))
                        archRow("│       └── HomeView → DetailView → …", level: 3, color: .secondary)
                        archRow("├── SearchTab", level: 1, color: .tvBlue)
                        archRow("│   └── NavigationStack(path: $searchPath)", level: 2, color: Color(hex: "#C2410C"))
                        archRow("│       └── SearchView → ResultView → …", level: 3, color: .secondary)
                        archRow("└── ProfileTab", level: 1, color: .tvBlue)
                        archRow("    └── NavigationStack(path: $profilePath)", level: 2, color: Color(hex: "#7C3AED"))
                        archRow("        └── ProfileView → EditView → …", level: 3, color: .secondary)

                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill").font(.system(size: 12)).foregroundStyle(Color.formGreen)
                            Text("Each tab owns its NavigationPath - switching tabs preserves navigation state in other tabs")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color(hex: "#E1F5EE")).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // State isolation demo
                    VStack(spacing: 10) {
                        TabView(selection: $selectedTab) {
                            NavigationStack(path: $homePath) {
                                tabNavContent(tab: "Home", path: $homePath, color: .tvBlue, depth: homePath.count)
                            }
                            .tabItem { Label("Home", systemImage: "house.fill") }.tag(0)

                            NavigationStack(path: $searchPath) {
                                tabNavContent(tab: "Search", path: $searchPath, color: Color(hex: "#0F766E"), depth: searchPath.count)
                            }
                            .tabItem { Label("Search", systemImage: "magnifyingglass") }.tag(1)

                            NavigationStack(path: $profilePath) {
                                tabNavContent(tab: "Profile", path: $profilePath, color: Color(hex: "#7C3AED"), depth: profilePath.count)
                            }
                            .tabItem { Label("Profile", systemImage: "person.fill") }.tag(2)
                        }
                        .frame(height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                        Text("Each tab tracks its own push depth - switch tabs, come back, navigation is preserved")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }

                default:
                    // Back to root
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Button("Push in Home tab") {
                                homePath.append("level-\(homePath.count + 1)")
                                selectedTab = 0
                            }
                            .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Color.tvBlue).clipShape(RoundedRectangle(cornerRadius: 8))
                            .buttonStyle(PressableButtonStyle())

                            Button("Back to root") {
                                withAnimation { homePath.removeLast(homePath.count) }
                                selectedTab = 0
                            }
                            .font(.system(size: 12, weight: .semibold)).foregroundStyle(Color.tvBlue)
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Color.tvBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                            .buttonStyle(PressableButtonStyle())
                            .disabled(homePath.isEmpty)
                        }

                        TabView(selection: $selectedTab) {
                            NavigationStack(path: $homePath) {
                                tabNavContent(tab: "Home", path: $homePath, color: .tvBlue, depth: homePath.count)
                            }
                            .tabItem { Label("Home", systemImage: "house.fill") }.tag(0)

                            NavigationStack(path: $searchPath) {
                                tabNavContent(tab: "Search", path: $searchPath, color: Color(hex: "#0F766E"), depth: searchPath.count)
                            }
                            .tabItem { Label("Search", systemImage: "magnifyingglass") }.tag(1)
                        }
                        .frame(height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                        Text("path.removeLast(path.count) pops to root - use on retap detection")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func tabNavContent(tab: String, path: Binding<NavigationPath>, color: Color, depth: Int) -> some View {
        VStack(spacing: 6) {
            Text(tab).font(.system(size: 15, weight: .bold)).foregroundStyle(color)
            Text("Depth: \(depth)").font(.system(size: 13, design: .monospaced)).foregroundStyle(.secondary)
            Button("Push deeper") { path.wrappedValue.append("level-\(depth + 1)") }
                .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(color).clipShape(RoundedRectangle(cornerRadius: 8))
                .buttonStyle(PressableButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color.opacity(0.06))
        .navigationTitle(tab)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: String.self) { level in
            VStack(spacing: 6) {
                Text(level).font(.system(size: 14, weight: .semibold)).foregroundStyle(color)
                Text("Depth: \(path.wrappedValue.count)").font(.system(size: 12)).foregroundStyle(.secondary)
                Button("Push deeper") { path.wrappedValue.append("level-\(path.wrappedValue.count + 1)") }
                    .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background(color).clipShape(RoundedRectangle(cornerRadius: 8))
                    .buttonStyle(PressableButtonStyle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color.opacity(0.06))
            .navigationTitle(level)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func archRow(_ text: String, level: Int, color: Color) -> some View {
        HStack(spacing: 0) {
            Text(String(repeating: "  ", count: level))
                .font(.system(size: 10, design: .monospaced))
            Text(text)
                .font(.system(size: 10, design: .monospaced))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TVWithNavExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "TabView + NavigationStack")
            Text("The canonical iOS architecture: one NavigationStack per tab, each with its own NavigationPath. Switching tabs preserves each tab's navigation state. The paths live in the parent view so they can be reset programmatically.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "One NavigationStack per tab - wrap each tab's root view in its own NavigationStack.", color: .tvBlue)
                StepRow(number: 2, text: "@State private var homePath = NavigationPath() - one path per tab, owned by the parent.", color: .tvBlue)
                StepRow(number: 3, text: "NavigationStack(path: $homePath) - bound path enables programmatic navigation.", color: .tvBlue)
                StepRow(number: 4, text: "Back to root: homePath.removeLast(homePath.count) - clears all pushed views.", color: .tvBlue)
                StepRow(number: 5, text: "Retap to root: in onChange(of: selectedTab) { if old == new { clearPath() } }", color: .tvBlue)
            }

            CalloutBox(style: .warning, title: "Don't put NavigationStack outside TabView", contentBody: "NavigationStack outside TabView means the tab bar disappears on push - the navigation overlays everything including the tab bar. Always put NavigationStack inside each tab, not wrapping TabView.")

            CodeBlock(code: """
// ✓ Correct - NavigationStack inside tab
@State private var homePath = NavigationPath()
@State private var selected = Tab.home

TabView(selection: $selected) {
    NavigationStack(path: $homePath) {
        HomeView()
            .navigationDestination(for: Item.self) { item in
                DetailView(item: item)
            }
    }
    .tabItem { Label("Home", systemImage: "house") }
    .tag(Tab.home)
}
.onChange(of: selected) { old, new in
    if old == new {
        homePath.removeLast(homePath.count)  // scroll/pop to root
    }
}

// ✗ Wrong - NavigationStack outside TabView
NavigationStack {
    TabView { ... }  // tab bar disappears on push!
}
""")
        }
    }
}
