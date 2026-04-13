//
//
//  EnvironmentDependenciesTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `13/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Environment & Dependencies Topic
struct EnvironmentDependenciesTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Environment & Dependencies"
    let subtitle    = "EnvironmentValues, custom keys, @Observable injection, scene storage, preference keys and DI patterns"
    let icon        = "arrow.down.left.and.arrow.up.right.circle.fill"
    let color       = Color(hex: "#F0FFF4")
    let accentColor = Color(hex: "#0F6E3A")
    let tag         = "Foundations"

    @MainActor
    var lessons: [AnyLesson] {
        EnvironmentDependenciesLessons.all.map { AnyLesson($0) }
    }
}

enum EnvironmentDependenciesLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        EDLesson(number: 1, title: "@Environment built-ins",       subtitle: "colorScheme, locale, calendar, dynamicTypeSize, scenePhase and more",         icon: "square.stack.3d.down.right.fill",      visual: AnyView(BuiltInEnvVisual()),         explanation: AnyView(BuiltInEnvExplanation())),
        EDLesson(number: 2, title: "Custom EnvironmentKey",        subtitle: "EnvironmentKey, EnvironmentValues extension, scoped injection",               icon: "key.horizontal.fill",                  visual: AnyView(CustomEnvKeyVisual()),        explanation: AnyView(CustomEnvKeyExplanation())),
        EDLesson(number: 3, title: "Injecting @Observable models", subtitle: ".environment(model) vs .environmentObject, @Environment(Type.self) reading",  icon: "cpu.fill",                             visual: AnyView(InjectObservableVisual()),    explanation: AnyView(InjectObservableExplanation())),
        EDLesson(number: 4, title: "PreferenceKey deep dive",      subtitle: "Bottom-up data flow - child-to-ancestor communication, anchor prefs",         icon: "arrow.up.to.line.circle.fill",         visual: AnyView(PreferenceKeyDeepVisual()),   explanation: AnyView(PreferenceKeyDeepExplanation())),
        EDLesson(number: 5, title: "@AppStorage & @SceneStorage",  subtitle: "UserDefaults binding, scene state, persistence across launches",              icon: "externaldrive.fill",                   visual: AnyView(StorageVisual()),             explanation: AnyView(StorageExplanation())),
        EDLesson(number: 6, title: "Dependency injection patterns",subtitle: "Protocol-backed DI, service locator, environment-based DI, testability",      icon: "arrow.triangle.branch",               visual: AnyView(DIPatternVisual()),           explanation: AnyView(DIPatternExplanation())),
        EDLesson(number: 7, title: "focusedValue & @FocusedBinding",subtitle: "Keyboard shortcut targets, window-scoped values, focusedSceneValue",        icon: "scope",                                visual: AnyView(FocusedValueVisual()),        explanation: AnyView(FocusedValueExplanation())),
        EDLesson(number: 8, title: "Advanced patterns",            subtitle: "Nested environments, override injection, namespace isolation, pitfalls",       icon: "exclamationmark.triangle.fill",        visual: AnyView(AdvancedEnvVisual()),         explanation: AnyView(AdvancedEnvExplanation())),
    ]
}

struct EDLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let envGreen      = Color(hex: "#0F6E3A")
    static let envGreenLight = Color(hex: "#F0FFF4")
    static let envTeal       = Color(hex: "#0D9488")
}
