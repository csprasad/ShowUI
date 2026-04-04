//
//
//  6_DynamicData.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Dynamic Data
struct DynamicDataVisual: View {
    @State private var tasks: [LFTask] = LFTask.samples
    @State private var newTaskTitle = ""
    @State private var sortOrder = 0
    @State private var filterDone = false

    let sortOptions = ["Default", "A → Z", "Priority ↑", "Priority ↓"]

    var displayedTasks: [LFTask] {
        var result = filterDone ? tasks.filter { !$0.isDone } : tasks
        switch sortOrder {
        case 1: result.sort { $0.title < $1.title }
        case 2: result.sort { $0.priority.sortValue < $1.priority.sortValue }
        case 3: result.sort { $0.priority.sortValue > $1.priority.sortValue }
        default: break
        }
        return result
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Dynamic data", systemImage: "arrow.up.arrow.down.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.lfBlue)

                // Controls row
                HStack(spacing: 8) {
                    // Sort picker
                    Menu {
                        ForEach(sortOptions.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { sortOrder = i }
                            } label: {
                                HStack {
                                    Text(sortOptions[i])
                                    if sortOrder == i { Image(systemName: "checkmark") }
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.arrow.down").font(.system(size: 11))
                            Text(sortOptions[sortOrder]).font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(Color.lfBlue)
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(Color.lfBlueLight)
                        .clipShape(Capsule())
                    }

                    Button {
                        withAnimation(.spring(response: 0.3)) { filterDone.toggle() }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: filterDone ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                                .font(.system(size: 11))
                            Text(filterDone ? "Hide done" : "Show all").font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(filterDone ? .white : Color.lfBlue)
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(filterDone ? Color.lfBlue : Color.lfBlueLight)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(PressableButtonStyle())

                    Spacer()
                    Text("\(displayedTasks.count)/\(tasks.count)")
                        .font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                }

                // Live list
                List {
                    ForEach(displayedTasks) { task in
                        HStack(spacing: 10) {
                            Button {
                                if let i = tasks.firstIndex(where: { $0.id == task.id }) {
                                    withAnimation { tasks[i].isDone.toggle() }
                                }
                            } label: {
                                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(task.isDone ? Color.animTeal : Color(.systemGray3))
                            }
                            .buttonStyle(PressableButtonStyle())

                            Text(task.title)
                                .font(.system(size: 14))
                                .strikethrough(task.isDone, color: .secondary)
                                .foregroundStyle(task.isDone ? .secondary : .primary)
                            Spacer()
                            Circle().fill(task.priority.color).frame(width: 8, height: 8)
                        }
                    }
                    .onDelete { indexSet in
                        // Must map displayed indices back to tasks array
                        let idsToDelete = indexSet.map { displayedTasks[$0].id }
                        withAnimation { tasks.removeAll { idsToDelete.contains($0.id) } }
                    }
                }
                .listStyle(.plain)
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .animation(.spring(response: 0.35), value: sortOrder)
                .animation(.spring(response: 0.35), value: filterDone)

                // Add new task
                HStack(spacing: 8) {
                    TextField("New task...", text: $newTaskTitle)
                        .font(.system(size: 13))
                        .padding(8)
                        .background(Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    Button {
                        guard !newTaskTitle.isEmpty else { return }
                        withAnimation(.spring(response: 0.35)) {
                            tasks.append(LFTask(title: newTaskTitle, priority: .medium))
                            newTaskTitle = ""
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(!newTaskTitle.isEmpty ? Color.lfBlue : Color(.systemGray4))
                    }
                    .buttonStyle(PressableButtonStyle())
                    .disabled(newTaskTitle.isEmpty)
                }
            }
        }
    }
}

struct DynamicDataExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Dynamic data — add, remove, sort")
            Text("List and ForEach react to @State array changes automatically. Add, remove, or reorder items in your array and SwiftUI animates the list to match. Filtering and sorting are best handled as derived computed properties.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Add: tasks.append(newTask) inside withAnimation — the row slides in.", color: .lfBlue)
                StepRow(number: 2, text: "Remove: tasks.remove(atOffsets:) or tasks.removeAll { condition } — the row slides out.", color: .lfBlue)
                StepRow(number: 3, text: "Sort: sort the array or use a computed property. Wrap in withAnimation for an animated reorder.", color: .lfBlue)
                StepRow(number: 4, text: "Filter: derive a filtered array as a computed property — never store it in @State separately.", color: .lfBlue)
                StepRow(number: 5, text: "onDelete with filtered list — map displayed indices back to the source array to delete the right item.", color: .lfBlue)
            }

            CalloutBox(style: .warning, title: "Filtering + onDelete gotcha", contentBody: "When your ForEach shows a filtered or sorted subset, the IndexSet in onDelete refers to the displayed array — not the source array. Always map the displayed index back to the source before deleting.")

            CalloutBox(style: .success, title: "withAnimation for list changes", contentBody: "Wrap array mutations in withAnimation { } to get smooth insert/remove animations. Without it, changes are still applied but snap instantly with no animation.")

            CodeBlock(code: """
@State private var items: [Item] = []
@State private var searchText = ""

// Derived — never in @State
var filtered: [Item] {
    searchText.isEmpty ? items
        : items.filter { $0.name.contains(searchText) }
}

// Add
Button("Add") {
    withAnimation { items.append(Item(name: "New")) }
}

// Remove by condition
withAnimation { items.removeAll { $0.isDone } }

// Sort (animated)
withAnimation { items.sort { $0.name < $1.name } }

// onDelete with filtered list — map indices back
.onDelete { indexSet in
    let idsToDelete = indexSet.map { filtered[$0].id }
    withAnimation {
        items.removeAll { idsToDelete.contains($0.id) }
    }
}
""")
        }
    }
}

extension LFTask.Priority {
    var sortValue: Int {
        switch self {
        case .high: return 0
        case .medium: return 1
        case .low: return 2
        }
    }
}

