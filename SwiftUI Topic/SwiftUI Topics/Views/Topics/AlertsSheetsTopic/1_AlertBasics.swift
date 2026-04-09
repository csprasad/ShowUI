//
//
//  1_AlertBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: Alert Basics
struct AlertBasicsVisual: View {
    @State private var showBasic         = false
    @State private var showMessage       = false
    @State private var showDestructive   = false
    @State private var showTextField     = false
    @State private var inputText         = ""
    @State private var lastAction        = "None"
    @State private var selectedDemo      = 0

    let demos = ["Single button", "Multiple buttons", "With input"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Alert basics", systemImage: "exclamationmark.triangle.fill")
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

                switch selectedDemo {
                case 0:
                    // Single + destructive
                    VStack(spacing: 10) {
                        alertButton("OK only alert") { showBasic = true }
                            .alert("Something happened", isPresented: $showBasic) {
                                Button("OK") { lastAction = "Tapped OK" }
                            } message: {
                                Text("This is the message body. Keep it short and clear.")
                            }

                        alertButton("Destructive alert", color: .animCoral) { showDestructive = true }
                            .alert("Delete this item?", isPresented: $showDestructive) {
                                Button("Delete", role: .destructive) { lastAction = "Deleted!" }
                                Button("Cancel", role: .cancel) { lastAction = "Cancelled" }
                            } message: {
                                Text("This action cannot be undone.")
                            }
                    }

                case 1:
                    // Multiple buttons
                    alertButton("3-button alert") { showMessage = true }
                        .alert("Save changes?", isPresented: $showMessage) {
                            Button("Save") { lastAction = "Saved" }
                            Button("Don't Save", role: .destructive) { lastAction = "Discarded" }
                            Button("Cancel", role: .cancel) { lastAction = "Cancelled" }
                        } message: {
                            Text("You have unsaved changes. What would you like to do?")
                        }

                default:
                    // With text field
                    alertButton("Alert with TextField") { showTextField = true }
                        .alert("Rename Item", isPresented: $showTextField) {
                            TextField("New name", text: $inputText)
                            Button("Rename") { lastAction = "Renamed to: \(inputText)" }
                            Button("Cancel", role: .cancel) { lastAction = "Cancelled" }
                        } message: {
                            Text("Enter a new name for this item.")
                        }
                }

                // Result display
                actionLog(lastAction)
            }
        }
    }

    func alertButton(_ title: String, color: Color = .asRed, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 14))
                Text(title).font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 12)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PressableButtonStyle())
    }

    func actionLog(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "return").font(.system(size: 12)).foregroundStyle(Color.asRed)
            Text("Last action: \(text)").font(.system(size: 12)).foregroundStyle(.secondary)
            Spacer()
        }
        .padding(10).background(Color.asRedLight).clipShape(RoundedRectangle(cornerRadius: 10))
        .animation(.easeInOut(duration: 0.2), value: text)
    }
}

struct AlertBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Alert")
            Text(".alert presents the system alert dialog. SwiftUI handles layout, animation, and button styling automatically. You provide the title, optional message, and buttons. Button roles control appearance - .destructive is red, .cancel is bold.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".alert(title, isPresented: $bool) - simplest form. Set bool to true to present.", color: .asRed)
                StepRow(number: 2, text: "{ } after isPresented: - button builder. Add Button views here.", color: .asRed)
                StepRow(number: 3, text: "message: { Text(\"...\") } - optional description shown below the title.", color: .asRed)
                StepRow(number: 4, text: "Button(role: .destructive) - red tinted. Button(role: .cancel) - bold, dismisses on tap outside.", color: .asRed)
                StepRow(number: 5, text: "TextField inside the button builder adds an editable field to the alert (iOS 16+).", color: .asRed)
            }

            CalloutBox(style: .warning, title: "Attach to a stable view", contentBody: ".alert must be attached to a view that stays in the hierarchy. Don't attach it to a view inside a conditional or ForEach row - it may be dismissed unexpectedly when the anchor view disappears.")

            CalloutBox(style: .info, title: "Alert with item binding", contentBody: ".alert(item: $selectedItem) presents when item is non-nil and dismisses when nil. The alert closure receives the unwrapped item - useful for showing item-specific alerts like 'Delete «Alice»?'")

            CodeBlock(code: """
// Simple alert
.alert("Title", isPresented: $showAlert) {
    Button("OK") { }
} message: {
    Text("Description")
}

// Destructive + cancel
.alert("Delete?", isPresented: $showDelete) {
    Button("Delete", role: .destructive) { delete() }
    Button("Cancel", role: .cancel) { }
} message: {
    Text("This cannot be undone.")
}

// Alert with text input
@State private var name = ""
.alert("Rename", isPresented: $showRename) {
    TextField("New name", text: $name)
    Button("OK") { rename(to: name) }
    Button("Cancel", role: .cancel) { }
}

// Item-driven alert
.alert(item: $selectedItem) { item in
    Alert(title: Text("Delete \\(item.name)?"),
          primaryButton: .destructive(Text("Delete")) { delete(item) },
          secondaryButton: .cancel())
}
""")
        }
    }
}
