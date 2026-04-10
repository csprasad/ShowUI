//
//
//  AnimationsTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Animations Topic
struct AnimationsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Animations"
    let subtitle    = "Every animation API from springs, keyframes, scroll, custom and more"
    let icon        = "sparkles"
    let color       = Color(hex: "#EEEDFE")
    let accentColor = Color(hex: "#534AB7")
    let tag         = "Motion"

    @MainActor
    var lessons: [AnyLesson] {
        AnimationLessons.all.map { AnyLesson($0) }
    }
}

// MARK: - Lesson List
enum AnimationLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        
        // MARK: Foundations
        AnimLesson(number: 1,  title: "Animation basics",
                   subtitle: "withAnimation, duration, delay and the .animation modifier",
                   icon: "play.circle.fill",
                   section: "Foundations",
                   visual: AnyView(AnimBasicsVisual()),
                   explanation: AnyView(AnimBasicsExplanation())),
        AnimLesson(number: 2,  title: "Spring animations",
                   subtitle: "bouncy, snappy, smooth, and more tuning spring parameters",
                   icon: "waveform.path.ecg",
                   section: "Foundations",
                   visual: AnyView(SpringVisual()),
                   explanation: AnyView(SpringExplanation())),
        AnimLesson(number: 3,  title: "Timing curves",
                   subtitle: "easeIn, easeOut, linear and custom bezier curves",
                   icon: "chart.line.uptrend.xyaxis",
                   section: "Foundations",
                   visual: AnyView(TimingCurveVisual()),
                   explanation: AnyView(TimingCurveExplanation())),
        AnimLesson(number: 4,  title: "Repeat & autoreverse",
                   subtitle: "repeatCount, repeatForever and autoreverses",
                   icon: "repeat",
                   section: "Foundations",
                   visual: AnyView(RepeatVisual()),
                   explanation: AnyView(RepeatExplanation())),
        
        // MARK: Modern APIs - iOS 17+
        AnimLesson(number: 5,  title: "Phase Animator",
                   subtitle: "Cycle through states automatically - iOS 17+",
                   icon: "arrow.trianglehead.2.clockwise.rotate.90",
                   section: "Modern APIs - iOS 17+",
                   visual: AnyView(PhaseAnimatorVisual()),
                   explanation: AnyView(PhaseAnimatorExplanation())),
        AnimLesson(number: 6,  title: "Keyframe Animator",
                   subtitle: "Animate multiple properties on a precise timeline - iOS 17+",
                   icon: "slider.horizontal.3",
                   section: "Modern APIs - iOS 17+",
                   visual: AnyView(KeyframeAnimatorVisual()),
                   explanation: AnyView(KeyframeAnimatorExplanation())),
        AnimLesson(number: 7,  title: "Symbol effects",
                   subtitle: ".bounce, .pulse, .rotate, .wiggle SF Symbol animation - iOS 17+",
                   icon: "star.circle.fill",
                   section: "Modern APIs - iOS 17+",
                   visual: AnyView(SymbolEffectVisual()),
                   explanation: AnyView(SymbolEffectExplanation())),
        AnimLesson(number: 8,  title: "Content transitions",
                   subtitle: ".numericText, .interpolate animating text and number changes",
                   icon: "textformat.123",
                   section: "Modern APIs - iOS 17+",
                   visual: AnyView(ContentTransitionVisual()),
                   explanation: AnyView(ContentTransitionExplanation())),
        
        // MARK: Transitions & Geometry
        AnimLesson(number: 9,  title: "matchedGeometryEffect",
                   subtitle: "Hero transitions share geometry between two views",
                   icon: "rectangle.2.swap",
                   section: "Transitions & Geometry",
                   visual: AnyView(MatchedGeometryVisual()),
                   explanation: AnyView(MatchedGeometryExplanation())),
        AnimLesson(number: 10, title: "Custom transitions",
                   subtitle: "AnyTransition, asymmetric and building your own",
                   icon: "arrow.left.arrow.right.square",
                   section: "Transitions & Geometry",
                   visual: AnyView(CustomTransitionVisual()),
                   explanation: AnyView(CustomTransitionExplanation())),
        AnimLesson(number: 11, title: "Scroll animations",
                   subtitle: "scrollTransition, visualEffect and parallax - iOS 17+",
                   icon: "scroll.fill",
                   section: "Transitions & Geometry",
                   visual: AnyView(ScrollAnimVisual()),
                   explanation: AnyView(ScrollAnimExplanation())),
        
        // MARK: Advanced & Custom
        AnimLesson(number: 12, title: "Animatable shapes",
                   subtitle: "animatableData, morphing paths, custom animated shapes",
                   icon: "scribble.variable",
                   section: "Advanced & Custom",
                   visual: AnyView(AnimateShapesVisual()),
                   explanation: AnyView(AnimateShapesExplanation())),
        AnimLesson(number: 13, title: "GeometryEffect",
                   subtitle: "Custom transforms, wave, skew and 3D rotation effects",
                   icon: "rotate.3d.fill",
                   section: "Advanced & Custom",
                   visual: AnyView(GeometryEffectVisual()),
                   explanation: AnyView(GeometryEffectExplanation())),
        AnimLesson(number: 14, title: "TimelineView",
                   subtitle: "Clock-driven animations, real-time and particle-like effects",
                   icon: "clock.fill",
                   section: "Advanced & Custom",
                   visual: AnyView(TimelineViewVisual()),
                   explanation: AnyView(TimelineViewExplanation())),
        AnimLesson(number: 15, title: "Transaction",
                   subtitle: "withTransaction, disabling animations, overriding mid-flight",
                   icon: "bolt.shield.fill",
                   section: "Advanced & Custom",
                   visual: AnyView(TransactionVisual()),
                   explanation: AnyView(TransactionExplanation())),
        AnimLesson(number: 16, title: "DrawingGroup & performance",
                   subtitle: "Metal offload, when animations drop frames and how to fix it",
                   icon: "cpu.fill",
                   section: "Advanced & Custom",
                   visual: AnyView(DrawingGroupVisual()),
                   explanation: AnyView(DrawingGroupExplanation())),
        AnimLesson(number: 17, title: "animation(_:body:)",
                   subtitle: "Scoped animations - avoiding unwanted side effects",
                   icon: "scope",
                   section: "Advanced & Custom",
                   visual: AnyView(ScopedAnimationVisual()),
                   explanation: AnyView(ScopedAnimationExplanation()))
    ]
}

struct AnimLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let section:    String?
    let visual:     AnyView
    let explanation: AnyView
}

// MARK: - Shared colors
extension Color {
    static let animPurple = Color(hex: "#534AB7")
    static let animTeal   = Color(hex: "#1D9E75")
    static let animCoral  = Color(hex: "#D85A30")
    static let animAmber  = Color(hex: "#BA7517")
    static let animBlue   = Color(hex: "#185FA5")
    static let animPink   = Color(hex: "#993556")
}
