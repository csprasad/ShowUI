//
//
//  ControlsDeepDiveTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Controls Deep Dive Topic
struct ControlsDeepDiveTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Toggle, Picker, Slider, Stepper"
    let subtitle    = "All four interactive controls - styles, customisation and real-world patterns"
    let icon        = "switch.2"
    let color       = Color(hex: "#F5F3FF")
    let accentColor = Color(hex: "#6D28D9")
    let tag         = "Controls"

    @MainActor
    var lessons: [AnyLesson] {
        ControlsDeepDiveLessons.all.map { AnyLesson($0) }
    }
}

enum ControlsDeepDiveLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        CDLesson(number: 1, title: "Toggle deep dive",       subtitle: "toggleStyle, custom toggle, binding tricks and label customisation", icon: "switch.2",                     visual: AnyView(ToggleDeepDiveVisual()),    explanation: AnyView(ToggleDeepDiveExplanation())),
        CDLesson(number: 2, title: "Toggle patterns",        subtitle: "Multi-select, enable/disable chains, animated icon toggle",          icon: "checklist",                    visual: AnyView(TogglePatternsVisual()),    explanation: AnyView(TogglePatternsExplanation())),
        CDLesson(number: 3, title: "Picker deep dive",       subtitle: "All picker styles, enum-backed, multi-component, onChange",          icon: "list.bullet.circle.fill",      visual: AnyView(PickerDeepDiveVisual()),    explanation: AnyView(PickerDeepDiveExplanation())),
        CDLesson(number: 4, title: "Picker patterns",        subtitle: "Searchable picker, custom row content, dependent pickers",           icon: "arrow.triangle.branch",        visual: AnyView(PickerPatternsVisual()),    explanation: AnyView(PickerPatternsExplanation())),
        CDLesson(number: 5, title: "Slider deep dive",       subtitle: "Range, step, labels, tint, custom thumb and continuous feedback",    icon: "slider.horizontal.3",           visual: AnyView(SliderDeepDiveVisual()),    explanation: AnyView(SliderDeepDiveExplanation())),
        CDLesson(number: 6, title: "Slider patterns",        subtitle: "Range slider, multi-thumb, gradient track, live preview",           icon: "slider.horizontal.below.square.filled.and.square", visual: AnyView(SliderPatternsVisual()), explanation: AnyView(SliderPatternsExplanation())),
        CDLesson(number: 7, title: "Stepper deep dive",      subtitle: "Custom increment, format, onEditingChanged, combined with Slider",  icon: "plus.forwardslash.minus",       visual: AnyView(StepperDeepDiveVisual()),   explanation: AnyView(StepperDeepDiveExplanation())),
        CDLesson(number: 8, title: "Controls composition",   subtitle: "Building a real settings panel combining all four controls",        icon: "gearshape.2.fill",              visual: AnyView(ControlsCompositionVisual()), explanation: AnyView(ControlsCompositionExplanation())),
    ]
}

struct CDLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let cdPurple      = Color(hex: "#6D28D9")
    static let cdPurpleLight = Color(hex: "#F5F3FF")
    static let cdViolet      = Color(hex: "#7C3AED")
}
