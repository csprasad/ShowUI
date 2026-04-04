//
//
//  TextTypographyTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Text & Typography Topic
struct TextTypographyTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Text & Typography"
    let subtitle    = "Fonts, markdown formatting, truncation, and advanced styling"
    let icon        = "textformat"
    let color       = Color(hex: "#E1F5EE")
    let accentColor = Color(hex: "#1D9E75")
    let tag         = "Foundations"

    @MainActor
    var lessons: [AnyLesson] {
        TextTypographyLessons.all.map { AnyLesson($0) }
    }
}

enum TextTypographyLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        TTLesson(number: 1, title: "Text basics", subtitle: "System fonts, weights, and design styles", icon: "text.alignleft", visual: AnyView(TextBasicsVisual()), explanation: AnyView(TextBasicsExplanation())),
        TTLesson(number: 2, title: "Formatting & Markdown", subtitle: "Bold, italic, links, and attributed strings", icon: "bold.italic.underline", visual: AnyView(TextFormattingVisual()), explanation: AnyView(TextFormattingExplanation())),
        TTLesson(number: 3, title: "Frame & Truncation", subtitle: "Line limits, truncation modes, and tightening", icon: "text.append", visual: AnyView(TextTruncationVisual()), explanation: AnyView(TextTruncationExplanation())),
        TTLesson(number: 4, title: "Advanced Styling", subtitle: "Kerning, tracking, and baseline offset", icon: "character.cursor.ibeam", visual: AnyView(TextAdvancedVisual()), explanation: AnyView(TextAdvancedExplanation())),
        TTLesson(number: 5, title: "Dynamic Type", subtitle: "Accessibility scaling and semantic sizes", icon: "textformat.size", visual: AnyView(TextDynamicTypeVisual()), explanation: AnyView(TextDynamicTypeExplanation())),
        TTLesson(number: 6, title: "Privacy & Selection", subtitle: "Redaction and text selection", icon: "eye.slash", visual: AnyView(TextPrivacyVisual()), explanation: AnyView(TextPrivacyExplanation())),
    ]
}

struct TTLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}
