//
//
//  13_Undo&HistoryTracking.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import SwiftData

// MARK: - LESSON 13: Undo & History Tracking
struct UndoHistoryVisual: View {
    @State private var selectedDemo = 0
    let demos = ["UndoManager", "History tracking", "Transaction watch"]

    @State private var items: [UndoItem] = [
        UndoItem(title: "First note",  color: "blue"),
        UndoItem(title: "Second note", color: "green"),
        UndoItem(title: "Third note",  color: "orange"),
    ]
    @State private var undoStack: [[UndoItem]] = []
    @State private var redoStack: [[UndoItem]] = []
    @State private var historyLog: [HistoryEntry] = []
    @State private var newTitle = ""

    struct UndoItem: Identifiable {
        let id = UUID(); var title: String; var color: String
    }
    struct HistoryEntry: Identifiable {
        let id = UUID(); let action: String; let timestamp: String; let kind: String
    }

    var canUndo: Bool { !undoStack.isEmpty }
    var canRedo: Bool { !redoStack.isEmpty }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Undo & history tracking", systemImage: "arrow.uturn.backward.circle.fill")
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
                    // UndoManager integration
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            TextField("New note…", text: $newTitle)
                                .textFieldStyle(.roundedBorder).font(.system(size: 12))
                            Button {
                                let t = newTitle.trimmingCharacters(in: .whitespaces)
                                guard !t.isEmpty else { return }
                                recordUndo()
                                withAnimation(.spring(bounce: 0.3)) {
                                    items.insert(UndoItem(title: t, color: "blue"), at: 0)
                                    addHistory("Insert: \"\(t)\"", kind: "insert")
                                    newTitle = ""
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill").font(.system(size: 20)).foregroundStyle(Color.sdPurple)
                            }.buttonStyle(PressableButtonStyle())
                        }

