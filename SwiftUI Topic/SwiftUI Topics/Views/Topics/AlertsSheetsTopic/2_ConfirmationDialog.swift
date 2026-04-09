//
//
//  2_ConfirmationDialog.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: ConfirmationDialog
struct ConfirmationDialogVisual: View {
    @State private var showShare          = false
    @State private var showDelete         = false
    @State private var showPhotoOptions   = false
    @State private var lastAction         = "None"
    @State private var selectedDemo       = 0

    let demos = ["Share sheet style", "Edit actions", "Photo options"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("ConfirmationDialog", systemImage: "list.bullet.rectangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.asRed)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.asRed : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.asRedLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Info box showing key difference
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.asRed)
                    Text("confirmationDialog = action sheet. Shows from the bottom on iPhone, as a popover on iPad.")
                        .font(.system(size: 11)).foregroundStyle(.secondary)
                }
                .padding(10).background(Color.asRedLight).clipShape(RoundedRectangle(cornerRadius: 10))

                switch selectedDemo {
                case 0:
                    // Share-style
                    actionTrigger("Share options", icon: "square.and.arrow.up", color: .navBlue) { showShare = true }
                        .confirmationDialog("Share via", isPresented: $showShare, titleVisibility: .visible) {
                            Button("Copy Link")  { lastAction = "Copied link" }
                            Button("AirDrop")    { lastAction = "AirDrop" }
                            Button("Message")    { lastAction = "Messages" }
                            Button("Mail")       { lastAction = "Mail" }
                            Button("Cancel", role: .cancel) { lastAction = "Cancelled" }
                        } message: {
                            Text("Choose how to share this item")
                        }

                case 1:
                    // Edit actions
                    actionTrigger("Edit options", icon: "ellipsis.circle", color: .formGreen) { showDelete = true }
                        .confirmationDialog("Edit Item", isPresented: $showDelete, titleVisibility: .hidden) {
                            Button("Rename")           { lastAction = "Rename" }
                            Button("Duplicate")        { lastAction = "Duplicate" }
                            Button("Move to folder")   { lastAction = "Move" }
                            Button("Delete", role: .destructive) { lastAction = "Deleted!" }
                            Button("Cancel", role: .cancel) { lastAction = "Cancelled" }
                        }

                default:
                    // Photo options
                    actionTrigger("Photo options", icon: "photo.fill", color: .ssPurple) { showPhotoOptions = true }
                        .confirmationDialog("Choose Photo Source", isPresented: $showPhotoOptions, titleVisibility: .visible) {
                            Button("Camera")           { lastAction = "Camera" }
                            Button("Photo Library")    { lastAction = "Library" }
                            Button("Files")            { lastAction = "Files" }
                            Button("Cancel", role: .cancel) { lastAction = "Cancelled" }
                        }
                }

                actionLog(lastAction)
            }
        }
    }

    func actionTrigger(_ title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon).font(.system(size: 16)).foregroundStyle(.white)
                Text(title).font(.system(size: 14, weight: .semibold)).foregroundStyle(.white)
                Spacer()
                Image(systemName: "chevron.up").font(.system(size: 11, weight: .semibold)).foregroundStyle(.white.opacity(0.7))
            }
            .padding(.horizontal, 14).padding(.vertical, 12)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PressableButtonStyle())
    }

    func actionLog(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "return").font(.system(size: 12)).foregroundStyle(Color.asRed)
            Text("Last: \(text)").font(.system(size: 12)).foregroundStyle(.secondary)
            Spacer()
        }
        .padding(10).background(Color.asRedLight).clipShape(RoundedRectangle(cornerRadius: 10))
        .animation(.easeInOut(duration: 0.2), value: text)
    }
}

struct ConfirmationDialogExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "ConfirmationDialog - action sheet")
            Text("confirmationDialog replaces the old ActionSheet API. It slides up from the bottom on iPhone (action sheet style) and appears as a popover on iPad. Use it for multiple mutually exclusive actions - not for alerts requiring user acknowledgment.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".confirmationDialog(title, isPresented: $bool) - same binding pattern as .alert.", color: .asRed)
                StepRow(number: 2, text: "titleVisibility: .visible / .hidden / .automatic - controls whether the title shows in the sheet.", color: .asRed)
                StepRow(number: 3, text: "Button(role: .destructive) - red button. Button(role: .cancel) - bolded and separate from others.", color: .asRed)
                StepRow(number: 4, text: "message: { Text(...) } - optional subtitle shown below the title in the sheet.", color: .asRed)
                StepRow(number: 5, text: "On iPad, confirmationDialog appears as a popover - attach it to the triggering button.", color: .asRed)
            }

            CalloutBox(style: .info, title: "Alert vs ConfirmationDialog", contentBody: "Alert - for critical decisions requiring acknowledgment (error, permission, data loss). ConfirmationDialog - for choosing between multiple valid actions (share, edit menu, photo source). Use the right one for the right context.")

            CalloutBox(style: .warning, title: "Cancel button placement", contentBody: "The .cancel role button is always displayed separately at the bottom of the sheet, regardless of where you place it in the button builder. You don't need to add it last - SwiftUI positions it automatically.")

            CodeBlock(code: """
.confirmationDialog(
    "Options",
    isPresented: $showOptions,
    titleVisibility: .visible
) {
    Button("Edit") { edit() }
    Button("Share") { share() }
    Button("Delete", role: .destructive) { delete() }
    Button("Cancel", role: .cancel) { }   // auto-separated
} message: {
    Text("Choose an action for this item")
}

// Item-driven (shows item name in title)
.confirmationDialog(
    item: $selectedItem
) { item in
    Button("Delete \\(item.name)", role: .destructive) {
        delete(item)
    }
    Button("Cancel", role: .cancel) { }
} message: { item in
    Text("Action for \\(item.name)")
}
""")
        }
    }
}
