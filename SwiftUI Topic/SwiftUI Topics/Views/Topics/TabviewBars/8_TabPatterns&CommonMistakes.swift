//
//
//  8_TabPatterns&CommonMistakes.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Tab Patterns & Common Mistakes
struct TVPatternsVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Common mistakes", "Safe area", "Nested tabs"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Tab patterns", systemImage: "exclamationmark.triangle.fill")
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
                    // Mistakes
                    VStack(alignment: .leading, spacing: 8) {
                        mistakeRow(bad: true, code: "NavigationStack { TabView { } }",
                                   issue: "Tab bar hidden behind nav. Always NavigationStack INSIDE each tab.")
                        mistakeRow(bad: true, code: ".tabItem { VStack { Image; Text } }",
                                   issue: "VStack silently ignored. Only Label/Image/Text work in .tabItem.")
                        mistakeRow(bad: true, code: "TabView { }.sheet(…)",
                                   issue: "Sheet on TabView itself can behave unexpectedly. Attach to content.")
                        mistakeRow(bad: true, code: "@State inside TabView root",
                                   issue: "State in the TabView parent re-renders all tabs on change. Use child views.")
                        mistakeRow(bad: false, code: "TabView { Tab1().tabItem { Label(…) }.tag(0) }",
                                   issue: "Correct - individual views with .tabItem and matching .tag")
                        mistakeRow(bad: false, code: "Tab content in NavigationStack with own path",
                                   issue: "Correct - isolation keeps each tab's nav state independent")
                    }

                case 1:
                    // Safe area handling
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 10) {
                            // Without safe area fix
                            VStack(spacing: 4) {
                                Text("Wrong").font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.animCoral)
                                ZStack(alignment: .bottom) {
                                    RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground)).frame(height: 110)
                                    VStack(spacing: 0) {
                                        ForEach(0..<4, id: \.self) { _ in
                                            RoundedRectangle(cornerRadius: 4).fill(Color(.systemFill)).frame(height: 16).padding(.horizontal, 8).padding(.vertical, 1)
                                        }
                                        // Bar overlaps last item
                                        RoundedRectangle(cornerRadius: 0).fill(Color(.systemGray5)).frame(height: 32)
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text("Last item hidden").font(.system(size: 8)).foregroundStyle(Color.animCoral)
                            }
                            .frame(maxWidth: .infinity)

                            // With safe area
                            VStack(spacing: 4) {
                                Text("Correct").font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.formGreen)
                                ZStack(alignment: .bottom) {
                                    RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground)).frame(height: 110)
                                    VStack(spacing: 0) {
                                        ForEach(0..<4, id: \.self) { _ in
                                            RoundedRectangle(cornerRadius: 4).fill(Color(.systemFill)).frame(height: 16).padding(.horizontal, 8).padding(.vertical, 1)
                                        }
                                        Spacer().frame(height: 32) // safe area inset
                                    }
                                    RoundedRectangle(cornerRadius: 0).fill(Color(.systemGray5)).frame(height: 32)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text("Content clears bar").font(.system(size: 8)).foregroundStyle(Color.formGreen)
                            }
                            .frame(maxWidth: .infinity)
                        }

                        ForEach([
                            ("ScrollView scrolls under tab bar automatically", true),
                            ("List adds bottom inset automatically", true),
                            ("Custom views need .safeAreaInset or .ignoresSafeArea carefully", false),
                            ("Custom tab bar needs .safeAreaInset(edge: .bottom)", false),
                        ], id: \.0) { text, isAuto in
                            HStack(spacing: 6) {
                                Image(systemName: isAuto ? "checkmark.circle.fill" : "info.circle.fill")
                                    .font(.system(size: 11)).foregroundStyle(isAuto ? Color.formGreen : Color.tvBlue)
                                Text(text).font(.system(size: 11)).foregroundStyle(.secondary)
                            }
                        }
                        .padding(8).background(Color.tvBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // Nested tabs concept
                    VStack(spacing: 8) {
                        Text("Avoid deeply nested tabs - confusing UX").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 6) {
                            patternRow(good: true,  text: "TabView at root level - 3-5 tabs max")
                            patternRow(good: true,  text: "NavigationStack inside each tab for depth")
                            patternRow(good: false, text: "TabView inside TabView - two tab bars at once")
                            patternRow(good: false, text: "More than 5 tabs - truncated with 'More' by system")
                            patternRow(good: true,  text: "Modal sheet from tab for temporary flows")
                            patternRow(good: true,  text: "One tab can contain a segmented picker for sub-sections")
                        }

                        // PageTabViewStyle as nested tabs alternative
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Alternative: PageTabViewStyle for sub-tabs").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.tvBlue)
                            Text("Put a .page style TabView inside a tab's NavigationStack for a horizontal swipe sub-section - clean and native-feeling.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tvBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    func mistakeRow(bad: Bool, code: String, issue: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: bad ? "xmark.circle.fill" : "checkmark.circle.fill")
                .font(.system(size: 13))
                .foregroundStyle(bad ? Color.animCoral : Color.formGreen)
                .padding(.top, 1)
            VStack(alignment: .leading, spacing: 2) {
                Text(code)
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(bad ? Color.animCoral : Color.formGreen)
                Text(issue).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }
        .padding(8)
        .background(bad ? Color(hex: "#FCEBEB") : Color(hex: "#E1F5EE"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func patternRow(good: Bool, text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: good ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 12))
                .foregroundStyle(good ? Color.formGreen : Color.animCoral)
            Text(text).font(.system(size: 11)).foregroundStyle(.secondary)
        }
    }
}

struct TVPatternsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Tab patterns and pitfalls")
            Text("TabView is straightforward but has several common mistakes. Navigation inside tabs, tab item content restrictions, safe area handling, and the tab-count limit all trip up developers new to SwiftUI tabs.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Never wrap TabView in NavigationStack - tab bar disappears on push. NavigationStack goes inside.", color: .tvBlue)
                StepRow(number: 2, text: ".tabItem only accepts Label, Text, Image - VStack, HStack etc. silently render nothing.", color: .tvBlue)
                StepRow(number: 3, text: "5 tabs max - system shows 'More' beyond 5 on iPhone. If you need more, reconsider IA.", color: .tvBlue)
                StepRow(number: 4, text: "Safe area: ScrollView and List automatically inset for the tab bar. Custom layouts need care.", color: .tvBlue)
                StepRow(number: 5, text: "Tab state is preserved - switching away and back keeps the tab's view alive (good for performance).", color: .tvBlue)
            }

            CalloutBox(style: .warning, title: "5-tab limit", contentBody: "iOS truncates tabs beyond 5 with a 'More' row - an older UIKit behaviour that still applies in SwiftUI. If your app needs more than 5 sections, consider a sidebar (iPad), NavigationSplitView, or restructuring the information architecture.")

            CodeBlock(code: """
// ✓ The correct full structure
@State private var tab: Tab = .home
@State private var homePath = NavigationPath()

TabView(selection: $tab) {
    NavigationStack(path: $homePath) {
        HomeView()
            .navigationDestination(for: Item.self) { item in
                ItemDetail(item: item)
            }
    }
    .tabItem { Label("Home", systemImage: "house.fill") }
    .tag(Tab.home)

    SearchView()
        .tabItem { Label("Search", systemImage: "magnifyingglass") }
        .tag(Tab.search)
}
.tint(.blue)
.onChange(of: tab) { old, new in
    if old == .home && new == .home {
        homePath = NavigationPath()  // scroll/pop to root
    }
}
""")
        }
    }
}
