//
//
//  9_FetchDescriptor.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import SwiftData

// MARK: - LESSON 9: FetchDescriptor Deep Dive
struct FetchDescriptorVisual: View {
    @State private var selectedDemo     = 0
    @State private var fetchLimit       = 3
    @State private var fetchOffset      = 0
    @State private var includePending   = true
    @State private var sortAscending    = true

    let demos = ["Pagination", "Options", "vs @Query"]

    // Simulated dataset of 20 items
    struct PageItem: Identifiable {
        let id = UUID(); let index: Int; let title: String; let score: Int
    }
    let allItems: [PageItem] = (1...20).map {
        PageItem(index: $0, title: "Record \($0)", score: Int.random(in: 10...99))
    }

    var pagedItems: [PageItem] {
        let sorted = sortAscending ? allItems : allItems.reversed()
        let start  = min(fetchOffset, sorted.count)
        let end    = min(start + fetchLimit, sorted.count)
        return Array(sorted[start..<end])
    }

    var totalPages: Int { max(1, Int(ceil(Double(allItems.count) / Double(fetchLimit)))) }
    var currentPage: Int { fetchOffset / fetchLimit + 1 }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("FetchDescriptor deep dive", systemImage: "doc.text.magnifyingglass")
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
                    // Pagination demo
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("fetchLimit").font(.system(size: 10)).foregroundStyle(.secondary)
                                HStack(spacing: 6) {
                                    Stepper("", value: $fetchLimit, in: 1...10)
                                        .labelsHidden()
                                    Text("\(fetchLimit)").font(.system(size: 14, weight: .bold, design: .monospaced)).foregroundStyle(Color.sdPurple)
                                        .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: fetchLimit)
                                }
                            }
                            Spacer()
                            Toggle("Sort ASC", isOn: $sortAscending.animation()).tint(.sdPurple)
                                .font(.system(size: 12))
                        }

                        // Page indicator
                        HStack {
                            Text("Page \(currentPage) of \(totalPages)")
                                .font(.system(size: 12, weight: .semibold)).foregroundStyle(Color.sdPurple)
                            Spacer()
                            Text("offset: \(fetchOffset)")
                                .font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                        }

                        // Results
                        VStack(spacing: 4) {
                            ForEach(pagedItems) { item in
                                HStack(spacing: 8) {
                                    Text("#\(item.index)").font(.system(size: 10, design: .monospaced))
                                        .foregroundStyle(Color.sdPurple).frame(width: 28)
                                    Text(item.title).font(.system(size: 12))
                                    Spacer()
                                    Text("score: \(item.score)").font(.system(size: 10, design: .monospaced))
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.horizontal, 10).padding(.vertical, 7)
                                .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 7))
                            }
                        }
                        .animation(.spring(response: 0.35), value: fetchOffset)
                        .animation(.spring(response: 0.35), value: fetchLimit)

                        // Prev / Next
                        HStack(spacing: 8) {
                            Button("← Prev") {
                                withAnimation { fetchOffset = max(0, fetchOffset - fetchLimit) }
                            }
                            .disabled(fetchOffset == 0)
                            .font(.system(size: 12, weight: .semibold)).foregroundStyle(Color.sdPurple)
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
                            .buttonStyle(PressableButtonStyle())

                            Spacer()

                            Button("Next →") {
                                withAnimation {
                                    let next = fetchOffset + fetchLimit
                                    if next < allItems.count { fetchOffset = next }
                                }
                            }
                            .disabled(fetchOffset + fetchLimit >= allItems.count)
                            .font(.system(size: 12, weight: .semibold)).foregroundStyle(Color.sdPurple)
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
                            .buttonStyle(PressableButtonStyle())
                        }

                        codeSnip("var d = FetchDescriptor<Record>()\nd.fetchLimit  = \(fetchLimit)\nd.fetchOffset = \(fetchOffset)\nd.sortBy = [SortDescriptor(\\.index, order: .\(sortAscending ? "forward" : "reverse"))]")
                    }

                case 1:
                    // Options breakdown
                    VStack(spacing: 8) {
                        optionRow(prop: "fetchLimit",
                                  type: "Int?",
                                  desc: "Max rows returned. nil = no limit. Essential for pagination and performance.",
                                  example: "descriptor.fetchLimit = 20")
                        optionRow(prop: "fetchOffset",
                                  type: "Int",
                                  desc: "Skip this many rows before returning results. Combine with fetchLimit for pages.",
                                  example: "descriptor.fetchOffset = page * 20")
                        optionRow(prop: "sortBy",
                                  type: "[SortDescriptor<T>]",
                                  desc: "Array of sort descriptors. Evaluated in order - first sorts, ties broken by second.",
                                  example: "descriptor.sortBy = [SortDescriptor(\\.date, order: .reverse)]")
                        optionRow(prop: "predicate",
                                  type: "Predicate<T>?",
                                  desc: "Filter expression. Compiled to SQL WHERE clause.",
                                  example: "descriptor.predicate = #Predicate { $0.done == false }")
                        optionRow(prop: "includePendingChanges",
                                  type: "Bool",
                                  desc: "true (default) = include unsaved inserts/updates. false = only committed data.",
                                  example: "descriptor.includePendingChanges = false")
                        optionRow(prop: "relationshipKeyPathsForPrefetching",
                                  type: "[AnyKeyPath]",
                                  desc: "Eagerly load relationships to avoid N+1 faults.",
                                  example: "descriptor.relationshipKeyPathsForPrefetching = [\\.tasks]")
                    }

                default:
                    // @Query vs FetchDescriptor
                    VStack(spacing: 8) {
                        compCard(
                            title: "@Query",
                            color: .sdBlue,
                            pros: ["Reactive - auto-updates view", "Declarative - simple syntax", "Built into SwiftUI property wrapper"],
                            cons: ["View-only", "Can't be called from functions", "Limited to current view context"]
                        )
                        compCard(
                            title: "FetchDescriptor",
                            color: .sdPurple,
                            pros: ["Use anywhere - functions, actors, services", "Pagination with fetchLimit/fetchOffset", "Prefetch relationships", "Fine-grained includePendingChanges"],
                            cons: ["Manual fetch call required", "No auto-reactivity - you call try context.fetch(d)"]
                        )
                        codeSnip("// FetchDescriptor - manual, anywhere\nlet d = FetchDescriptor<Item>(\n    predicate: #Predicate { $0.done == false },\n    sortBy: [SortDescriptor(\\.date)]\n)\nd.fetchLimit = 50\nlet results = try context.fetch(d)")
                    }
                }
            }
        }
    }

    func optionRow(prop: String, type: String, desc: String, example: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Text(prop).font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(Color.sdPurple)
                Text(type).font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                    .padding(.horizontal, 5).padding(.vertical, 2).background(Color(.systemFill)).clipShape(Capsule())
            }
            Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            Text(example).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdPurple)
                .padding(5).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func compCard(title: String, color: Color, pros: [String], cons: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.system(size: 11, weight: .semibold)).foregroundStyle(color)
            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(pros, id: \.self) { p in
                        HStack(spacing: 3) {
                            Text("✓").font(.system(size: 9)).foregroundStyle(Color.formGreen)
                            Text(p).font(.system(size: 9)).foregroundStyle(.secondary)
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(cons, id: \.self) { c in
                        HStack(spacing: 3) {
                            Text("·").font(.system(size: 9)).foregroundStyle(Color.animCoral)
                            Text(c).font(.system(size: 9)).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .padding(8).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func codeSnip(_ text: String) -> some View {
        Text(text).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.sdPurple)
            .padding(8).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct FetchDescriptorExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "FetchDescriptor - manual fetch control")
            Text("FetchDescriptor is the imperative counterpart to @Query. Use it when you need to fetch from a function, actor, or service layer; when you need pagination; or when you need fine-grained control over exactly what the database returns.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "FetchDescriptor<T>(predicate:sortBy:) - type-safe, compiled to SQL.", color: .sdPurple)
                StepRow(number: 2, text: "descriptor.fetchLimit = 20 + descriptor.fetchOffset = page * 20 - cursor-based pagination.", color: .sdPurple)
                StepRow(number: 3, text: "descriptor.includePendingChanges = false - only reads committed data (useful for background reads).", color: .sdPurple)
                StepRow(number: 4, text: "descriptor.relationshipKeyPathsForPrefetching = [\\.tasks] - avoids N+1 faults on relationships.", color: .sdPurple)
                StepRow(number: 5, text: "try context.fetchCount(descriptor) - count without loading objects into memory.", color: .sdPurple)
            }

            CalloutBox(style: .success, title: "fetchCount for badges and counts", contentBody: "context.fetchCount(FetchDescriptor<TodoItem>(predicate: #Predicate { !$0.done })) returns the count without materialising any objects. Far more efficient than fetching all items and checking .count.")

            CodeBlock(code: """
// Pagination - page 2, 20 items per page
var descriptor = FetchDescriptor<Article>(
    predicate: #Predicate { $0.isPublished },
    sortBy: [SortDescriptor(\\.publishedAt, order: .reverse)]
)
descriptor.fetchLimit  = 20
descriptor.fetchOffset = 20     // skip first page

let page2 = try context.fetch(descriptor)

// Eager-load relationships (avoid N+1)
var d = FetchDescriptor<Project>()
d.relationshipKeyPathsForPrefetching = [\\.tasks, \\.members]
let projects = try context.fetch(d)

// Count only - no object materialisation
let undoneCount = try context.fetchCount(
    FetchDescriptor<TodoItem>(
        predicate: #Predicate { !$0.isCompleted }
    )
)
""")
        }
    }
}

