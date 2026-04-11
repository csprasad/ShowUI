//
//
//  AnimationsDeepDiveTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Animations Deep Dive Topic
struct AnimationsDeepDiveTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Animations Deep Dive"
    let subtitle    = "Springs, timing, transitions, keyframes, phase animators and custom"
    let icon        = "wand.and.sparkles"
    let color       = Color(hex: "#FFF9F0")
    let accentColor = Color(hex: "#D97706")
    let tag         = "Visual"

    @MainActor
    var lessons: [AnyLesson] {
        AnimationsDeepDiveLessons.all.map { AnyLesson($0) }
    }
}

enum AnimationsDeepDiveLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        ANLesson(number: 1, title: "Animation types",        subtitle: "spring, easeIn/Out, linear, bouncy - every curve compared live",          icon: "chart.line.uptrend.xyaxis",         visual: AnyView(AnimTypesVisual()),       explanation: AnyView(AnimTypesExplanation())),
        ANLesson(number: 2, title: "withAnimation & implicit",subtitle: "Explicit withAnimation{} vs .animation() implicit - when to use which",  icon: "arrow.trianglehead.counterclockwise",visual: AnyView(ExplicitImplicitVisual()), explanation: AnyView(ExplicitImplicitExplanation())),
        ANLesson(number: 3, title: "Transitions",             subtitle: ".transition() - opacity, move, slide, scale, combined and asymmetric",    icon: "arrow.left.arrow.right.square.fill", visual: AnyView(TransitionsVisual()),     explanation: AnyView(TransitionsExplanation())),
        ANLesson(number: 4, title: "Keyframe animations",    subtitle: "KeyframeAnimator - multi-step tracks, timing offsets, realistic motion",   icon: "timeline.selection",                visual: AnyView(KeyframeVisual()),        explanation: AnyView(KeyframeExplanation())),
        ANLesson(number: 5, title: "PhaseAnimator",          subtitle: "Phase-based looping - discrete steps with per-phase animations",          icon: "repeat.circle.fill",                visual: AnyView(DeepPhaseAnimatorVisual()),   explanation: AnyView(DeepPhaseAnimatorExplanation())),
        ANLesson(number: 6, title: "Matched geometry",       subtitle: "matchedGeometryEffect - hero transitions, shared element animations",     icon: "arrow.up.left.and.down.right.magnifyingglass", visual: AnyView(MatchedGeoAnim()),  explanation: AnyView(MatchedGeoAnimExplanation())),
        ANLesson(number: 7, title: "Custom AnimatableData",  subtitle: "AnimatableModifier, animatableData, interpolating custom types",          icon: "function",                          visual: AnyView(CustomAnimDataVisual()),  explanation: AnyView(CustomAnimDataExplanation())),
        ANLesson(number: 8, title: "Animation patterns",     subtitle: "Stagger, sequencing, repeat, onAppear triggers, performance tips",        icon: "sparkles.rectangle.stack.fill",     visual: AnyView(AnimPatternsVisual()),    explanation: AnyView(AnimPatternsExplanation())),
    ]
}

struct ANLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let anAmber      = Color(hex: "#D97706")
    static let anAmberLight = Color(hex: "#FFF9F0")
    static let anAmberMid   = Color(hex: "#FDE68A")
}
