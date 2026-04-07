//
//
//  ColorsGradientsTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Colors & Gradients Topic
struct ColorsGradientsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Colors & Gradients"
    let subtitle    = "Color system, gradients, materials, opacity and dynamic color"
    let icon        = "paintpalette.fill"
    let color       = Color(hex: "#FFF8E1")
    let accentColor = Color(hex: "#B45309")
    let tag         = "Foundations"

    @MainActor
    var lessons: [AnyLesson] {
        ColorsGradientsLessons.all.map { AnyLesson($0) }
    }
}

enum ColorsGradientsLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        CGLesson(number: 1, title: "Color system",        subtitle: "Semantic colors, adaptive dark/light, hex init, opacity",         icon: "circle.hexagongrid.fill",        visual: AnyView(ColorSystemVisual()),       explanation: AnyView(ColorSystemExplanation())),
        CGLesson(number: 2, title: "Linear gradient",     subtitle: "LinearGradient - direction, stops, multi-color blends",           icon: "arrow.up.right.circle.fill",     visual: AnyView(LinearGradientVisual()),    explanation: AnyView(LinearGradientExplanation())),
        CGLesson(number: 3, title: "Radial & Angular",    subtitle: "RadialGradient, AngularGradient and EllipticalGradient",          icon: "circle.dashed.inset.filled",     visual: AnyView(RadialAngularVisual()),     explanation: AnyView(RadialAngularExplanation())),
        CGLesson(number: 4, title: "Mesh gradient",       subtitle: "MeshGradient - iOS 18 smooth multi-point color fields",          icon: "waveform.path",                  visual: AnyView(MeshGradientVisual()),      explanation: AnyView(MeshGradientExplanation())),
        CGLesson(number: 5, title: "Materials & vibrancy", subtitle: ".ultraThinMaterial, .regularMaterial and blur effects",          icon: "camera.filters",                 visual: AnyView(MaterialsVisual()),         explanation: AnyView(MaterialsExplanation())),
        CGLesson(number: 6, title: "Gradient as fill",    subtitle: "Gradient on shapes, text, strokes and view backgrounds",         icon: "paintbrush.fill",                visual: AnyView(GradientFillVisual()),      explanation: AnyView(GradientFillExplanation())),
        CGLesson(number: 7, title: "Dynamic color",       subtitle: "Dark mode adaptation, Color(uiColor:), environment color scheme", icon: "circle.lefthalf.filled",         visual: AnyView(DynamicColorVisual()),      explanation: AnyView(DynamicColorExplanation())),
        CGLesson(number: 8, title: "Color harmony",       subtitle: "Building palettes, tint/shade, accessible contrast ratios",      icon: "swatchpalette.fill",             visual: AnyView(ColorHarmonyVisual()),      explanation: AnyView(ColorHarmonyExplanation())),
    ]
}

struct CGLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let cgAmber      = Color(hex: "#B45309")
    static let cgAmberLight = Color(hex: "#FFF8E1")
}
