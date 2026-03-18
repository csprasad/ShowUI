//
//
//  Protocol.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Lesson Protocol
/// Every individual lesson inside a topic must conform to this.
/// The lesson is fully self-contained — it owns its visual and explanation.
protocol LessonProtocol: Identifiable, Hashable {
    var id: UUID { get }
    var number: Int { get }
    var title: String { get }
    var subtitle: String { get }
    var icon: String { get }
    var visual: AnyView { get }
    var explanation: AnyView { get }
}

// Default Hashable + Equatable based on id so conforming types don't need to implement it
extension LessonProtocol {
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Topic Protocol
/// Every top-level topic (Concurrency, Buttons, etc.) must conform to this.
protocol TopicProtocol: Identifiable {
    var id: UUID { get }
    var title: String { get }
    var subtitle: String { get }
    var icon: String { get }
    var color: Color { get }
    var accentColor: Color { get }
    var tag: String { get }

    /// All lessons belonging to this topic, type-erased so HomeView stays generic
    @MainActor var lessons: [AnyLesson] { get }
}

// MARK: - AnyLesson (type eraser)
/// Wraps any LessonProtocol so TopicDetailView can hold a heterogeneous list
struct AnyLesson: Identifiable, Hashable {
    let id: UUID
    let number: Int
    let title: String
    let subtitle: String
    let icon: String
    let visual: AnyView
    let explanation: AnyView

    @MainActor
    init<L: LessonProtocol>(_ lesson: L) {
        id          = lesson.id
        number      = lesson.number
        title       = lesson.title
        subtitle    = lesson.subtitle
        icon        = lesson.icon
        visual      = lesson.visual
        explanation = lesson.explanation
    }

    static func == (lhs: AnyLesson, rhs: AnyLesson) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
