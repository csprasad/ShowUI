//
//
//  ObservablestateTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Observation

// MARK: - @Observable & @State Deep Dive Topic
struct ObservableStateTopic: TopicProtocol {
    let id          = UUID()
    let title       = "@Observable & @State"
    let subtitle    = "State ownership, observation, bindings, environment and the new Observation framework"
    let icon        = "circle.dashed.inset.filled"
    let color       = Color(hex: "#F0FDF4")
    let accentColor = Color(hex: "#15803D")
    let tag         = "Foundations"

    @MainActor
    var lessons: [AnyLesson] {
        ObservableStateLessons.all.map { AnyLesson($0) }
    }
}

enum ObservableStateLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        OSLesson(number: 1, title: "@State fundamentals",      subtitle: "What @State owns, value vs reference, lifecycle, when views re-render",    icon: "circle.dashed.inset.filled",          visual: AnyView(StateFoundationsVisual()),    explanation: AnyView(StateFoundationsExplanation())),
        OSLesson(number: 2, title: "@Binding deep dive",       subtitle: "Two-way binding, Binding(get:set:), parent-child communication",            icon: "arrow.left.arrow.right.circle.fill",  visual: AnyView(BindingDeepDiveVisual()),     explanation: AnyView(BindingDeepDiveExplanation())),
        OSLesson(number: 3, title: "@Observable basics",       subtitle: "The new Observation framework - @Observable vs ObservableObject",          icon: "eye.circle.fill",                     visual: AnyView(ObservableBasicsVisual()),    explanation: AnyView(ObservableBasicsExplanation())),
        OSLesson(number: 4, title: "Fine-grained observation", subtitle: "Per-property tracking, access patterns, avoiding unnecessary renders",      icon: "line.diagonal.arrow",                 visual: AnyView(FineGrainedVisual()),         explanation: AnyView(FineGrainedExplanation())),
        OSLesson(number: 5, title: "@State with @Observable",  subtitle: "@State var model = MyModel() - ownership and lifetime in SwiftUI",          icon: "square.and.pencil.circle.fill",       visual: AnyView(StateWithObservableVisual()), explanation: AnyView(StateWithObservableExplanation())),
        OSLesson(number: 6, title: "@Environment with models", subtitle: ".environment(model) - injecting @Observable into the view tree",            icon: "arrow.down.left.and.arrow.up.right.circle.fill", visual: AnyView(EnvironmentModelsVisual()), explanation: AnyView(EnvironmentModelsExplanation())),
        OSLesson(number: 7, title: "Old vs new patterns",      subtitle: "ObservableObject + @StateObject/@ObservedObject vs the new Observation",   icon: "arrow.triangle.2.circlepath",         visual: AnyView(OldVsNewVisual()),            explanation: AnyView(OldVsNewExplanation())),
        OSLesson(number: 8, title: "Patterns & pitfalls",      subtitle: "Render budgets, identity, derived state, common mistakes and solutions",    icon: "exclamationmark.triangle.fill",       visual: AnyView(ObsPatternsVisual()),         explanation: AnyView(ObsPatternsExplanation())),
    ]
}

struct OSLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let obsGreen      = Color(hex: "#15803D")
    static let obsGreenLight = Color(hex: "#F0FDF4")
    static let obsEmerald    = Color(hex: "#059669")
    static let obsEmeraldLight = Color(hex: "#E8F8E8")
    static let obsMint = Color(hex: "#4ADE80")
}
