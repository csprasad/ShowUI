//
//
//  3_CRUDOperations.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import SwiftData

// MARK: - LESSON 3: CRUD Operations
struct SDCRUDVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Insert & delete", "Update & save", "Undo support"]

    // Simulated CRUD with in-memory list
    @State private var items: [CRUDItem] = [
        CRUDItem(title: "First item",  priority: 1),
        CRUDItem(title: "Second item", priority: 2),
        CRUDItem(title: "Third item",  priority: 0),
    ]
    @State private var newTitle      = ""
    @State private var editingID: UUID?     = nil
    @State private var editingTitle  = ""
    @State private var undoStack: [[CRUDItem]] = []
    @State private var lastAction    = "None"

    struct CRUDItem: Identifiable {
        let id    = UUID()
        var title: String
        var priority: Int
        var done: Bool = false
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("CRUD operations", systemImage: "pencil.and.outline")
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
                    // Insert & Delete
                    VStack(spacing: 8) {
                        // Add row
                        HStack(spacing: 8) {
                            TextField("New item title…", text: $newTitle)
                                .textFieldStyle(.roundedBorder).font(.system(size: 13))
                            Button {
                                let trimmed = newTitle.trimmingCharacters(in: .whitespaces)
                                guard !trimmed.isEmpty else { return }
                                pushUndo()
                                withAnimation(.spring(bounce: 0.3)) {
                                    items.insert(CRUDItem(title: trimmed, priority: 0), at: 0)
                                    newTitle = ""
                                    lastAction = "Inserted \"\(trimmed)\""
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 22)).foregroundStyle(Color.sdBlue)
                            }
                            .buttonStyle(PressableButtonStyle())
                        }

                        ForEach(items) { item in
                            HStack(spacing: 8) {
                                Circle().fill([Color.formGreen, Color.animAmber, Color.animCoral][item.priority])
                                    .frame(width: 8, height: 8)
                                Text(item.title).font(.system(size: 13))
                                Spacer()
                                Button {
                                    pushUndo()
                                    withAnimation(.spring(bounce: 0.2)) {
                                        items.removeAll { $0.id == item.id }
                                        lastAction = "Deleted \"\(item.title)\""
                                    }
                                } label: {
                                    Image(systemName: "trash.fill")
                                        .font(.system(size: 13)).foregroundStyle(Color.animCoral)
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                            .padding(.horizontal, 10).padding(.vertical, 8)
                            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        actionChip(lastAction)
                        codeNote("context.insert(item) / context.delete(item)")
                    }

                case 1:
                    // Update
                    VStack(spacing: 8) {
                        ForEach($items) { $item in
                            HStack(spacing: 8) {
                                if editingID == item.id {
                                    TextField("Title", text: $editingTitle)
                                        .textFieldStyle(.roundedBorder).font(.system(size: 13))
                                        .onSubmit {
                                            pushUndo()
                                            item.title = editingTitle
                                            editingID = nil
                                            lastAction = "Updated to \"\(editingTitle)\""
                                        }
                                } else {
                                    Text(item.title).font(.system(size: 13)).frame(maxWidth: .infinity, alignment: .leading)
                                }

                                // Priority cycle
                                Button {
                                    pushUndo()
                                    withAnimation { item.priority = (item.priority + 1) % 3 }
                                    lastAction = "Changed priority"
                                } label: {
                                    Circle().fill([Color.formGreen, Color.animAmber, Color.animCoral][item.priority])
                                        .frame(width: 16, height: 16)
                                }
                                .buttonStyle(PressableButtonStyle())

                                // Edit toggle
                                Button {
                                    if editingID == item.id {
                                        item.title = editingTitle
                                        editingID = nil
                                        lastAction = "Updated \"\(editingTitle)\""
                                    } else {
                                        editingID = item.id
                                        editingTitle = item.title
                                    }
                                } label: {
                                    Image(systemName: editingID == item.id ? "checkmark.circle.fill" : "pencil")
                                        .font(.system(size: 14))
                                        .foregroundStyle(editingID == item.id ? Color.formGreen : Color.sdBlue)
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                            .padding(.horizontal, 10).padding(.vertical, 8)
                            .background(editingID == item.id ? Color.sdBlueLight : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .animation(.spring(response: 0.25), value: editingID == item.id)
                        }

                        actionChip(lastAction)
                        codeNote("item.title = newValue\ntry? context.save() - optional: auto-saves on run loop")
                    }

                default:
                    // Undo
                    VStack(alignment: .center, spacing: 8) {
                        HStack(spacing: 8) {
                            Button("+ Add") {
                                pushUndo()
                                withAnimation { items.append(CRUDItem(title: "Item \(items.count + 1)", priority: 0)) }
                            }.smallSDButton(color: .formGreen)
                            Button("Delete last") {
                                guard !items.isEmpty else { return }
                                pushUndo()
                               _ = withAnimation { items.removeLast() }
                            }.smallSDButton(color: .animCoral)
                            .disabled(items.isEmpty)
                            Button("↩ Undo") {
                                withAnimation(.spring(bounce: 0.3)) { popUndo() }
                            }.smallSDButton(color: undoStack.isEmpty ? .secondary : .sdBlue)
                            .disabled(undoStack.isEmpty)
                        }

                        ForEach(items) { item in
                            HStack(spacing: 8) {
                                Circle().fill(Color.sdBlue).frame(width: 6, height: 6)
                                Text(item.title).font(.system(size: 12))
                            }.frame(maxWidth: 120, alignment: .leading)
                            .padding(.horizontal, 10).padding(.vertical, 7)
                            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.sdBlue)
                            Text("Undo stack: \(undoStack.count) states saved · ModelContext has built-in undo support via context.undoManager")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    func pushUndo() { undoStack.append(items) }
    func popUndo()  { if let prev = undoStack.popLast() { items = prev } }

    func actionChip(_ text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "arrow.right.circle.fill").font(.system(size: 11)).foregroundStyle(Color.sdBlue)
            Text(text).font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
        }
        .padding(7).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 7))
    }

    func codeNote(_ text: String) -> some View {
        Text(text).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.sdBlue)
            .padding(7).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

private extension View {
    func smallSDButton(color: Color) -> some View {
        self.font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 8)
            .background(color).clipShape(RoundedRectangle(cornerRadius: 8))
            .buttonStyle(PressableButtonStyle())
    }
}

struct SDCRUDExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "CRUD - insert, update, delete")
            Text("All mutations go through the ModelContext. Insert new objects with context.insert(), delete with context.delete(), and update by mutating properties directly. SwiftData auto-saves at the end of the run loop - explicit save() is optional.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Insert: context.insert(newItem) - adds to the context and schedules a save.", color: .sdBlue)
                StepRow(number: 2, text: "Delete: context.delete(item) - removes from context. Cascade rules apply to relationships.", color: .sdBlue)
                StepRow(number: 3, text: "Update: just mutate item.title = \"new\" - @Model observes and schedules a save.", color: .sdBlue)
                StepRow(number: 4, text: "try context.save() - explicit save. Auto-save happens at run loop end, explicit is safer for error handling.", color: .sdBlue)
                StepRow(number: 5, text: "context.undoManager - built-in undo/redo. Enable with context.undoManager = UndoManager().", color: .sdBlue)
            }

            CalloutBox(style: .info, title: "Auto-save vs explicit save", contentBody: "SwiftData automatically saves at the end of each run loop iteration. You only need try context.save() when you want to catch a save error, force a save before a background operation, or confirm data is flushed before navigation.")

            CodeBlock(code: """
@Environment(\\.modelContext) var context

// Insert
func addItem(title: String) {
    let item = TodoItem(title: title)
    context.insert(item)
    // Auto-saved at end of run loop
}

// Delete
func deleteItem(_ item: TodoItem) {
    context.delete(item)
}

// Delete from list (ForEach onDelete)
func deleteItems(at offsets: IndexSet) {
    for index in offsets {
        context.delete(todos[index])
    }
}

// Update - just mutate
func toggle(_ item: TodoItem) {
    item.isCompleted.toggle()
    // @Model observes, no explicit save needed
}

// Explicit save with error handling
func saveWithError() {
    do {
        try context.save()
    } catch {
        print("Save failed:", error)
    }
}
""")
        }
    }
}
