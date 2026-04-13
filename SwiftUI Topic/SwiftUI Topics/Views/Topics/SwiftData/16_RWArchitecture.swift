//
//
//  16_RWArchitecture.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 16: Real-World Architecture
struct ArchitectureVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Repository pattern", "Dependency injection", "MVVM + SwiftData"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Real-world architecture", systemImage: "building.columns.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sdPurple)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.sdPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.sdPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Repository pattern
                    VStack(spacing: 8) {
                        layerDiagram
                        codeBlock("""
// Repository - abstracts SwiftData from views
@MainActor
protocol TodoRepositoryProtocol {
    var todos: [TodoItem] { get }
    func insert(title: String, priority: Int)
    func delete(_ item: TodoItem)
    func fetchActive() throws -> [TodoItem]
}

@MainActor
final class TodoRepository: TodoRepositoryProtocol {
    private let context: ModelContext

    init(context: ModelContext) { self.context = context }

    func insert(title: String, priority: Int = 0) {
        context.insert(TodoItem(title: title, priority: priority))
    }

    func delete(_ item: TodoItem) {
        context.delete(item)
    }

    func fetchActive() throws -> [TodoItem] {
        try context.fetch(FetchDescriptor<TodoItem>(
            predicate: #Predicate { !$0.isCompleted }
        ))
    }
}
""")
                    }

                case 1:
                    // Dependency injection
                    VStack(spacing: 8) {
                        codeBlock("""
// Inject repository via @Observable + @Environment

@Observable
final class AppEnvironment {
    let todoRepo: TodoRepositoryProtocol
    let projectRepo: ProjectRepositoryProtocol

    init(container: ModelContainer) {
        let ctx  = container.mainContext
        todoRepo    = TodoRepository(context: ctx)
        projectRepo = ProjectRepository(context: ctx)
    }
}

// Root injection
@main struct MyApp: App {
    @State private var env: AppEnvironment

    init() {
        let container = try! ModelContainer(for: TodoItem.self)
        _env = State(initialValue: AppEnvironment(container: container))
    }

    var body: some Scene {
        WindowGroup { RootView() }
            .environment(env)
    }
}

// Usage in view
struct TodoListView: View {
    @Environment(AppEnvironment.self) var env

    var body: some View {
        // Access via env.todoRepo
    }
}
""")
                    }

                default:
                    // MVVM
                    VStack(spacing: 8) {
                        codeBlock("""
// ViewModel holds @Query + business logic
@Observable
@MainActor
final class TodoListViewModel {
    private let context: ModelContext
    var isLoading = false
    var errorMessage: String?

    // @Query equivalent via FetchDescriptor
    var todos: [TodoItem] = []
    var activeCount: Int  = 0

    init(context: ModelContext) { self.context = context }

    func load() throws {
        todos = try context.fetch(
            FetchDescriptor<TodoItem>(
                sortBy: [SortDescriptor(\\.createdAt, order: .reverse)]
            )
        )
        activeCount = try context.fetchCount(
            FetchDescriptor<TodoItem>(
                predicate: #Predicate { !$0.isCompleted }
            )
        )
    }

    func toggle(_ item: TodoItem) {
        item.isCompleted.toggle()
        // Auto-saved at run loop end
    }
}

// View
struct TodoListView: View {
    @State private var vm: TodoListViewModel

    var body: some View {
        List(vm.todos) { item in
            TodoRow(item: item)
                .onTapGesture { vm.toggle(item) }
        }
        .onAppear { try? vm.load() }
        .overlay { if vm.isLoading { ProgressView() } }
    }
}
""")
                    }
                }
            }
        }
    }

    var layerDiagram: some View {
        VStack(spacing: 4) {
            ForEach([
                (color: Color.sdPurple, label: "SwiftUI View", note: "@Query / @Environment"),
                (color: Color.sdViolet, label: "Repository / Service", note: "business logic, FetchDescriptor"),
                (color: Color.sdBlue,    label: "ModelContext", note: "insert / delete / fetch"),
                (color: Color(hex: "#0891B2"), label: "SwiftData (SQLite)", note: "persisted data on disk"),
            ], id: \.label) { layer in
                HStack(spacing: 10) {
                    Text(layer.label)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 140)
                        .padding(.vertical, 6)
                        .background(layer.color)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    Text(layer.note)
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    func codeBlock(_ text: String) -> some View {
        Text(text).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdPurple).frame(maxWidth: .infinity, alignment: .leading)
            .padding().background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ArchitectureExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Real-world architecture patterns")
            Text("For large apps, putting SwiftData calls directly in every view creates untestable, hard-to-change code. A repository layer abstracts the data operations, enabling dependency injection, unit testing, and clean separation of concerns.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Repository pattern - class that wraps ModelContext operations behind a protocol.", color: .sdPurple)
                StepRow(number: 2, text: "Protocol-backed repositories - swap real impl for mock in tests without changing views.", color: .sdPurple)
                StepRow(number: 3, text: "@Observable AppEnvironment - inject all repos via a single environment object.", color: .sdPurple)
                StepRow(number: 4, text: "MVVM: @Observable ViewModel holds FetchDescriptor-based fetches + business logic.", color: .sdPurple)
                StepRow(number: 5, text: "Views stay thin - only layout and user interaction. All data logic lives in the model layer.", color: .sdPurple)
            }

            CalloutBox(style: .info, title: "Keep @Query where it belongs", contentBody: "@Query in a view is perfectly fine for simple screens. Only reach for a ViewModel/Repository when you need: business logic on top of fetches, multiple data sources combined, testability, or complex filtering that changes at runtime.")

            CodeBlock(code: """
// The three layers
// 1. Model (SwiftData)
@Model class TodoItem { var title = ""; var isDone = false }

// 2. Repository (business logic + data access)
@MainActor
final class TodoRepository {
    private let context: ModelContext

    func fetchActive() throws -> [TodoItem] {
        try context.fetch(FetchDescriptor<TodoItem>(
            predicate: #Predicate { !$0.isDone },
            sortBy: [SortDescriptor(\\.createdAt, order: .reverse)]
        ))
    }

    func complete(_ item: TodoItem) {
        item.isDone = true
        // cascade: update streak, send notification etc.
    }
}

// 3. View (purely presentational)
struct TodoListView: View {
    @Environment(TodoRepository.self) var repo
    @State private var todos: [TodoItem] = []

    var body: some View {
        List(todos) { TodoRow(todo: $0) }
            .task { todos = (try? repo.fetchActive()) ?? [] }
    }
}
""")
        }
    }
}

