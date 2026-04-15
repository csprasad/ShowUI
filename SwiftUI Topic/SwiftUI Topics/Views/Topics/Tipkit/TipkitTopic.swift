//
//
//  TipkitTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import TipKit

// MARK: - TipKit Topic
struct TipKitTopic: TopicProtocol {
    let id          = UUID()
    let title       = "TipKit"
    let subtitle    = "Feature tips, onboarding popovers, inline cards, rules, events and testing"
    let icon        = "lightbulb.circle.fill"
    let color       = Color(hex: "#FFFBF0")
    let accentColor = Color(hex: "#B45309")
    let tag         = "Foundations"

    @MainActor
    var lessons: [AnyLesson] {
        TipKitLessons.all.map { AnyLesson($0) }
    }
}

enum TipKitLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        TKLesson(number: 1, title: "TipKit fundamentals",    subtitle: "What TipKit is, Tips.configure, Tip protocol anatomy, display rules",          icon: "lightbulb.circle.fill",            visual: AnyView(TKFundamentalsVisual()),    explanation: AnyView(TKFundamentalsExplanation())),
        TKLesson(number: 2, title: "TipView - inline tips",  subtitle: "TipView in layouts, custom styling, arrowEdge, .tipViewStyle",                 icon: "rectangle.badge.plus",             visual: AnyView(TKInlineTipVisual()),       explanation: AnyView(TKInlineTipExplanation())),
        TKLesson(number: 3, title: "popoverTip - floating",  subtitle: ".popoverTip() modifier, arrow edge, anchoring to buttons and toolbar items",   icon: "arrow.up.message.fill",            visual: AnyView(TKPopoverTipVisual()),      explanation: AnyView(TKPopoverTipExplanation())),
        TKLesson(number: 4, title: "Display rules",          subtitle: "#Rule macro, MaxDisplayCount, applicationState, invalidation",                  icon: "checklist.checked",                visual: AnyView(TKDisplayRulesVisual()),    explanation: AnyView(TKDisplayRulesExplanation())),
        TKLesson(number: 5, title: "Events & parameters",    subtitle: "Events.donate(), @Parameter, conditional rules, trigger patterns",              icon: "bolt.circle.fill",                 visual: AnyView(TKEventsVisual()),          explanation: AnyView(TKEventsExplanation())),
        TKLesson(number: 6, title: "Tip customisation",      subtitle: "Image, title, message, actions, TipViewStyle, custom layout",                   icon: "paintbrush.pointed.fill",          visual: AnyView(TKCustomisationVisual()),   explanation: AnyView(TKCustomisationExplanation())),
        TKLesson(number: 7, title: "Testing & debugging",    subtitle: "Tips.showAllTipsForTesting(), resetAllTips(), DatastoreLocation, preview tips", icon: "checkmark.seal.fill",              visual: AnyView(TKTestingVisual()),         explanation: AnyView(TKTestingExplanation())),
        TKLesson(number: 8, title: "Patterns & best practices", subtitle: "Tip sequencing, onboarding flows, max tips, analytics, real-world patterns", icon: "star.bubble.fill",                 visual: AnyView(TKPatternsVisual()),        explanation: AnyView(TKPatternsExplanation())),
    ]
}

struct TKLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let tkAmber      = Color(hex: "#B45309")
    static let tkAmberLight = Color(hex: "#FFFBF0")
    static let tkGold       = Color(hex: "#D97706")
}
