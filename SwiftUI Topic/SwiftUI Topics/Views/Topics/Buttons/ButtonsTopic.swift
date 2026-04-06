//
//
//  ButtonsTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Buttons Topic
struct ButtonsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Buttons"
    let subtitle    = "Styles, roles, states, menus, haptics and custom interactions"
    let icon        = "hand.tap.fill"
    let color       = Color(hex: "#EEEDFE")
    let accentColor = Color(hex: "#534AB7")
    let tag         = "Controls"

    @MainActor
    var lessons: [AnyLesson] {
        ButtonLessons.all.map { AnyLesson($0) }
    }
}

enum ButtonLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        BLesson(number: 1,  title: "Button basics",
                subtitle: "action, label, roles - .destructive and .cancel",
                icon: "hand.tap.fill",
                visual: AnyView(ButtonBasicsVisual()),
                explanation: AnyView(ButtonBasicsExplanation())),
        BLesson(number: 2,  title: "Button styles",
                subtitle: ".bordered, .borderedProminent, .plain and custom",
                icon: "paintbrush.fill",
                visual: AnyView(ButtonStylesVisual()),
                explanation: AnyView(ButtonStylesExplanation())),
        BLesson(number: 3,  title: "Custom button style",
                subtitle: "Building reusable ButtonStyle from scratch",
                icon: "slider.horizontal.3",
                visual: AnyView(CustomStyleVisual()),
                explanation: AnyView(CustomStyleExplanation())),
        BLesson(number: 4,  title: "Loading state",
                subtitle: "Disabled + progress indicator - the async button pattern",
                icon: "arrow.triangle.2.circlepath",
                visual: AnyView(LoadingStateVisual()),
                explanation: AnyView(LoadingStateExplanation())),
        BLesson(number: 5,  title: "Toggle button",
                subtitle: "Selected state, custom toggle styles",
                icon: "togglepower",
                visual: AnyView(ToggleButtonVisual()),
                explanation: AnyView(ToggleButtonExplanation())),
        BLesson(number: 6,  title: "Confirmation & alerts",
                subtitle: "confirmationDialog and Alert before destructive actions",
                icon: "exclamationmark.triangle.fill",
                visual: AnyView(ConfirmationVisual()),
                explanation: AnyView(ConfirmationExplanation())),
        BLesson(number: 7,  title: "Menu button",
                subtitle: "Menu { } with actions, submenus and picker menus",
                icon: "ellipsis.circle.fill",
                visual: AnyView(MenuButtonVisual()),
                explanation: AnyView(MenuButtonExplanation())),
        BLesson(number: 8,  title: "Tappable areas",
                subtitle: "contentShape, minimum tap targets and hit testing",
                icon: "scope",
                visual: AnyView(TappableAreasVisual()),
                explanation: AnyView(TappableAreasExplanation())),
        BLesson(number: 9,  title: "Long press & context",
                subtitle: "longPressGesture, contextMenu and simultaneous gestures",
                icon: "hand.point.up.left.fill",
                visual: AnyView(LongPressVisual()),
                explanation: AnyView(LongPressExplanation())),
        BLesson(number: 10, title: "Haptic feedback",
                subtitle: "UIImpactFeedbackGenerator, UINotificationFeedbackGenerator",
                icon: "waveform.path",
                visual: AnyView(HapticVisual()),
                explanation: AnyView(HapticExplanation())),
    ]
}

struct BLesson: LessonProtocol {
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
    static let btnPurple      = Color(hex: "#534AB7")
    static let btnPurpleLight = Color(hex: "#EEEDFE")
}
