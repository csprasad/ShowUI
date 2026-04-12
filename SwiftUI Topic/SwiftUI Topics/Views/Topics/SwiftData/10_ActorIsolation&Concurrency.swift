//
//
//  10_ActorIsolation&Concurrency.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 10: Actor Isolation & Concurrency
struct ModelActorVisual: View {
    @State private var selectedDemo  = 0
    @State private var log: [String] = []
    @State private var isRunning     = false
    @State private var progress: Double = 0
    let demos = ["@ModelActor", "MainActor bridge", "Data races"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Actor isolation & concurrency", systemImage: "cpu.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sdPurple)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; log = [] }
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
                    // @ModelActor concept
                    VStack(spacing: 8) {
                        architectureDiagram
                        codeBlock("""
// @ModelActor creates an actor with its own
// ModelContext - safe background operations
@ModelActor
actor DataService {
    func importArticles(_ raw: [RawArticle]) async throws {
        for item in raw {
            let article = Article(title: item.title)
            modelContext.insert(article)
        }
        try modelContext.save()
    }

    func fetchUrgent() async throws -> [TodoItem] {
        let d = FetchDescriptor<TodoItem>(
            predicate: #Predicate { $0.priority == 2 }
        )
        return try modelContext.fetch(d)
    }
}

// Call from a view or task
let service = DataService(modelContainer: container)
try await service.importArticles(rawData)
""")
                    }

                case 1:
                    // Main actor bridge
                    VStack(spacing: 8) {
                        simulatedLog
                        Button(isRunning ? "Running…" : "Simulate background import") {
                            runSimulation()
                        }
                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(isRunning ? Color(.systemGray4) : Color.sdPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .buttonStyle(PressableButtonStyle())
                        .disabled(isRunning)

                        if isRunning {
                            ProgressView(value: progress)
                                .tint(.sdPurple)
                                .animation(.easeInOut(duration: 0.2), value: progress)
                        }

                        codeBlock("""
// Bridge: background work → main thread UI update
Task {
    // 1. Run heavy work on background actor
    let results = await dataService.processItems()

    // 2. Update @State on main actor
    await MainActor.run {
        self.items = results   // ← safe main thread update
        self.isLoading = false
    }
}
""")
                    }

                default:
                    // Data race examples
                    VStack(spacing: 8) {
                        raceRow(bad: true,
                                code: "Task {\n    item.title = \"new\"  // ← off main thread!\n}",
                                fix: "@MainActor on the model class, or await MainActor.run { item.title = \"new\" }")
                        raceRow(bad: true,
                                code: "Task.detached {\n    context.insert(newItem)  // wrong context!\n}",
                                fix: "Create ModelContext(container) inside the detached task - each thread needs its own context")
                        raceRow(bad: true,
                                code: "// Passing @Model objects across actor boundaries\nawait bgActor.process(item)  // item is MainActor",
                                fix: "Pass PersistentIdentifier instead: await bgActor.process(item.persistentModelID)")
                        raceRow(bad: false,
                                code: "@ModelActor actor Service {\n    func work() async throws {\n        let item = try modelContext.fetch(d).first\n        item?.title = \"safe\"  // ← actor-isolated\n    }\n}",
                                fix: "✓ @ModelActor gives the actor its own context - fully safe")
                    }
                }
            }
        }
    }

    var architectureDiagram: some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                layerBox("Main Thread", icon: "iphone", color: .sdBlue, note: "@Environment(\\.modelContext)\nUI reads & simple writes")
                Image(systemName: "arrow.left.arrow.right").font(.system(size: 12)).foregroundStyle(.secondary)
                layerBox("@ModelActor", icon: "cpu.fill", color: .sdPurple, note: "Background context\nImport, processing, bulk ops")
            }
            HStack(spacing: 6) {
                Image(systemName: "info.circle.fill").font(.system(size: 11)).foregroundStyle(Color.sdPurple)
                Text("Changes from @ModelActor auto-merge into the main context via NSPersistentStore notifications")
                    .font(.system(size: 10)).foregroundStyle(.secondary)
            }
            .padding(7).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 7))
        }
    }

    func layerBox(_ title: String, icon: String, color: Color, note: String) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 12)).foregroundStyle(color)
                Text(title).font(.system(size: 10, weight: .semibold)).foregroundStyle(color)
            }
            Text(note).font(.system(size: 8, design: .monospaced)).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
        .padding(8).background(color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(maxWidth: .infinity)
    }

    var simulatedLog: some View {
        VStack(alignment: .leading, spacing: 3) {
            ForEach(log.suffix(6), id: \.self) { entry in
                HStack(spacing: 6) {
                    Circle()
                        .fill(entry.hasPrefix("✓") ? Color.formGreen : entry.hasPrefix("→") ? Color.sdPurple : Color.animAmber)
                        .frame(width: 6, height: 6)
                    Text(entry).font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                }
            }
            if log.isEmpty {
                Text("(tap button to simulate)")
                    .font(.system(size: 10)).foregroundStyle(Color(.systemGray4))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .topLeading)
        .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func runSimulation() {
        isRunning = true
        log = []
        progress = 0
        let steps: [(Double, String)] = [
            (0.1, "→ Task.detached started"),
            (0.2, "→ ModelContext(container) created"),
            (0.4, "→ Importing 50 records…"),
            (0.6, "→ try context.save() called"),
            (0.75, "✓ Save succeeded - 50 records"),
            (0.9, "→ MainActor.run { updating UI }"),
            (1.0, "✓ UI updated - 50 items visible"),
        ]
        for (i, step) in steps.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.45) {
                withAnimation { log.append(step.1); progress = step.0 }
                if i == steps.count - 1 { isRunning = false }
            }
        }
    }

    func raceRow(bad: Bool, code: String, fix: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 6) {
                Image(systemName: bad ? "xmark.circle.fill" : "checkmark.circle.fill")
                    .font(.system(size: 12)).foregroundStyle(bad ? Color.animCoral : Color.formGreen)
                Text(code).font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(bad ? Color.animCoral : Color.formGreen)
            }
            if bad {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.right").font(.system(size: 9)).foregroundStyle(Color.sdPurple)
                    Text(fix).font(.system(size: 10)).foregroundStyle(Color.sdPurple)
                }.padding(.leading, 18)
            }
        }
        .padding(8).background(bad ? Color(hex: "#FCEBEB") : Color(hex: "#E1F5EE")).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func codeBlock(_ text: String) -> some View {
        Text(text).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdPurple)
            .padding(8).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ModelActorExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "@ModelActor - safe background SwiftData")
            Text("@ModelActor is a macro that creates an actor with its own ModelContext. Operations inside the actor run on a dedicated thread. Changes auto-merge into the main context, so @Query views update automatically when background work completes.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@ModelActor actor MyService - creates an actor with modelContext and modelContainer properties.", color: .sdPurple)
                StepRow(number: 2, text: "Use modelContext inside the actor - fully isolated, no data races.", color: .sdPurple)
                StepRow(number: 3, text: "Never pass @Model objects across actor boundaries - pass PersistentIdentifier instead.", color: .sdPurple)
                StepRow(number: 4, text: "await MainActor.run { self.items = results } - safely bridge results back to the main thread.", color: .sdPurple)
                StepRow(number: 5, text: "Background context changes merge automatically - @Query views refresh without manual work.", color: .sdPurple)
            }

            CalloutBox(style: .danger, title: "Never pass @Model objects across actors", contentBody: "@Model objects are bound to their ModelContext's thread. Passing them to a different actor causes a data race. Pass PersistentIdentifier (item.persistentModelID) across the boundary, then fetch a fresh copy inside the receiving actor.")

            CodeBlock(code: """
// Define the background actor
@ModelActor
actor ImportService {
    func importLargeDataset(_ items: [RawItem]) async throws -> Int {
        var count = 0
        for chunk in items.chunked(into: 100) {
            for raw in chunk {
                modelContext.insert(TodoItem(title: raw.title))
                count += 1
            }
            try modelContext.save()  // save per chunk
        }
        return count
    }
}

// Use from a SwiftUI view
struct ContentView: View {
    @Environment(\\.modelContainer) var container
    @State private var importedCount = 0

    var body: some View {
        Button("Import data") {
            Task {
                let service = ImportService(modelContainer: container)
                let count = try await service.importLargeDataset(rawItems)
                await MainActor.run {
                    importedCount = count  // main thread update
                }
            }
        }
    }
}
""")
        }
    }
}
