//
//
//  2-focusmanagement.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Visual
struct FocusManagementVisual: View {
    enum Field: Hashable, CaseIterable {
        case name, email, password
        var label: String {
            switch self { case .name: return "Full name"
                case .email: return "Email"
                case .password: return "Password" }
        }
        var icon: String {
            switch self { case .name: return "person"
                case .email: return "envelope"
                case .password: return "lock" }
        }
        var keyboardType: UIKeyboardType {
            switch self { case .email: return .emailAddress
                default: return .default }
        }
    }

    @FocusState private var focusedField: Field?
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var logLines: [String] = []

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("Focus management", systemImage: "scope")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#185FA5"))
                    Spacer()
                    if focusedField != nil {
                        Button("Dismiss") {
                            focusedField = nil
                            log("Keyboard dismissed")
                        }
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color(hex: "#185FA5"))
                    }
                }

                // Form fields
                VStack(spacing: 10) {
                    ForEach(Field.allCases, id: \.self) { field in
                        focusableField(field)
                    }
                }

                // Jump buttons
                HStack(spacing: 8) {
                    Text("Jump to:")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    ForEach(Field.allCases, id: \.self) { field in
                        Button(field.label) {
                            focusedField = field
                            log("Focus → \(field.label)")
                        }
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(focusedField == field ? Color(hex: "#185FA5") : .secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule().fill(focusedField == field
                                ? Color(hex: "#E6F1FB")
                                : Color(.systemFill))
                        )
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Log
                if !logLines.isEmpty {
                    VStack(alignment: .leading, spacing: 3) {
                        ForEach(logLines.suffix(3), id: \.self) { line in
                            Text(line)
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .transition(.opacity)
                }
            }
        }
        .onChange(of: focusedField) { field, _ in
            if let field { log("Focused: \(field.label)") }
        }
    }

    func focusableField(_ field: Field) -> some View {
        let isFocused = focusedField == field
        let binding: Binding<String> = {
            switch field {
            case .name:     return $name
            case .email:    return $email
            case .password: return $password
            }
        }()

        return HStack(spacing: 10) {
            Image(systemName: field.icon)
                .font(.system(size: 14))
                .foregroundStyle(isFocused ? Color(hex: "#185FA5") : .secondary)
                .frame(width: 20)

            if field == .password {
                SecureField(field.label, text: binding)
                    .focused($focusedField, equals: field)
            } else {
                TextField(field.label, text: binding)
                    .keyboardType(field.keyboardType)
                    .focused($focusedField, equals: field)
                    .autocorrectionDisabled(field == .email)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isFocused ? Color(hex: "#185FA5") : Color(.systemFill),
                    lineWidth: isFocused ? 1.5 : 0.5
                )
        )
        .animation(.easeInOut(duration: 0.15), value: isFocused)
    }

    func log(_ message: String) {
        withAnimation(.easeIn(duration: 0.2)) {
            logLines.append("→ \(message)")
        }
    }
}

// MARK: - Explanation
struct FocusManagementExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "How focus works")
            Text("@FocusState is a property wrapper that tracks which field currently has keyboard focus. Assigning a value programmatically moves focus — and the keyboard — without the user tapping.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Declare an @FocusState var tied to an enum of your fields.", color: Color(hex: "#185FA5"))
                StepRow(number: 2, text: "Attach .focused($focusedField, equals: .name) to each field.", color: Color(hex: "#185FA5"))
                StepRow(number: 3, text: "Set focusedField = .email to move focus programmatically.", color: Color(hex: "#185FA5"))
                StepRow(number: 4, text: "Set focusedField = nil to dismiss the keyboard entirely.", color: Color(hex: "#185FA5"))
            }

            CalloutBox(style: .success, title: "Auto-advance pattern", contentBody: "In a form, set focusedField = .nextField inside onSubmit to move focus forward automatically when the user taps Return.")

            CalloutBox(style: .info, title: "onAppear focus", contentBody: "Set focusedField = .firstField inside onAppear to open the keyboard immediately when a screen appears — common in search screens.")

            CodeBlock(code: """
enum Field: Hashable { case name, email, password }

@FocusState private var focused: Field?

TextField("Name", text: $name)
    .focused($focused, equals: .name)
    .onSubmit { focused = .email }   // advance on Return

TextField("Email", text: $email)
    .focused($focused, equals: .email)
    .onSubmit { focused = .password }

// Dismiss keyboard
Button("Done") { focused = nil }

// Focus on appear
.onAppear { focused = .name }
""")
        }
    }
}
