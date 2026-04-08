//
//
//  ViewModifiersTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `08/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - ViewModifiers Topic
struct ViewModifiersTopic: TopicProtocol {
    let id          = UUID()
    let title       = "ViewModifiers"
    let subtitle    = "Custom modifiers, modifier order, conditional styling and reuse"
    let icon        = "slider.horizontal.3"
    let color       = Color(hex: "#F0FDF4")
    let accentColor = Color(hex: "#166534")
    let tag         = "Foundations"

    @MainActor
    var lessons: [AnyLesson] {
        ViewModifiersLessons.all.map { AnyLesson($0) }
    }
}

enum ViewModifiersLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        VMLesson(number: 1, title: "What is a modifier",   subtitle: "How modifiers work, the View → View transform and method chaining",    icon: "arrow.forward.circle.fill",          visual: AnyView(WhatIsModifierVisual()),     explanation: AnyView(WhatIsModifierExplanation())),
        VMLesson(number: 2, title: "Modifier order",       subtitle: "Why order matters - padding before background vs after",               icon: "list.number",                        visual: AnyView(ModifierOrderVisual()),      explanation: AnyView(ModifierOrderExplanation())),
        VMLesson(number: 3, title: "Custom ViewModifier",  subtitle: "Conforming to ViewModifier, the body(content:) pattern",               icon: "hammer.fill",                        visual: AnyView(CustomModifierVisual()),     explanation: AnyView(CustomModifierExplanation())),
        VMLesson(number: 4, title: "View extensions",      subtitle: ".myModifier() via extension - ergonomic API for reuse",                icon: "puzzlepiece.extension.fill",         visual: AnyView(ViewExtensionVisual()),      explanation: AnyView(ViewExtensionExplanation())),
        VMLesson(number: 5, title: "Conditional modifiers", subtitle: "if let, ternary, .modifier(condition ? A : B) patterns",              icon: "arrow.triangle.branch",              visual: AnyView(ConditionalModifierVisual()), explanation: AnyView(ConditionalModifierExplanation())),
        VMLesson(number: 6, title: "Environment modifiers", subtitle: "Modifiers that propagate through the view tree to all children",      icon: "leaf.fill",                          visual: AnyView(EnvironmentModifierVisual()), explanation: AnyView(EnvironmentModifierExplanation())),
        VMLesson(number: 7, title: "Modifier composition",  subtitle: "Combining multiple modifiers, ViewModifier + AnimatableModifier",      icon: "square.stack.3d.up.fill",            visual: AnyView(ModifierCompositionVisual()), explanation: AnyView(ModifierCompositionExplanation())),
        VMLesson(number: 8, title: "Built-in modifier deep dive", subtitle: "shadow, overlay, background, clipShape, contentShape patterns", icon: "square.on.square.fill",              visual: AnyView(BuiltInModifierVisual()),    explanation: AnyView(BuiltInModifierExplanation())),
    ]
}

struct VMLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let vmGreen      = Color(hex: "#166534")
    static let vmGreenLight = Color(hex: "#F0FDF4")
}
