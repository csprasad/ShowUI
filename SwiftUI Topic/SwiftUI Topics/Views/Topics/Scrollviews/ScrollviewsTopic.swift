//
//
//  ScrollviewsTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - ScrollView Topic
struct ScrollViewsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "ScrollView & Scroll APIs"
    let subtitle    = "Scroll axes, offsets, paging, transitions, targets and scroll position"
    let icon        = "scroll.fill"
    let color       = Color(hex: "#FFF7ED")
    let accentColor = Color(hex: "#C2410C")
    let tag         = "Layout"

    @MainActor
    var lessons: [AnyLesson] {
        ScrollViewsLessons.all.map { AnyLesson($0) }
    }
}

enum ScrollViewsLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        SVLesson(number: 1, title: "ScrollView basics",       subtitle: "Axes, indicators, bounce, content insets and nested scroll",       icon: "scroll.fill",                        visual: AnyView(ScrollBasicsVisual()),        explanation: AnyView(ScrollBasicsExplanation())),
        SVLesson(number: 2, title: "scrollTransition",        subtitle: "Animate views as they enter and leave the visible region",         icon: "sparkles.rectangle.stack.fill",      visual: AnyView(ScrollTransitionVisual()),    explanation: AnyView(ScrollTransitionExplanation())),
        SVLesson(number: 3, title: "scrollTargetBehavior",    subtitle: "Paging, viewAligned snapping and custom scroll targets",           icon: "hand.point.right.fill",              visual: AnyView(ScrollTargetVisual()),        explanation: AnyView(ScrollTargetExplanation())),
        SVLesson(number: 4, title: "ScrollPosition",          subtitle: "Programmatic scroll - scrollTo, scrollPosition binding",           icon: "arrow.up.to.line.circle.fill",       visual: AnyView(ScrollPositionVisual()),      explanation: AnyView(ScrollPositionExplanation())),
        SVLesson(number: 5, title: "Scroll offset",           subtitle: "Reading scroll position via PreferenceKey and ScrollGeometry",     icon: "gauge.with.dots.needle.67percent",   visual: AnyView(ScrollOffsetVisual()),        explanation: AnyView(ScrollOffsetExplanation())),
        SVLesson(number: 6, title: "visualEffect",            subtitle: "Per-cell effects using geometry proxy - parallax, scale, blur",    icon: "wand.and.rays",                      visual: AnyView(VisualEffectVisual()),        explanation: AnyView(VisualEffectExplanation())),
        SVLesson(number: 7, title: "safeAreaInset",           subtitle: "Float views above scroll content without obscuring last items",    icon: "rectangle.bottomthird.inset.filled", visual: AnyView(SafeAreaInsetVisual()),       explanation: AnyView(SafeAreaInsetExplanation())),
        SVLesson(number: 8, title: "Scroll modifiers",        subtitle: "scrollClipDisabled, scrollBounceBehavior, scrollDismissesKeyboard", icon: "ellipsis.rectangle.fill",            visual: AnyView(ScrollModifiersVisual()),     explanation: AnyView(ScrollModifiersExplanation())),
    ]
}

struct SVLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let scrollOrange      = Color(hex: "#C2410C")
    static let scrollOrangeLight = Color(hex: "#FFF7ED")
}

// MARK: - Shared scroll sample data
struct ScrollCard: Identifiable {
    let id = UUID()
    let index: Int
    var color: Color { scrollCardColors[index % scrollCardColors.count] }
    var label: String { "Card \(index + 1)" }
}

let scrollCardColors: [Color] = [
    Color(hex: "#C2410C"), Color(hex: "#1D4ED8"), Color(hex: "#0F766E"),
    Color(hex: "#7E22CE"), Color(hex: "#B45309"), Color(hex: "#BE123C"),
]

extension ScrollCard {
    static func samples(_ n: Int) -> [ScrollCard] { (0..<n).map { ScrollCard(index: $0) } }
}
