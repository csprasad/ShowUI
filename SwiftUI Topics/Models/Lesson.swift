//
//
//  Lesson.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

struct Lesson: Identifiable, Hashable {
    let id = UUID()
    let number: Int
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let accentColor: Color
    let tag: String

    static func == (lhs: Lesson, rhs: Lesson) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Lesson {
    static let all: [Lesson] = [
        Lesson(
            number: 1,
            title: "Sequential Execution",
            subtitle: "Tasks wait in line, one finishes before the next begins",
            icon: "arrow.right.circle.fill",
            color: Color(hex: "#E6F1FB"),
            accentColor: Color(hex: "#185FA5"),
            tag: "Basics"
        ),
        Lesson(
            number: 2,
            title: "Concurrent Execution",
            subtitle: "Tasks run at the same time. total time = the slowest",
            icon: "arrow.triangle.branch",
            color: Color(hex: "#E1F5EE"),
            accentColor: Color(hex: "#0F6E56"),
            tag: "Basics"
        ),
        Lesson(
            number: 3,
            title: "Race Condition",
            subtitle: "Two tasks collide on shared data, causing silent data loss",
            icon: "exclamationmark.triangle.fill",
            color: Color(hex: "#FCEBEB"),
            accentColor: Color(hex: "#A32D2D"),
            tag: "Problem"
        ),
        Lesson(
            number: 4,
            title: "Actors",
            subtitle: "A single-lane bridge that serialises access to shared state",
            icon: "lock.shield.fill",
            color: Color(hex: "#EEEDFE"),
            accentColor: Color(hex: "#534AB7"),
            tag: "Solution"
        ),
        Lesson(
            number: 5,
            title: "async let",
            subtitle: "Start multiple tasks instantly, await them all at once",
            icon: "bolt.horizontal.fill",
            color: Color(hex: "#EAF3DE"),
            accentColor: Color(hex: "#3B6D11"),
            tag: "Patterns"
        ),
        Lesson(
            number: 6,
            title: "Task Groups",
            subtitle: "Spawn a dynamic number of tasks and collect their results",
            icon: "square.grid.2x2.fill",
            color: Color(hex: "#FAEEDA"),
            accentColor: Color(hex: "#854F0B"),
            tag: "Patterns"
        ),
        Lesson(
            number: 7,
            title: "Cancellation",
            subtitle: "Tasks must cooperate and check if work is still needed",
            icon: "stop.circle.fill",
            color: Color(hex: "#FAECE7"),
            accentColor: Color(hex: "#993C1D"),
            tag: "Lifecycle"
        ),
        Lesson(
            number: 8,
            title: "Sendable",
            subtitle: "The compiler enforces what data is safe to cross task boundaries",
            icon: "checkmark.seal.fill",
            color: Color(hex: "#FBEAF0"),
            accentColor: Color(hex: "#993556"),
            tag: "Safety"
        ),
    ]
}
