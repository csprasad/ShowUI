//
//
//  8_programmaticDismiss.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Programmatic Dismiss
struct ProgrammaticDismissVisual: View {
    @State private var showSheet = false
    @State private var showLocked = false
    @State private var selectedDemo = 0
 
    let demos = ["Auto dismiss", "Prevent dismiss", "Conditional"]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Programmatic dismiss", systemImage: "xmark.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sheetGreen)
 
                // Demo selector
                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.sheetGreen : .secondary)
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(selectedDemo == i ? Color.sheetGreenLight : Color(.systemFill))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
 
                // Description
                let descriptions = [
                    "Sheet dismisses automatically after 3 seconds - no user interaction needed",
                    "Sheet cannot be swiped to dismiss - .interactiveDismissDisabled(true)",
                    "Dismiss only allowed after filling a required field - controlled dismiss",
                ]
                Text(descriptions[selectedDemo])
                    .font(.system(size: 12)).foregroundStyle(.secondary)
                    .animation(.easeInOut(duration: 0.2), value: selectedDemo)
 
                Button {
                    showSheet = true
                } label: {
                    Text("Open sheet")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(Color.sheetGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PressableButtonStyle())
                .sheet(isPresented: $showSheet) {
                    switch selectedDemo {
                    case 0: AutoDismissSheet()
                    case 1: LockedSheet()
                    default: ConditionalDismissSheet()
                    }
                }
            }
        }
    }
}
 
struct AutoDismissSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var countdown = 3
 
    var body: some View {
        VStack(spacing: 20) {
            Capsule().fill(Color(.systemFill)).frame(width: 36, height: 5).padding(.top, 8)
            Image(systemName: "timer").font(.system(size: 48)).foregroundStyle(Color.sheetGreen)
            Text("Auto dismiss").font(.system(size: 22, weight: .bold))
            Text("Closing in \(countdown)...")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundStyle(Color.sheetGreen)
                .contentTransition(.numericText(countsDown: true))
                .animation(.spring(duration: 0.3), value: countdown)
            Button("Dismiss now") { dismiss() }
                .buttonStyle(.bordered).tint(.sheetGreen)
            Spacer()
        }
        .presentationDetents([.medium])
        .task {
            for i in stride(from: 3, through: 1, by: -1) {
                countdown = i
                try? await Task.sleep(for: .seconds(1))
            }
            dismiss()
        }
    }
}
 
struct LockedSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var isLocked = true
 
    var body: some View {
        VStack(spacing: 20) {
            Capsule().fill(Color(.systemFill)).frame(width: 36, height: 5).padding(.top, 8)
            Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                .font(.system(size: 48))
                .foregroundStyle(isLocked ? Color.animCoral : Color.sheetGreen)
                .animation(.spring(duration: 0.4, bounce: 0.4), value: isLocked)
            Text(isLocked ? "Swipe-to-dismiss disabled" : "You can now dismiss")
                .font(.system(size: 18, weight: .bold))
            Text(isLocked ? "Tap the button to unlock the sheet" : "Swipe down or tap Close")
                .font(.system(size: 14)).foregroundStyle(.secondary).multilineTextAlignment(.center)
            Button(isLocked ? "Unlock dismiss" : "Close") {
                if isLocked { withAnimation(.spring(duration: 0.4, bounce: 0.3)) { isLocked = false } }
                else { dismiss() }
            }
            .font(.system(size: 15, weight: .semibold)).foregroundStyle(.white)
            .padding(.horizontal, 28).padding(.vertical, 12)
            .background(isLocked ? Color.animCoral : Color.sheetGreen)
            .clipShape(Capsule())
            .buttonStyle(PressableButtonStyle())
            Spacer()
        }
        .presentationDetents([.medium])
        .interactiveDismissDisabled(isLocked)
    }
}
 
struct ConditionalDismissSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    var canDismiss: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }
 
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "person.fill").font(.system(size: 48)).foregroundStyle(Color.sheetGreen)
                Text("Enter your name to continue")
                    .font(.system(size: 18, weight: .bold))
                TextField("Your name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 32)
                if !canDismiss {
                    Text("*Name is required").font(.system(size: 12)).foregroundStyle(.red)
                }
                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("Required field")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .disabled(!canDismiss)
                }
            }
        }
        .presentationDetents([.medium])
        .interactiveDismissDisabled(!canDismiss)
    }
}
 
struct ProgrammaticDismissExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Controlling dismiss")
            Text("SwiftUI gives you full control over when and how a sheet dismisses, whether it's dismissed from inside the sheet, from the parent, or not at all. Use these tools to guide users through flows that shouldn't be interrupted.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "@Environment(\\.dismiss) - call dismiss() from anywhere inside the sheet to close it.", color: .sheetGreen)
                StepRow(number: 2, text: ".interactiveDismissDisabled(true) - prevents swipe-to-dismiss. User must use your dismiss control.", color: .sheetGreen)
                StepRow(number: 3, text: ".interactiveDismissDisabled(!canDismiss) - conditional. Locks the sheet until conditions are met.", color: .sheetGreen)
                StepRow(number: 4, text: "Programmatic dismiss from parent: set the isPresented binding to false or the item binding to nil.", color: .sheetGreen)
            }
 
            CalloutBox(style: .warning, title: "Always provide a way out", contentBody: "If you use .interactiveDismissDisabled(true), you must provide a visible dismiss button. Trapping a user with no escape is a serious UX failure, especially on mobile devices where accidental taps can lead to undesirable behavior. It can also break Store Connect and App Review may reject your app for it.")
 
            CalloutBox(style: .info, title: "onDismiss for cleanup", contentBody: ".sheet(isPresented:onDismiss:) lets you run cleanup code after the sheet closes, regardless of whether dismissed by the user, programmatically, or by losing the anchor view.")
 
            CodeBlock(code: """
// Dismiss from inside
struct SheetView: View {
    @Environment(\\.dismiss) var dismiss
 
    var body: some View {
        Button("Close") { dismiss() }
    }
}
 
// Prevent dismiss
.interactiveDismissDisabled(true)
 
// Conditional dismiss
.interactiveDismissDisabled(!formIsValid)
 
// Dismiss from parent
Button("Close sheet") { isPresented = false }
 
// Auto-dismiss after delay
.task {
    try? await Task.sleep(for: .seconds(3))
    dismiss()
}
 
// Cleanup on dismiss
.sheet(isPresented: $show, onDismiss: {
    clearDraftData()
}) { SheetContent() }
""")
        }
    }
}
