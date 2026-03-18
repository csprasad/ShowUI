//
//
//  MaskingTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `19/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Masking Topic
struct MaskingTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Masking"
    let subtitle    = "Every masking technique clip, fade, cutout, reveal, and more"
    let icon        = "theatermask.and.paintbrush.fill"
    let color       = Color(hex: "#FAECE7")
    let accentColor = Color(hex: "#993C1D")
    let tag         = "Visual"

    @MainActor
    var lessons: [AnyLesson] {
        MaskingLessons.all.map { AnyLesson($0) }
    }
}

// MARK: - Lesson List
enum MaskingLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        MaskLesson(
            number: 1,
            title: "What is a mask?",
            subtitle: "How alpha channels control visibility in SwiftUI",
            icon: "square.on.square",
            visual: AnyView(MaskIntroVisual()),
            explanation: AnyView(MaskIntroExplanation())
        ),
        MaskLesson(
            number: 2,
            title: "Basic mask",
            subtitle: "Use any view as a mask with .mask()",
            icon: "heart.fill",
            visual: AnyView(BasicMaskVisual()),
            explanation: AnyView(BasicMaskExplanation())
        ),
        MaskLesson(
            number: 3,
            title: "Clip shapes",
            subtitle: ".clipShape() fast, built-in shape clipping",
            icon: "circle.rectangle.filled.pattern.diagonalline",
            visual: AnyView(ClipShapeVisual()),
            explanation: AnyView(ClipShapeExplanation())
        ),
        MaskLesson(
            number: 4,
            title: "Gradient mask",
            subtitle: "Fade content in or out using a gradient as the mask",
            icon: "rectangle.bottomthird.inset.filled",
            visual: AnyView(GradientMaskVisual()),
            explanation: AnyView(GradientMaskExplanation())
        ),
        MaskLesson(
            number: 5,
            title: "Inverted mask",
            subtitle: "Cut a shape OUT of content with .destinationOut",
            icon: "minus.circle",
            visual: AnyView(InvertedMaskVisual()),
            explanation: AnyView(InvertedMaskExplanation())
        ),
        MaskLesson(
            number: 6,
            title: "Luminance to alpha",
            subtitle: "Convert brightness to transparency for true inversion",
            icon: "sun.max.fill",
            visual: AnyView(LuminanceMaskVisual()),
            explanation: AnyView(LuminanceMaskExplanation())
        ),
        MaskLesson(
            number: 7,
            title: "Text mask",
            subtitle: "Show an image or gradient through the shape of text",
            icon: "textformat",
            visual: AnyView(TextMaskVisual()),
            explanation: AnyView(TextMaskExplanation())
        ),
        MaskLesson(
            number: 8,
            title: "Animated reveal",
            subtitle: "Animate a mask to progressively reveal content",
            icon: "play.rectangle.fill",
            visual: AnyView(AnimatedRevealVisual()),
            explanation: AnyView(AnimatedRevealExplanation())
        ),
        MaskLesson(
            number: 9,
            title: "Path mask",
            subtitle: "Use a custom Path or Shape as a precise mask",
            icon: "pencil.and.outline",
            visual: AnyView(PathMaskVisual()),
            explanation: AnyView(PathMaskExplanation())
        ),
    ]
}

struct MaskLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

// MARK: - Shared gradient used across all masking visuals
// No image assets required — works out of the box
extension View {
    var maskBaseGradient: some View {
        LinearGradient(
            colors: [
                Color(hex: "#B5D4F4"),
                Color(hex: "#9FE1CB"),
                Color(hex: "#FAC775"),
                Color(hex: "#F5C4B3"),
                Color(hex: "#CECBF6"),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct MaskBaseGradient: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(hex: "#B5D4F4"),
                Color(hex: "#9FE1CB"),
                Color(hex: "#FAC775"),
                Color(hex: "#F5C4B3"),
                Color(hex: "#CECBF6"),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