                        ForEach(items) { item in
                            HStack(spacing: 8) {
                                Circle().fill(colorFor(item.color)).frame(width: 8, height: 8)
                                Text(item.title).font(.system(size: 12))
                                Spacer()
                                Button {
                                    recordUndo()
                                    withAnimation { items.removeAll { $0.id == item.id }; addHistory("Delete: \"\(item.title)\"", kind: "delete") }
                                } label: {
                                    Image(systemName: "trash").font(.system(size: 12)).foregroundStyle(Color.animCoral)
                                }.buttonStyle(PressableButtonStyle())
                            }
                            .padding(.horizontal, 10).padding(.vertical, 7)
                            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 7))
                        }

                        HStack(spacing: 8) {
                            Button("↩ Undo") {
                                if let prev = undoStack.popLast() {
                                    redoStack.append(items)
                                    withAnimation { items = prev; addHistory("Undo", kind: "undo") }
                                }
                            }
                            .font(.system(size: 12, weight: .semibold)).foregroundStyle(canUndo ? Color.sdPurple : .secondary)
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(Color.sdPurpleLight.opacity(canUndo ? 1 : 0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .buttonStyle(PressableButtonStyle()).disabled(!canUndo)

                            Button("↪ Redo") {
                                if let next = redoStack.popLast() {
                                    undoStack.append(items)
                                    withAnimation { items = next; addHistory("Redo", kind: "redo") }
                                }
                            }
                            .font(.system(size: 12, weight: .semibold)).foregroundStyle(canRedo ? Color.sdPurple : .secondary)
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(Color.sdPurpleLight.opacity(canRedo ? 1 : 0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .buttonStyle(PressableButtonStyle()).disabled(!canRedo)

                            Spacer()
                            Text("Stack: \(undoStack.count)")
                                .font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                        }
                    }

                case 1:
                    // History tracking concept
                    VStack(spacing: 8) {
                        Text("NSPersistentHistoryTracking records every transaction").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        VStack(spacing: 4) {
                            ForEach(historyLog.suffix(5)) { entry in
                                HStack(spacing: 8) {
                                    Circle().fill(kindColor(entry.kind)).frame(width: 7, height: 7)
                                    Text(entry.action).font(.system(size: 11))
                                    Spacer()
                                    Text(entry.timestamp).font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                                }
                                .padding(.horizontal, 8).padding(.vertical, 5)
                                .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                            if historyLog.isEmpty {
                                Text("Perform actions above to see history").font(.system(size: 10)).foregroundStyle(Color(.systemGray4))
                            }
                        }
                        .frame(minHeight: 80)

                        codeBlock("""
// Enable persistent history in ModelConfiguration
let config = ModelConfiguration(
    allowsSave: true
)
// Then access via NSPersistentHistoryChangeRequest:
let request = NSPersistentHistoryChangeRequest
    .fetchHistory(after: lastToken)
let result = try context.execute(request)
    as! NSPersistentHistoryResult
let transactions = result.result
    as! [NSPersistentHistoryTransaction]
""")
                    }

                default:
                    // Transaction watching
                    VStack(spacing: 8) {
                        codeBlock("""
// Watch for remote changes (CloudKit / extensions)
NotificationCenter.default.publisher(
    for: .NSManagedObjectContextDidSave,
    object: nil
)
.sink { notification in
    guard
        let userInfo = notification.userInfo,
        let insertedIDs = userInfo[NSInsertedObjectIDsKey]
    else { return }

    // Merge changes into main context
    mainContext.perform {
        mainContext.mergeChanges(
            fromContextDidSave: notification
        )
    }
}

// SwiftData: observe ModelContext changes
context.addObserver(
    self, forKeyPath: "hasChanges", options: .new
) { _, _, _ in
    // pendingModelChanges is non-empty
}
""")

                        HStack(spacing: 6) {
                            Image(systemName: "icloud.fill").font(.system(size: 12)).foregroundStyle(Color.sdPurple)
                            Text("Persistent history is essential for CloudKit apps, App Extensions, and Widgets that share a store.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    func recordUndo() { undoStack.append(items); redoStack = [] }
    func addHistory(_ action: String, kind: String) {
        let formatter = DateFormatter(); formatter.timeStyle = .medium
        historyLog.append(HistoryEntry(action: action, timestamp: formatter.string(from: Date()), kind: kind))
    }
    func colorFor(_ name: String) -> Color { ["blue": Color.navBlue, "green": Color.formGreen, "orange": Color.animAmber][name] ?? .secondary }
    func kindColor(_ kind: String) -> Color {
        switch kind { case "insert": .formGreen; case "delete": .animCoral; case "undo": .sdPurple; case "redo": .sdViolet; default: .secondary }
    }
    func codeBlock(_ text: String) -> some View {
        Text(text).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdPurple)
            .padding(8).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct UndoHistoryExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Undo/Redo and persistent history")
            Text("ModelContext has a built-in UndoManager. Mutations through the context are registered as undo groups automatically. NSPersistentHistoryTracking records every transaction so you can detect external changes from CloudKit, app extensions, or Widgets.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "context.undoManager - access the built-in UndoManager. context.undoManager?.undo() rolls back.", color: .sdPurple)
                StepRow(number: 2, text: "context.processPendingChanges() - flush pending mutations before registering an undo group.", color: .sdPurple)
                StepRow(number: 3, text: "NSPersistentHistoryTracking - enable to record every transaction with timestamps and author info.", color: .sdPurple)
                StepRow(number: 4, text: "NSPersistentHistoryChangeRequest.fetchHistory(after: token) - read new transactions since last check.", color: .sdPurple)
                StepRow(number: 5, text: "context.mergeChanges(fromContextDidSave:) - merge remote changes into the main context.", color: .sdPurple)
            }

            CalloutBox(style: .info, title: "Persistent history for shared stores", contentBody: "When your app and a Widget or App Extension share the same SwiftData store, changes made by the extension won't automatically refresh @Query. Enable NSPersistentHistoryTracking and merge changes when the app becomes active.")

            CodeBlock(code: """
// Access UndoManager
@Environment(\\.modelContext) var context

func saveSnapshot() {
    context.processPendingChanges()
    context.undoManager?.registerUndo(
        withTarget: self
    ) { _ in /* custom undo */ }
}

func undo() { context.undoManager?.undo() }
func redo() { context.undoManager?.redo() }

// Enable history tracking (via CoreData escape)
let storeDesc = NSPersistentStoreDescription(url: storeURL)
storeDesc.setOption(
    NSNumber(booleanLiteral: true),
    forKey: NSPersistentHistoryTrackingKey
)
storeDesc.setOption(
    NSNumber(booleanLiteral: true),
    forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
)
""")
        }
    }
}
