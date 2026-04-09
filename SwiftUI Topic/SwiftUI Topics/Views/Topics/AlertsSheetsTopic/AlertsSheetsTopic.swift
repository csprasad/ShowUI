//
//
//  AlertsSheetsTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Alerts, Sheets & Popovers Topic
struct AlertsSheetsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Alerts & Popovers"
    let subtitle    = "Alert, confirmationDialog, sheet, popover, fullScreenCover"
    let icon        = "bubble.left.and.exclamationmark.bubble.right.fill"
    let color       = Color(hex: "#FEF2F2")
    let accentColor = Color(hex: "#B91C1C")
    let tag         = "Navigation"

    @MainActor
    var lessons: [AnyLesson] {
        AlertsSheetsLessons.all.map { AnyLesson($0) }
    }
}

enum AlertsSheetsLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        ASLesson(number: 1, title: "Alert basics",              subtitle: "isPresented, message, single/multiple buttons, roles",          icon: "exclamationmark.triangle.fill",          visual: AnyView(AlertBasicsVisual()),         explanation: AnyView(AlertBasicsExplanation())),
        ASLesson(number: 2, title: "ConfirmationDialog",        subtitle: "Action sheets - multiple choices, cancel, destructive roles",   icon: "list.bullet.rectangle.fill",             visual: AnyView(ConfirmationDialogVisual()),  explanation: AnyView(ConfirmationDialogExplanation())),
        ASLesson(number: 3, title: "Sheet basics",              subtitle: ".sheet, isPresented, item, onDismiss, NavigationStack inside",  icon: "rectangle.bottomhalf.inset.filled",      visual: AnyView(SheetBasicsDiagramVisual()),  explanation: AnyView(SheetBasicsDiagramExplanation())),
        ASLesson(number: 4, title: "Sheet detents & styling",   subtitle: "Detents, drag indicator, background, corner radius, interaction", icon: "arrow.up.and.down.square.fill",         visual: AnyView(SheetDetentsVisual()),        explanation: AnyView(SheetDetentsExplanation())),
        ASLesson(number: 5, title: "Popover",                   subtitle: ".popover - source anchor, arrowEdge, iPad/iPhone differences",  icon: "bubble.right.fill",                      visual: AnyView(PopoverVisual()),             explanation: AnyView(PopoverExplanation())),
        ASLesson(number: 6, title: "fullScreenCover",           subtitle: "Full screen modal - vs .sheet, dismiss, keyboard handling",     icon: "rectangle.fill",                         visual: AnyView(FullScreenCoverVisual()),     explanation: AnyView(FullScreenCoverExplanation())),
        ASLesson(number: 7, title: "Presentation patterns",     subtitle: "Correct anchor placement, avoiding double-present bugs",        icon: "arrow.triangle.branch",                  visual: AnyView(PresentationPatternsVisual()), explanation: AnyView(PresentationPatternsExplanation())),
        ASLesson(number: 8, title: "Custom overlays",           subtitle: "Building your own overlay with ZStack, matchedGeometry, masks", icon: "square.on.square.dashed",                visual: AnyView(CustomOverlayVisual()),       explanation: AnyView(CustomOverlayExplanation())),
    ]
}

struct ASLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let asRed      = Color(hex: "#B91C1C")
    static let asRedLight = Color(hex: "#FEF2F2")
}
