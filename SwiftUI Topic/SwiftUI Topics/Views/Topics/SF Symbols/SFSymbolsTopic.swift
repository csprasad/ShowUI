//
//
//  SFSymbolsTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `23/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - SF Symbols Topic
struct SFSymbolsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "SF Symbols"
    let subtitle    = "Browse 300+ symbols, rendering modes, variants, layers, effects and more"
    let icon        = "star.circle.fill"
    let color       = Color(hex: "#EAF3DE")
    let accentColor = Color(hex: "#3B6D11")
    let tag         = "Icons"

    @MainActor
    var lessons: [AnyLesson] {
        SFSymbolsLessons.all.map { AnyLesson($0) }
    }
}

// MARK: - Lesson List
enum SFSymbolsLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        SFLesson(number: 1,  title: "Symbol browser",
                 subtitle: "Browse and search 300 common symbols & tap to copy name",
                 icon: "square.grid.3x3.fill",
                 visual: AnyView(SymbolBrowserVisual()),
                 explanation: AnyView(SymbolBrowserExplanation())),
        SFLesson(number: 2,  title: "Rendering modes",
                 subtitle: "Monochrome, hierarchical, palette and multicolor",
                 icon: "circle.hexagongrid.fill",
                 visual: AnyView(RenderingModesVisual()),
                 explanation: AnyView(RenderingModesExplanation())),
        SFLesson(number: 3,  title: "Layered symbols",
                 subtitle: "Primary, secondary and tertiary layers explained",
                 icon: "square.3.layers.3d.top.filled",
                 visual: AnyView(LayeredSymbolsVisual()),
                 explanation: AnyView(LayeredSymbolsExplanation())),
        SFLesson(number: 4,  title: "Variable color",
                 subtitle: "Animating the variable color layer",
                 icon: "speaker.wave.3.fill",
                 visual: AnyView(VariableColorVisual()),
                 explanation: AnyView(VariableColorExplanation())),
        SFLesson(number: 5,  title: "Font weight & scale",
                 subtitle: "How weight and imageScale change symbol rendering",
                 icon: "textformat.size",
                 visual: AnyView(WeightScaleVisual()),
                 explanation: AnyView(WeightScaleExplanation())),
        SFLesson(number: 6,  title: "Symbol variants",
                 subtitle: ".fill, .slash, .circle, .square and .rectangle variants",
                 icon: "heart.circle.fill",
                 visual: AnyView(VariantsVisual()),
                 explanation: AnyView(VariantsExplanation())),
        SFLesson(number: 7,  title: "Symbol alignment",
                 subtitle: "Baseline alignment and mixing symbols with text",
                 icon: "text.alignleft",
                 visual: AnyView(AlignmentVisual()),
                 explanation: AnyView(AlignmentExplanation())),
        SFLesson(number: 8,  title: "Symbol effects",
                 subtitle: "Quick reference. More covered in depth in Animations",
                 icon: "sparkles",
                 visual: AnyView(EffectsReferenceVisual()),
                 explanation: AnyView(EffectsReferenceExplanation())),
        SFLesson(number: 9,  title: "Accessibility",
                 subtitle: "accessibilityLabel, accessibilityHidden and VoiceOver",
                 icon: "accessibility.fill",
                 visual: AnyView(AccessibilityVisual()),
                 explanation: AnyView(AccessibilityExplanation())),
        SFLesson(number: 10, title: "Custom symbols",
                 subtitle: "Importing your own SVG as an SF Symbol in Xcode",
                 icon: "square.and.pencil",
                 visual: AnyView(CustomSymbolVisual()),
                 explanation: AnyView(CustomSymbolExplanation())),
    ]
}

struct SFLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

// MARK: - Shared accent
extension Color {
    static let sfGreen = Color(hex: "#3B6D11")
    static let sfGreenLight = Color(hex: "#EAF3DE")
}

