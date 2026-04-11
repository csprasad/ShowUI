//
//
//  1_TabViewBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Shared tab demo content
struct TabContentView: View {
    let tab: Int
    let icon: String
    let label: String
    let color: Color

    var body: some View {
        ZStack {
            color.opacity(0.08).ignoresSafeArea()
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundStyle(color)
                Text(label)
                    .font(.system(size: 14, weight: .bold))
                Text("Tab \(tab) content")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - LESSON 1: TabView Basics
struct TVBasicsVisual: View {
    @State private var selectedTab = 0
    @State private var selectedDemo = 0
    let demos = ["Basic TabView", "Icon variants", "Label only"]

    let tabData: [(icon: String, label: String, color: Color)] = [
        ("house.fill",       "Home",     Color.tvBlue),
        ("magnifyingglass",  "Search",   Color(hex: "#0F766E")),
        ("bell.fill",        "Alerts",   Color(hex: "#C2410C")),
        ("person.fill",      "Profile",  Color(hex: "#7C3AED")),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("TabView basics", systemImage: "square.grid.3x1.below.line.grid.1x2.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tvBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; selectedTab = 0 }
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
                    // Full working TabView
                    TabView(selection: $selectedTab) {
                        ForEach(tabData.indices, id: \.self) { i in
                            TabContentView(tab: i + 1, icon: tabData[i].icon, label: tabData[i].label, color: tabData[i].color)
                                .tabItem {
                                    Label(tabData[i].label, systemImage: tabData[i].icon)
                                }
                                .tag(i)
                        }
                    }
                    .frame(height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemFill), lineWidth: 0.5))

                case 1:
                    // Icon variants explained
                    VStack(spacing: 10) {
                        infoRow("Label(\"Title\", systemImage: \"icon\")", detail: "icon + text - most common ✓")
                        infoRow("Image(systemName: \"icon\")", detail: "icon only - iOS auto-adds title from accessibility")
                        infoRow("Text(\"Title\")", detail: "text only - unusual but valid")
                        infoRow("Label { } icon: { }", detail: "fully custom label content")
                        Divider()
                        TabView(selection: $selectedTab) {
                            Color.tvBlueLight.tabItem { Label("Home", systemImage: "house.fill") }.tag(0)
                            Color(hex: "#F0FDF4").tabItem { Image(systemName: "magnifyingglass") }.tag(1)
                            Color(hex: "#FFF7ED").tabItem { Text("Person") }.tag(2)
                        }
                        .frame(height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                default:
                    // Label-only anatomy
                    VStack(spacing: 10) {
                        TabView(selection: $selectedTab) {
                            ForEach(tabData.indices, id: \.self) { i in
                                Color(tabData[i].color).opacity(0.1)
                                    .tabItem { Label(tabData[i].label, systemImage: tabData[i].icon) }
                                    .tag(i)
                            }
                        }
                        .frame(height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.tvBlue)
                            Text("Each tab needs a unique .tag(). The selection binding type must match the tag type - use Int, String or an enum.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tvBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    func infoRow(_ code: String, detail: String) -> some View {
        HStack(spacing: 8) {
            Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.tvBlue)
            Spacer()
            Text(detail).font(.system(size: 10)).foregroundStyle(.secondary).multilineTextAlignment(.trailing)
        }
        .padding(7).background(Color.tvBlueLight.opacity(0.6)).clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct TVBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "TabView - the basics")
            Text("TabView presents multiple tabs with a tab bar at the bottom. Each child view declares its tab appearance via .tabItem { } and its identifier via .tag(). A selection binding lets you read and set the active tab programmatically.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "TabView(selection: $tab) { } - wraps all tab views. selection binding is optional if you don't need to control tabs.", color: .tvBlue)
                StepRow(number: 2, text: ".tabItem { Label(\"Title\", systemImage: \"icon\") } - declares the tab bar item. Only Label, Text and Image are supported.", color: .tvBlue)
                StepRow(number: 3, text: ".tag(0) - unique identifier for each tab. Must match the selection binding's type.", color: .tvBlue)
                StepRow(number: 4, text: "SwiftUI renders the tab bar automatically - no layout code needed.", color: .tvBlue)
                StepRow(number: 5, text: "Only Label, Text, and Image work inside .tabItem { }. Other views are silently ignored.", color: .tvBlue)
            }

            CalloutBox(style: .warning, title: ".tabItem only accepts Label, Text or Image", contentBody: "Only Label(title:systemImage:), Text, and Image work inside .tabItem. Any other view - VStack, HStack, custom views - is silently ignored. For custom tab bars, build your own (Lesson 6).")

            CodeBlock(code: """
enum Tab { case home, search, profile }
@State private var selected: Tab = .home

TabView(selection: $selected) {
    HomeView()
        .tabItem { Label("Home", systemImage: "house.fill") }
        .tag(Tab.home)

    SearchView()
        .tabItem { Label("Search", systemImage: "magnifyingglass") }
        .tag(Tab.search)

    ProfileView()
        .tabItem { Label("Profile", systemImage: "person.fill") }
        .tag(Tab.profile)
}
// No selection binding - just navigational
TabView {
    HomeView().tabItem { Label("Home", systemImage: "house") }
    SearchView().tabItem { Label("Search", systemImage: "magnifyingglass") }
}
""")
        }
    }
}
