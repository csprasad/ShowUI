//
//
//  GeometryReaderTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - GeometryReader Topic
struct GeometryReaderTopic: TopicProtocol {
    let id          = UUID()
    let title       = "GeometryReader"
    let subtitle    = "Size-adaptive layouts, coordinate spaces, anchor preferences and proxies"
    let icon        = "ruler.fill"
    let color       = Color(hex: "#F0FDF4")
    let accentColor = Color(hex: "#15803D")
    let tag         = "Layout"

    @MainActor
    var lessons: [AnyLesson] {
        GeometryReaderLessons.all.map { AnyLesson($0) }
    }
}

enum GeometryReaderLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        GELesson(number: 1, title: "GeometryReader basics",    subtitle: "size, frame, the layout quirks and when to reach for it",              icon: "arrow.up.left.and.arrow.down.right",    visual: AnyView(GeoBasicsVisual()),          explanation: AnyView(GeoBasicsExplanation())),
        GELesson(number: 2, title: "Coordinate spaces",        subtitle: "global, local, named - reading frames in different coordinate systems", icon: "mappin.and.ellipse",                    visual: AnyView(CoordSpacesVisual()),        explanation: AnyView(CoordSpacesExplanation())),
        GELesson(number: 3, title: "Proportional sizing",      subtitle: "Sizing children relative to parent - responsive layouts",              icon: "square.resize",                         visual: AnyView(ProportionalSizingVisual()), explanation: AnyView(ProportionalSizingExplanation())),
        GELesson(number: 4, title: "Offset & parallax",        subtitle: "Reading scroll position, parallax headers, sticky effects",           icon: "square.3.layers.3d.down.forward",                             visual: AnyView(OffsetParallaxVisual()),     explanation: AnyView(OffsetParallaxExplanation())),
        GELesson(number: 5, title: "PreferenceKey",            subtitle: "Passing geometry data up the view tree to ancestors",                  icon: "arrow.up.message.fill",                 visual: AnyView(PreferenceKeyVisual()),      explanation: AnyView(PreferenceKeyExplanation())),
        GELesson(number: 6, title: "matchedGeometryEffect",    subtitle: "Hero transitions - animating shared frames between two views",         icon: "arrow.up.left.and.down.right.magnifyingglass", visual: AnyView(MatchedGeoVisual()),  explanation: AnyView(MatchedGeoExplanation())),
        GELesson(number: 7, title: "Size-adaptive layouts",    subtitle: "Switching layout based on available width - HStack/VStack/grid",       icon: "rectangle.3.group.fill",                visual: AnyView(AdaptiveLayoutVisual()),     explanation: AnyView(AdaptiveLayoutExplanation())),
        GELesson(number: 8, title: "Custom Layout protocol",   subtitle: "iOS 16 Layout - full control over child sizing and placement",         icon: "gear.badge",                            visual: AnyView(CustomLayoutVisual()),       explanation: AnyView(CustomLayoutExplanation())),
    ]
}

struct GELesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let geoGreen      = Color(hex: "#15803D")
    static let geoGreenLight = Color(hex: "#F0FDF4")
}
