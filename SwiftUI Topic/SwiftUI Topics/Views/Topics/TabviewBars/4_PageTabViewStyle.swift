//
//
//  4_PageTabViewStyle.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: PageTabViewStyle
struct TVPageStyleVisual: View {
    @State private var currentPage  = 0
    @State private var selectedDemo = 0
    let demos = ["Horizontal", "Indicator styles", "Vertical"]

    let pages: [(color: Color, icon: String, title: String)] = [
        (.tvBlue,            "house.fill",         "Welcome Home"),
        (Color(hex: "#0F766E"), "leaf.fill",        "Nature"),
        (Color(hex: "#C2410C"), "flame.fill",       "Hot Topics"),
        (Color(hex: "#7C3AED"), "star.fill",        "Featured"),
        (Color(hex: "#1E40AF"), "globe.americas",   "World"),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("PageTabViewStyle", systemImage: "rectangle.portrait.on.rectangle.portrait.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tvBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; currentPage = 0 }
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
                    // Horizontal paging
                    VStack(spacing: 8) {
                        TabView(selection: $currentPage) {
                            ForEach(pages.indices, id: \.self) { i in
                                ZStack {
                                    pages[i].color
                                    VStack(spacing: 8) {
                                        Image(systemName: pages[i].icon).font(.system(size: 32)).foregroundStyle(.white)
                                        Text(pages[i].title).font(.system(size: 16, weight: .bold)).foregroundStyle(.white)
                                        Text("\(i + 1) of \(pages.count)").font(.system(size: 11)).foregroundStyle(.white.opacity(0.7))
                                    }
                                }
                                .tag(i)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                        HStack(spacing: 8) {
                            Button("← Prev") {
                                withAnimation { currentPage = max(0, currentPage - 1) }
                            }.disabled(currentPage == 0).foregroundStyle(Color.tvBlue).buttonStyle(PressableButtonStyle())
                            Text("Page \(currentPage + 1)/\(pages.count)")
                                .font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary)
                            Button("Next →") {
                                withAnimation { currentPage = min(pages.count - 1, currentPage + 1) }
                            }.disabled(currentPage == pages.count - 1).foregroundStyle(Color.tvBlue).buttonStyle(PressableButtonStyle())
                        }
                        .frame(maxWidth: .infinity)
                    }

                case 1:
                    // Dot indicator modes
                    VStack(spacing: 10) {
                        let modes: [(String, PageTabViewStyle.IndexDisplayMode)] = [
                            ("always", .always), ("never", .never), ("automatic", .automatic)
                        ]
                        ForEach(modes, id: \.0) { name, mode in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("indexDisplayMode: .\(name)")
                                    .font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(.secondary)
                                TabView(selection: $currentPage) {
                                    ForEach(pages.indices, id: \.self) { i in
                                        pages[i].color.tag(i)
                                    }
                                }
                                .tabViewStyle(.page(indexDisplayMode: mode))
                                .indexViewStyle(.page(backgroundDisplayMode: .always))
                                .frame(height: 44)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }

                default:
                    // Vertical paging - simulate with rotation
                    VStack(spacing: 8) {
                        TabView(selection: $currentPage) {
                            ForEach(pages.indices, id: \.self) { i in
                                ZStack {
                                    pages[i].color
                                    VStack(spacing: 8) {
                                        Image(systemName: pages[i].icon).font(.system(size: 28)).foregroundStyle(.white)
                                        Text(pages[i].title).font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
                                    }
                                }
                                .rotationEffect(.degrees(-90))
                                .tag(i)
                            }
                        }
                        .tabViewStyle(.page)
                        .frame(height: 160)
                        .rotationEffect(.degrees(90))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .frame(maxWidth: .infinity)

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.tvBlue)
                            Text("Vertical paging: rotate TabView +90° and each page -90°. iOS 17 adds native .page.vertical axis.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tvBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                }
            }
        }
    }
}

struct TVPageStyleExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "PageTabViewStyle")
            Text(".tabViewStyle(.page) transforms TabView into a swipeable pager with dot indicators. No tab bar is shown. It's the standard pattern for onboarding flows, photo carousels, and story-style screens.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".tabViewStyle(.page) - horizontal swipe pager. Tab bar replaced with dot indicators.", color: .tvBlue)
                StepRow(number: 2, text: ".tabViewStyle(.page(indexDisplayMode: .always / .never / .automatic))", color: .tvBlue)
                StepRow(number: 3, text: ".indexViewStyle(.page(backgroundDisplayMode: .always)) - pill background behind dots.", color: .tvBlue)
                StepRow(number: 4, text: "Bind selection to navigate programmatically - perfect for Next/Skip buttons in onboarding.", color: .tvBlue)
                StepRow(number: 5, text: "iOS 17: .tabViewStyle(.page(verticalPage)) - native vertical paging (TikTok-style).", color: .tvBlue)
            }

            CalloutBox(style: .success, title: "PageTabViewStyle for onboarding", contentBody: "The canonical pattern: TabView(selection: $page) with .tabViewStyle(.page), a Page N/Total counter, and Next/Skip buttons that set page = page + 1 or page = total. Much cleaner than the old UIPageViewController.")

            CodeBlock(code: """
@State private var page = 0
let pages = OnboardingPage.allCases

TabView(selection: $page) {
    ForEach(pages.indices, id: \\.self) { i in
        OnboardingPageView(page: pages[i])
            .tag(i)
    }
}
.tabViewStyle(.page(indexDisplayMode: .always))
.indexViewStyle(.page(backgroundDisplayMode: .always))

// Navigation buttons
HStack {
    Button("Skip") { page = pages.count - 1 }
    Spacer()
    Button("Next") { page = min(page + 1, pages.count - 1) }
}

// iOS 17 vertical paging
.tabViewStyle(.page(verticalPage))
""")
        }
    }
}

