//
//
//  6_ReturnKey.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Return Key & Submit

struct ReturnKeyVisual: View {
    enum Field: Int, Hashable, CaseIterable {
        case firstName, lastName, email, password
        var label: String {
            switch self {
            case .firstName: return "First name"
            case .lastName:  return "Last name"
            case .email:     return "Email"
            case .password:  return "Password"
            }
        }
        var submitLabel: SubmitLabel {
            switch self {
            case .firstName, .lastName, .email: return .next
            case .password: return .join
            }
        }
        var next: Field? {
            Field(rawValue: rawValue + 1)
        }
    }

    @FocusState private var focused: Field?
    @State private var values: [Field: String] = [:]
    @State private var submitted = false

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {
                Label("Return key & submit", systemImage: "return")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#185FA5"))

                if submitted {
                    VStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(Color(hex: "#1D9E75"))
                        Text("Form submitted!")
                            .font(.system(size: 16, weight: .semibold))
                        Text("onSubmit fired on the last field")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                        Button("Reset") {
                            withAnimation { submitted = false; values = [:] }
                            focused = .firstName
                        }
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(hex: "#185FA5"))
                        .buttonStyle(PressableButtonStyle())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .transition(.opacity.combined(with: .scale))
                } else {
                    VStack(spacing: 10) {
                        ForEach(Field.allCases, id: \.self) { field in
                            submitField(field)
                        }
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                        Text("Return key label changes per field. Last field shows 'Join'.")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .onAppear { focused = .firstName }
    }

    func submitField(_ field: Field) -> some View {
        let isFocused = focused == field
        let binding = Binding(
            get: { values[field] ?? "" },
            set: { values[field] = $0 }
        )
        return HStack(spacing: 10) {
            // Return key label badge — use field position instead of comparing SubmitLabel
               Text(field == .password ? "join" : "next")
                   .font(.system(size: 9, weight: .semibold, design: .monospaced))
                   .foregroundStyle(isFocused ? Color(hex: "#185FA5") : Color(.tertiaryLabel))
                   .padding(.horizontal, 6)
                   .padding(.vertical, 3)
                   .background(
                       Capsule().fill(isFocused
                           ? Color(hex: "#E6F1FB")
                           : Color(.systemFill))
                   )

            if field == .password {
                SecureField(field.label, text: binding)
                    .focused($focused, equals: field)
                    .submitLabel(field.submitLabel)
                    .onSubmit { handleSubmit(field) }
            } else {
                TextField(field.label, text: binding)
                    .focused($focused, equals: field)
                    .submitLabel(field.submitLabel)
                    .onSubmit { handleSubmit(field) }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(field == .email ? .never : .words)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(
            isFocused ? Color(hex: "#185FA5") : Color(.systemFill),
            lineWidth: isFocused ? 1.5 : 0.5
        ))
        .animation(.easeInOut(duration: 0.15), value: isFocused)
    }

    func handleSubmit(_ field: Field) {
        if let next = field.next {
            focused = next
        } else {
            focused = nil
            withAnimation(.spring()) { submitted = true }
        }
    }
}

struct ReturnKeyExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Return key labels and submit")
            Text("submitLabel sets what the Return key says. onSubmit fires when Return is tapped. Together they let you build a form that auto-advances from field to field and submits at the end.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Add .submitLabel(.next) on intermediate fields — the key reads 'Next'.", color: Color(hex: "#185FA5"))
                StepRow(number: 2, text: "Add .submitLabel(.done) or .join on the last field.", color: Color(hex: "#185FA5"))
                StepRow(number: 3, text: "In onSubmit, advance focus to the next field, or set it to nil and call your submit function.", color: Color(hex: "#185FA5"))
            }

            CalloutBox(style: .info, title: "Available submit labels", contentBody: ".done, .go, .join, .next, .return, .route, .search, .send — each changes the Return key text without affecting behaviour.")

            CalloutBox(style: .success, title: "The full pattern", contentBody: "submitLabel + onSubmit + @FocusState together give you a fully keyboard-navigable form — no Done buttons needed on most fields.")

            CodeBlock(code: """
@FocusState private var focused: Field?

TextField("First name", text: $firstName)
    .focused($focused, equals: .firstName)
    .submitLabel(.next)
    .onSubmit { focused = .lastName }

TextField("Last name", text: $lastName)
    .focused($focused, equals: .lastName)
    .submitLabel(.next)
    .onSubmit { focused = .email }

SecureField("Password", text: $password)
    .focused($focused, equals: .password)
    .submitLabel(.join)
    .onSubmit { submitForm() }
""")
        }
    }
}

