//
//
//  2_ProgrammaticSelection.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Programmatic Selection
struct TVProgrammaticVisual: View {
    @State private var selectedTab   = 0
    @State private var tabPressCount = [0, 0, 0, 0]
    @State private var selectedDemo  = 0
    let demos = ["Switch from code", "Reset on retap", "Deep link"]

    let tabData: [(icon: String, label: String, color: Color)] = [
        ("house.fill",      "Home",    Color.tvBlue),
        ("magnifyingglass", "Search",  Color(hex: "#0F766E")),
        ("bell.fill",       "Alerts",  Color(hex: "#C2410C")),
        ("person.fill",     "Profile", Color(hex: "#7C3AED")),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Programmatic selection", systemImage: "arrow.left.arrow.right.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tvBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; selectedTab = 0; tabPressCount = [0,0,0,0] }
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
                    // Switch from code
                    VStack(spacing: 10) {
                        HStack(spacing: 6) {
                            ForEach(tabData.indices, id: \.self) { i in
                                Button {
                                    withAnimation(.spring(response: 0.35)) { selectedTab = i }
                                } label: {
                                    VStack(spacing: 3) {
                                        Image(systemName: tabData[i].icon)
                                            .font(.system(size: 14))
                                            .foregroundStyle(selectedTab == i ? .white : tabData[i].color)
                                        Text(tabData[i].label)
                                            .font(.system(size: 9, weight: .semibold))
                                            .foregroundStyle(selectedTab == i ? .white : tabData[i].color)
                                    }
                                    .frame(maxWidth: .infinity).padding(.vertical, 7)
                                    .background(selectedTab == i ? tabData[i].color : tabData[i].color.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }

                        TabView(selection: $selectedTab) {
                            ForEach(tabData.indices, id: \.self) { i in
                                TabContentView(tab: i + 1, icon: tabData[i].icon, label: tabData[i].label, color: tabData[i].color)
                                    .tabItem { Label(tabData[i].label, systemImage: tabData[i].icon) }
                                    .tag(i)
                            }
                        }
                        .frame(height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .animation(.spring(response: 0.4), value: selectedTab)
                    }

                case 1:
                    // Reset-on-retap pattern
                    VStack(spacing: 10) {
                        TabView(selection: $selectedTab) {
                            ForEach(tabData.indices, id: \.self) { i in
                                VStack(spacing: 8) {
                                    Text(tabData[i].label).font(.system(size: 16, weight: .bold)).foregroundStyle(tabData[i].color)
                                    Text("Tapped \(tabPressCount[i]) time\(tabPressCount[i] == 1 ? "" : "s")")
                                        .font(.system(size: 12)).foregroundStyle(.secondary)
                                        .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: tabPressCount[i])
                                    Text("Tap same tab again to reset count").font(.system(size: 10)).foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(tabData[i].color.opacity(0.06))
                                .tabItem { Label(tabData[i].label, systemImage: tabData[i].icon) }
                                .tag(i)
                            }
                        }
                        .frame(height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .onChange(of: selectedTab) { old, new in
                            if old == new {
                                // retap - reset
                                withAnimation { tabPressCount[new] = 0 }
                            } else {
                                tabPressCount[new] += 1
                            }
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.tvBlue)
                            Text("onChange(of: selected) { old, new in if old == new { /* retap */ } } - detect retap to scroll-to-top or reset state.")
                                .font(.system(size: 10)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tvBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // Deep link simulation
                    VStack(spacing: 10) {
                        Text("Deep link buttons").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                        HStack(spacing: 8) {
                            deepLinkButton("Open Alerts", tab: 2, icon: "bell.fill", color: .animCoral)
                            deepLinkButton("Open Profile", tab: 3, icon: "person.fill", color: Color(hex: "#7C3AED"))
                        }
                        deepLinkButton("Back to Home", tab: 0, icon: "house.fill", color: .tvBlue)

                        TabView(selection: $selectedTab) {
                            ForEach(tabData.indices, id: \.self) { i in
                                TabContentView(tab: i + 1, icon: tabData[i].icon, label: tabData[i].label, color: tabData[i].color)
                                    .tabItem { Label(tabData[i].label, systemImage: tabData[i].icon) }
                                    .tag(i)
                            }
                        }
                        .frame(height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .animation(.spring(response: 0.4), value: selectedTab)
                    }
                }
            }
        }
    }

    func deepLinkButton(_ label: String, tab: Int, icon: String, color: Color) -> some View {
        Button {
            withAnimation(.spring(response: 0.35)) { selectedTab = tab }
        } label: {
            Label(label, systemImage: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 9)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(PressableButtonStyle())
    }
}

struct TVProgrammaticExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Programmatic tab selection")
            Text("Setting the selection binding to a specific tag value switches tabs from anywhere in the app - from a notification, a deep link, a button. The onChange modifier detects both tab switches and retaps on the current tab.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "selectedTab = .alerts - set the binding anywhere to switch tabs programmatically.", color: .tvBlue)
                StepRow(number: 2, text: ".onChange(of: selection) { old, new in } - fires on every tab change, including retap.", color: .tvBlue)
                StepRow(number: 3, text: "Retap detection: if old == new { scrollToTop() } - standard iOS behaviour on retap.", color: .tvBlue)
                StepRow(number: 4, text: "Deep links: in .onOpenURL or push notification handler, set selectedTab = .target.", color: .tvBlue)
                StepRow(number: 5, text: "Pass the binding via @Binding or @EnvironmentObject down the tree for tabs to switch each other.", color: .tvBlue)
            }

            CalloutBox(style: .success, title: "Retap to scroll-to-top", contentBody: "iOS apps conventionally scroll the active tab's list back to the top when you tap its tab again. Detect this with onChange: if old == new, post a notification or set a flag that the child ScrollView observes.")

            CodeBlock(code: """
enum Tab: Hashable { case home, search, alerts, profile }
@State private var selected: Tab = .home

TabView(selection: $selected) {
    HomeView()
        .tabItem { Label("Home", systemImage: "house") }
        .tag(Tab.home)
    // ...
}
.onChange(of: selected) { old, new in
    if old == new {
        // Retapped current tab
        scrollToTop()           // scroll list to top
        NotificationCenter.default.post(name: .retapHome, object: nil)
    }
}

// Navigate from anywhere
Button("Go to Alerts") {
    selected = .alerts
}

// Deep link
.onOpenURL { url in
    if url.path == "/alerts" { selected = .alerts }
}
""")
        }
    }
}

