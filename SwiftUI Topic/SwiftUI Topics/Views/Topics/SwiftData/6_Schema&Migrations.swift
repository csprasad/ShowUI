//
//
//  6_Schema&Migrations.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Schema & Migrations
struct SDMigrationsVisual: View {
    @State private var selectedDemo = 0
    let demos = ["VersionSchema", "Migration plan", "Migration types"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Schema & migrations", systemImage: "arrow.triangle.2.circlepath.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sdBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.sdBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.sdBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // VersionedSchema
                    VStack(alignment: .leading, spacing: 8) {
                        versionBlock(v: "V1", icon: "1.circle.fill", color: .secondary,
                            models: ["TodoItem: title, done"],
                            desc: "Initial schema - basic todo with title and completion flag")
                        arrowDown
                        versionBlock(v: "V2", icon: "2.circle.fill", color: .animAmber,
                            models: ["TodoItem: title, done, priority"],
                            desc: "Added priority Int property - lightweight migration handles this")
                        arrowDown
                        versionBlock(v: "V3", icon: "3.circle.fill", color: .sdBlue,
                            models: ["TodoItem: title, done, priority", "Project: name, tasks"],
                            desc: "Added Project model + relationship - lightweight if only adds, custom if transforms data")

                        codeNote("enum MySchema: VersionedSchema { ... }\nenum V1Schema: VersionedSchema { ... }")
                    }

                case 1:
                    // Migration plan
                    VStack(spacing: 8) {
                        codeBlock("""
enum MyMigrationPlan: SchemaMigrationPlan {

    // List ALL versions in order
    static var schemas: [VersionedSchema.Type] = [
        SchemaV1.self,
        SchemaV2.self,
        SchemaV3.self
    ]

    // Declare each migration stage
    static var stages: [MigrationStage] = [
        migrateV1toV2,
        migrateV2toV3
    ]

    // Lightweight - SwiftData handles automatically
    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: SchemaV1.self,
        toVersion:   SchemaV2.self
    )

    // Custom - you write the migration logic
    static let migrateV2toV3 = MigrationStage.custom(
        fromVersion: SchemaV2.self,
        toVersion:   SchemaV3.self,
        willMigrate: nil,
        didMigrate: { context in
            // fetch old objects and transform them
            let todos = try context.fetch(FetchDescriptor<SchemaV2.TodoItem>())
            for todo in todos {
                let project = SchemaV3.Project(name: "Default")
                project.tasks.append(todo)
                context.insert(project)
            }
        }
    )
}
""")
                    }

                default:
                    // Migration types
                    VStack(spacing: 8) {
                        migTypeRow(type: "Lightweight", color: .formGreen,
                                   when: "Adding new properties, adding new models, renaming columns with @Attribute(originalName:)",
                                   how: "MigrationStage.lightweight(from:to:) - automatic")
                        migTypeRow(type: "Custom", color: .animAmber,
                                   when: "Splitting/merging models, transforming data, changing property types, complex relationship changes",
                                   how: "MigrationStage.custom(…, didMigrate: { context in … })")
                        migTypeRow(type: "originalName", color: .sdBlue,
                                   when: "Renaming a property without data loss",
                                   how: "@Attribute(originalName: \"oldName\") var newName: String")

                        codeNote("@Attribute(originalName: \"name\")\nvar title: String  // ← rename without data loss")
                    }
                }
            }
        }
    }

    var arrowDown: some View {
        HStack { Spacer(); Image(systemName: "arrow.down").font(.system(size: 12)).foregroundStyle(.secondary); Spacer() }
    }

    func versionBlock(v: String, icon: String, color: Color, models: [String], desc: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon).font(.system(size: 18)).foregroundStyle(color)
            VStack(alignment: .leading, spacing: 4) {
                Text("Schema \(v)").font(.system(size: 12, weight: .semibold)).foregroundStyle(color)
                ForEach(models, id: \.self) { m in
                    Text(m).font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                }
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }
        .padding(8).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func migTypeRow(type: String, color: Color, when: String, how: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(type).font(.system(size: 11, weight: .semibold)).foregroundStyle(color)
            Text("When: \(when)").font(.system(size: 10)).foregroundStyle(.secondary)
            Text(how).font(.system(size: 9, design: .monospaced)).foregroundStyle(color)
                .padding(5).background(color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 5))
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(8).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func codeNote(_ text: String) -> some View {
        Text(text).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.sdBlue)
            .padding(7).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 7))
    }

    func codeBlock(_ text: String) -> some View {
        Text(text).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdBlue)
            .padding(10).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct SDMigrationsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Schema versions and migrations")
            Text("When your @Model changes, you need a migration plan so existing user data isn't lost. SwiftData uses VersionedSchema and SchemaMigrationPlan to describe schema history and the steps to migrate between versions.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "VersionedSchema enum - wraps all @Model types for one schema version.", color: .sdBlue)
                StepRow(number: 2, text: "SchemaMigrationPlan - lists all schemas and stages in order. Register with ModelContainer.", color: .sdBlue)
                StepRow(number: 3, text: "MigrationStage.lightweight - for additive changes (new properties, new models). Automatic.", color: .sdBlue)
                StepRow(number: 4, text: "MigrationStage.custom - for data transformation. didMigrate closure runs on the context.", color: .sdBlue)
                StepRow(number: 5, text: "@Attribute(originalName: \"old\") var new: Type - rename property without data loss.", color: .sdBlue)
            }

            CalloutBox(style: .danger, title: "Always use VersionedSchema from day one", contentBody: "If you ship an app without VersionedSchema and later need to migrate, SwiftData will destroy and recreate the store (deleting all user data). Wrap your initial schema in a VersionedSchema from your first release.")

            CodeBlock(code: """
// V1 - initial
enum SchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] = [TodoItem.self]

    @Model class TodoItem {
        var title: String = ""
    }
}

// V2 - added priority
enum SchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    static var models: [any PersistentModel.Type] = [TodoItem.self]

    @Model class TodoItem {
        var title: String = ""
        var priority: Int = 0   // new property
    }
}

// Migration plan
enum MyMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] = [
        SchemaV1.self, SchemaV2.self
    ]
    static var stages: [MigrationStage] = [
        .lightweight(fromVersion: SchemaV1.self, toVersion: SchemaV2.self)
    ]
}

// Register with container
.modelContainer(for: SchemaV2.TodoItem.self,
                migrationPlan: MyMigrationPlan.self)
""")
        }
    }
}

