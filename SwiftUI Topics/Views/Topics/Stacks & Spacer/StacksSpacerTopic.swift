//
//
//  StacksSpacerTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `05/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Stacks & Spacer Topic
struct StacksSpacerTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Stacks & Spacer"
    let subtitle    = "Layout fundamentals - HStack, VStack, ZStack, frame, alignment"
    let icon        = "square.3.layers.3d.middle.filled"
    let color       = Color(hex: "#F3EFFE")
    let accentColor = Color(hex: "#6B3FA0")
    let tag         = "Foundations"

    @MainActor
    var lessons: [AnyLesson] {
        StacksSpacerLessons.all.map { AnyLesson($0) }
    }
}

enum StacksSpacerLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        SSLesson(number: 1, title: "HStack & VStack",    subtitle: "Horizontal and vertical stacks - axis, spacing, alignment",      icon: "rectangle.split.3x1.fill",           visual: AnyView(HVStackVisual()),          explanation: AnyView(HVStackExplanation())),
        SSLesson(number: 2, title: "ZStack",             subtitle: "Layering views, z-order and alignment",                          icon: "square.2.layers.3d.fill",            visual: AnyView(ZStackVisual()),           explanation: AnyView(ZStackExplanation())),
        SSLesson(number: 3, title: "Spacer & Divider",   subtitle: "Flexible space, fixed space and visual dividers",                 icon: "arrow.left.and.right",               visual: AnyView(SpacerDividerVisual()),    explanation: AnyView(SpacerDividerExplanation())),
        SSLesson(number: 4, title: "Alignment",          subtitle: ".leading, .center, .trailing and custom alignment guides",        icon: "align.horizontal.center.fill",       visual: AnyView(AlignmentGuideVisual()),   explanation: AnyView(AlignmentGuideExplanation())),
        SSLesson(number: 5, title: "Frame",              subtitle: "Fixed size, maxWidth: .infinity and aspect ratios",               icon: "rectangle.dashed",                   visual: AnyView(FrameVisual()),            explanation: AnyView(FrameExplanation())),
        SSLesson(number: 6, title: "Padding & offset",   subtitle: ".padding() vs .offset() - what they do and when to use each",    icon: "arrow.up.left.and.arrow.down.right", visual: AnyView(PaddingOffsetVisual()),    explanation: AnyView(PaddingOffsetExplanation())),
        SSLesson(number: 7, title: "ViewThatFits",       subtitle: "Adaptive layout - picks the first view that fits the space",     icon: "arrow.down.left.and.arrow.up.right", visual: AnyView(ViewThatFitsVisual()),     explanation: AnyView(ViewThatFitsExplanation())),
        SSLesson(number: 8, title: "Layout priority",    subtitle: ".layoutPriority() - controlling which views expand and shrink",   icon: "scale.3d",                           visual: AnyView(LayoutPriorityVisual()),   explanation: AnyView(LayoutPriorityExplanation())),
    ]
}

struct SSLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let ssPurple      = Color(hex: "#6B3FA0")
    static let ssPurpleLight = Color(hex: "#F3EFFE")
}
