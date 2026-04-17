//
//
//  CombineBasicsTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `17/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine

// MARK: - Combine Basics Topic
struct CombineBasicsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Combine"
    let subtitle    = "Publishers, subscribers, operators, schedulers, SwiftUI integration and real-world patterns"
    let icon        = "arrow.triangle.merge"
    let color       = Color(hex: "#FFF7ED")
    let accentColor = Color(hex: "#C2410C")
    let tag         = "Foundations"

    @MainActor
    var lessons: [AnyLesson] {
        CombineLessons.all.map { AnyLesson($0) }
    }
}

enum CombineLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        CBLesson(number:  1, title: "Publisher & Subscriber",    subtitle: "What Combine is, Publisher protocol, Subscriber, subscription lifecycle",        icon: "antenna.radiowaves.left.and.right",        visual: AnyView(CBPubSubVisual()),            explanation: AnyView(CBPubSubExplanation())),
        CBLesson(number:  2, title: "Built-in publishers",       subtitle: "Just, Empty, Fail, Future, Deferred, PassthroughSubject, CurrentValueSubject",   icon: "shippingbox.fill",                        visual: AnyView(CBBuiltInPublishersVisual()),  explanation: AnyView(CBBuiltInPublishersExplanation())),
        CBLesson(number:  3, title: "Transforming operators",    subtitle: "map, flatMap, compactMap, scan, collect, replaceNil, setFailureType",             icon: "arrow.triangle.2.circlepath",             visual: AnyView(CBTransformVisual()),          explanation: AnyView(CBTransformExplanation())),
        CBLesson(number:  4, title: "Filtering operators",       subtitle: "filter, removeDuplicates, debounce, throttle, first, last, drop, prefix",         icon: "line.3.horizontal.decrease.circle.fill",  visual: AnyView(CBFilterVisual()),             explanation: AnyView(CBFilterExplanation())),
        CBLesson(number:  5, title: "Combining operators",       subtitle: "merge, zip, combineLatest, switchToLatest, append, prepend",                     icon: "arrow.triangle.merge",                    visual: AnyView(CBCombiningVisual()),          explanation: AnyView(CBCombiningExplanation())),
        CBLesson(number:  6, title: "Error handling",            subtitle: "catch, retry, mapError, replaceError, assertNoFailure, tryCatch",                 icon: "exclamationmark.triangle.fill",           visual: AnyView(CBErrorHandlingVisual()),      explanation: AnyView(CBErrorHandlingExplanation())),
        CBLesson(number:  7, title: "Schedulers & threading",    subtitle: "receive(on:), subscribe(on:), RunLoop, DispatchQueue, ImmediateScheduler",        icon: "cpu.fill",                                visual: AnyView(CBSchedulersVisual()),         explanation: AnyView(CBSchedulersExplanation())),
        CBLesson(number:  8, title: "SwiftUI integration",       subtitle: "onReceive, @Published, ObservableObject, assign(to:), sink in views",            icon: "iphone.gen3",                             visual: AnyView(CBSwiftUIVisual()),            explanation: AnyView(CBSwiftUIExplanation())),
        CBLesson(number:  9, title: "Networking with Combine",   subtitle: "URLSession.dataTaskPublisher, decode, retry, network pipeline patterns",          icon: "network",                                 visual: AnyView(CBNetworkingVisual()),         explanation: AnyView(CBNetworkingExplanation())),
        CBLesson(number: 10, title: "Timer & notifications",     subtitle: "Timer.publish, NotificationCenter.publisher, keyboard, app lifecycle",            icon: "timer",                                   visual: AnyView(CBTimerNotifVisual()),         explanation: AnyView(CBTimerNotifExplanation())),
        CBLesson(number: 11, title: "Subjects deep dive",        subtitle: "PassthroughSubject vs CurrentValueSubject, multicast, share, lifecycle",          icon: "dot.radiowaves.left.and.right",           visual: AnyView(CBSubjectsVisual()),           explanation: AnyView(CBSubjectsExplanation())),
        CBLesson(number: 12, title: "Real-world patterns",       subtitle: "Search debounce, form validation, cancellation, memory leaks, Combine vs async", icon: "building.columns.fill",                   visual: AnyView(CBRealWorldVisual()),          explanation: AnyView(CBRealWorldExplanation())),
    ]
}

struct CBLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let cbOrange      = Color(hex: "#C2410C")
    static let cbOrangeLight = Color(hex: "#FFF7ED")
    static let cbAmber       = Color(hex: "#D97706")
}
