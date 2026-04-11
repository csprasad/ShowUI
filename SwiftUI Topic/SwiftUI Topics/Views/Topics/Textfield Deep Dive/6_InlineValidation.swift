//
//
//  6_InlineValidation.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Inline Validation
struct InlineValidationVisual: View {
    @State private var name     = ""
    @State private var email    = ""
    @State private var phone    = ""
    @State private var website  = ""
    @State private var touched: Set<String> = []
    @State private var submitted = false
    @State private var selectedDemo = 0
    @FocusState private var focusedField: String?
    let demos = ["Live errors", "Debounced", "Submit state"]

    var nameError: String? {
        guard shouldShow("name") else { return nil }
        if name.isEmpty { return "Name is required" }
        if name.count < 2 { return "Too short - at least 2 characters" }
        if name.count > 50 { return "Too long - max 50 characters" }
        return nil
    }
    var emailError: String? {
        guard shouldShow("email") else { return nil }
        if email.isEmpty { return "Email is required" }
        if !email.contains("@") { return "Must contain @" }
        if !email.contains(".") { return "Must contain a domain" }
        return nil
    }
    var phoneError: String? {
        guard shouldShow("phone") else { return nil }
        if phone.isEmpty { return nil }
        let digits = phone.filter { $0.isNumber }
        if digits.count < 7 { return "Too short - minimum 7 digits" }
        return nil
    }
    var websiteError: String? {
        guard shouldShow("website") else { return nil }
        if website.isEmpty { return nil }
        if !website.hasPrefix("https://") && !website.hasPrefix("http://") { return "Must start with https:// or http://" }
        return nil
    }

    func shouldShow(_ field: String) -> Bool { submitted || touched.contains(field) }
    var isFormValid: Bool { nameError == nil && emailError == nil && phoneError == nil && websiteError == nil && !name.isEmpty && !email.isEmpty }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Inline validation", systemImage: "checkmark.shield.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tfOrange)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; touched = []; submitted = false }
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
                    // Live validation
                    VStack(spacing: 8) {
                        validatedField("Name", id: "name", text: $name, error: nameError, placeholder: "Full name", keyboard: .namePhonePad)
                        validatedField("Email", id: "email", text: $email, error: emailError, placeholder: "user@example.com", keyboard: .emailAddress)
                        validatedField("Phone", id: "phone", text: $phone, error: phoneError, placeholder: "Optional", keyboard: .phonePad)
                        validatedField("Website", id: "website", text: $website, error: websiteError, placeholder: "https://", keyboard: .URL)
                    }

                case 1:
                    // Show-on-blur behaviour
                    VStack(spacing: 8) {
                        validatedField("Name", id: "name", text: $name, error: nameError, placeholder: "Full name - error shows on blur")
                        validatedField("Email", id: "email", text: $email, error: emailError, placeholder: "email - error shows on blur", keyboard: .emailAddress)
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.tfOrange)
                            Text("Errors appear after you leave a field (blur) - not while typing")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tfOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // Submit reveals all
                    VStack(spacing: 8) {
                        validatedField("Name", id: "name", text: $name, error: nameError, placeholder: "Full name")
                        validatedField("Email", id: "email", text: $email, error: emailError, placeholder: "user@example.com", keyboard: .emailAddress)

                        Button {
                            submitted = true
                            withAnimation(.spring(response: 0.3)) {}
                        } label: {
                            HStack(spacing: 8) {
                                if isFormValid && submitted {
                                    Image(systemName: "checkmark.circle.fill").font(.system(size: 15))
                                }
                                Text(isFormValid && submitted ? "Form is valid ✓" : "Submit")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 12)
                            .background(submitted && isFormValid ? Color.formGreen : submitted ? Color.animCoral : Color.tfOrange)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressableButtonStyle())
                        .animation(.spring(response: 0.3), value: submitted)

                        if submitted && !isFormValid {
                            Label("Fix the errors above", systemImage: "exclamationmark.triangle.fill")
                                .font(.system(size: 11, weight: .medium)).foregroundStyle(Color.animCoral)
                                .transition(.opacity)
                        }
                    }
                    .animation(.spring(response: 0.3), value: submitted)
                }
            }
        }
    }

    func validatedField(_ label: String, id: String, text: Binding<String>, error: String?, placeholder: String, keyboard: UIKeyboardType = .default) -> some View {
        let hasError    = error != nil
        let hasValue    = !text.wrappedValue.isEmpty
        let showSuccess = shouldShow(id) && !hasError && hasValue

        return VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 10) {
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(hasError ? Color.animCoral : .secondary)
                    .frame(width: 50, alignment: .leading)
                TextField(placeholder, text: text)
                    .font(.system(size: 13))
                    .keyboardType(keyboard)
                    .textInputAutocapitalization(keyboard == .emailAddress || keyboard == .URL ? .never : .words)
                    .focused($focusedField, equals: id)
                    .onChange(of: focusedField) { _, new in
                        if new != id { touched.insert(id) }
                    }
                if showSuccess {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 14)).foregroundStyle(Color.formGreen)
                } else if hasError {
                    Image(systemName: "exclamationmark.circle.fill").font(.system(size: 14)).foregroundStyle(Color.animCoral)
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 10)
            .background(
                hasError ? Color.animCoral.opacity(0.06) :
                showSuccess ? Color.formGreen.opacity(0.06) : Color(.systemFill)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(
                    hasError ? Color.animCoral.opacity(0.5) :
                    focusedField == id ? Color.tfOrange.opacity(0.4) : Color.clear,
                    lineWidth: 1.5
                )
            )
            .animation(.spring(response: 0.25), value: hasError)

            if let error {
                Text(error)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Color.animCoral)
                    .padding(.leading, 64)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

struct InlineValidationExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Inline validation")
            Text("Good inline validation strikes a balance - don't show errors while the user is still typing, but show them promptly when they leave a field. Computed error properties guarantee errors are always fresh.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Derived errors: var emailError: String? { … } - computed, never stale.", color: .tfOrange)
                StepRow(number: 2, text: "Show-on-blur: add field id to touched Set in .onChange(of: focusedField) when focus leaves.", color: .tfOrange)
                StepRow(number: 3, text: "Show-on-submit: a submitted Bool flag - set true on button tap, show all errors at once.", color: .tfOrange)
                StepRow(number: 4, text: "Visual: red border + red background tint + error label below. Green tint + checkmark on valid.", color: .tfOrange)
                StepRow(number: 5, text: ".animation on the error message - .transition(.opacity.combined(with: .move)) for smooth appear.", color: .tfOrange)
            }

            CalloutBox(style: .success, title: "Computed properties for errors", contentBody: "Store validation rules in computed var properties, not @State. They recompute on every render with the latest values - no risk of stale or out-of-sync error messages.")

            CodeBlock(code: """
@State private var email = ""
@State private var touched = Set<String>()
@State private var submitted = false

var emailError: String? {
    guard submitted || touched.contains("email") else { return nil }
    if email.isEmpty { return "Required" }
    if !email.contains("@") { return "Invalid email" }
    return nil
}

// Mark as touched on focus-out
.focused($focus, equals: .email)
.onChange(of: focus) { _, new in
    if new != .email { touched.insert("email") }
}

// Field UI
VStack(alignment: .leading) {
    TextField("Email", text: $email)
        .border(emailError != nil ? Color.red : Color.clear)

    if let error = emailError {
        Text(error)
            .font(.caption)
            .foregroundStyle(.red)
            .transition(.opacity)
    }
}
.animation(.easeInOut, value: emailError != nil)
""")
        }
    }
}

