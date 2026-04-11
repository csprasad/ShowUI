//
//
//  6_CustomTabBar.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

private struct CodeCode: View {
    let code: String
    var body: some View { CodeBlock(code: code) }
}

// MARK: - LESSON 6: Custom Tab Bar
enum CustomTab: Int, CaseIterable {
    case home, explore, create, messages, profile
    var icon: String {
        switch self { case .home: "house.fill"; case .explore: "magnifyingglass"; case .create: "plus.circle.fill"; case .messages: "message.fill"; case .profile: "person.fill" }
    }
    var label: String {
        switch self { case .home: "Home"; case .explore: "Explore"; case .create: "Create"; case .messages: "Messages"; case .profile: "Profile" }
    }
    var color: Color {
        switch self { case .home: .tvBlue; case .explore: Color(hex: "#0F766E"); case .create: Color(hex: "#C2410C"); case .messages: Color(hex: "#7C3AED"); case .profile: Color(hex: "#B45309") }
    }
    var isSpecial: Bool { self == .create }
}

struct TVCustomBarVisual: View {
    @State private var selected: CustomTab = .home
    @State private var selectedDemo        = 0
    let demos = ["Floating pill bar", "Icon-only bar", "Highlighted center"]

    let tabColors: [CustomTab: Color] = [.home: .tvBlue, .explore: Color(hex: "#0F766E"), .create: Color(hex: "#C2410C"), .messages: Color(hex: "#7C3AED"), .profile: Color(hex: "#B45309")]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Custom tab bar", systemImage: "dock.rectangle")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tvBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; selected = .home }
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

                // Content area
                ZStack(alignment: .bottom) {
                    // Tab content
                    TabContentView(tab: selected.rawValue + 1, icon: selected.icon, label: selected.label, color: selected.color)
                        .frame(maxWidth: .infinity)
                        .frame(height: selected == .create ? 200 : 240)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .animation(.spring(response: 0.35), value: selected)
                    // Custom tab bar overlay
                    Group {
                        switch selectedDemo {
                        case 0: floatingPillBar
                        case 1: iconOnlyBar
                        default: highlightedCenterBar
                        }
                    }
                    .padding(.bottom, 8)
                }

                Text("""
ZStack(alignment: .bottom) {
    TabContentView()          // content
    customTabBar              // overlaid bar
}
""")
                .font(.system(size: 9, design: .monospaced))
                .foregroundStyle(.secondary)
                .padding(8).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    var floatingPillBar: some View {
        HStack(spacing: 0) {
            ForEach(CustomTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selected = tab }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: tab.icon)
                            .font(.system(size: selected == tab ? 16 : 14))
                            .foregroundStyle(selected == tab ? .white : Color(.systemGray3))
                        if selected == tab {
                            Text(tab.label)
                                .font(.system(size: 8, weight: .semibold))
                                .foregroundStyle(.white)
                                .transition(.opacity.combined(with: .scale(scale: 0.8)))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        selected == tab ?
                        RoundedRectangle(cornerRadius: 20).fill(tab.color) :
                        RoundedRectangle(cornerRadius: 20).fill(Color.clear)
                    )
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selected)
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
        .padding(4)
        .background(.regularMaterial)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
        .padding(.horizontal, 16)
    }

    var iconOnlyBar: some View {
        HStack(spacing: 24) {
            ForEach(CustomTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selected = tab }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20))
                            .foregroundStyle(selected == tab ? tab.color : Color(.systemGray4))
                            .scaleEffect(selected == tab ? 1.15 : 1.0)
                        Circle()
                            .fill(selected == tab ? tab.color : Color.clear)
                            .frame(width: 4, height: 4)
                    }
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selected)
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
        .padding(.horizontal, 20).padding(.vertical, 10)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
        .padding(.horizontal, 20)
    }

    var highlightedCenterBar: some View {
        HStack(spacing: 0) {
            ForEach(CustomTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selected = tab }
                } label: {
                    VStack(spacing: 3) {
                        ZStack {
                            if tab.isSpecial {
                                Circle()
                                    .fill(LinearGradient(colors: [tab.color, tab.color.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 44, height: 44)
                                    .shadow(color: tab.color.opacity(0.4), radius: 8, y: 3)
                                    .offset(y: -10)
                                Image(systemName: tab.icon)
                                    .font(.system(size: 20)).foregroundStyle(.white)
                                    .offset(y: -10)
                            } else {
                                Image(systemName: tab.icon)
                                    .font(.system(size: 18))
                                    .foregroundStyle(selected == tab ? tab.color : Color(.systemGray4))
                                    .scaleEffect(selected == tab ? 1.1 : 1.0)
                                    .animation(.spring(response: 0.25), value: selected)
                            }
                        }
                        if !tab.isSpecial {
                            Text(tab.label).font(.system(size: 9)).foregroundStyle(selected == tab ? tab.color : Color(.systemGray4))
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
        .padding(.top, 8)
        .background(.regularMaterial)
        .shadow(color: .black.opacity(0.08), radius: 8, y: -2)
    }
}

struct TVCustomBarExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Custom tab bar from scratch")
            Text("Build a custom tab bar by hiding the system tab bar with .toolbar(.hidden, for: .tabBar) and overlaying your own HStack with tab buttons inside a ZStack. The content view and custom bar sit in the same ZStack aligned to the bottom.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".toolbar(.hidden, for: .tabBar) - hides the system tab bar so your custom one shows.", color: .tvBlue)
                StepRow(number: 2, text: "ZStack(alignment: .bottom) { content; customBar } - overlay bar on top of content.", color: .tvBlue)
                StepRow(number: 3, text: ".background(.regularMaterial) on the bar - frosted glass that blurs content behind.", color: .tvBlue)
                StepRow(number: 4, text: "Use @State var selected: Tab and if/else or switch for tab content.", color: .tvBlue)
                StepRow(number: 5, text: ".safeAreaInset(edge: .bottom) - alternative to ZStack; insets content above the bar.", color: .tvBlue)
            }

            CalloutBox(style: .info, title: "safeAreaInset vs ZStack", contentBody: "ZStack positions the bar on top of content - content can scroll under it. .safeAreaInset(edge: .bottom) adds the bar height to the bottom safe area so content scrolls just above it. Use safeAreaInset for lists/scrollviews to prevent content hiding behind the bar.")

            CodeBlock(code: """
@State private var selected: Tab = .home

ZStack(alignment: .bottom) {
    // Content for each tab
    switch selected {
    case .home:    HomeView()
    case .explore: ExploreView()
    case .profile: ProfileView()
    }

    // Custom bar
    HStack {
        ForEach(Tab.allCases) { tab in
            Button { selected = tab } label: {
                VStack(spacing: 4) {
                    Image(systemName: selected == tab
                        ? tab.filledIcon : tab.icon)
                        .foregroundStyle(selected == tab ? .blue : .gray)
                    Text(tab.title)
                        .font(.caption2)
                        .foregroundStyle(selected == tab ? .blue : .gray)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    .padding(.vertical, 8)
    .background(.regularMaterial)
}
.ignoresSafeArea(edges: .bottom)
""")
        }
    }
}

