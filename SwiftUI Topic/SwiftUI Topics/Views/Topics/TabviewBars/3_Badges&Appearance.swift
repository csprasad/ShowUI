//
//
//  3_Badges&Appearance.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Badges & Appearance
struct TVBadgesVisual: View {
    @State private var selectedTab  = 0
    @State private var notifCount   = 3
    @State private var msgCount     = 12
    @State private var showDot      = true
    @State private var selectedDemo = 0
    let demos = ["Tab badges", "Tint & color", "Appearance"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Badges & appearance", systemImage: "app.badge.fill")
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
                    // Badges
                    VStack(spacing: 12) {
                        HStack(spacing: 10) {
                            badgeControl("Notifs", count: $notifCount)
                            badgeControl("Messages", count: $msgCount)
                            VStack(spacing: 4) {
                                Text("Dot").font(.system(size: 10)).foregroundStyle(.secondary)
                                Toggle("", isOn: $showDot).tint(.tvBlue).labelsHidden()
                                Text("\(showDot ? "On" : "Off")").font(.system(size: 14)).foregroundStyle(.secondary)
                            }
                        }

                        TabView(selection: $selectedTab) {
                            Color.tvBlueLight
                                .tabItem { Label("Home", systemImage: "house.fill") }
                                .tag(0)

                            Color(hex: "#FEF2F2")
                                .tabItem { Label("Alerts", systemImage: "bell.fill") }
                                .badge(notifCount > 0 ? notifCount : 0)
                                .tag(1)

                            Color(hex: "#F0FDF4")
                                .tabItem { Label("Messages", systemImage: "message.fill") }
                                .badge(msgCount > 0 ? "\(msgCount)" : nil)
                                .tag(2)

                            Color(hex: "#FFF7ED")
                                .tabItem { Label("Updates", systemImage: "arrow.clockwise.circle.fill") }
                                .badge(showDot ? "" : nil)
                                .tag(3)
                        }
                        .frame(height: 85)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .animation(.spring(response: 0.3), value: notifCount)
                        .animation(.spring(response: 0.3), value: msgCount)
                    }

                case 1:
                    // Tint variations
                    VStack(spacing: 10) {
                        ForEach([
                            (Color.tvBlue,  "Blue (default)"),
                            (.formGreen,    "Green"),
                            (.animCoral,    "Coral"),
                            (.animAmber,    "Amber"),
                            (Color(hex: "#7C3AED"), "Purple"),
                        ], id: \.1) { color, name in
                            HStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: 4).fill(color).frame(width: 20, height: 12)
                                Text(name).font(.system(size: 12))
                                Spacer()
                                Text(".tint(\(name.lowercased()))")
                                    .font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                            }
                            .padding(8).background(color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        TabView(selection: $selectedTab) {
                            Color.tvBlueLight.tabItem { Label("Tab 1", systemImage: "1.circle.fill") }.tag(0)
                            Color(hex: "#F0FDF4").tabItem { Label("Tab 2", systemImage: "2.circle.fill") }.tag(1)
                            Color(hex: "#FFF7ED").tabItem { Label("Tab 3", systemImage: "3.circle.fill") }.tag(2)
                        }
                        .tint(.tvBlue)
                        .frame(height: 85)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                default:
                    // Appearance diagram
                    VStack(spacing: 8) {
                        appearanceRow(".tint(color)", detail: "Active tab icon + label tint color")
                        appearanceRow(".badge(Int/String)", detail: "Red badge on tab item")
                        appearanceRow(".badge(nil)", detail: "Removes badge")
                        appearanceRow("TabBarItem.appearance()", detail: "UIKit bridge for advanced styling")
                        appearanceRow(".toolbarBackground(.visible, for: .tabBar)", detail: "Force tab bar background visible")
                        appearanceRow(".toolbarBackground(.hidden, for: .tabBar)", detail: "Hide tab bar background")

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.tvBlue)
                            Text(".badge is applied to each tab view, not to the TabView itself.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tvBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    func badgeControl(_ label: String, count: Binding<Int>) -> some View {
        VStack(spacing: 4) {
            Text(label).font(.system(size: 10)).foregroundStyle(.secondary)
            Stepper("", value: count, in: 0...99).labelsHidden()
            Text("\(count.wrappedValue)").font(.system(size: 14, weight: .bold, design: .monospaced)).foregroundStyle(Color.tvBlue)
                .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: count.wrappedValue)
        }
    }

    func appearanceRow(_ code: String, detail: String) -> some View {
        HStack(spacing: 8) {
            Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.tvBlue)
            Spacer()
            Text(detail).font(.system(size: 10)).foregroundStyle(.secondary).multilineTextAlignment(.trailing)
        }
        .padding(7).background(Color.tvBlueLight.opacity(0.6)).clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct TVBadgesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Badges and tab bar appearance")
            Text(".badge modifier adds the red notification count to a tab. .tint controls the active tab color. toolbarBackground modifiers let you control visibility and material of the tab bar itself.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".badge(count) - Int badge on tab item. .badge(nil) removes it. Applied to each tab view.", color: .tvBlue)
                StepRow(number: 2, text: ".badge(\"New\") - String badge. Use \"+99\" for capped counts or \"·\" for a dot.", color: .tvBlue)
                StepRow(number: 3, text: ".tint(color) on TabView - changes the active icon and label color for all tabs.", color: .tvBlue)
                StepRow(number: 4, text: ".toolbarBackground(.visible, for: .tabBar) - force background visible even when scrolled to top.", color: .tvBlue)
                StepRow(number: 5, text: ".toolbarBackground(Material, for: .tabBar) - custom material (blur) for tab bar background.", color: .tvBlue)
            }

            CalloutBox(style: .info, title: ".badge on the tab view, not TabView", contentBody: ".badge is applied to the child view inside TabView: HomeView().badge(3), not TabView { }.badge(3). Each tab item gets its own badge independently.")

            CodeBlock(code: """
TabView(selection: $selected) {
    HomeView()
        .tabItem { Label("Home", systemImage: "house") }
        .tag(Tab.home)
        // No badge needed

    AlertsView()
        .tabItem { Label("Alerts", systemImage: "bell") }
        .badge(unreadCount > 0 ? unreadCount : nil)
        .tag(Tab.alerts)

    MessageView()
        .tabItem { Label("Messages", systemImage: "message") }
        .badge(unreadCount > 99 ? "+99" : "\\(unreadCount)")
        .tag(Tab.messages)
}
.tint(.blue)       // active tab color

// Tab bar appearance
.toolbarBackground(.visible, for: .tabBar)
.toolbarBackground(.regularMaterial, for: .tabBar)
.toolbarColorScheme(.dark, for: .tabBar)
""")
        }
    }
}
