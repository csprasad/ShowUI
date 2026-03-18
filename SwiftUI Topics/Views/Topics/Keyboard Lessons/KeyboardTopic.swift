//
//
//  KeyboardTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Keyboard Topic
struct KeyboardTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Keyboard"
    let subtitle    = "Types, focus, avoidance, validation, toolbars and submit"
    let icon        = "keyboard.fill"
    let color       = Color(hex: "#E6F1FB")
    let accentColor = Color(hex: "#185FA5")
    let tag         = "Input"

    @MainActor
    var lessons: [AnyLesson] {
        KeyboardLessons.all.map { AnyLesson($0) }
    }
}

// MARK: - Lesson List
enum KeyboardLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        KeyboardLesson(
            number: 1,
            title: "Keyboard Types",
            subtitle: "Every UIKeyboardType — when to use each one",
            icon: "keyboard",
            visual: AnyView(KeyboardTypesVisual()),
            explanation: AnyView(KeyboardTypesExplanation())
        ),
        KeyboardLesson(
            number: 2,
            title: "Focus Management",
            subtitle: "FocusState, programmatic focus and multi-field flows",
            icon: "scope",
            visual: AnyView(FocusManagementVisual()),
            explanation: AnyView(FocusManagementExplanation())
        ),
        KeyboardLesson(
            number: 3,
            title: "Keyboard Avoidance",
            subtitle: "How views shift and how to control it",
            icon: "arrow.up.to.line",
            visual: AnyView(KeyboardAvoidanceVisual()),
            explanation: AnyView(KeyboardAvoidanceExplanation())
        ),
        KeyboardLesson(
            number: 4,
            title: "Input Validation",
            subtitle: "React to input in real time, format as the user types",
            icon: "checkmark.shield",
            visual: AnyView(InputValidationVisual()),
            explanation: AnyView(InputValidationExplanation())
        ),
        KeyboardLesson(
            number: 5,
            title: "Keyboard Toolbar",
            subtitle: "Add buttons above the keyboard with ToolbarItemGroup",
            icon: "rectangle.topthird.inset.filled",
            visual: AnyView(KeyboardToolbarVisual()),
            explanation: AnyView(KeyboardToolbarExplanation())
        ),
        KeyboardLesson(
            number: 6,
            title: "Return Key & Submit",
            subtitle: "onSubmit, submitLabel and multi-field form flows",
            icon: "return",
            visual: AnyView(ReturnKeyVisual()),
            explanation: AnyView(ReturnKeyExplanation())
        ),
    ]
}

// MARK: - Concrete Lesson Model
struct KeyboardLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}
