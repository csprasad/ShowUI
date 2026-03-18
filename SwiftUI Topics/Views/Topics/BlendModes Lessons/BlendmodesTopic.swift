//
//
//  BlendmodesTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Blend Modes Topic
struct BlendModesTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Blend Modes"
    let subtitle    = "Every compositing mode shown side by side with live controls"
    let icon        = "circle.lefthalf.filled.righthalf.striped.horizontal.inverse"
    let color       = Color(hex: "#FBEAF0")
    let accentColor = Color(hex: "#993556")
    let tag         = "Visual"

    @MainActor
    var lessons: [AnyLesson] {
        BlendModeLessons.all.map { AnyLesson($0) }
    }
}

// MARK: - Lesson List
enum BlendModeLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        BlendLesson(
            number: 1,
            title: "What is blending?",
            subtitle: "How SwiftUI composites layers and why blend modes exist",
            icon: "square.2.layers.3d",
            visual: AnyView(BlendIntroVisual()),
            explanation: AnyView(BlendIntroExplanation())
        ),
        BlendLesson(
            number: 2,
            title: "Darken modes",
            subtitle: "Multiply, Darken, Color Burn, Plus Darker",
            icon: "moon.fill",
            visual: AnyView(BlendCategoryVisual(category: .darken)),
            explanation: AnyView(BlendCategoryExplanation(category: .darken))
        ),
        BlendLesson(
            number: 3,
            title: "Lighten modes",
            subtitle: "Screen, Lighten, Color Dodge, Plus Lighter",
            icon: "sun.max.fill",
            visual: AnyView(BlendCategoryVisual(category: .lighten)),
            explanation: AnyView(BlendCategoryExplanation(category: .lighten))
        ),
        BlendLesson(
            number: 4,
            title: "Contrast modes",
            subtitle: "Overlay, Soft Light, Hard Light",
            icon: "circle.lefthalf.filled",
            visual: AnyView(BlendCategoryVisual(category: .contrast)),
            explanation: AnyView(BlendCategoryExplanation(category: .contrast))
        ),
        BlendLesson(
            number: 5,
            title: "Inversion modes",
            subtitle: "Difference, Exclusion",
            icon: "arrow.left.arrow.right",
            visual: AnyView(BlendCategoryVisual(category: .inversion)),
            explanation: AnyView(BlendCategoryExplanation(category: .inversion))
        ),
        BlendLesson(
            number: 6,
            title: "Component modes",
            subtitle: "Hue, Saturation, Color, Luminosity",
            icon: "paintpalette.fill",
            visual: AnyView(BlendCategoryVisual(category: .component)),
            explanation: AnyView(BlendCategoryExplanation(category: .component))
        ),
        BlendLesson(
            number: 7,
            title: "Compositing modes",
            subtitle: "Source Atop, Destination Over, Destination Out",
            icon: "square.on.square.dashed",
            visual: AnyView(BlendCategoryVisual(category: .compositing)),
            explanation: AnyView(BlendCategoryExplanation(category: .compositing))
        ),
    ]
}

struct BlendLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

// MARK: - Shared Category Model
enum BlendCategory {
    case darken, lighten, contrast, inversion, component, compositing

    var title: String {
        switch self {
        case .darken:      return "Darken modes"
        case .lighten:     return "Lighten modes"
        case .contrast:    return "Contrast modes"
        case .inversion:   return "Inversion modes"
        case .component:   return "Component modes"
        case .compositing: return "Compositing modes"
        }
    }

    var accentColor: Color {
        switch self {
        case .darken:      return Color(hex: "#185FA5")
        case .lighten:     return Color(hex: "#854F0B")
        case .contrast:    return Color(hex: "#534AB7")
        case .inversion:   return Color(hex: "#993C1D")
        case .component:   return Color(hex: "#0F6E56")
        case .compositing: return Color(hex: "#993556")
        }
    }

    var modes: [(name: String, mode: BlendMode, description: String)] {
        switch self {
        case .darken:
            return [
                ("Multiply",   .multiply,  "Multiplies colors. Always darker"),
                ("Darken",     .darken,    "Keeps whichever pixel is darker"),
                ("Color Burn", .colorBurn, "Darkens base to reflect blend"),
                ("Plus Darker",.plusDarker,"Adds then darkens the result"),
            ]
        case .lighten:
            return [
                ("Screen",      .screen,     "Inverts, multiplies, inverts. Always lighter"),
                ("Lighten",     .lighten,    "Keeps whichever pixel is lighter"),
                ("Color Dodge", .colorDodge, "Brightens base to reflect blend"),
                ("Plus Lighter",.plusLighter,"Adds color values together"),
            ]
        case .contrast:
            return [
                ("Overlay",    .overlay,   "Multiply or screen based on base"),
                ("Soft Light", .softLight, "Like a diffused light source"),
                ("Hard Light", .hardLight, "Like a direct harsh light"),
            ]
        case .inversion:
            return [
                ("Difference", .difference, "Subtracts, inverts where blend is white"),
                ("Exclusion",  .exclusion,  "Like difference, lower contrast"),
            ]
        case .component:
            return [
                ("Hue",        .hue,        "Blend hue, keep base luminance"),
                ("Saturation", .saturation, "Blend saturation, keep base"),
                ("Color",      .color,      "Blend hue + sat, keep luminance"),
                ("Luminosity", .luminosity, "Blend luminance, keep base color"),
            ]
        case .compositing:
            return [
                ("Source Atop",    .sourceAtop,      "Draw source only where dest exists"),
                ("Dest. Over",     .destinationOver, "Draw destination over source"),
                ("Dest. Out",      .destinationOut,  "Erase dest where source exists"),
            ]
        }
    }
}
