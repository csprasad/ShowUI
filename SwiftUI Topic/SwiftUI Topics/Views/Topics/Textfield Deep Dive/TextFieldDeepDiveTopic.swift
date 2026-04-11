//
//
//  TextFieldDeepDiveTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - TextField Deep Dive Topic
struct TextFieldDeepDiveTopic: TopicProtocol {
    let id          = UUID()
    let title       = "TextField Deep Dive"
    let subtitle    = "Focus, formatting, validation, keyboard, secure fields and custom styles"
    let icon        = "text.cursor"
    let color       = Color(hex: "#FFF7ED")
    let accentColor = Color(hex: "#C2410C")
    let tag         = "Controls"

    @MainActor
    var lessons: [AnyLesson] {
        TextFieldDeepDiveLessons.all.map { AnyLesson($0) }
    }
}

enum TextFieldDeepDiveLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        TFLesson(number: 1, title: "TextField basics",         subtitle: "String binding, prompt, axis, lineLimit, truncation and label",           icon: "text.cursor",                         visual: AnyView(TFBasicsVisual()),        explanation: AnyView(TFBasicsExplanation())),
        TFLesson(number: 2, title: "FocusState & focus chain", subtitle: "@FocusState, .focused(), submitLabel, onSubmit, focus chaining",          icon: "arrow.right.to.line",                 visual: AnyView(FocusChainVisual()),      explanation: AnyView(FocusChainExplanation())),
        TFLesson(number: 3, title: "Keyboard types",           subtitle: "UIKeyboardType, textContentType, autocapitalization, autocorrect",        icon: "keyboard.fill",                       visual: AnyView(TxtKeyboardTypesVisual()),   explanation: AnyView(TxtKeyboardTypesExplanation())),
        TFLesson(number: 4, title: "Formatted fields",         subtitle: "FormatStyle, ParseableFormatStyle - currency, dates, numbers, custom",    icon: "number.circle.fill",                  visual: AnyView(FormattedFieldsVisual()), explanation: AnyView(FormattedFieldsExplanation())),
        TFLesson(number: 5, title: "SecureField",              subtitle: "Passwords, show/hide toggle, strength meter, confirmation",               icon: "lock.fill",                           visual: AnyView(SecureFieldVisual()),     explanation: AnyView(SecureFieldExplanation())),
        TFLesson(number: 6, title: "Inline validation",        subtitle: "Real-time error states, debounce, accessible error labels",               icon: "checkmark.shield.fill",               visual: AnyView(InlineValidationVisual()), explanation: AnyView(InlineValidationExplanation())),
        TFLesson(number: 7, title: "Custom TextField style",   subtitle: "TextFieldStyle protocol, custom backgrounds, animated border, shake",     icon: "paintbrush.pointed.fill",             visual: AnyView(CustomTFStyleVisual()),   explanation: AnyView(CustomTFStyleExplanation())),
        TFLesson(number: 8, title: "TextField in lists",       subtitle: "Inline editing in List rows, tap-to-edit, commit on dismiss",             icon: "list.bullet.rectangle.fill",          visual: AnyView(TFInListVisual()),        explanation: AnyView(TFInListExplanation())),
    ]
}

struct TFLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let tfOrange      = Color(hex: "#C2410C")
    static let tfOrangeLight = Color(hex: "#FFF7ED")
}
