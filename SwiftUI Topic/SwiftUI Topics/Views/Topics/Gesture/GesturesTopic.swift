//
//
//  GesturesTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Gestures Topic
struct GesturesTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Gestures"
    let subtitle    = "Tap, drag, pinch, rotate and composing complex interactions"
    let icon        = "hand.point.up.left.fill"
    let color       = Color(hex: "#FFF0F3")
    let accentColor = Color(hex: "#C0305A")
    let tag         = "Controls"

    @MainActor
    var lessons: [AnyLesson] {
        GestureLessons.all.map { AnyLesson($0) }
    }
}

enum GestureLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        GLesson(number: 1, title: "TapGesture",          subtitle: "Single tap, double tap, tap count and .onTapGesture",               icon: "hand.tap.fill",                      visual: AnyView(TapGestureVisual()),          explanation: AnyView(TapGestureExplanation())),
        GLesson(number: 2, title: "LongPressGesture",    subtitle: "Hold duration, onPressingChanged and haptic feedback",              icon: "hand.point.up.left.fill",             visual: AnyView(LongPressGestureVisual()),           explanation: AnyView(LongPressGestureExplanation())),
        GLesson(number: 3, title: "DragGesture",         subtitle: "Translation, velocity, predictedEndLocation and snap-back",        icon: "arrow.up.and.down.and.arrow.left.and.right", visual: AnyView(DragGestureVisual()),  explanation: AnyView(DragGestureExplanation())),
        GLesson(number: 4, title: "MagnifyGesture",      subtitle: "Pinch to zoom - scale factor, limits and reset",                   icon: "plus.magnifyingglass",               visual: AnyView(MagnifyGestureVisual()),      explanation: AnyView(MagnifyGestureExplanation())),
        GLesson(number: 5, title: "RotateGesture",       subtitle: "Rotation angle, cumulative tracking and combining with scale",     icon: "arrow.clockwise.circle.fill",        visual: AnyView(RotateGestureVisual()),       explanation: AnyView(RotateGestureExplanation())),
        GLesson(number: 6, title: "Simultaneous",        subtitle: "Running two gestures at the same time with .simultaneously",       icon: "hand.raised.fingers.spread.fill",    visual: AnyView(SimultaneousVisual()),        explanation: AnyView(SimultaneousExplanation())),
        GLesson(number: 7, title: "Gesture composition", subtitle: ".sequenced, .exclusively and highPriorityGesture",                 icon: "square.stack.fill",                  visual: AnyView(GestureCompositionVisual()),  explanation: AnyView(GestureCompositionExplanation())),
        GLesson(number: 8, title: "Custom gestures",     subtitle: "@GestureState, reusable gesture structs and combining gestures",   icon: "wand.and.stars",                     visual: AnyView(CustomGestureVisual()),       explanation: AnyView(CustomGestureExplanation())),
    ]
}

struct GLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let gesturePink      = Color(hex: "#C0305A")
    static let gesturePinkLight = Color(hex: "#FFF0F3")
    static let gestureOrange = Color(hex: "#F47C3E")
    static let gestureOrangeLight = Color(hex: "#FFF4EE")
}

struct GesturePlayground<Content: View>: View {
    let hint: String
    let content: Content
    
    init(hint: String, @ViewBuilder content: () -> Content) {
        self.hint = hint
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Color(.secondarySystemBackground)
                content
            }
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            
            Text(hint.uppercased())
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(.secondary)
        }
    }
}
