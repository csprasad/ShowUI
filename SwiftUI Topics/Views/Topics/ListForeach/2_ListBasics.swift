//
//
//  1_ListBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: List Basics
struct ListBasicsVisual: View {
    @State private var selectedStyle = 0
    @State private var singleSelection: UUID? = nil
    @State private var multiSelection = Set<UUID>()
    @State private var selectionMode = 0

    let styles = [".automatic", ".plain", ".grouped", ".insetGrouped", ".sidebar"]
    let styleDescs = ["Platform default", "No background dividers", "Grouped sections", "Inset + rounded", "Sidebar/nav style"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("List basics", systemImage: "list.bullet.rectangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.lfBlue)

                // Style selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(styles.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedStyle = i }
                            } label: {
                                VStack(spacing: 2) {
                                    Text(styles[i])
                                        .font(.system(size: 10, weight: selectedStyle == i ? .semibold : .regular, design: .monospaced))
                                        .foregroundStyle(selectedStyle == i ? Color.lfBlue : .secondary)
                                    Text(styleDescs[i])
                                        .font(.system(size: 9))
                                        .foregroundStyle(selectedStyle == i ? Color.lfBlue.opacity(0.7) : Color(.tertiaryLabel))
                                }
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(selectedStyle == i ? Color.lfBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }

                // Live list demo
                listDemo
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .animation(.spring(response: 0.35), value: selectedStyle)

                // Selection mode
                VStack(alignment: .leading, spacing: 8) {
                    sectionLabel("Selection")
                    HStack(spacing: 8) {
                        ForEach(["None", "Single", "Multi"].indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectionMode = i }
                            } label: {
                                Text(["None", "Single", "Multi"][i])
                                    .font(.system(size: 12, weight: selectionMode == i ? .semibold : .regular))
                                    .foregroundStyle(selectionMode == i ? Color.lfBlue : .secondary)
                                    .frame(maxWidth: .infinity).padding(.vertical, 7)
                                    .background(selectionMode == i ? Color.lfBlueLight : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }

                    selectionList
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }

    @ViewBuilder
    private var listDemo: some View {
        let listContent = ForEach(LFContact.samples.prefix(4)) { contact in
            HStack(spacing: 10) {
                Circle().fill(Color.lfBlue).frame(width: 28, height: 28)
                    .overlay(Text(contact.initial).font(.system(size: 11, weight: .semibold)).foregroundStyle(.white))
                Text(contact.name).font(.system(size: 13))
            }
        }

        switch selectedStyle {
        case 1: List { listContent }.listStyle(.plain)
        case 2: List { listContent }.listStyle(.grouped)
        case 3: List { listContent }.listStyle(.insetGrouped)
        case 4: List { listContent }.listStyle(.sidebar)
        default: List { listContent }.listStyle(.automatic)
        }
    }

    @ViewBuilder
    private var selectionList: some View {
        switch selectionMode {
        case 1:
            List(LFContact.samples.prefix(3), selection: $singleSelection) { contact in
                Text(contact.name).tag(contact.id)
            }
            .listStyle(.plain)
        case 2:
            List(LFContact.samples.prefix(3), selection: $multiSelection) { contact in
                Text(contact.name).tag(contact.id)
            }
            .listStyle(.plain)
        default:
            List(LFContact.samples.prefix(3)) { contact in
                Text(contact.name)
            }
            .listStyle(.plain)
        }
    }

    func sectionLabel(_ text: String) -> some View {
        Text(text).font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
    }
}

struct ListBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "List — the workhorse view")
            Text("List is a container that displays rows of data with system-standard styling — separators, backgrounds, insets. Unlike a VStack with ForEach, List is lazy — it only renders visible rows, making it efficient for hundreds or thousands of items.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "List(items) { item in } — simplest form. Items must be Identifiable.", color: .lfBlue)
                StepRow(number: 2, text: ".listStyle(.insetGrouped) — the modern iOS style. .plain for no background. .sidebar for navigation lists.", color: .lfBlue)
                StepRow(number: 3, text: "Single selection: List(items, selection: $selected) — $selected is Binding<ID?>.", color: .lfBlue)
                StepRow(number: 4, text: "Multi-selection: List(items, selection: $selected) — $selected is Binding<Set<ID>>.", color: .lfBlue)
            }

            CalloutBox(style: .info, title: "List vs VStack + ForEach", contentBody: "List is lazy — renders only visible rows. VStack renders all rows immediately. Use List for dynamic data that may be long. Use VStack + ForEach inside ScrollView when you need custom layout or the data is short and fixed.")

            CalloutBox(style: .success, title: "Selection requires Edit mode on iOS", contentBody: "Multi-selection in List only shows checkmarks when EditButton is active or .environment(\\.editMode, .constant(.active)) is set. Single selection works without edit mode.")

            CodeBlock(code: """
// Basic list
List(contacts) { contact in
    Text(contact.name)
}

// With style
List(contacts) { contact in
    ContactRow(contact: contact)
}
.listStyle(.insetGrouped)

// Single selection
@State private var selected: UUID? = nil

List(contacts, selection: $selected) { contact in
    Text(contact.name).tag(contact.id)
}

// Multi-selection (needs edit mode)
@State private var selected = Set<UUID>()

List(contacts, selection: $selected) { contact in
    Text(contact.name).tag(contact.id)
}
.toolbar { EditButton() }
""")
        }
    }
}

