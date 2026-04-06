//
//
//  ConcurrencyTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Concurrency Topic
struct ConcurrencyTopic: TopicProtocol {
    let id = UUID()
    let title       = "Concurrency"
    let subtitle    = "Actors, async/await, race conditions, task groups and more"
    let icon        = "arrow.triangle.branch"
    let color       = Color(hex: "#E1F5EE")
    let accentColor = Color(hex: "#0F6E56")
    let tag         = "Concurrency"

    @MainActor
    var lessons: [AnyLesson] {
        ConcurrencyLessons.all.map { AnyLesson($0) }
    }
}

// MARK: - Lesson List
enum ConcurrencyLessons {
    static let all: [any LessonProtocol] = [
        ConcurrencyLesson(
            number: 1,
            title: "Sequential Execution",
            subtitle: "Tasks wait in line - one finishes before the next begins",
            icon: "arrow.right.circle.fill",
            visual: AnyView(SequentialVisual()),
            explanation: AnyView(SequentialExplanation())
        ),
        ConcurrencyLesson(
            number: 2,
            title: "Concurrent Execution",
            subtitle: "Tasks run at the same time - total time = the slowest",
            icon: "arrow.triangle.branch",
            visual: AnyView(ConcurrentVisual()),
            explanation: AnyView(ConcurrentExplanation())
        ),
        ConcurrencyLesson(
            number: 3,
            title: "Race Condition",
            subtitle: "Two tasks collide on shared data - silent data loss",
            icon: "exclamationmark.triangle.fill",
            visual: AnyView(RaceConditionVisual()),
            explanation: AnyView(RaceConditionExplanation())
        ),
        ConcurrencyLesson(
            number: 4,
            title: "Actors",
            subtitle: "A single-lane bridge that serialises access to shared state",
            icon: "lock.shield.fill",
            visual: AnyView(ActorVisual()),
            explanation: AnyView(ActorExplanation())
        ),
        ConcurrencyLesson(
            number: 5,
            title: "async let",
            subtitle: "Start multiple tasks instantly - await them all at once",
            icon: "bolt.horizontal.fill",
            visual: AnyView(AsyncLetVisual()),
            explanation: AnyView(AsyncLetExplanation())
        ),
        ConcurrencyLesson(
            number: 6,
            title: "Task Groups",
            subtitle: "Spawn a dynamic number of tasks and collect their results",
            icon: "square.grid.2x2.fill",
            visual: AnyView(TaskGroupVisual()),
            explanation: AnyView(TaskGroupExplanation())
        ),
        ConcurrencyLesson(
            number: 7,
            title: "Cancellation",
            subtitle: "Tasks must cooperate - check if work is still needed",
            icon: "stop.circle.fill",
            visual: AnyView(CancellationVisual()),
            explanation: AnyView(CancellationExplanation())
        ),
        ConcurrencyLesson(
            number: 8,
            title: "Sendable",
            subtitle: "The compiler enforces what data is safe to cross task boundaries",
            icon: "checkmark.seal.fill",
            visual: AnyView(SendableVisual()),
            explanation: AnyView(SendableExplanation())
        ),
    ]
}

// MARK: - Concrete Lesson Model
struct ConcurrencyLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}
