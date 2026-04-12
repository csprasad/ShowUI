//
//
//  1_@ModelBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import SwiftData

// MARK: - LESSON 1: @Model Basics
struct SDModelBasicsVisual: View {
    @State private var selectedDemo = 0
    let demos = ["@Model anatomy", "Container setup", "modelContext"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("@Model basics", systemImage: "cylinder.split.1x2.fill")
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
                    // @Model anatomy - annotated code breakdown
                    VStack(spacing: 8) {
                        annotatedBlock(
                            title: "@Model - the macro",
                            code: "@Model\nclass TodoItem {",
                            desc: "Marks the class as a SwiftData model. Synthesises PersistentModel conformance, observation, and the schema.",
                            color: .sdBlue
                        )
                        annotatedBlock(
                            title: "Stored properties → columns",
                            code: "    var title: String\n    var isCompleted: Bool\n    var createdAt: Date",
                            desc: "Every stored property becomes a column. Optional properties allow NULL values. Use @Attribute for custom options.",
                            color: Color(hex: "#0F766E")
                        )
                        annotatedBlock(
                            title: "@Attribute(.unique) - constraints",
                            code: "    @Attribute(.unique)\n    var email: String",
                            desc: "Enforce uniqueness at the database level. Other options: .externalStorage (large blobs), .allowsCloudEncryption.",
                            color: Color(hex: "#7C3AED")
                        )
                        annotatedBlock(
                            title: "Computed properties - not stored",
                            code: "    var displayTitle: String {\n        isCompleted ? \"✓ \" + title : title\n    }",
                            desc: "Computed properties are not stored in the database. They're derived from stored properties each time.",
                            color: Color(hex: "#C2410C")
                        )
                    }

                case 1:
                    // Container setup
                    VStack(spacing: 8) {
                        setupRow(step: "1", icon: "app.fill",
                                 title: "@main App entry point",
                                 code: ".modelContainer(for: [TodoItem.self])",
                                 desc: "Attach once at the top of the app - automatically creates the SQLite file and injects modelContext.")
                        setupRow(step: "2", icon: "cylinder.fill",
                                 title: "ModelContainer",
                                 code: "ModelContainer(for: Schema([TodoItem.self]))",
                                 desc: "The database itself. One per app. Configured with a Schema listing all your model types.")
                        setupRow(step: "3", icon: "pencil.circle.fill",
                                 title: "ModelContext",
                                 code: "@Environment(\\.modelContext) var context",
                                 desc: "The unit of work - use it to insert, delete and save. Every view gets one from the environment.")
                        setupRow(step: "4", icon: "magnifyingglass.circle.fill",
                                 title: "@Query in views",
                                 code: "@Query var items: [TodoItem]",
                                 desc: "Reactive fetch - auto-updates the view when data changes. Defined directly in the view.")

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.sdBlue)
                            Text(".modelContainer(for:) at the App level sets up everything. All child views inherit the context automatically.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // modelContext access patterns
                    VStack(spacing: 8) {
                        contextRow(icon: "app.fill", title: "Via .modelContainer on App",
                                   code: "@main struct MyApp: App {\n    var body: some Scene {\n        WindowGroup { ContentView() }\n            .modelContainer(for: TodoItem.self)\n    }\n}",
                                   desc: "Simplest - one line wires up the whole app")
                        contextRow(icon: "square.fill", title: "Via @Environment in view",
                                   code: "@Environment(\\.modelContext) var context",
                                   desc: "Read the context injected by the container")
                        contextRow(icon: "gearshape.fill", title: "Manual container",
                                   code: "let container = try! ModelContainer(\n    for: TodoItem.self,\n    configurations: ModelConfiguration(\n        isStoredInMemoryOnly: true)\n)",
                                   desc: "In-memory for previews and tests")
                    }
                }
            }
        }
    }

    func annotatedBlock(title: String, code: String, desc: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.system(size: 10, weight: .semibold)).foregroundStyle(color)
            Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(color)
                .padding(7).background(color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 6))
            Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
        } .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(Color.sdPurpleLight.opacity(0.7)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func setupRow(step: String, icon: String, title: String, code: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle().fill(Color.sdBlue).frame(width: 24, height: 24)
                Text(step).font(.system(size: 11, weight: .bold)).foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.system(size: 11, weight: .semibold))
                Text(code).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdBlue)
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(Color.sdBlueLight.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func contextRow(icon: String, title: String, code: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 12)).foregroundStyle(Color.sdBlue)
                Text(title).font(.system(size: 11, weight: .semibold))
            }
            Text(code).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdBlue)
                .padding(6).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 5))
            Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(8).background(Color.sdBlueLight.opacity(0.7)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct SDModelBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "@Model - the foundation")
            Text("@Model is a Swift macro that transforms a class into a SwiftData model. It synthesises PersistentModel conformance, generates the schema for the database, and adds observation so views automatically re-render when data changes.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@Model class MyModel { } - macro does all the work. Must be a class, not a struct.", color: .sdBlue)
                StepRow(number: 2, text: "All stored var properties become columns automatically. No manual schema definition.", color: .sdBlue)
                StepRow(number: 3, text: "@Attribute(.unique) - enforce uniqueness. @Attribute(.externalStorage) for large blobs.", color: .sdBlue)
                StepRow(number: 4, text: ".modelContainer(for: MyModel.self) on WindowGroup - creates DB and injects context.", color: .sdBlue)
                StepRow(number: 5, text: "@Environment(\\.modelContext) var context - access the context in any child view.", color: .sdBlue)
            }

            CalloutBox(style: .warning, title: "@Model must be a class", contentBody: "@Model only works on classes, not structs. This is because SwiftData needs reference semantics to track identity and changes. The macro adds Observation support so views re-render automatically when model properties change.")

            CodeBlock(code: """
import SwiftData

@Model
class TodoItem {
    var title: String
    var isCompleted: Bool = false
    var createdAt: Date   = Date()
    var priority: Int     = 0

    @Attribute(.unique)
    var id: String = UUID().uuidString

    // Computed - NOT stored in DB
    var isOverdue: Bool { createdAt < Date() }

    init(title: String) {
        self.title = title
    }
}

// App setup - one line
@main struct MyApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
            .modelContainer(for: TodoItem.self)
    }
}
""")
        }
    }
}
