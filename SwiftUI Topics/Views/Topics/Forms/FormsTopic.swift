//
//
//  FormsTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Forms & Settings UI Topic
struct FormsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Forms & Settings"
    let subtitle    = "Form, Section, Picker, Toggle, Slider and validation patterns"
    let icon        = "list.bullet.rectangle.portrait.fill"
    let color       = Color(hex: "#E8F5E9")
    let accentColor = Color(hex: "#1B6B35")
    let tag         = "Foundations"

    @MainActor
    var lessons: [AnyLesson] {
        FormsLessons.all.map { AnyLesson($0) }
    }
}

enum FormsLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        FLesson(number: 1, title: "Form basics",          subtitle: "Form vs List, Section, formStyle and the settings look",           icon: "list.bullet.rectangle.portrait.fill",  visual: AnyView(FormBasicsVisual()),       explanation: AnyView(FormBasicsExplanation())),
        FLesson(number: 2, title: "Toggle & Picker",      subtitle: "Toggle, Picker styles - wheel, segmented, menu, inline",          icon: "switch.2",                             visual: AnyView(TogglePickerVisual()),     explanation: AnyView(TogglePickerExplanation())),
        FLesson(number: 3, title: "Slider & Stepper",     subtitle: "Slider with range/step, Stepper, combined controls",              icon: "slider.horizontal.3",                  visual: AnyView(SliderStepperVisual()),    explanation: AnyView(SliderStepperExplanation())),
        FLesson(number: 4, title: "TextField in forms",   subtitle: "Prompt, axis, formatting, secure field and focus",                icon: "text.cursor",                          visual: AnyView(FormTextFieldVisual()),    explanation: AnyView(FormTextFieldExplanation())),
        FLesson(number: 5, title: "DatePicker & Color",   subtitle: "DatePicker styles, ColorPicker and combined form inputs",         icon: "calendar.badge.clock",                 visual: AnyView(DateColorPickerVisual()),  explanation: AnyView(DateColorPickerExplanation())),
        FLesson(number: 6, title: "Form validation",      subtitle: "Inline errors, required fields, disabled submit",                 icon: "checkmark.shield.fill",                visual: AnyView(FormValidationVisual()),   explanation: AnyView(FormValidationExplanation())),
        FLesson(number: 7, title: "LabeledContent",       subtitle: "LabeledContent, GroupBox, DisclosureGroup and form layout",      icon: "sidebar.squares.leading",              visual: AnyView(LabeledContentVisual()),   explanation: AnyView(LabeledContentExplanation())),
        FLesson(number: 8, title: "Settings screen",      subtitle: "Building a real settings UI - groups, navigation, links",        icon: "gear",                                 visual: AnyView(SettingsScreenVisual()),   explanation: AnyView(SettingsScreenExplanation())),
    ]
}

struct FLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let formGreen      = Color(hex: "#1B6B35")
    static let formGreenLight = Color(hex: "#E8F5E9")
}
