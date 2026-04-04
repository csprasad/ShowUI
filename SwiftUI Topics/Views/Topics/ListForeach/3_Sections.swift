//
//
//  3_Sections.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Sections

struct SectionsVisual: View {
    @State private var selectedDemo = 0
    @State private var expandedSections = Set<String>(["High Priority", "Medium Priority"])

    let demos = ["Basic sections", "Header & footer", "Collapsible"]

    let grouped: [(title: String, tasks: [LFTask])] = [
        ("High Priority",   LFTask.samples.filter { $0.priority == .high }),
        ("Medium Priority", LFTask.samples.filter { $0.priority == .medium }),
        ("Low Priority",    LFTask.samples.filter { $0.priority == .low }),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Sections", systemImage: "rectangle.grid.1x2.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.lfBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.lfBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.lfBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Live demo
                listDemo
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .animation(.spring(response: 0.35), value: selectedDemo)
            }
        }
    }

    @ViewBuilder
    private var listDemo: some View {
        switch selectedDemo {
        case 0:
            // Basic sections
            List {
                Section("Design") {
                    Label("Typography", systemImage: "textformat")
                    Label("Colors", systemImage: "paintpalette.fill")
                }
                Section("Engineering") {
                    Label("State", systemImage: "circle.fill")
                    Label("Navigation", systemImage: "rectangle.stack.fill")
                }
                Section("Tools") {
                    Label("Instruments", systemImage: "waveform.path.ecg")
                }
            }
            .listStyle(.insetGrouped)

        case 1:
            // Header and footer
            List {
                ForEach(grouped.prefix(2), id: \.title) { group in
                    Section {
                        ForEach(group.tasks) { task in
                            HStack(spacing: 8) {
                                Circle().fill(task.priority.color).frame(width: 8, height: 8)
                                Text(task.title).font(.system(size: 13))
                            }
                        }
                    } header: {
                        HStack {
                            Text(group.title)
                            Spacer()
                            Text("\(group.tasks.count) task\(group.tasks.count == 1 ? "" : "s")")
                                .foregroundStyle(.secondary)
                        }
                    } footer: {
                        Text(group.title == "High Priority" ? "⚠️ Address these first" : "Schedule for this sprint")
                            .font(.system(size: 11)).foregroundStyle(.secondary)
                    }
                }
            }
            .listStyle(.insetGrouped)

        default:
            // Collapsible
            List {
                ForEach(grouped, id: \.title) { group in
                    Section(isExpanded: Binding(
                        get: { expandedSections.contains(group.title) },
                        set: { isExpanded in
                            withAnimation {
                                if isExpanded { expandedSections.insert(group.title) }
                                else { expandedSections.remove(group.title) }
                            }
                        }
                    )) {
                        ForEach(group.tasks) { task in
                            HStack(spacing: 8) {
                                Circle().fill(task.priority.color).frame(width: 8, height: 8)
                                Text(task.title).font(.system(size: 13))
                            }
                        }
                    } header: {
                        Text(group.title)
                    }
                }
            }
            .listStyle(.sidebar)
        }
    }
}

struct SectionsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Sections")
            Text("Section groups related rows with an optional header and footer. Combine ForEach with Section to build grouped lists dynamically. The .sidebar list style adds expand/collapse arrows to sections automatically.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Section(\"Title\") { rows } — simplest form. Title string becomes the header.", color: .lfBlue)
                StepRow(number: 2, text: "Section { rows } header: { view } footer: { view } — custom header and footer views.", color: .lfBlue)
                StepRow(number: 3, text: "Section(isExpanded: $bool) — collapsible section. Works with .listStyle(.sidebar) for the chevron arrow.", color: .lfBlue)
                StepRow(number: 4, text: "Nest ForEach inside Section to generate sections dynamically from grouped data.", color: .lfBlue)
            }

            CalloutBox(style: .info, title: "Collapsible sections need .sidebar", contentBody: "Section(isExpanded:) only shows the expand/collapse arrow with .listStyle(.sidebar). With other styles the section is still collapsible programmatically, but there's no visual indicator.")

            CalloutBox(style: .success, title: "Dynamic sections pattern", contentBody: "Group your data before passing it to the view: let grouped = Dictionary(grouping: items, by: { $0.category }). Then ForEach over the groups, and Section + ForEach for the items inside each group.")

            CodeBlock(code: """
// Static sections
List {
    Section("Pinned") {
        Text("Item 1")
        Text("Item 2")
    }
    Section("Recent") {
        Text("Item 3")
    }
}

// Dynamic sections with header + footer
ForEach(groupedItems, id: \\.key) { key, items in
    Section {
        ForEach(items) { item in ItemRow(item: item) }
    } header: {
        HStack {
            Text(key)
            Spacer()
            Text("\\(items.count)")
                .foregroundStyle(.secondary)
        }
    } footer: {
        Text("End of \\(key)")
    }
}

// Collapsible
Section(isExpanded: $isExpanded) {
    ForEach(items) { item in ItemRow(item: item) }
} header: {
    Text("Archived")
}
.listStyle(.sidebar)
""")
        }
    }
}
