//
//
//  4_TextField.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: TextField in Forms
struct FormTextFieldVisual: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var bio = ""
    @State private var amount = ""
    @State private var selectedDemo = 0
    @FocusState private var focusedField: FormField?

    enum FormField: Hashable { case name, email, password, bio, amount }

    let demos = ["Basic fields", "Secure & axis", "Format & focus"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("TextField in forms", systemImage: "text.cursor")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.formGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.formGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.formGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Basic text fields in form-style
                    VStack(spacing: 0) {
                        fieldRow("Name", placeholder: "Your full name", text: $name, field: .name)
                        Divider().padding(.leading, 16)
                        fieldRow("Email", placeholder: "email@example.com", text: $email, field: .email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        Divider().padding(.leading, 16)
                        fieldRow("Password", placeholder: "••••••••", text: $password, field: .password, isSecure: true)
                    }
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                case 1:
                    VStack(spacing: 10) {
                        // SecureField
                        VStack(alignment: .leading, spacing: 6) {
                            Text("SecureField - hides text").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            HStack(spacing: 10) {
                                Image(systemName: "lock.fill").foregroundStyle(Color.formGreen).frame(width: 20)
                                SecureField("Password", text: $password)
                                    .font(.system(size: 14))
                            }
                            .padding(10).background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black.opacity(0.04), radius: 3)
                        }

                        // Multi-line axis
                        VStack(alignment: .leading, spacing: 6) {
                            Text("axis: .vertical - grows with content").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            TextField("Tell us about yourself...", text: $bio, axis: .vertical)
                                .font(.system(size: 14))
                                .lineLimit(2...5)
                                .padding(10)
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: .black.opacity(0.04), radius: 3)
                            Text("\(bio.count) characters").font(.system(size: 10)).foregroundStyle(.secondary)
                        }
                    }

                default:
                    VStack(spacing: 10) {
                        // Currency format
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Formatted - currency input").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            HStack(spacing: 8) {
                                Text("$").font(.system(size: 16, weight: .semibold)).foregroundStyle(Color.formGreen)
                                TextField("0.00", text: $amount)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 16))
                                    .focused($focusedField, equals: .amount)
                            }
                            .padding(10)
                            .background(focusedField == .amount ? Color.formGreenLight : Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(focusedField == .amount ? Color.formGreen : Color.clear, lineWidth: 1.5))
                            .shadow(color: .black.opacity(0.04), radius: 3)
                            .animation(.spring(response: 0.25), value: focusedField == .amount)
                        }

                        // Focus chain
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Focus chain - Tab/Return moves focus").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            VStack(spacing: 6) {
                                focusableField("Name", text: $name, field: .name, next: .email)
                                focusableField("Email", text: $email, field: .email, next: .name)
                            }
                        }
                    }
                }
            }
        }
    }

    func fieldRow(_ label: String, placeholder: String, text: Binding<String>, field: FormField, isSecure: Bool = false) -> some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.system(size: 14))
                .frame(width: 70, alignment: .leading)
            if isSecure {
                SecureField(placeholder, text: text)
                    .font(.system(size: 14))
                    .focused($focusedField, equals: field)
            } else {
                TextField(placeholder, text: text)
                    .font(.system(size: 14))
                    .focused($focusedField, equals: field)
            }
        }
        .padding(.horizontal, 14).padding(.vertical, 10)
        .onTapGesture { focusedField = field }
    }

    func focusableField(_ label: String, text: Binding<String>, field: FormField, next: FormField) -> some View {
        HStack(spacing: 8) {
            Text(label).font(.system(size: 13)).foregroundStyle(.secondary).frame(width: 40)
            TextField(label, text: text)
                .font(.system(size: 13))
                .focused($focusedField, equals: field)
                .submitLabel(.next)
                .onSubmit { focusedField = next }
        }
        .padding(8)
        .background(focusedField == field ? Color.formGreenLight : Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(focusedField == field ? Color.formGreen : Color.clear, lineWidth: 1.5))
        .animation(.spring(response: 0.25), value: focusedField == field)
        .onTapGesture { focusedField = field }
    }
}

struct FormTextFieldExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "TextField in forms")
            Text("TextField in a form context needs careful handling - prompt text, keyboard type, auto-capitalization, return key behavior, and focus management all affect the user experience significantly.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "TextField(\"Prompt\", text: $value) - label acts as placeholder when empty.", color: .formGreen)
                StepRow(number: 2, text: "TextField(\"...\", text: $value, axis: .vertical) - grows vertically. Combine with .lineLimit(2...5).", color: .formGreen)
                StepRow(number: 3, text: "SecureField(\"Password\", text: $pass) - dots input, no autocomplete.", color: .formGreen)
                StepRow(number: 4, text: "@FocusState var focused: Field? - programmatically move focus. .focused($focused, equals: .email).", color: .formGreen)
                StepRow(number: 5, text: ".submitLabel(.next/.done) - changes the Return key label. .onSubmit { } fires on Return.", color: .formGreen)
            }

            CalloutBox(style: .success, title: "Focus chain for smooth UX", contentBody: "Set up a @FocusState enum and .onSubmit { focusedField = .next } to advance through form fields on Return. This matches the expected iOS behavior and makes forms feel native.")

            CodeBlock(code: """
enum Field: Hashable { case name, email, password }
@FocusState private var focus: Field?

VStack {
    TextField("Name", text: $name)
        .focused($focus, equals: .name)
        .submitLabel(.next)
        .onSubmit { focus = .email }

    TextField("Email", text: $email)
        .focused($focus, equals: .email)
        .keyboardType(.emailAddress)
        .textInputAutocapitalization(.never)
        .submitLabel(.next)
        .onSubmit { focus = .password }

    SecureField("Password", text: $password)
        .focused($focus, equals: .password)
        .submitLabel(.done)
        .onSubmit { submitForm() }
}
.onAppear { focus = .name }   // auto-focus first field

// Multiline
TextField("Bio", text: $bio, axis: .vertical)
    .lineLimit(3...8)

// Formatted - currency
TextField("Amount", value: $amount,
          format: .currency(code: "USD"))
    .keyboardType(.decimalPad)
""")
        }
    }
}
