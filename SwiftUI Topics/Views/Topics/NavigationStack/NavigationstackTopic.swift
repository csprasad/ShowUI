//
//
//  NavigationstackTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `03/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Navigation Topic
struct NavigationStackTopic: TopicProtocol {
    let id          = UUID()
    let title       = "NavigationStack"
    let subtitle    = "Typed navigation, paths, deep linking, toolbars and split views"
    let icon        = "rectangle.stack.fill"
    let color       = Color(hex: "#EAF0FE")
    let accentColor = Color(hex: "#2251CC")
    let tag         = "Navigation"

    @MainActor
    var lessons: [AnyLesson] {
        NavigationLessons.all.map { AnyLesson($0) }
    }
}

enum NavigationLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        NavLesson(number: 1,  title: "Stack basics",          subtitle: "NavigationStack, NavigationLink and navigationTitle",              icon: "rectangle.stack.fill",                   visual: AnyView(NavBasicsVisual()),          explanation: AnyView(NavBasicsExplanation())),
        NavLesson(number: 2,  title: "Typed navigation",      subtitle: "navigationDestination(for:) and value-based links",               icon: "arrow.right.square.fill",                visual: AnyView(TypedNavVisual()),           explanation: AnyView(TypedNavExplanation())),
        NavLesson(number: 3,  title: "Navigation path",       subtitle: "NavigationPath - programmatic push, pop and replace",             icon: "list.bullet.rectangle.fill",             visual: AnyView(NavPathVisual()),            explanation: AnyView(NavPathExplanation())),
        NavLesson(number: 4,  title: "Deep linking",          subtitle: "Drive navigation from URLs, notifications and widgets",           icon: "link.circle.fill",                       visual: AnyView(DeepLinkVisual()),           explanation: AnyView(DeepLinkExplanation())),
        NavLesson(number: 5,  title: "Navigation bar",        subtitle: "Toolbar, buttons, back button, title display modes",              icon: "menubar.rectangle",                      visual: AnyView(NavBarVisual()),             explanation: AnyView(NavBarExplanation())),
        NavLesson(number: 6,  title: "NavigationSplitView",   subtitle: "Sidebar, two-column and three-column layouts for iPad",           icon: "sidebar.left",                           visual: AnyView(SplitViewVisual()),          explanation: AnyView(SplitViewExplanation())),
        NavLesson(number: 7,  title: "Sheets in navigation",  subtitle: "Combining NavigationStack with sheets and covers cleanly",        icon: "rectangle.on.rectangle.fill",            visual: AnyView(SheetsInNavVisual()),        explanation: AnyView(SheetsInNavExplanation())),
        NavLesson(number: 8,  title: "Common mistakes",       subtitle: "Deprecated patterns, re-render gotchas, path management",         icon: "exclamationmark.triangle.fill",          visual: AnyView(NavMistakesVisual()),        explanation: AnyView(NavMistakesExplanation())),
    ]
}

struct NavLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let navBlue      = Color(hex: "#2251CC")
    static let navBlueLight = Color(hex: "#EAF0FE")
}

// MARK: - Shared mock data used across lessons
struct NavCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let items: [NavItem]
}

struct NavItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
}

extension NavCategory {
    static let samples: [NavCategory] = [
        NavCategory(name: "Swift", icon: "swift", color: .animCoral, items: [
            NavItem(name: "Protocols",      description: "Define blueprints for types",    icon: "doc.plaintext.fill"),
            NavItem(name: "Generics",       description: "Write flexible reusable code",   icon: "arrow.left.and.right.square.fill"),
            NavItem(name: "Concurrency",    description: "async/await and actors",         icon: "arrow.triangle.2.circlepath"),
        ]),
        NavCategory(name: "SwiftUI", icon: "rectangle.3.group.fill", color: .navBlue, items: [
            NavItem(name: "State",          description: "Managing view data",             icon: "circle.fill"),
            NavItem(name: "Layout",         description: "Stacks, grids and geometry",     icon: "square.grid.2x2.fill"),
            NavItem(name: "Animations",     description: "Springs, keyframes and more",    icon: "sparkles"),
        ]),
        NavCategory(name: "Xcode", icon: "hammer.fill", color: .animAmber, items: [
            NavItem(name: "Instruments",    description: "Profiling and performance",      icon: "waveform.path.ecg"),
            NavItem(name: "Previews",       description: "Live canvas previews",           icon: "eye.fill"),
            NavItem(name: "Debugger",       description: "LLDB and breakpoints",           icon: "ant.fill"),
        ]),
    ]
}
