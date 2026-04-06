//
//
//  5_EditMode.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Edit Mode
struct EditModeVisual: View {
    @State private var tasks: [LFTask] = LFTask.samples
    @State private var editMode: EditMode = .inactive

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Edit mode", systemImage: "pencil.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.lfBlue)

                // Edit mode toggle
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Edit mode: \(editMode == .active ? "active" : "inactive")")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(editMode == .active ? Color.lfBlue : .secondary)
                        Text(editMode == .active ? "Drag to reorder · swipe to delete" : "Tap Edit to enable delete and reorder")
                            .font(.system(size: 11)).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button(editMode == .active ? "Done" : "Edit") {
                        withAnimation {
                            editMode = editMode == .active ? .inactive : .active
                        }
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16).padding(.vertical, 7)
                    .background(editMode == .active ? Color.animTeal : Color.lfBlue)
                    .clipShape(Capsule())
                    .buttonStyle(PressableButtonStyle())
                }
                .padding(12)
                .background(editMode == .active ? Color(hex: "#E1F5EE") : Color.lfBlueLight)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .animation(.spring(response: 0.3), value: editMode)

                // Live list
                List {
                    ForEach(tasks) { task in
                        HStack(spacing: 10) {
                            Circle().fill(task.priority.color).frame(width: 8, height: 8)
                            Text(task.title).font(.system(size: 14))
                            Spacer()
                        }
                    }
                    .onDelete { indexSet in
                        withAnimation { tasks.remove(atOffsets: indexSet) }
                    }
                    .onMove { from, to in
                        tasks.move(fromOffsets: from, toOffset: to)
                    }
                }
                .listStyle(.plain)
                .frame(height: 170)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .environment(\.editMode, $editMode)

                // Reset
                if tasks.count < LFTask.samples.count {
                    Button {
                        withAnimation { tasks = LFTask.samples }
                    } label: {
                        Label("Reset list", systemImage: "arrow.counterclockwise")
                            .font(.system(size: 12)).foregroundStyle(Color.lfBlue)
                    }
                    .buttonStyle(PressableButtonStyle())
                }
            }
        }
    }
}

struct EditModeExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Edit mode - delete and reorder")
            Text("Edit mode reveals delete controls and drag handles in a List. Add .onDelete and .onMove to the ForEach inside the List, then toggle editMode to activate them. The system handles all the animations.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".onDelete(perform:) - receives an IndexSet of rows to delete. Remove those indices from your @State array.", color: .lfBlue)
                StepRow(number: 2, text: ".onMove(perform:) - receives source IndexSet and destination Int. Call array.move(fromOffsets:toOffset:).", color: .lfBlue)
                StepRow(number: 3, text: ".environment(\\.editMode, $editMode) - injects edit mode into the List. Toggle .active / .inactive to show/hide controls.", color: .lfBlue)
                StepRow(number: 4, text: "EditButton() in a toolbar automatically toggles edit mode for the nearest List - the simplest approach.", color: .lfBlue)
            }

            CalloutBox(style: .info, title: "onDelete and onMove go on ForEach, not List", contentBody: ".onDelete and .onMove must be applied to the ForEach inside the List, not to the List itself. This is a common mistake that produces no effect.")

            CalloutBox(style: .success, title: "EditButton is the easy path", contentBody: "Adding EditButton() to the toolbar automatically handles the Edit/Done toggle and connects it to the List's edit mode - no @State needed. Use custom edit mode only when you need programmatic control.")

            CodeBlock(code: """
@State private var items = ["Item 1", "Item 2", "Item 3"]
@State private var editMode: EditMode = .inactive

List {
    ForEach(items, id: \\.self) { item in
        Text(item)
    }
    .onDelete { indexSet in
        items.remove(atOffsets: indexSet)  // ← on ForEach
    }
    .onMove { from, to in
        items.move(fromOffsets: from, toOffset: to)  // ← on ForEach
    }
}
.environment(\\.editMode, $editMode)
.toolbar {
    // Option 1: custom button
    Button(editMode.isEditing ? "Done" : "Edit") {
        editMode = editMode.isEditing ? .inactive : .active
    }

    // Option 2: automatic EditButton
    EditButton()
}
""")
        }
    }
}
