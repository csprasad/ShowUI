//
//
//  GridsTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Grid Topic
struct GridsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Grids"
    let subtitle    = "LazyVGrid, LazyHGrid, Grid, columns, alignment and performance"
    let icon        = "square.grid.3x3.fill"
    let color       = Color(hex: "#FDF4FF")
    let accentColor = Color(hex: "#7E22CE")
    let tag         = "Layout"

    @MainActor
    var lessons: [AnyLesson] {
        GridsLessons.all.map { AnyLesson($0) }
    }
}

enum GridsLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        GRLesson(number: 1, title: "GridItem columns",      subtitle: "fixed, flexible, adaptive - the three column types",                icon: "rectangle.split.3x1.fill",       visual: AnyView(GridItemVisual()),        explanation: AnyView(GridItemExplanation())),
        GRLesson(number: 2, title: "LazyVGrid basics",      subtitle: "Vertical scrolling grid - spacing, alignment and cell content",     icon: "square.grid.3x3.fill",           visual: AnyView(LazyVGridBasicsVisual()), explanation: AnyView(LazyVGridBasicsExplanation())),
        GRLesson(number: 3, title: "LazyHGrid basics",      subtitle: "Horizontal scrolling grid - rows, carousels and shelf layouts",     icon: "square.grid.3x3.fill",           visual: AnyView(LazyHGridBasicsVisual()), explanation: AnyView(LazyHGridBasicsExplanation())),
        GRLesson(number: 4, title: "Grid (non-lazy)",       subtitle: "iOS 16 Grid - aligned rows, GridRow, column spans",                 icon: "tablecells.fill",                visual: AnyView(GridNonLazyVisual()),     explanation: AnyView(GridNonLazyExplanation())),
        GRLesson(number: 5, title: "Square & aspect cells", subtitle: "GeometryReader trick, aspectRatio(1) for perfectly square cells",   icon: "square.grid.2x2.fill",           visual: AnyView(SquareCellsVisual()),     explanation: AnyView(SquareCellsExplanation())),
        GRLesson(number: 6, title: "Pinned headers",        subtitle: "pinnedViews - sticky section headers and footers in grids",        icon: "pin.fill",                       visual: AnyView(PinnedHeadersVisual()),   explanation: AnyView(PinnedHeadersExplanation())),
        GRLesson(number: 7, title: "Mixed layouts",         subtitle: "Combining fixed + flexible columns, spanning cells, waterfall",     icon: "rectangle.3.group.fill",         visual: AnyView(MixedLayoutVisual()),     explanation: AnyView(MixedLayoutExplanation())),
        GRLesson(number: 8, title: "Performance & patterns", subtitle: "LazyVGrid vs VStack, id stability, prefetching and cell reuse",   icon: "speedometer",                    visual: AnyView(GridPerformanceVisual()), explanation: AnyView(GridPerformanceExplanation())),
    ]
}

struct GRLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let gridPurple      = Color(hex: "#7E22CE")
    static let gridPurpleLight = Color(hex: "#FDF4FF")
}

// MARK: - Shared sample data
struct GridItem_Data: Identifiable {
    let id = UUID()
    let index: Int
    let label: String
    var colorIndex: Int { index % 9 }
}

extension GridItem_Data {
    static func samples(_ count: Int) -> [GridItem_Data] {
        (0..<count).map { GridItem_Data(index: $0, label: "\($0 + 1)") }
    }
}

// Cell palette
let gridCellColors: [Color] = [
    Color(hex: "#7E22CE"), Color(hex: "#1D4ED8"), Color(hex: "#0F766E"),
    Color(hex: "#B45309"), Color(hex: "#BE123C"), Color(hex: "#0369A1"),
    Color(hex: "#4D7C0F"), Color(hex: "#6D28D9"), Color(hex: "#9D174D"),
]
