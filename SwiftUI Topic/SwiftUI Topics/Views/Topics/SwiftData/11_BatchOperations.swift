//
//
//  11_BatchOperations.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import SwiftData

// MARK: - LESSON 11: Batch Operations
struct BatchOpsVisual: View {
    @State private var selectedDemo     = 0
    @State private var batchSize        = 100
    @State private var isRunning        = false
    @State private var progress: Double = 0
    @State private var log: [LogEntry]  = []
    @State private var resultCount      = 0

    struct LogEntry: Identifiable {
        let id = UUID(); let text: String; let kind: Kind
        enum Kind { case info, success, warning, timing }
        var color: Color { switch kind { case .info: .secondary; case .success: .formGreen; case .warning: .animAmber; case .timing: .sdPurple } }
        var icon: String { switch kind { case .info: "info.circle"; case .success: "checkmark.circle.fill"; case .warning: "exclamationmark.triangle.fill"; case .timing: "clock.fill" } }
    }

    let demos = ["Naive vs batch", "Chunk strategy", "Bulk delete"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Batch operations", systemImage: "tray.full.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sdPurple)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; log = []; progress = 0 }
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
                    // Naive vs batch comparison
                    VStack(spacing: 8) {
                        batchCompare(
                            title: "✗ Naive - one-by-one insert",
                            code: "for item in 10_000_items {\n    context.insert(item)\n}\ntry context.save()\n// ≈ 8–15 seconds - UI freezes",
                            timeLabel: "~12s", timeColor: .animCoral, barFill: 0.9
                        )
                        batchCompare(
                            title: "✓ Chunked - save every N",
                            code: "for chunk in items.chunked(into: 500) {\n    chunk.forEach { context.insert($0) }\n    try context.save()  // flush each chunk\n}\n// ≈ 1–2 seconds - stays responsive",
                            timeLabel: "~1.5s", timeColor: .animAmber, barFill: 0.15
                        )
                        batchCompare(
                            title: "⚡︎ NSBatchInsertRequest (CoreData bridge)",
                            code: "// Via NSPersistentContainer escape hatch\nlet request = NSBatchInsertRequest(\n    entity: TodoItem.entity(),\n    objects: rawDicts\n)\ntry container.performBackgroundTask { ctx in\n    try ctx.execute(request)\n}\n// ≈ 0.2 seconds - bypasses all overhead",
                            timeLabel: "~0.2s", timeColor: .formGreen, barFill: 0.03
                        )
                    }

                case 1:
                    // Chunk strategy simulator
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Text("Batch size:").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 72)
                            Stepper(value: $batchSize, in: 50...1000, step: 50) {
                                Text("\(batchSize)").font(.system(size: 14, weight: .bold, design: .monospaced)).foregroundStyle(Color.sdPurple)
                                    .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: batchSize)
                            }
                        }

                        logView

                        Button(isRunning ? "Running…" : "Simulate import of 500 items") {
                            runChunkSimulation()
                        }
                        .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(isRunning ? Color(.systemGray4) : Color.sdPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .buttonStyle(PressableButtonStyle()).disabled(isRunning)

                        if isRunning {
                            ProgressView(value: progress).tint(.sdPurple)
                                .animation(.easeInOut(duration: 0.15), value: progress)
                        }
                    }

                default:
                    // Bulk delete
                    VStack(spacing: 8) {
                        codeBlock("""
// Delete all completed items (efficient)
let predicate = #Predicate<TodoItem> {
    $0.isCompleted == true
}
try context.delete(model: TodoItem.self,
                   where: predicate)
try context.save()
// Generates single DELETE WHERE SQL

// Delete all items of a type
try context.delete(model: TodoItem.self)

// NSBatchDeleteRequest for even more control
let req = NSFetchRequest<NSFetchRequestResult>(
    entityName: "TodoItem"
)
req.predicate = NSPredicate(
    format: "isCompleted == true"
)
let batchDelete = NSBatchDeleteRequest(
    fetchRequest: req
)
batchDelete.resultType = .resultTypeObjectIDs
try container.viewContext.execute(batchDelete)
""")

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.sdPurple)
                            Text("context.delete(model:where:) is SwiftData's efficient bulk delete - compiles to a single SQL DELETE WHERE statement.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    var logView: some View {
        VStack(alignment: .leading, spacing: 3) {
            ForEach(log.suffix(6)) { entry in
                HStack(spacing: 6) {
                    Image(systemName: entry.icon).font(.system(size: 10)).foregroundStyle(entry.color)
                    Text(entry.text).font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                }
            }
            if log.isEmpty {
                Text("(tap button to simulate)").font(.system(size: 10)).foregroundStyle(Color(.systemGray4))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 56, alignment: .topLeading)
        .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func batchCompare(title: String, code: String, timeLabel: String, timeColor: Color, barFill: Double) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.system(size: 10, weight: .semibold))
            Text(code).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdPurple)
                .padding(5).clipShape(RoundedRectangle(cornerRadius: 5))
            HStack(spacing: 8) {
                GeometryReader { g in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color(.systemFill)).frame(height: 8)
                        Capsule().fill(timeColor).frame(width: g.size.width * barFill, height: 8)
                    }
                }.frame(height: 8)
                Text(timeLabel).font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(timeColor).frame(width: 40)
            }
        }
        .padding(8).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func runChunkSimulation() {
        isRunning = true; log = []; progress = 0
        let total    = 500
        let chunks   = Int(ceil(Double(total) / Double(batchSize)))
        var schedule = [(Double, LogEntry)]()

        schedule.append((0.0, LogEntry(text: "Starting import of \(total) items", kind: .info)))
        for i in 0..<chunks {
            let start = i * batchSize + 1
            let end   = min((i + 1) * batchSize, total)
            let t     = Double(i + 1) * 0.35
            schedule.append((t, LogEntry(text: "Chunk \(i+1)/\(chunks): items \(start)-\(end)", kind: .info)))
            schedule.append((t + 0.1, LogEntry(text: "context.save() - \(end - start + 1) rows", kind: .timing)))
        }
        schedule.append((Double(chunks) * 0.35 + 0.25, LogEntry(text: "✓ All \(total) items imported", kind: .success)))

        for (delay, entry) in schedule {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation { log.append(entry); progress = min(1, (delay / (Double(chunks) * 0.35 + 0.25))) }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(chunks) * 0.35 + 0.4) {
            isRunning = false; progress = 1
        }
    }

    func codeBlock(_ text: String) -> some View {
        Text(text).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdPurple).frame(maxWidth: .infinity, alignment: .leading)
            .padding(16).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct BatchOpsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Batch operations - scale beyond 1,000 rows")
            Text("Inserting or deleting thousands of objects one-by-one through the ModelContext is slow - each triggers observation notifications and memory allocation. Chunked saves, NSBatchInsertRequest, and context.delete(model:where:) are the tools for scale.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Chunk inserts: save every 500–1000 items - keeps memory pressure low and context responsive.", color: .sdPurple)
                StepRow(number: 2, text: "context.delete(model: T.self, where: predicate) - bulk delete in one SQL statement.", color: .sdPurple)
                StepRow(number: 3, text: "NSBatchInsertRequest - bypasses the object graph entirely. Fastest for read-only imports.", color: .sdPurple)
                StepRow(number: 4, text: "Always process bulk operations on a background @ModelActor - never block the main thread.", color: .sdPurple)
                StepRow(number: 5, text: "After NSBatch operations, call context.refreshAllObjects() on the main context to sync.", color: .sdPurple)
            }

            CalloutBox(style: .warning, title: "NSBatch operations bypass observers", contentBody: "NSBatchInsertRequest and NSBatchDeleteRequest skip the in-memory object graph entirely. @Query and other observers are NOT notified automatically. After a batch operation, call context.refreshAllObjects() on the main context, or merge changes manually.")

            CodeBlock(code: """
// Chunked insert - balanced approach
@ModelActor
actor BulkImporter {
    func insert(_ items: [RawItem]) async throws {
        let chunks = items.chunked(into: 500)
        for chunk in chunks {
            for raw in chunk {
                modelContext.insert(Item(raw: raw))
            }
            try modelContext.save()   // flush each chunk
        }
    }
}

// Bulk delete - single SQL statement
try context.delete(
    model: CacheItem.self,
    where: #Predicate { $0.expiresAt < Date() }
)

// NSBatchInsertRequest - fastest, bypasses ORM
let dicts = rawItems.map { ["title": $0.title, "score": $0.score] }
let request = NSBatchInsertRequest(
    entity: NSEntityDescription.entity(
        forEntityName: "Item",
        in: nsContext
    )!,
    objects: dicts
)
try nsContext.execute(request)
nsContext.refreshAllObjects()   // resync
""")
        }
    }
}
