//
//
//  StatebindingTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `01/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - State & Binding Topic
struct StateBindingTopic: TopicProtocol {
    let id          = UUID()
    let title       = "State & Binding"
    let subtitle    = "How SwiftUI views own, share and react to data changes"
    let icon        = "arrow.triangle.2.circlepath.circle.fill"
    let color       = Color(hex: "#FEF3E7")
    let accentColor = Color(hex: "#C2570A")
    let tag         = "Foundations"

    @MainActor
    var lessons: [AnyLesson] {
        StateBindingLessons.all.map { AnyLesson($0) }
    }
}

enum StateBindingLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        SBLesson(number: 1, title: "@State basics",            subtitle: "What @State is and how it drives view re-renders",              icon: "circle.fill",                            visual: AnyView(StateBasicsVisual()),        explanation: AnyView(StateBasicsExplanation())),
        SBLesson(number: 2, title: "State vs plain property",  subtitle: "Why var alone doesn't trigger updates",                        icon: "exclamationmark.triangle.fill",          visual: AnyView(StatePlainVisual()),         explanation: AnyView(StatePlainExplanation())),
        SBLesson(number: 3, title: "@Binding",                 subtitle: "Passing state down - two-way connection between views",         icon: "arrow.left.and.right.circle.fill",       visual: AnyView(BindingVisual()),            explanation: AnyView(BindingExplanation())),
        SBLesson(number: 4, title: "Derived state",            subtitle: "Computed properties and when you don't need @State",            icon: "function",                               visual: AnyView(DerivedStateVisual()),       explanation: AnyView(DerivedStateExplanation())),
        SBLesson(number: 5, title: "@Environment",             subtitle: "System values and injecting shared state through the tree",     icon: "leaf.fill",                              visual: AnyView(EnvironmentVisual()),        explanation: AnyView(EnvironmentExplanation())),
        SBLesson(number: 6, title: "@Observable",              subtitle: "iOS 17+ - the modern replacement for ObservableObject",         icon: "eye.fill",                               visual: AnyView(ObservableVisual()),         explanation: AnyView(ObservableExplanation())),
        SBLesson(number: 7, title: "StateObject vs Observed",  subtitle: "Ownership vs reference - which wrapper to use",                 icon: "person.2.fill",                          visual: AnyView(StateObjectVisual()),        explanation: AnyView(StateObjectExplanation())),
        SBLesson(number: 8, title: "Multiple state sources",   subtitle: "Combining @State, @Binding and @Observable cleanly",            icon: "square.3.layers.3d.top.filled",          visual: AnyView(MultipleSourcesVisual()),    explanation: AnyView(MultipleSourcesExplanation())),
    ]
}

struct SBLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let sbOrange      = Color(hex: "#C2570A")
    static let sbOrangeLight = Color(hex: "#FEF3E7")
}
