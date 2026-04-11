//
//
//  TabviewBarsTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - TabView & Tab Bars Topic
struct TabViewBarsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "TabView & Tab Bars"
    let subtitle    = "Tab navigation, paging, badges, customisation and sidebar on iPad"
    let icon        = "square.grid.3x1.below.line.grid.1x2.fill"
    let color       = Color(hex: "#F0F4FE")
    let accentColor = Color(hex: "#1E3A8A")
    let tag         = "Navigation"

    @MainActor
    var lessons: [AnyLesson] {
        TabViewBarsLessons.all.map { AnyLesson($0) }
    }
}

enum TabViewBarsLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        TVLesson(number: 1, title: "TabView basics",         subtitle: "tabItem, selection binding, tag, icons and labels",                  icon: "square.grid.3x1.below.line.grid.1x2.fill", visual: AnyView(TVBasicsVisual()),        explanation: AnyView(TVBasicsExplanation())),
        TVLesson(number: 2, title: "Programmatic selection", subtitle: "Driving tab changes from code, deep links and reset-on-retap",        icon: "arrow.left.arrow.right.circle.fill",        visual: AnyView(TVProgrammaticVisual()),   explanation: AnyView(TVProgrammaticExplanation())),
        TVLesson(number: 3, title: "Badges & appearance",    subtitle: "Tab badges, .tint, toolbar background, scrollEdgeAppearance",        icon: "app.badge.fill",                            visual: AnyView(TVBadgesVisual()),         explanation: AnyView(TVBadgesExplanation())),
        TVLesson(number: 4, title: "PageTabViewStyle",       subtitle: "Horizontal paging, dot indicator, vertical paging, photo scroll",    icon: "rectangle.portrait.on.rectangle.portrait.fill", visual: AnyView(TVPageStyleVisual()), explanation: AnyView(TVPageStyleExplanation())),
        TVLesson(number: 5, title: "Tab with NavigationStack", subtitle: "Embedding navigation per tab, state isolation, back to root",       icon: "rectangle.stack.fill",                      visual: AnyView(TVWithNavVisual()),        explanation: AnyView(TVWithNavExplanation())),
        TVLesson(number: 6, title: "Custom tab bar",         subtitle: "Building a fully custom floating tab bar from scratch",              icon: "dock.rectangle",                            visual: AnyView(TVCustomBarVisual()),      explanation: AnyView(TVCustomBarExplanation())),
        TVLesson(number: 7, title: "iPad sidebar (iOS 18)",  subtitle: "TabSection, sidebarAdaptable, compact vs expanded layout",          icon: "sidebar.leading",                           visual: AnyView(TVSidebarVisual()),        explanation: AnyView(TVSidebarExplanation())),
        TVLesson(number: 8, title: "Tab patterns",           subtitle: "Nested tabs, safe area, keyboard avoidance, common mistakes",        icon: "exclamationmark.triangle.fill",             visual: AnyView(TVPatternsVisual()),       explanation: AnyView(TVPatternsExplanation())),
    ]
}

struct TVLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let tvBlue      = Color(hex: "#1E3A8A")
    static let tvBlueLight = Color(hex: "#F0F4FE")
    static let tvIndigo    = Color(hex: "#3730A3")
}
