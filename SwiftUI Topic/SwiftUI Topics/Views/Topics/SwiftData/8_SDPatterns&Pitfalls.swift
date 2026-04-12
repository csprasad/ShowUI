//
//
//  8_SDPatterns&Pitfalls.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Patterns & Pitfalls
struct SDPatternsVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Common mistakes", "Background context", "Testing"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Patterns & pitfalls", systemImage: "exclamationmark.triangle.fill")
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
                    // Common mistakes
                    VStack(spacing: 8) {
                        mistakeRow(bad: true,
                                   code: "// No VersionedSchema - data destroyed on schema change",
                                   fix: "Wrap initial schema in VersionedSchema from day one")
                        mistakeRow(bad: true,
                                   code: "let container = try! ModelContainer(for: M.self)\n// force-unwrap crashes on schema mismatch",
                                   fix: "Use do/catch and handle migration errors gracefully")
                        mistakeRow(bad: true,
                                   code: "@Query var items // in child view that doesn't need live updates",
                                   fix: "Pass items from parent - @Query only where live observation needed")
                        mistakeRow(bad: true,
                                   code: "item.title = \"new\"\n// inside Task {} - off main thread",
                                   fix: "Mutate @Model on main thread - use @MainActor or await MainActor.run { }")
                        mistakeRow(bad: false,
                                   code: "@Query(sort: \\.createdAt, order: .reverse)\nvar todos: [TodoItem]  // ← correct usage",
                                   fix: "✓ @Query with sort at the right view level")
                    }

                case 1:
                    // Background context
                    VStack(spacing: 8) {
                        Text("Background processing without blocking the UI").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        codeBlock("""
// Create a background context from the container
let bgContext = ModelContext(container)

// Process on a background Task
Task.detached {
    let bgContext = ModelContext(container)

    // Fetch and process data
    let descriptor = FetchDescriptor<TodoItem>()
    let items = try bgContext.fetch(descriptor)

    for item in items {
        item.processedAt = Date()
    }

    // Save background context
    try bgContext.save()

    // Main context auto-merges via NSPersistentStore
}

// OR use the actor-based approach
actor DataProcessor {
    private let container: ModelContainer

    func importData(_ raw: [RawItem]) async throws {
        let context = ModelContext(container)
        for item in raw {
            context.insert(TodoItem(title: item.title))
        }
        try context.save()
    }
}
""")

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.sdBlue)
                            Text("Background contexts auto-merge changes to the main context - @Query updates automatically.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // Testing
                    VStack(spacing: 8) {
                        Text("Unit testing with in-memory container").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        codeBlock("""
// Create an in-memory container for tests
func makeTestContainer() throws -> ModelContainer {
    let config = ModelConfiguration(
        isStoredInMemoryOnly: true
    )
    return try ModelContainer(
        for: TodoItem.self,
        configurations: config
    )
}

// Example test
func testInsertAndFetch() throws {
    let container = try makeTestContainer()
    let context = ModelContext(container)

    // Insert
    context.insert(TodoItem(title: "Test item"))
    try context.save()

    // Fetch
    let todos = try context.fetch(
        FetchDescriptor<TodoItem>()
    )
    XCTAssertEqual(todos.count, 1)
    XCTAssertEqual(todos[0].title, "Test item")
}

// Preview helper
extension ModelContainer {
    static var preview: ModelContainer = {
        let config = ModelConfiguration(
            isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: TodoItem.self,
            configurations: config)
        // Seed preview data
        let ctx = container.mainContext
        ctx.insert(TodoItem(title: "Preview todo"))
        return container
    }()
}
""")
                    }
                }
            }
        }
    }

    func mistakeRow(bad: Bool, code: String, fix: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 6) {
                Image(systemName: bad ? "xmark.circle.fill" : "checkmark.circle.fill")
                    .font(.system(size: 12)).foregroundStyle(bad ? Color.animCoral : Color.formGreen)
                Text(code).font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(bad ? Color.animCoral : Color.formGreen)
            }
            if bad {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.right").font(.system(size: 9)).foregroundStyle(Color.sdBlue)
                    Text(fix).font(.system(size: 10)).foregroundStyle(Color.sdBlue)
                }.padding(.leading, 18)
            }
        }
        .padding(8).background(bad ? Color(hex: "#FCEBEB") : Color(hex: "#E1F5EE")).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func codeBlock(_ text: String) -> some View {
        Text(text).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdBlue)
            .padding(8).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct SDPatternsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "SwiftData patterns and pitfalls")
            Text("SwiftData is powerful but opinionated. Most production bugs come from missing VersionedSchema, off-thread mutations, @Query overuse, or ignoring migration failures. These patterns prevent the most common issues.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "VersionedSchema from day one - even if you never migrate, you need it to migrate later.", color: .sdBlue)
                StepRow(number: 2, text: "@MainActor on your @Model class - guarantees all mutations happen on the main thread.", color: .sdBlue)
                StepRow(number: 3, text: "@Query at the view level - don't over-use it. Pass items down as parameters to child views.", color: .sdBlue)
                StepRow(number: 4, text: "In-memory ModelContainer for previews and tests - never touches the real database.", color: .sdBlue)
                StepRow(number: 5, text: "Background contexts for bulk imports - create ModelContext(container) on a background Task.", color: .sdBlue)
            }

            CalloutBox(style: .danger, title: "Mark models @MainActor", contentBody: "SwiftData models are not thread-safe by default. Mutating model properties off the main thread causes data races and crashes. Mark @Model classes @MainActor to make mutations safe, or carefully use background ModelContext instances that are created and destroyed on the same thread.")

            CalloutBox(style: .success, title: "Preview containers", contentBody: "Create a static ModelContainer.preview property with isStoredInMemoryOnly: true and pre-seeded data. Attach it with .modelContainer(ModelContainer.preview) in #Preview blocks. Previews stay fast and never touch the real database.")

            CodeBlock(code: """
// ✓ Safe @Model - MainActor isolated
@MainActor
@Model class TodoItem {
    var title: String = ""
    var isDone: Bool  = false
}

// ✓ Pass items down - avoid @Query in every child
struct ParentView: View {
    @Query var todos: [TodoItem]        // fetch once here

    var body: some View {
        ForEach(todos) { todo in
            TodoRow(todo: todo)         // pass as let
        }
    }
}
struct TodoRow: View {
    let todo: TodoItem                  // no @Query needed
}

// ✓ Preview container
extension ModelContainer {
    static var preview: ModelContainer = {
        let c = try! ModelContainer(
            for: TodoItem.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
        c.mainContext.insert(TodoItem(title: "Sample"))
        return c
    }()
}
#Preview {
    ContentView()
        .modelContainer(.preview)
}
""")
        }
    }
}
