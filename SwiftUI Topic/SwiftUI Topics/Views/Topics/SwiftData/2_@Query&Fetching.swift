//
//
//  2_@Query&Fetching.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: @Query & Fetching
struct SDQueryVisual: View {
    @State private var selectedDemo = 0
    let demos = ["@Query live", "Sort descriptors", "Filter query"]

    // In-memory demo items
    @State private var demoItems: [DemoTodo] = [
        DemoTodo(title: "Buy groceries",     priority: 1, done: false, tag: "Personal"),
        DemoTodo(title: "Review PR #42",     priority: 2, done: false, tag: "Work"),
        DemoTodo(title: "Call dentist",      priority: 0, done: true,  tag: "Personal"),
        DemoTodo(title: "Write unit tests",  priority: 2, done: false, tag: "Work"),
        DemoTodo(title: "Read SwiftData doc",priority: 1, done: true,  tag: "Learning"),
        DemoTodo(title: "Ship v2.0",         priority: 2, done: false, tag: "Work"),
    ]
    @State private var sortBy       = 0   // 0=title, 1=priority, 2=date
    @State private var showDone     = true
    @State private var tagFilter    = "All"

    struct DemoTodo: Identifiable {
        let id    = UUID()
        var title: String
        var priority: Int
        var done: Bool
        var tag: String
    }

    var sortedFiltered: [DemoTodo] {
        var items = demoItems
        if !showDone { items = items.filter { !$0.done } }
        if tagFilter != "All" { items = items.filter { $0.tag == tagFilter } }
        switch sortBy {
        case 1: items.sort { $0.priority > $1.priority }
        case 2: items.sort { $0.id.uuidString < $1.id.uuidString }
        default: items.sort { $0.title < $1.title }
        }
        return items
    }

    let tags = ["All", "Work", "Personal", "Learning"]
    let priorityColors: [Color] = [.formGreen, .animAmber, .animCoral]
    let priorityLabels = ["Low", "Med", "High"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("@Query & fetching", systemImage: "magnifyingglass.circle.fill")
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
                    // @Query live simulation
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "bolt.fill").font(.system(size: 11)).foregroundStyle(Color.sdBlue)
                            Text("@Query auto-updates this list - simulated live with in-memory data")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))

                        Toggle("Show completed", isOn: $showDone.animation()).tint(.sdBlue)
                            .font(.system(size: 13))

                        ForEach(demoItems.filter { showDone || !$0.done }) { item in
                            HStack(spacing: 8) {
                                Button {
                                    withAnimation(.spring(bounce: 0.3)) {
                                        if let idx = demoItems.firstIndex(where: { $0.id == item.id }) {
                                            demoItems[idx].done.toggle()
                                        }
                                    }
                                } label: {
                                    Image(systemName: item.done ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 18))
                                        .foregroundStyle(item.done ? Color.formGreen : Color(.systemGray3))
                                }
                                .buttonStyle(PressableButtonStyle())

                                Text(item.title).font(.system(size: 13))
                                    .strikethrough(item.done, color: .secondary)
                                    .foregroundStyle(item.done ? .secondary : .primary)
                                Spacer()
                                Text(item.tag).font(.system(size: 9))
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 6).padding(.vertical, 2)
                                    .background(Color(.systemFill)).clipShape(Capsule())
                            }
                            .padding(.horizontal, 10).padding(.vertical, 8)
                            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }

                case 1:
                    // Sort descriptors
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Text("Sort by:").font(.system(size: 12)).foregroundStyle(.secondary)
                            ForEach(["Title A-Z", "Priority ↓", "Date"].indices, id: \.self) { i in
                                Button(["Title A-Z", "Priority ↓", "Date"][i]) {
                                    withAnimation(.spring(response: 0.3)) { sortBy = i }
                                }
                                .font(.system(size: 11, weight: sortBy == i ? .semibold : .regular))
                                .foregroundStyle(sortBy == i ? .white : .sdBlue)
                                .padding(.horizontal, 10).padding(.vertical, 5)
                                .background(sortBy == i ? Color.sdBlue : Color.sdBlueLight)
                                .clipShape(Capsule())
                                .buttonStyle(PressableButtonStyle())
                            }
                        }

                        ForEach(sortedFiltered) { item in
                            HStack(spacing: 8) {
                                Circle().fill(priorityColors[item.priority])
                                    .frame(width: 8, height: 8)
                                Text(item.title).font(.system(size: 12))
                                Spacer()
                                Text(priorityLabels[item.priority])
                                    .font(.system(size: 9, weight: .semibold))
                                    .foregroundStyle(priorityColors[item.priority])
                            }
                            .padding(.horizontal, 10).padding(.vertical, 8)
                            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                            .transition(.opacity)
                        }
                    }
                    .animation(.spring(response: 0.35), value: sortBy)

                default:
                    // Filter / tag
                    VStack(spacing: 8) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(tags, id: \.self) { tag in
                                    Button(tag) {
                                        withAnimation(.spring(response: 0.3)) { tagFilter = tag }
                                    }
                                    .font(.system(size: 11, weight: tagFilter == tag ? .semibold : .regular))
                                    .foregroundStyle(tagFilter == tag ? .white : .sdBlue)
                                    .padding(.horizontal, 12).padding(.vertical, 6)
                                    .background(tagFilter == tag ? Color.sdBlue : Color.sdBlueLight)
                                    .clipShape(Capsule())
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }
                        }

                        ForEach(sortedFiltered) { item in
                            HStack(spacing: 8) {
                                Image(systemName: item.done ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 15))
                                    .foregroundStyle(item.done ? Color.formGreen : Color(.systemGray3))
                                Text(item.title).font(.system(size: 12))
                                    .strikethrough(item.done)
                                Spacer()
                                Text(item.tag).font(.system(size: 9))
                                    .padding(.horizontal, 6).padding(.vertical, 2)
                                    .background(Color.sdBlueLight).clipShape(Capsule())
                                    .foregroundStyle(Color.sdBlue)
                            }
                            .padding(.horizontal, 10).padding(.vertical, 8)
                            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        Text("\(sortedFiltered.count) items · \(tagFilter == "All" ? "all tags" : tagFilter)")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }
                    .animation(.spring(response: 0.35), value: tagFilter)
                }
            }
        }
    }
}

