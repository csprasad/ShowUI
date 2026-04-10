//
//
//  ShapesPathsTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Shapes & Paths Topic
struct ShapesPathsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Shapes & Paths"
    let subtitle    = "Built-in shapes, custom paths, stroke, fill, trim and animation"
    let icon        = "pentagon.fill"
    let color       = Color(hex: "#F0F9FF")
    let accentColor = Color(hex: "#0369A1")
    let tag         = "Visual"

    @MainActor
    var lessons: [AnyLesson] {
        ShapesPathsLessons.all.map { AnyLesson($0) }
    }
}

enum ShapesPathsLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        SPLesson(number: 1, title: "Built-in shapes",       subtitle: "Rectangle, Circle, Capsule, Ellipse, RoundedRectangle, UnevenRounded",  icon: "square.on.circle",               visual: AnyView(BuiltInShapesVisual()),     explanation: AnyView(BuiltInShapesExplanation())),
        SPLesson(number: 2, title: "Fill & stroke",          subtitle: "fill, stroke, strokeBorder, fill+stroke layering",                       icon: "paintbrush.fill",                visual: AnyView(FillStrokeVisual()),        explanation: AnyView(FillStrokeExplanation())),
        SPLesson(number: 3, title: "Custom Path",            subtitle: "Path API - moveTo, addLine, addCurve, addArc, close",                    icon: "scribble.variable",              visual: AnyView(CustomPathVisual()),        explanation: AnyView(CustomPathExplanation())),
        SPLesson(number: 4, title: "Shape protocol",         subtitle: "Conforming to Shape - reusable, parameterized, composable shapes",       icon: "hexagon.fill",                   visual: AnyView(ShapeProtocolVisual()),     explanation: AnyView(ShapeProtocolExplanation())),
        SPLesson(number: 5, title: "Animatable shapes",      subtitle: "AnimatablePair, animatableData, smooth morphing between shapes",         icon: "sparkles",                       visual: AnyView(AnimatableShapesVisual()),  explanation: AnyView(AnimatableShapesExplanation())),
        SPLesson(number: 6, title: "Trim & draw-on effect",  subtitle: ".trim(from:to:) - progress rings, draw-on animation, progress bars",    icon: "circle.dotted",                  visual: AnyView(TrimVisual()),              explanation: AnyView(TrimExplanation())),
        SPLesson(number: 7, title: "Canvas",                 subtitle: "Canvas view - imperative drawing, symbols, blend modes, performance",   icon: "paintpalette.fill",              visual: AnyView(CanvasVisual()),            explanation: AnyView(CanvasExplanation())),
        SPLesson(number: 8, title: "Composing shapes",       subtitle: "Combining shapes with ZStack, masks, even-odd fill, clipping paths",    icon: "square.on.square.fill",          visual: AnyView(ComposingShapesVisual()),   explanation: AnyView(ComposingShapesExplanation())),
    ]
}

struct SPLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let spBlue      = Color(hex: "#0369A1")
    static let spBlueLight = Color(hex: "#F0F9FF")
}
