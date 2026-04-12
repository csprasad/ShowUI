//
//
//  15_TestingStrategies.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import SwiftData

// MARK: - LESSON 15: Testing Strategies
struct TestingStrategiesVisual: View {
    @State private var selectedDemo   = 0
    @State private var testResults: [TestResult] = []
    @State private var isRunning      = false
    let demos = ["In-memory setup", "Test patterns", "Preview container"]

    struct TestResult: Identifiable {
        let id = UUID(); let name: String; let passed: Bool; let detail: String
    }

    let allTests: [(String, String, Bool, Double)] = [
        ("testInsertItem",    "TodoItem inserted, count = 1",        true,  0.2),
        ("testDeleteItem",    "Item deleted, count = 0",             true,  0.3),
        ("testFetchFilter",   "Filtered fetch returns 2 items",      true,  0.4),
        ("testRelationship",  "Project.tasks count = 3",             true,  0.5),
        ("testPredicate",     "#Predicate { $0.priority > 1 }",      true,  0.65),
        ("testCascadeDelete", "Tasks deleted with project",          true,  0.8),
        ("testSortDescriptor","Sorted by date, newest first",        true,  0.95),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Testing strategies", systemImage: "checkmark.seal.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sdPurple)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; testResults = [] }
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
                    // In-memory setup
                    VStack(spacing: 8) {
                        codeBlock("""
// Helper - creates a fresh in-memory container per test
func makeContainer() throws -> ModelContainer {
    let schema = Schema([TodoItem.self, Project.self])
    let config = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: true
    )
    return try ModelContainer(
        for: schema,
        configurations: config
    )
}

// XCTest example
class TodoItemTests: XCTestCase {
    var container: ModelContainer!
    var context: ModelContext!

    override func setUp() async throws {
        container = try makeContainer()
        context   = ModelContext(container)
    }

    override func tearDown() async throws {
        // In-memory - auto-destroyed after test
        container = nil
        context   = nil
    }
}
""")

                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill").font(.system(size: 12)).foregroundStyle(Color.formGreen)
                            Text("Each test gets a fresh in-memory container - no leaking data between tests, no disk I/O.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color(hex: "#E1F5EE")).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // Test runner simulation
                    VStack(spacing: 8) {
                        Button(isRunning ? "Running tests…" : "▶ Run test suite") {
                            runTests()
                        }
                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(isRunning ? Color(.systemGray4) : Color.sdPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .buttonStyle(PressableButtonStyle()).disabled(isRunning)

                        VStack(spacing: 4) {
                            ForEach(testResults) { result in
                                HStack(spacing: 8) {
                                    Image(systemName: result.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .font(.system(size: 13)).foregroundStyle(result.passed ? Color.formGreen : Color.animCoral)
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text(result.name).font(.system(size: 11, weight: .semibold))
                                        Text(result.detail).font(.system(size: 9)).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 10).padding(.vertical, 7)
                                .background(result.passed ? Color(hex: "#E1F5EE") : Color(hex: "#FCEBEB"))
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                            if testResults.isEmpty {
                                Text("(no tests run yet)").font(.system(size: 10)).foregroundStyle(Color(.systemGray4))
                                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                            }
                        }
                        .animation(.spring(response: 0.35), value: testResults.count)

                        if !testResults.isEmpty && !isRunning {
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.shield.fill").font(.system(size: 12)).foregroundStyle(Color.formGreen)
                                Text("\(testResults.filter { $0.passed }.count)/\(testResults.count) tests passed · 0 failures")
                                    .font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.formGreen)
                            }
                            .padding(8).background(Color(hex: "#E1F5EE")).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }

                default:
                    // Preview container pattern
                    VStack(spacing: 8) {
                        codeBlock("""
// Reusable preview container extension
extension ModelContainer {
    @MainActor
    static var preview: ModelContainer = {
        let config = ModelConfiguration(
            isStoredInMemoryOnly: true
        )
        let container = try! ModelContainer(
            for: TodoItem.self, Project.self,
            configurations: config
        )
        // Seed with realistic preview data
        let ctx = container.mainContext
        let p1  = Project(name: "ShowUI App")
        ctx.insert(p1)
        let t1  = TodoItem(title: "Build lessons", priority: 2)
        let t2  = TodoItem(title: "Write tests",   priority: 1)
        p1.tasks = [t1, t2]
        try? ctx.save()
        return container
    }()
}

// Use in previews
#Preview {
    TodoListView()
        .modelContainer(.preview)
}

// Use in SwiftUI previews with @Query
#Preview {
    @Previewable @Query var todos: [TodoItem]
    List(todos) { TodoRow(todo: $0) }
        .modelContainer(.preview)
}
""")
                    }
                }
            }
        }
    }

    func runTests() {
        isRunning = true; testResults = []
        for (i, test) in allTests.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + test.3) {
                withAnimation {
                    testResults.append(TestResult(name: test.0, passed: test.2, detail: test.1))
                }
                if i == allTests.count - 1 { isRunning = false }
            }
        }
    }

    func codeBlock(_ text: String) -> some View {
        Text(text).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdPurple)
            .padding(8).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct TestingStrategiesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Testing SwiftData")
            Text("Unit testing SwiftData code requires an in-memory container that resets between tests. The same pattern powers SwiftUI previews. Always test the service/repository layer directly against a real in-memory store - not mocks.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "ModelConfiguration(isStoredInMemoryOnly: true) - fresh, isolated store per test.", color: .sdPurple)
                StepRow(number: 2, text: "Create container in setUp(), nil it in tearDown() - guarantees no cross-test contamination.", color: .sdPurple)
                StepRow(number: 3, text: "Test service/repository classes directly - insert, fetch, and assert on the context.", color: .sdPurple)
                StepRow(number: 4, text: "@Previewable @Query in #Preview blocks - live @Query in preview without a view model.", color: .sdPurple)
                StepRow(number: 5, text: "ModelContainer.preview static property - seed realistic data, reuse across all previews.", color: .sdPurple)
            }

            CalloutBox(style: .success, title: "Test against real in-memory SwiftData", contentBody: "Don't mock ModelContext with protocols - create a real in-memory store. It's fast (sub-millisecond), isolated, and tests the actual SwiftData behaviour. Mocks hide real bugs like cascade rule mistakes and predicate errors.")

            CodeBlock(code: """
class TodoServiceTests: XCTestCase {
    var container: ModelContainer!
    var context: ModelContext!
    var service: TodoService!

    override func setUp() async throws {
        container = try ModelContainer(
            for: TodoItem.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
        context  = container.mainContext
        service  = TodoService(context: context)
    }

    func testInsert() throws {
        service.insert(title: "Test todo")

        let all = try context.fetch(
            FetchDescriptor<TodoItem>()
        )
        XCTAssertEqual(all.count, 1)
        XCTAssertEqual(all[0].title, "Test todo")
    }

    func testFilterActive() throws {
        service.insert(title: "Active")
        service.insert(title: "Done",   isDone: true)

        let active = try service.fetchActive()
        XCTAssertEqual(active.count, 1)
        XCTAssertEqual(active[0].title, "Active")
    }
}
""")
        }
    }
}