struct SDQueryExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "@Query - reactive fetching")
            Text("@Query is a property wrapper that fetches model objects from SwiftData and keeps the view in sync. When the underlying data changes, @Query automatically updates the view - no manual observation setup needed.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@Query var items: [MyModel] - fetches all items, re-renders view on any change.", color: .sdBlue)
                StepRow(number: 2, text: "@Query(sort: \\.title) - sort by a key path. .reverse for descending.", color: .sdBlue)
                StepRow(number: 3, text: "@Query(sort: [SortDescriptor(\\.priority, order: .reverse), SortDescriptor(\\.title)]) - multi-sort.", color: .sdBlue)
                StepRow(number: 4, text: "@Query(filter: #Predicate { $0.isCompleted == false }) - filter with type-safe predicate.", color: .sdBlue)
                StepRow(number: 5, text: "@Query(filter:sort:) - combine filter and sort in one query.", color: .sdBlue)
            }

            CalloutBox(style: .success, title: "@Query is always in sync", contentBody: "@Query is backed by a live database observer. Any insert, update or delete - even from another context - automatically re-fetches and updates the view. You never need to manually refresh.")

            CodeBlock(code: """
// Simple fetch - all items
@Query var todos: [TodoItem]

// Sorted
@Query(sort: \\.title)
var todos: [TodoItem]

// Multi-sort
@Query(sort: [
    SortDescriptor(\\.priority, order: .reverse),
    SortDescriptor(\\.title)
])
var todos: [TodoItem]

// Filtered
@Query(filter: #Predicate<TodoItem> { todo in
    todo.isCompleted == false
})
var activeTodos: [TodoItem]

// Filter + sort
@Query(
    filter: #Predicate<TodoItem> { $0.priority > 0 },
    sort: \\.createdAt, order: .reverse
)
var urgentTodos: [TodoItem]
""")
        }
    }
}

