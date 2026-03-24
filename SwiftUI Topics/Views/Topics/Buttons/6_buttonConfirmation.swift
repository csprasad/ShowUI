//
//
//  6_buttonConfirmation.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
 
// MARK: - LESSON 6: Confirmation & Alerts
struct ConfirmationVisual: View {
    @State private var showConfirmation = false
    @State private var showAlert = false
    @State private var showDestructiveAlert = false
    @State private var lastAction = "Nothing yet"
    @State private var itemName = "Project backup.zip"
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Confirmation & alerts", systemImage: "exclamationmark.triangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.btnPurple)
 
                // Last action result
                HStack(spacing: 8) {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .foregroundStyle(.secondary).font(.system(size: 13))
                    Text(lastAction)
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
 
                // confirmationDialog
                Button {
                    showConfirmation = true
                } label: {
                    HStack {
                        Image(systemName: "trash.fill").foregroundStyle(.red)
                        Text("Delete with confirmationDialog")
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.right").foregroundStyle(.secondary).font(.system(size: 12))
                    }
                    .font(.system(size: 14))
                    .padding(14)
                    .background(Color(.systemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PressableButtonStyle())
                .confirmationDialog(
                    "Delete \"\(itemName)\"?",
                    isPresented: $showConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("Delete", role: .destructive) {
                        lastAction = "Deleted \(itemName)"
                    }
                    Button("Move to Trash") {
                        lastAction = "Moved \(itemName) to Trash"
                    }
                    Button("Cancel", role: .cancel) {
                        lastAction = "Cancelled"
                    }
                } message: {
                    Text("This action cannot be undone.")
                }
 
                // Alert
                Button {
                    showAlert = true
                } label: {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill").foregroundStyle(.orange)
                        Text("Show Alert before action")
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.right").foregroundStyle(.secondary).font(.system(size: 12))
                    }
                    .font(.system(size: 14))
                    .padding(14)
                    .background(Color(.systemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PressableButtonStyle())
                .alert("Sign out?", isPresented: $showAlert) {
                    Button("Sign out", role: .destructive) {
                        lastAction = "Signed out"
                    }
                    Button("Cancel", role: .cancel) {
                        lastAction = "Cancelled"
                    }
                } message: {
                    Text("You'll need to sign in again to access your account.")
                }
            }
        }
    }
}
 
struct ConfirmationExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Confirmations before destructive actions")
            Text("Destructive actions, like delete, sign out, cancel subscriptions should always ask for confirmation. SwiftUI provides two tools: .alert for simple yes/no decisions, and .confirmationDialog for multiple options presented as a sheet.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: ".confirmationDialog - presents a bottom sheet with multiple action options. Use when there are 2+ choices.", color: .btnPurple)
                StepRow(number: 2, text: ".alert - presents a centered modal with a title, message and up to 2-3 buttons. Use for simple yes/no.", color: .btnPurple)
                StepRow(number: 3, text: "Always include a Cancel button with role: .cancel, even if it doesn’t do anything. This gives users an escape route.", color: .btnPurple)
                StepRow(number: 4, text: "titleVisibility: .visible shows the dialog title. Default is .automatic which may hide it.", color: .btnPurple)
            }
 
            CalloutBox(style: .info, title: "confirmationDialog vs alert", contentBody: "Use confirmationDialog when you want to offer multiple paths (Delete / Move to Trash / Cancel). Use alert when it's a binary decision (Delete / Cancel) or when you need to communicate an error.")
 
            CalloutBox(style: .warning, title: "Don't confirm everything", contentBody: "Only confirm irreversible or high-stakes actions. Confirmations on low-stakes actions (e.g. 'Are you sure you want to like this?') feel patronising and train users to dismiss without reading.")
 
            CodeBlock(code: """
// confirmationDialog - multiple options as sheet
Button("Delete", role: .destructive) {
    showDialog = true
}
.confirmationDialog(
    "Delete this file?",
    isPresented: $showDialog,
    titleVisibility: .visible
) {
    Button("Delete permanently", role: .destructive) {
        delete()
    }
    Button("Move to Trash") {
        moveToTrash()
    }
    Button("Cancel", role: .cancel) { }
} message: {
    Text("This cannot be undone.")
}
 
// Alert - simple modal
.alert("Sign out?", isPresented: $showAlert) {
    Button("Sign out", role: .destructive) { signOut() }
    Button("Cancel", role: .cancel) { }
} message: {
    Text("You'll need to sign in again.")
}
""")
        }
    }
}
