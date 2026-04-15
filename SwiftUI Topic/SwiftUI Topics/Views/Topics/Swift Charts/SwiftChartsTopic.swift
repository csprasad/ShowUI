//
//
//  SwiftChartsTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Charts

// MARK: - Swift Charts Topic
struct SwiftChartsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Swift Charts"
    let subtitle    = "Bar, line, area, pie, scatter - marks, scales, axes, annotations and interactivity"
    let icon        = "chart.bar.xaxis"
    let color       = Color(hex: "#F0F7FF")
    let accentColor = Color(hex: "#1A56DB")
    let tag         = "Visual"

    @MainActor
    var lessons: [AnyLesson] {
        SwiftChartsLessons.all.map { AnyLesson($0) }
    }
}

enum SwiftChartsLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        SCLesson(number:  1, title: "Chart fundamentals",       subtitle: "Chart view, data model, mark types overview, anatomy",                    icon: "chart.bar.xaxis",                          visual: AnyView(SCFundamentalsVisual()),      explanation: AnyView(SCFundamentalsExplanation())),
        SCLesson(number:  2, title: "Bar charts",               subtitle: "BarMark, stacked bars, grouped bars, horizontal bars, annotations",       icon: "chart.bar.fill",                           visual: AnyView(SCBarChartsVisual()),         explanation: AnyView(SCBarChartsExplanation())),
        SCLesson(number:  3, title: "Line & area charts",       subtitle: "LineMark, AreaMark, curved lines, multi-series, gradient fills",          icon: "chart.line.uptrend.xyaxis",                visual: AnyView(SCLineAreaVisual()),          explanation: AnyView(SCLineAreaExplanation())),
        SCLesson(number:  4, title: "Pie & donut charts",       subtitle: "SectorMark, donut hole, explode, corner radius, angular range",           icon: "chart.pie.fill",                           visual: AnyView(SCPieDonutVisual()),          explanation: AnyView(SCPieDonutExplanation())),
        SCLesson(number:  5, title: "Point & scatter charts",   subtitle: "PointMark, size encoding, symbol shapes, bubble charts",                  icon: "point.3.connected.trianglepath.dotted",    visual: AnyView(SCScatterVisual()),           explanation: AnyView(SCScatterExplanation())),
        SCLesson(number:  6, title: "Axes & scales",            subtitle: "AxisMarks, ValueLabel, GridLine, Tick, scale domains, log scale",         icon: "slider.horizontal.3",                      visual: AnyView(SCAxesScalesVisual()),        explanation: AnyView(SCAxesScalesExplanation())),
        SCLesson(number:  7, title: "Chart annotations",        subtitle: "ChartOverlay, RuleMark, threshold lines, custom overlays, value labels",  icon: "text.badge.plus",                          visual: AnyView(SCAnnotationsVisual()),       explanation: AnyView(SCAnnotationsExplanation())),
        SCLesson(number:  8, title: "Multi-mark & combining",   subtitle: "Multiple mark types, RectangleMark, overlay series, candlestick",         icon: "chart.bar.doc.horizontal.fill",            visual: AnyView(SCMultiMarkVisual()),         explanation: AnyView(SCMultiMarkExplanation())),
        SCLesson(number:  9, title: "Interactivity",            subtitle: "chartOverlay gesture, selection, crosshair, tooltip on drag",             icon: "hand.point.up.left.fill",                  visual: AnyView(SCInteractiveVisual()),       explanation: AnyView(SCInteractiveExplanation())),
        SCLesson(number: 10, title: "Scrolling charts",         subtitle: "chartScrollableAxes, visible domain, live streaming data",                icon: "scroll.fill",                              visual: AnyView(SCScrollingVisual()),         explanation: AnyView(SCScrollingExplanation())),
        SCLesson(number: 11, title: "Chart styling",            subtitle: "foregroundStyle, chartForegroundStyleScale, series colours, dark mode",   icon: "paintpalette.fill",                        visual: AnyView(SCStylingVisual()),           explanation: AnyView(SCStylingExplanation())),
        SCLesson(number: 12, title: "Real-world patterns",      subtitle: "Dashboard layout, animated data, accessibility, performance, export",     icon: "rectangle.3.group.fill",                   visual: AnyView(SCRealWorldVisual()),         explanation: AnyView(SCRealWorldExplanation())),
    ]
}

struct SCLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let scBlue      = Color(hex: "#1A56DB")
    static let scBlueLight = Color(hex: "#F0F7FF")
    static let scIndigo    = Color(hex: "#4338CA")
}

// MARK: - Shared chart data models

struct SalesData: Identifiable {
    let id = UUID()
    let month: String
    let revenue: Double
    let category: String
}

struct TimeSeriesPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    let series: String
}

struct ScatterPoint: Identifiable {
    let id = UUID()
    let x: Double
    let y: Double
    let size: Double
    let label: String
}

extension SalesData {
    static let monthly: [SalesData] = [
        SalesData(month: "Jan", revenue: 42, category: "A"),
        SalesData(month: "Feb", revenue: 58, category: "A"),
        SalesData(month: "Mar", revenue: 71, category: "A"),
        SalesData(month: "Apr", revenue: 63, category: "A"),
        SalesData(month: "May", revenue: 89, category: "A"),
        SalesData(month: "Jun", revenue: 102, category: "A"),
    ]
    static let stacked: [SalesData] = [
        SalesData(month: "Jan", revenue: 30, category: "iOS"),
        SalesData(month: "Jan", revenue: 20, category: "Android"),
        SalesData(month: "Feb", revenue: 45, category: "iOS"),
        SalesData(month: "Feb", revenue: 18, category: "Android"),
        SalesData(month: "Mar", revenue: 55, category: "iOS"),
        SalesData(month: "Mar", revenue: 28, category: "Android"),
        SalesData(month: "Apr", revenue: 48, category: "iOS"),
        SalesData(month: "Apr", revenue: 25, category: "Android"),
        SalesData(month: "May", revenue: 70, category: "iOS"),
        SalesData(month: "May", revenue: 35, category: "Android"),
        SalesData(month: "Jun", revenue: 82, category: "iOS"),
        SalesData(month: "Jun", revenue: 40, category: "Android"),
    ]
}
