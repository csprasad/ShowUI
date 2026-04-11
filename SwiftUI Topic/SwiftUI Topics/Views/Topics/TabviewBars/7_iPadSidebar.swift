//
//
//  7_iPadSidebar.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: iPad Sidebar (iOS 18 TabSection)
struct TVSidebarVisual: View {
    @State private var selectedDemo = 0
    let demos = ["sidebarAdaptable", "Compact vs expanded", "TabSection"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("iPad sidebar", systemImage: "sidebar.leading")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.tvBlue)
                    Spacer()
                    Text("iOS 18+")
                        .font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.tvBlue)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.tvBlueLight).clipShape(Capsule())
                }

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
                    // .sidebarAdaptable concept
                    VStack(spacing: 8) {
                        deviceCard(
                            device: "iPhone / compact",
                            icon: "iphone",
                            color: .tvBlue,
                            description: "Standard bottom tab bar - normal TabView behaviour",
                            shows: true
                        )
                        deviceCard(
                            device: "iPad / regular",
                            icon: "ipad",
                            color: Color(hex: "#7C3AED"),
                            description: ".tabViewStyle(.sidebarAdaptable) → sidebar on iPad, tab bar on iPhone",
                            shows: true
                        )
                        deviceCard(
                            device: "macOS / Catalyst",
                            icon: "laptopcomputer",
                            color: Color(hex: "#0F766E"),
                            description: "Same modifier shows macOS-style sidebar navigation",
                            shows: true
                        )

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.tvBlue)
                            Text("One modifier - TabView adapts to the platform and horizontal size class automatically.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tvBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // Compact vs expanded layout
                    HStack(spacing: 10) {
                        // Compact - tab bar
                        VStack(spacing: 6) {
                            Text("Compact (iPhone)").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                            ZStack(alignment: .bottom) {
                                RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)).frame(height: 130)
                                VStack(spacing: 4) {
                                    Image(systemName: "house.fill").font(.system(size: 20)).foregroundStyle(Color.tvBlue)
                                    Text("Home").font(.system(size: 10)).foregroundStyle(Color.tvBlue)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)

                                // Bottom tab bar
                                HStack(spacing: 0) {
                                    ForEach(["house.fill", "magnifyingglass", "person.fill"], id: \.self) { icon in
                                        Image(systemName: icon)
                                            .font(.system(size: 14))
                                            .foregroundStyle(icon == "house.fill" ? Color.tvBlue : Color(.systemGray4))
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding(.vertical, 8)
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 0, style: .continuous))
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemFill), lineWidth: 0.5))
                        }

                        // Regular - sidebar
                        VStack(spacing: 6) {
                            Text("Regular (iPad)").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                            HStack(spacing: 0) {
                                // Sidebar
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("App").font(.system(size: 9, weight: .bold)).foregroundStyle(Color.tvBlue).padding(.bottom, 4)
                                    ForEach([(Icon: "house.fill", name: "Home", selected: true),
                                             (Icon: "magnifyingglass", name: "Search", selected: false),
                                             (Icon: "person.fill", name: "Profile", selected: false)], id: \.name) { item in
                                        HStack(spacing: 5) {
                                            Image(systemName: item.Icon).font(.system(size: 10))
                                                .foregroundStyle(item.selected ? Color.tvBlue : .secondary)
                                            Text(item.name).font(.system(size: 9))
                                                .foregroundStyle(item.selected ? Color.tvBlue : .secondary)
                                        }
                                        .padding(.horizontal, 6).padding(.vertical, 3)
                                        .background(item.selected ? Color.tvBlueLight : Color.clear)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                    }
                                }
                                .frame(width: 70).padding(8)
                                .background(Color(.secondarySystemBackground))

                                Divider()

                                VStack(spacing: 4) {
                                    Image(systemName: "house.fill").font(.system(size: 18)).foregroundStyle(Color.tvBlue)
                                    Text("Home").font(.system(size: 11)).foregroundStyle(Color.tvBlue)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color(.systemBackground))
                            }
                            .frame(height: 130)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemFill), lineWidth: 0.5))
                        }
                    }

                default:
                    // TabSection code + concept
                    VStack(spacing: 8) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("iOS 18 TabSection").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            codeBlock("""
TabView {
    Tab("Home", systemImage: "house") {
        HomeView()
    }
    TabSection("Library") {
        Tab("Music", systemImage: "music.note") { MusicView() }
        Tab("Podcasts", systemImage: "mic") { PodcastView() }
        Tab("Books", systemImage: "book") { BooksView() }
    }
}
.tabViewStyle(.sidebarAdaptable)
""")
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            ForEach([
                                ("Tab(title, systemImage:)", "iOS 18 typed tab - cleaner than .tabItem"),
                                ("TabSection(title)", "Groups tabs in sidebar with a header"),
                                (".tabViewStyle(.sidebarAdaptable)", "Sidebar on iPad, tab bar on iPhone"),
                                (".tabViewStyle(.tabBarOnly)", "Forces tab bar on all sizes"),
                            ], id: \.0) { code, detail in
                                HStack(spacing: 8) {
                                    Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.tvBlue)
                                    Spacer()
                                    Text(detail).font(.system(size: 9)).foregroundStyle(.secondary).multilineTextAlignment(.trailing)
                                }
                                .padding(6).background(Color.tvBlueLight.opacity(0.6)).clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
                    }
                }
            }
        }
    }

    func deviceCard(device: String, icon: String, color: Color, description: String, shows: Bool) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 20)).foregroundStyle(color).frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(device).font(.system(size: 12, weight: .semibold)).foregroundStyle(color)
                Text(description).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }
        .padding(10).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func codeBlock(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 9, design: .monospaced))
            .foregroundStyle(Color.tvBlue)
            .padding(10).background(Color.tvBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct TVSidebarExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "iPad sidebar - iOS 18")
            Text(".tabViewStyle(.sidebarAdaptable) makes TabView display as a sidebar on iPad regular-width classes and as a standard tab bar on iPhone. iOS 18 also introduces the typed Tab and TabSection APIs for cleaner sidebar structure.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".tabViewStyle(.sidebarAdaptable) - sidebar on iPad, tab bar on iPhone. One modifier does both.", color: .tvBlue)
                StepRow(number: 2, text: "Tab(\"Title\", systemImage:) { content } - iOS 18 typed tab. Cleaner than .tabItem.", color: .tvBlue)
                StepRow(number: 3, text: "TabSection(\"Section Title\") { Tab; Tab } - groups sidebar items with a section header.", color: .tvBlue)
                StepRow(number: 4, text: ".tabViewStyle(.tabBarOnly) - forces tab bar even on iPad.", color: .tvBlue)
                StepRow(number: 5, text: "@Environment(\\.horizontalSizeClass) - read the current size class to conditionally adapt UI.", color: .tvBlue)
            }

            CalloutBox(style: .info, title: "iOS 17 and earlier", contentBody: "Before iOS 18, NavigationSplitView is the standard pattern for sidebar navigation on iPad. The new .sidebarAdaptable is iOS 18+ only. For broad compatibility, use NavigationSplitView or conditionally check the size class.")

            CodeBlock(code: """
// iOS 18+
TabView {
    Tab("Home", systemImage: "house.fill") {
        HomeView()
    }

    TabSection("Create") {
        Tab("New Post", systemImage: "plus") {
            NewPostView()
        }
        Tab("Camera", systemImage: "camera") {
            CameraView()
        }
    }

    Tab("Profile", systemImage: "person.fill") {
        ProfileView()
    }
}
.tabViewStyle(.sidebarAdaptable)   // sidebar on iPad

// iOS 17 - NavigationSplitView for sidebar
NavigationSplitView {
    SidebarView(selection: $selected)
} detail: {
    DetailView(for: selected)
}
""")
        }
    }
}
