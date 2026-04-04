//
//
//  4_SwipeActions.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Swipe Actions
struct SwipeActionsVisual: View {
    @State private var tasks: [LFTask] = LFTask.samples
    @State private var selectedEdge = 0
    @State private var lastAction = "Swipe a row to see actions"

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Swipe actions", systemImage: "arrow.left.and.right.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.lfBlue)

                // Edge selector
                HStack(spacing: 8) {
                    ForEach(["Trailing (default)", "Leading", "Both"].indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedEdge = i }
                        } label: {
                            Text(["Trailing", "Leading", "Both"][i])
                                .font(.system(size: 11, weight: selectedEdge == i ? .semibold : .regular))
                                .foregroundStyle(selectedEdge == i ? Color.lfBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedEdge == i ? Color.lfBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Live list with swipe actions
                List {
                    ForEach(tasks) { task in
                        taskRow(task)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                if selectedEdge == 0 || selectedEdge == 2 {
                                    Button(role: .destructive) {
                                        withAnimation { tasks.removeAll { $0.id == task.id } }
                                        lastAction = "Deleted: \(task.title)"
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }

                                    Button {
                                        lastAction = "Flagged: \(task.title)"
                                    } label: {
                                        Label("Flag", systemImage: "flag.fill")
                                    }
                                    .tint(.animAmber)
                                }
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                if selectedEdge == 1 || selectedEdge == 2 {
                                    Button {
                                        if let i = tasks.firstIndex(where: { $0.id == task.id }) {
                                            tasks[i].isDone.toggle()
                                        }
                                        lastAction = "Toggled: \(task.title)"
                                    } label: {
                                        Label(task.isDone ? "Undo" : "Done",
                                              systemImage: task.isDone ? "arrow.uturn.left" : "checkmark")
                                    }
                                    .tint(task.isDone ? .secondary : .animTeal)
                                }
                            }
                    }
                }
                .listStyle(.plain)
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Action log
                HStack(spacing: 6) {
                    Image(systemName: "arrow.left.and.right").font(.system(size: 11)).foregroundStyle(Color.lfBlue)
                    Text(lastAction).font(.system(size: 12)).foregroundStyle(.secondary)
                    Spacer()
                    if tasks.count < LFTask.samples.count {
                        Button("Reset") {
                            withAnimation { tasks = LFTask.samples }
                            lastAction = "Reset"
                        }
                        .font(.system(size: 12)).foregroundStyle(Color.lfBlue)
                    }
                }
                .padding(10).background(Color.lfBlueLight).clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut(duration: 0.2), value: lastAction)
            }
        }
    }

    func taskRow(_ task: LFTask) -> some View {
        HStack(spacing: 10) {
            Circle().fill(task.priority.color).frame(width: 8, height: 8)
            Text(task.title)
                .font(.system(size: 14))
                .strikethrough(task.isDone, color: .secondary)
                .foregroundStyle(task.isDone ? .secondary : .primary)
            Spacer()
            if task.isDone {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.animTeal).font(.system(size: 14))
            }
        }
    }
}

struct SwipeActionsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Swipe actions")
            Text("Swipe actions replace the old .onDelete modifier for customizable per-row actions. You can add buttons on both edges with any tint color, and mark one action as destructive so it gets the red treatment automatically.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".swipeActions(edge: .trailing) — the right swipe, the standard delete side. allowsFullSwipe triggers the first action on a full swipe.", color: .lfBlue)
                StepRow(number: 2, text: ".swipeActions(edge: .leading) — the left swipe. Use for positive actions like mark done, flag, or pin.", color: .lfBlue)
                StepRow(number: 3, text: "Button(role: .destructive) inside swipeActions — automatically tints the button red.", color: .lfBlue)
                StepRow(number: 4, text: ".tint(color) on the button overrides the default gray with any color.", color: .lfBlue)
                StepRow(number: 5, text: "allowsFullSwipe: true — full swipe triggers the first action without lifting. Use carefully for destructive actions.", color: .lfBlue)
            }

            CalloutBox(style: .warning, title: "allowsFullSwipe on destructive actions", contentBody: "allowsFullSwipe: true on a delete button means a user can accidentally delete by swiping too far. Consider setting it to false for destructive actions, or providing an undo option.")

            CalloutBox(style: .info, title: "Swipe actions replace onDelete", contentBody: ".swipeActions is more flexible than .onDelete — multiple buttons, custom colors, leading edge. Use .onDelete only for simple backward-compatible scenarios.")

            CodeBlock(code: """
List {
    ForEach(items) { item in
        ItemRow(item: item)
            // Trailing — standard delete side
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    delete(item)
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }

                Button { flag(item) } label: {
                    Label("Flag", systemImage: "flag.fill")
                }
                .tint(.orange)
            }
            // Leading — positive actions
            .swipeActions(edge: .leading) {
                Button { markDone(item) } label: {
                    Label("Done", systemImage: "checkmark")
                }
                .tint(.green)
            }
    }
}
""")
        }
    }
}
