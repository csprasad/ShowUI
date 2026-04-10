//
//
//  8_TextFieldInLists.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: TextField in Lists
struct ListItem: Identifiable {
    let id = UUID()
    var title: String
    var isEditing: Bool = false
}

struct TFInListVisual: View {
    @State private var items: [ListItem] = [
        ListItem(title: "Buy groceries"),
        ListItem(title: "Call the dentist"),
        ListItem(title: "Finish the report"),
        ListItem(title: "Book a flight"),
        ListItem(title: "Learn SwiftUI"),
    ]
    @State private var newItemText     = ""
    @State private var editingID: UUID? = nil
    @State private var selectedDemo    = 0
    @FocusState private var listFocus: UUID?
    @FocusState private var addFocus: Bool

    let demos = ["Tap to edit", "Inline add", "Swipe to rename"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("TextField in Lists", systemImage: "list.bullet.rectangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tfOrange)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; editingID = nil }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.tfOrange : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.tfOrangeLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Tap-to-edit rows
                    VStack(spacing: 0) {
                        ForEach($items, id: \.id) { $item in
                            HStack(spacing: 10) {
                                Image(systemName: "circle").foregroundStyle(.secondary).font(.system(size: 16))

                                if editingID == item.id {
                                    TextField("Task name", text: $item.title)
                                        .textFieldStyle(.plain)
                                        .font(.system(size: 14))
                                        .focused($listFocus, equals: item.id)
                                        .submitLabel(.done)
                                        .onSubmit { withAnimation { editingID = nil } }
                                } else {
                                    Text(item.title)
                                        .font(.system(size: 14))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.25)) {
                                                editingID = item.id
                                                DispatchQueue.main.async { listFocus = item.id }
                                            }
                                        }
                                }

                                if editingID == item.id {
                                    Button {
                                        withAnimation { editingID = nil }
                                    } label: {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(Color.tfOrange)
                                    }
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .background(editingID == item.id ? Color.tfOrangeLight : Color(.systemBackground))
                            .animation(.spring(response: 0.25), value: editingID == item.id)

                            if item.id != items.last?.id { Divider().padding(.leading, 40) }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                    Text("Tap any row to edit in-place").font(.system(size: 10)).foregroundStyle(.secondary)

                case 1:
                    // Inline add at bottom
                    VStack(spacing: 0) {
                        ForEach(items.prefix(4)) { item in
                            HStack(spacing: 10) {
                                Image(systemName: "circle").foregroundStyle(.secondary).font(.system(size: 16))
                                Text(item.title).font(.system(size: 14))
                                Spacer()
                            }
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .background(Color(.systemBackground))
                            if item.id != items.prefix(4).last?.id { Divider().padding(.leading, 40) }
                        }
                        Divider().padding(.leading, 40)
                        HStack(spacing: 10) {
                            Image(systemName: "plus.circle.fill").foregroundStyle(Color.tfOrange).font(.system(size: 16))
                            TextField("Add new item…", text: $newItemText)
                                .textFieldStyle(.plain)
                                .font(.system(size: 14))
                                .focused($addFocus)
                                .submitLabel(.done)
                                .onSubmit {
                                    if !newItemText.trimmingCharacters(in: .whitespaces).isEmpty {
                                        withAnimation(.spring(response: 0.3)) {
                                            items.append(ListItem(title: newItemText))
                                            newItemText = ""
                                        }
                                    }
                                }
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(Color(.systemBackground))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                    Text("Press Return to commit · item added to list").font(.system(size: 10)).foregroundStyle(.secondary)

                default:
                    // Swipe to reveal rename
                    VStack(spacing: 0) {
                        ForEach($items) { $item in
                            HStack(spacing: 10) {
                                Image(systemName: "line.3.horizontal").foregroundStyle(Color(.systemGray4)).font(.system(size: 14))

                                if item.isEditing {
                                    TextField("Name", text: $item.title)
                                        .textFieldStyle(.plain)
                                        .font(.system(size: 14))
                                        .focused($listFocus, equals: item.id)
                                        .submitLabel(.done)
                                        .onSubmit { withAnimation { item.isEditing = false } }
                                } else {
                                    Text(item.title).font(.system(size: 14)).frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .background(item.isEditing ? Color.tfOrangeLight : Color(.systemBackground))
                            .swipeActions(edge: .trailing) {
                                Button {
                                    withAnimation(.spring(response: 0.25)) {
                                        item.isEditing = true
                                        DispatchQueue.main.async { listFocus = item.id }
                                    }
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                }
                                .tint(.tfOrange)
                            }
                            .animation(.spring(response: 0.25), value: item.isEditing)

                            if item.id != items.last?.id { Divider().padding(.leading, 44) }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                    Text("Swipe left → Rename to edit in-place").font(.system(size: 10)).foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct TFInListExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "TextField in List rows")
            Text("Inline editing in lists is a common pattern - tapping a row reveals a TextField in-place, the user edits and commits with Return or tapping a checkmark. The key is managing focus correctly when switching between display and edit modes.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Track editingID: UUID? - nil = display mode, non-nil = which row is editing.", color: .tfOrange)
                StepRow(number: 2, text: "if editingID == item.id { TextField } else { Text } - swap on tap.", color: .tfOrange)
                StepRow(number: 3, text: "DispatchQueue.main.async { focus = item.id } - set focus one run-loop after state change to ensure the field exists.", color: .tfOrange)
                StepRow(number: 4, text: ".onSubmit { editingID = nil } - Return key commits and exits edit mode.", color: .tfOrange)
                StepRow(number: 5, text: ".swipeActions { } - exposes Rename button in swipe tray that enters edit mode.", color: .tfOrange)
                StepRow(number: 6, text: "For @Binding in ForEach: use ForEach($items) { $item in } to get a binding per item.", color: .tfOrange)
            }

            CalloutBox(style: .info, title: "Delay focus assignment", contentBody: "Setting focus immediately when switching from Text to TextField can fail because SwiftUI hasn't committed the view tree change yet. DispatchQueue.main.async { focus = id } delays by one run-loop, by which point the TextField exists and can receive focus.")

            CodeBlock(code: """
@State private var editingID: UUID? = nil
@FocusState private var focus: UUID?

ForEach($items) { $item in
    HStack {
        if editingID == item.id {
            TextField("Name", text: $item.title)
                .focused($focus, equals: item.id)
                .submitLabel(.done)
                .onSubmit { editingID = nil }
        } else {
            Text(item.title)
                .onTapGesture {
                    editingID = item.id
                    // Delay - field needs to exist first
                    DispatchQueue.main.async {
                        focus = item.id
                    }
                }
        }
    }
}
""")
        }
    }
}

