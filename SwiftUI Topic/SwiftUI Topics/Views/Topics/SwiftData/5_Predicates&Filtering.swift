//
//
//  5_Predicates&Filtering.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import SwiftData

// MARK: - LESSON 5: Predicates & Filtering
struct SDPredicatesVisual: View {
    @State private var selectedDemo = 0
    let demos = ["#Predicate basics", "Compound", "Dynamic query"]

    struct FilterItem: Identifiable {
        let id = UUID()
        let title: String
        let priority: Int
        let tag: String
        let done: Bool
        let score: Int
    }

    let allItems: [FilterItem] = [
        FilterItem(title: "Ship v2",         priority: 2, tag: "Work",     done: false, score: 95),
        FilterItem(title: "Buy groceries",   priority: 0, tag: "Personal", done: false, score: 30),
        FilterItem(title: "Read docs",       priority: 1, tag: "Learning", done: true,  score: 70),
        FilterItem(title: "Fix crash bug",   priority: 2, tag: "Work",     done: false, score: 98),
        FilterItem(title: "Call dentist",    priority: 0, tag: "Personal", done: true,  score: 20),
        FilterItem(title: "Write tests",     priority: 1, tag: "Work",     done: false, score: 75),
        FilterItem(title: "Learn Predicates",priority: 1, tag: "Learning", done: false, score: 80),
    ]

    @State private var activePredicateIndex = 0
    @State private var searchString   = ""
    @State private var minScore        = 0
    @State private var showOnlyActive  = false

    let predicateDescs: [(label: String, desc: String)] = [
        ("All items",         "No filter - show everything"),
        ("Not done",          "isCompleted == false"),
        ("High priority",     "priority == 2"),
        ("Work items",        "tag == \"Work\""),
        ("High score (≥70)",  "score >= 70"),
    ]

    func filteredItems(index: Int) -> [FilterItem] {
        switch index {
        case 1: return allItems.filter { !$0.done }
        case 2: return allItems.filter { $0.priority == 2 }
        case 3: return allItems.filter { $0.tag == "Work" }
        case 4: return allItems.filter { $0.score >= 70 }
        default: return allItems
        }
    }

