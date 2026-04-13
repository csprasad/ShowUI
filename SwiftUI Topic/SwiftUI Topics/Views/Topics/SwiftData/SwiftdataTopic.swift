//
//
//  SwiftdataTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import SwiftData

// MARK: - SwiftData Topic
struct SwiftDataTopic: TopicProtocol {
    let id          = UUID()
    let title       = "SwiftData"
    let subtitle    = "Models, queries, relationships, migrations, CloudKit sync and patterns"
    let icon        = "cylinder.split.1x2.fill"
    let color       = Color(hex: "#F0F4FF")
    let accentColor = Color(hex: "#3B5BDB")
    let tag         = "Foundations"

    @MainActor
    var lessons: [AnyLesson] {
        SwiftDataLessons.all.map { AnyLesson($0) }
    }
}

enum SwiftDataLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        SDLesson(number: 1, title: "@Model basics",
                 subtitle: "@Model macro, @Attribute, modelContainer, modelContext",
                 icon: "cylinder.split.1x2.fill",
                 visual: AnyView(SDModelBasicsVisual()),
                 explanation: AnyView(SDModelBasicsExplanation())),
        SDLesson(number: 2, title: "@Query & fetching",       subtitle: "@Query, predicates, sort descriptors, filtering live data",              icon: "magnifyingglass.circle.fill",         visual: AnyView(SDQueryVisual()),            explanation: AnyView(SDQueryExplanation())),
        SDLesson(number: 3, title: "CRUD operations",         subtitle: "Insert, update, delete - modelContext as the unit of work",              icon: "pencil.and.outline",                  visual: AnyView(SDCRUDVisual()),             explanation: AnyView(SDCRUDExplanation())),
        SDLesson(number: 4, title: "Relationships",           subtitle: "@Relationship, cascade rules, inverse links, to-one & to-many",          icon: "arrow.triangle.branch",               visual: AnyView(SDRelationshipsVisual()),    explanation: AnyView(SDRelationshipsExplanation())),
        SDLesson(number: 5, title: "Predicates & filtering",  subtitle: "#Predicate macro, compound predicates, dynamic queries",                 icon: "line.3.horizontal.decrease.circle.fill", visual: AnyView(SDPredicatesVisual()),   explanation: AnyView(SDPredicatesExplanation())),
        SDLesson(number: 6, title: "Schema & migrations",     subtitle: "VersionedSchema, SchemaMigrationPlan, lightweight vs custom",            icon: "arrow.triangle.2.circlepath.circle.fill", visual: AnyView(SDMigrationsVisual()),  explanation: AnyView(SDMigrationsExplanation())),
        SDLesson(number: 7, title: "CloudKit & sync",         subtitle: "iCloud sync with ModelContainer, CKSyncEngine, conflict resolution",     icon: "icloud.and.arrow.up.fill",            visual: AnyView(SDCloudKitVisual()),         explanation: AnyView(SDCloudKitExplanation())),
        SDLesson(number: 8, title: "Patterns & pitfalls",     subtitle: "Background contexts, testing, undo, concurrency, common mistakes",       icon: "exclamationmark.triangle.fill",       visual: AnyView(SDPatternsVisual()),         explanation: AnyView(SDPatternsExplanation())),
        // ------ Advance ------
        SDLesson(number: 9, title: "FetchDescriptor deep dive",  subtitle: "Manual fetches, fetchLimit, fetchOffset, includePendingChanges, relationship faulting", icon: "doc.text.magnifyingglass",              visual: AnyView(FetchDescriptorVisual()),    explanation: AnyView(FetchDescriptorExplanation())),
        SDLesson(number: 10, title: "Actor isolation & concurrency", subtitle: "@ModelActor - background processing without data races, MainActor bridging",          icon: "cpu.fill",                              visual: AnyView(ModelActorVisual()),         explanation: AnyView(ModelActorExplanation())),
        SDLesson(number: 11, title: "Batch operations",            subtitle: "Bulk insert, bulk delete, NSBatchInsertRequest / NSBatchDeleteRequest via CoreData",      icon: "tray.full.fill",                        visual: AnyView(BatchOpsVisual()),           explanation: AnyView(BatchOpsExplanation())),
        SDLesson(number: 12, title: "Custom @Attribute types",     subtitle: "Codable properties, transformable types, encrypted storage, external blobs",             icon: "lock.doc.fill",                         visual: AnyView(CustomAttributeVisual()),    explanation: AnyView(CustomAttributeExplanation())),
        SDLesson(number: 13, title: "Undo & history tracking",     subtitle: "NSUndoManager integration, NSPersistentHistoryTracking, transaction watching",           icon: "arrow.uturn.backward.circle.fill",      visual: AnyView(UndoHistoryVisual()),        explanation: AnyView(UndoHistoryExplanation())),
        SDLesson(number: 14, title: "Performance & debugging",     subtitle: "Faulting, lazy loading, sql logging, Instruments, avoiding N+1 queries",                 icon: "chart.xyaxis.line",                     visual: AnyView(PerformanceDebugVisual()),   explanation: AnyView(PerformanceDebugExplanation())),
        SDLesson(number: 15, title: "Testing strategies",          subtitle: "Unit tests, UI tests, in-memory stores, seeding, mock contexts, test isolation",         icon: "checkmark.seal.fill",                   visual: AnyView(TestingStrategiesVisual()),  explanation: AnyView(TestingStrategiesExplanation())),
        SDLesson(number: 16, title: "Real-world architecture",     subtitle: "Repository pattern, app store + model layer, dependency injection, MVVM with SwiftData", icon: "building.columns.fill",                 visual: AnyView(ArchitectureVisual()),       explanation: AnyView(ArchitectureExplanation())),
    ]
}

struct SDLesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let sdBlue        = Color(hex: "#3B5BDB")
    static let sdBlueLight   = Color(hex: "#F0F4FF")
    static let sdIndigo      = Color(hex: "#4C3BCF")
    static let sdPurple      = Color(hex: "#6D28D9")
    static let sdPurpleLight = Color(hex: "#F5F0FF")
    static let sdViolet      = Color(hex: "#7C3AED")
}
