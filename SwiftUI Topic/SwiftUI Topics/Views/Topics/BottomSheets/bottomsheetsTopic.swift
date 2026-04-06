//
//
//  bottomsheetsTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Bottom Sheets Topic
struct BottomSheetsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Bottom Sheets"
    let subtitle    = "Detents, drag indicators, background interaction and more"
    let icon        = "rectangle.bottomhalf.inset.filled"
    let color       = Color(hex: "#EAF3DE")
    let accentColor = Color(hex: "#3B6D11")
    let tag         = "Navigation"

    @MainActor
    var lessons: [AnyLesson] {
        BottomSheetLessons.all.map { AnyLesson($0) }
    }
}

enum BottomSheetLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        BSLesson(number: 1, title: "Sheet basics",
                 subtitle: ".sheet, isPresented and @Environment(\\.dismiss)",
                 icon: "rectangle.bottomhalf.inset.filled",
                 visual: AnyView(SheetBasicsVisual()),
                 explanation: AnyView(SheetBasicsExplanation())),
        BSLesson(number: 2, title: "Detents",
                 subtitle: ".medium, .large, custom height and fraction based",
                 icon: "arrow.up.and.down.square.fill",
                 visual: AnyView(DetentsVisual()),
                 explanation: AnyView(DetentsExplanation())),
        BSLesson(number: 3, title: "Multiple detents",
                 subtitle: "Switching between sizes with selectedDetent",
                 icon: "rectangle.split.3x1.fill",
                 visual: AnyView(MultipleDetentsVisual()),
                 explanation: AnyView(MultipleDetentsExplanation())),
        BSLesson(number: 4, title: "Drag indicator",
                 subtitle: ".presentationDragIndicator - when to show or hide",
                 icon: "minus.circle.fill",
                 visual: AnyView(DragIndicatorVisual()),
                 explanation: AnyView(DragIndicatorExplanation())),
        BSLesson(number: 5, title: "Background interaction",
                 subtitle: "Interact with content behind the sheet - iOS 16.4+",
                 icon: "rectangle.and.hand.point.up.left.fill",
                 visual: AnyView(BackgroundInteractionVisual()),
                 explanation: AnyView(BackgroundInteractionExplanation())),
        BSLesson(number: 6, title: "Custom background",
                 subtitle: ".presentationBackground - material, color, corner radius",
                 icon: "paintpalette.fill",
                 visual: AnyView(CustomBackgroundVisual()),
                 explanation: AnyView(CustomBackgroundExplanation())),
        BSLesson(number: 7, title: "Full screen cover",
                 subtitle: ".fullScreenCover - when and why to use it over .sheet",
                 icon: "rectangle.fill",
                 visual: AnyView(FullScreenCoverVisual()),
                 explanation: AnyView(FullScreenCoverExplanation())),
        BSLesson(number: 8, title: "Programmatic dismiss",
                 subtitle: "Dismiss from inside, prevent dismiss, interactiveDismiss",
                 icon: "xmark.circle.fill",
                 visual: AnyView(ProgrammaticDismissVisual()),
                 explanation: AnyView(ProgrammaticDismissExplanation())),
        BSLesson(number: 9, title: "Sheet content layout",
                 subtitle: "Safe areas, keyboard avoidance and scrollable sheets",
                 icon: "rectangle.and.text.magnifyingglass",
                 visual: AnyView(SheetLayoutVisual()),
                 explanation: AnyView(SheetLayoutExplanation())),
    ]
}

struct BSLesson: LessonProtocol {
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
    static let sheetGreen      = Color(hex: "#3B6D11")
    static let sheetGreenLight = Color(hex: "#EAF3DE")
}

// MARK: - Reusable mock sheet content
struct MockSheetContent: View {
    let title: String
    var subtitle: String = "This is content inside the sheet"
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "rectangle.bottomhalf.inset.filled")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.sheetGreen)
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