    func dynamicFiltered() -> [FilterItem] {
        allItems.filter { item in
            let matchSearch = searchString.isEmpty || item.title.localizedCaseInsensitiveContains(searchString)
            let matchScore  = item.score >= minScore
            let matchActive = !showOnlyActive || !item.done
            return matchSearch && matchScore && matchActive
        }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Predicates & filtering", systemImage: "line.3.horizontal.decrease.circle.fill")
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
                    // Predicate picker
                    VStack(spacing: 8) {
                        VStack(spacing: 6) {
                            ForEach(predicateDescs.indices, id: \.self) { i in
                                Button {
                                    withAnimation(.spring(response: 0.3)) { activePredicateIndex = i }
                                } label: {
                                    HStack(spacing: 8) {
                                        Circle().fill(activePredicateIndex == i ? Color.sdBlue : Color(.systemGray4))
                                            .frame(width: 8, height: 8)
                                        Text(predicateDescs[i].label)
                                            .font(.system(size: 12, weight: activePredicateIndex == i ? .semibold : .regular))
                                            .foregroundStyle(activePredicateIndex == i ? Color.sdBlue : .primary)
                                        Spacer()
                                        Text(predicateDescs[i].desc)
                                            .font(.system(size: 9, design: .monospaced))
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.horizontal, 10).padding(.vertical, 7)
                                    .background(activePredicateIndex == i ? Color.sdBlueLight : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }

                        resultRow(count: filteredItems(index: activePredicateIndex).count, total: allItems.count)

                        ForEach(filteredItems(index: activePredicateIndex)) { item in
                            itemRow(item)
                        }
                        .animation(.spring(response: 0.35), value: activePredicateIndex)
                    }

                case 1:
                    // Compound predicates
                    VStack(spacing: 8) {
                        let compoundItems = allItems.filter { !$0.done && $0.priority >= 1 }
                        let andOrItems    = allItems.filter { $0.tag == "Work" || $0.score >= 80 }

                        compoundBlock(
                            title: "#Predicate AND (&&)",
                            code: "!$0.done && $0.priority >= 1",
                            items: compoundItems
                        )
                        compoundBlock(
                            title: "#Predicate OR (||)",
                            code: "$0.tag == \"Work\" || $0.score >= 80",
                            items: andOrItems
                        )
                    }.background(Color.sdBlueLight)

                default:
                    // Dynamic predicate
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                            TextField("Search…", text: $searchString)
                                .textFieldStyle(.plain).font(.system(size: 13))
                                .autocorrectionDisabled().textInputAutocapitalization(.never)
                        }
                        .padding(.horizontal, 10).padding(.vertical, 8)
                        .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

                        HStack(spacing: 8) {
                            Text("Min score: \(minScore)").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 90)
                            Slider(value: Binding(get: { CGFloat(minScore) }, set: { minScore = Int($0) }), in: 0...100, step: 5).tint(.sdBlue)
                        }
                        Toggle("Active only", isOn: $showOnlyActive).tint(.sdBlue).font(.system(size: 12))

                        resultRow(count: dynamicFiltered().count, total: allItems.count)

                        ForEach(dynamicFiltered()) { item in itemRow(item) }
                            .animation(.spring(response: 0.3), value: searchString)
                            .animation(.spring(response: 0.3), value: minScore)
                            .animation(.spring(response: 0.3), value: showOnlyActive)
                    }
                }
            }
        }
    }

    func itemRow(_ item: FilterItem) -> some View {
        HStack(spacing: 8) {
            Circle().fill([Color.formGreen, Color.animAmber, Color.animCoral][item.priority]).frame(width: 7, height: 7)
            Text(item.title).font(.system(size: 12)).strikethrough(item.done)
                .foregroundStyle(item.done ? .secondary : .primary)
            Spacer()
            Text(item.tag).font(.system(size: 9)).foregroundStyle(.secondary)
                .padding(.horizontal, 5).padding(.vertical, 2).background(Color(.systemFill)).clipShape(Capsule())
            Text("\(item.score)").font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.sdBlue).frame(width: 28)
        }
        .padding(.horizontal, 8).padding(.vertical, 6)
        .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 7))
    }

    func resultRow(count: Int, total: Int) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "line.3.horizontal.decrease.circle.fill").font(.system(size: 11)).foregroundStyle(Color.sdBlue)
            Text("\(count) of \(total) items match").font(.system(size: 11)).foregroundStyle(.secondary)
        }
        .padding(7).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 7))
    }

    func compoundBlock(title: String, code: String, items: [FilterItem]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Text(title).font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.sdBlue)
                Spacer()
                Text("\(items.count) results").font(.system(size: 9)).foregroundStyle(.secondary)
            }
            Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.sdBlue)
                .padding(5).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 5))
            ForEach(items) { item in itemRow(item) }
        }
        .padding(8).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct SDPredicatesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "#Predicate - type-safe filtering")
            Text("#Predicate is a Swift macro that compiles filter expressions to database queries. Unlike NSPredicate strings, predicates are type-checked at compile time - no runtime crashes from typos.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "#Predicate<MyModel> { item in item.done == false } - basic type-safe predicate.", color: .sdBlue)
                StepRow(number: 2, text: "Use && for AND, || for OR - standard Swift boolean operators.", color: .sdBlue)
                StepRow(number: 3, text: "String operations: item.title.contains(\"search\") - works in predicates.", color: .sdBlue)
                StepRow(number: 4, text: "Dynamic: capture variables from scope - #Predicate { $0.priority == minPriority }.", color: .sdBlue)
                StepRow(number: 5, text: "Pass to @Query: @Query(filter: myPredicate) - or use FetchDescriptor manually.", color: .sdBlue)
            }

            CalloutBox(style: .warning, title: "#Predicate is compiled - not all Swift works", contentBody: "#Predicate compiles to SQL - not every Swift expression is supported. Avoid method calls, initializers, or complex logic. Stick to comparisons (==, !=, <, >, <=, >=), boolean operators, and .contains() on strings.")

            CodeBlock(code: """
// Basic predicate
let activePredicate = #Predicate<TodoItem> { item in
    item.isCompleted == false
}

// Compound - AND
let urgentPredicate = #Predicate<TodoItem> { item in
    item.isCompleted == false && item.priority >= 2
}

// Compound - OR
let workOrHighPredicate = #Predicate<TodoItem> { item in
    item.tag == "Work" || item.score >= 80
}

// Dynamic - capture from scope
func predicate(for tag: String) -> Predicate<TodoItem> {
    #Predicate<TodoItem> { item in
        item.tag == tag     // captures `tag` variable
    }
}

// Use with @Query
@Query(filter: activePredicate)
var activeTodos: [TodoItem]

// Use with FetchDescriptor
let descriptor = FetchDescriptor<TodoItem>(
    predicate: urgentPredicate,
    sortBy: [SortDescriptor(\\.priority, order: .reverse)]
)
let results = try context.fetch(descriptor)
""")
        }
    }
}
