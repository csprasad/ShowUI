//
//
//  ListforeachTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - List & ForEach Topic
struct ListForEachTopic: TopicProtocol {
    let id          = UUID()
    let title       = "List & ForEach"
    let subtitle    = "Dynamic lists, swipe actions, edit mode, sections and performance"
    let icon        = "list.bullet"
    let color       = Color(hex: "#F0F4FF")
    let accentColor = Color(hex: "#3461C1")
    let tag         = "Foundations"

    @MainActor
    var lessons: [AnyLesson] {
        ListForEachLessons.all.map { AnyLesson($0) }
    }
}

enum ListForEachLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        LFLesson(number: 1, title: "ForEach basics",        subtitle: "id parameter, Identifiable, index-based iteration",               icon: "repeat.circle.fill",             visual: AnyView(ForEachBasicsVisual()),      explanation: AnyView(ForEachBasicsExplanation())),
        LFLesson(number: 2, title: "List basics",           subtitle: "List vs ForEach, listStyle and single/multi selection",            icon: "list.bullet.rectangle.fill",     visual: AnyView(ListBasicsVisual()),         explanation: AnyView(ListBasicsExplanation())),
        LFLesson(number: 3, title: "Sections",              subtitle: "Grouped lists, headers, footers and collapsible sections",         icon: "rectangle.grid.1x2.fill",        visual: AnyView(SectionsVisual()),           explanation: AnyView(SectionsExplanation())),
        LFLesson(number: 4, title: "Swipe actions",         subtitle: "Leading and trailing swipe actions, roles and destructive",        icon: "arrow.left.and.right.circle.fill",visual: AnyView(SwipeActionsVisual()),      explanation: AnyView(SwipeActionsExplanation())),
        LFLesson(number: 5, title: "Edit mode",             subtitle: "onDelete, onMove, EditButton and reordering rows",                 icon: "pencil.circle.fill",             visual: AnyView(EditModeVisual()),           explanation: AnyView(EditModeExplanation())),
        LFLesson(number: 6, title: "Dynamic data",          subtitle: "Adding, removing and sorting @State arrays",                      icon: "arrow.up.arrow.down.circle.fill", visual: AnyView(DynamicDataVisual()),       explanation: AnyView(DynamicDataExplanation())),
        LFLesson(number: 7, title: "Row customization",     subtitle: "Separators, insets, row backgrounds and custom row styling",       icon: "paintbrush.pointed.fill",        visual: AnyView(RowCustomizationVisual()),   explanation: AnyView(RowCustomizationExplanation())),
        LFLesson(number: 8, title: "Performance",           subtitle: "LazyVStack vs List, when to use each, rendering strategy",        icon: "speedometer",                    visual: AnyView(ListPerformanceVisual()),    explanation: AnyView(ListPerformanceExplanation())),
    ]
}

struct LFLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let lfBlue      = Color(hex: "#3461C1")
    static let lfBlueLight = Color(hex: "#F0F4FF")
}

// MARK: - Shared sample data
struct LFContact: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var role: String
    var initial: String { String(name.prefix(1)) }
}

struct LFTask: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var isDone: Bool = false
    var priority: Priority = .medium

    enum Priority: String, CaseIterable {
        case low = "Low", medium = "Medium", high = "High"
        var color: Color {
            switch self {
            case .low: return .animTeal
            case .medium: return .animAmber
            case .high: return .animCoral
            }
        }
    }
}

extension LFContact {
    static let samples: [LFContact] = [
        LFContact(name: "Alice Chen",    role: "iOS Engineer"),
        LFContact(name: "Bob Martin",    role: "Designer"),
        LFContact(name: "Carol White",   role: "PM"),
        LFContact(name: "David Park",    role: "Backend"),
        LFContact(name: "Eva Torres",    role: "QA"),
    ]
}

extension LFTask {
    static let samples: [LFTask] = [
        LFTask(title: "Fix navigation bug",    priority: .high),
        LFTask(title: "Write unit tests",      priority: .medium),
        LFTask(title: "Update dependencies",   priority: .low),
        LFTask(title: "Review PR #42",         priority: .high),
        LFTask(title: "Update README",         priority: .low),
    ]
}
