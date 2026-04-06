//
//
//  6_Validation.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Form Validation
struct FormValidationVisual: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var submitted = false
    @State private var showSuccess = false
    @FocusState private var focus: ValidField?

    enum ValidField: Hashable { case name, email, password, confirm }

    var nameError: String? {
        guard submitted || !name.isEmpty else { return nil }
        if name.isEmpty { return "Name is required" }
        if name.count < 2 { return "At least 2 characters" }
        return nil
    }

    var emailError: String? {
        guard submitted || !email.isEmpty else { return nil }
        if email.isEmpty { return "Email is required" }
        if !email.contains("@") || !email.contains(".") { return "Enter a valid email" }
        return nil
    }

    var passwordError: String? {
        guard submitted || !password.isEmpty else { return nil }
        if password.isEmpty { return "Password is required" }
        if password.count < 8 { return "At least 8 characters" }
        return nil
    }

    var confirmError: String? {
        guard submitted || !confirmPassword.isEmpty else { return nil }
        if confirmPassword.isEmpty { return "Please confirm password" }
        if confirmPassword != password { return "Passwords don't match" }
        return nil
    }

    var isValid: Bool {
        nameError == nil && emailError == nil && passwordError == nil && confirmError == nil
            && !name.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Form validation", systemImage: "checkmark.shield.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.formGreen)

                if showSuccess {
                    successBanner
                } else {
                    VStack(spacing: 8) {
                        validatedField("Name", placeholder: "Full name", text: $name,
                                       error: nameError, field: .name, next: .email)
                        validatedField("Email", placeholder: "email@example.com", text: $email,
                                       error: emailError, field: .email, next: .password,
                                       keyboard: .emailAddress)
                        validatedField("Password", placeholder: "8+ characters", text: $password,
                                       error: passwordError, field: .password, next: .confirm,
                                       isSecure: true)
                        validatedField("Confirm", placeholder: "Repeat password", text: $confirmPassword,
                                       error: confirmError, field: .confirm, next: nil,
                                       isSecure: true)
                    }

                    // Strength indicator
                    if !password.isEmpty {
                        passwordStrength
                    }

                    // Submit button
                    Button {
                        submitted = true
                        if isValid { withAnimation(.spring(response: 0.4)) { showSuccess = true } }
                    } label: {
                        HStack(spacing: 8) {
                            if isValid {
                                Image(systemName: "checkmark.circle.fill").font(.system(size: 14))
                            }
                            Text(isValid ? "Create Account" : "Continue")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 13)
                        .background(isValid ? Color.formGreen : Color(.systemGray3))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(PressableButtonStyle())
                    .animation(.spring(response: 0.3), value: isValid)
                }
            }
        }
    }

    private var successBanner: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48)).foregroundStyle(Color.formGreen)
            Text("Account created!").font(.system(size: 18, weight: .bold))
            Button("Try again") {
                withAnimation(.spring(response: 0.4)) {
                    showSuccess = false; submitted = false
                    name = ""; email = ""; password = ""; confirmPassword = ""
                }
            }
            .font(.system(size: 14)).foregroundStyle(Color.formGreen)
            .buttonStyle(PressableButtonStyle())
        }
        .frame(maxWidth: .infinity).padding(.vertical, 20)
    }

    private var passwordStrength: some View {
        let strength = passwordStrengthScore(password)
        let colors: [Color] = [.animCoral, .animAmber, .animTeal, .formGreen]
        let labels = ["Weak", "Fair", "Good", "Strong"]

        return VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                ForEach(0..<4, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(i < strength ? colors[strength - 1] : Color(.systemFill))
                        .frame(maxWidth: .infinity).frame(height: 4)
                        .animation(.spring(response: 0.3), value: strength)
                }
            }
            Text(labels[max(0, strength - 1)])
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(strength > 0 ? colors[strength - 1] : .secondary)
        }
    }

    func passwordStrengthScore(_ pwd: String) -> Int {
        var score = 0
        if pwd.count >= 8 { score += 1 }
        if pwd.range(of: "[A-Z]", options: .regularExpression) != nil { score += 1 }
        if pwd.range(of: "[0-9]", options: .regularExpression) != nil { score += 1 }
        if pwd.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil { score += 1 }
        return score
    }

    func validatedField(_ label: String, placeholder: String, text: Binding<String>,
                         error: String?, field: ValidField, next: ValidField?,
                         isSecure: Bool = false, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 10) {
                Text(label)
                    .font(.system(size: 13))
                    .foregroundStyle(error != nil ? Color.animCoral : .secondary)
                    .frame(width: 60, alignment: .leading)
                if isSecure {
                    SecureField(placeholder, text: text)
                        .font(.system(size: 13))
                        .focused($focus, equals: field)
                } else {
                    TextField(placeholder, text: text)
                        .font(.system(size: 13))
                        .keyboardType(keyboard)
                        .textInputAutocapitalization(keyboard == .emailAddress ? .never : .sentences)
                        .focused($focus, equals: field)
                }
                if let error, !error.isEmpty {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 14)).foregroundStyle(Color.animCoral)
                } else if !text.wrappedValue.isEmpty {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14)).foregroundStyle(Color.formGreen)
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 9)
            .background(
                error != nil ? Color.animCoral.opacity(0.06) :
                !text.wrappedValue.isEmpty ? Color.formGreenLight.opacity(0.6) :
                Color(.systemBackground)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(
                error != nil ? Color.animCoral.opacity(0.4) :
                focus == field ? Color.formGreen.opacity(0.4) : Color.clear, lineWidth: 1.5))
            .animation(.spring(response: 0.25), value: error)
            .onSubmit { if let next { focus = next } else { focus = nil } }

            if let error {
                Text(error)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Color.animCoral)
                    .padding(.leading, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

struct FormValidationExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Form validation")
            Text("Good form validation shows errors at the right time - not on every keystroke, but after the user has had a chance to fill in the field. The standard pattern: validate on submit first, then on every change after that.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Derive error messages as computed properties from @State - never store errors in separate @State vars.", color: .formGreen)
                StepRow(number: 2, text: "Show errors only after the user has interacted - use a 'submitted' flag to control when validation is visible.", color: .formGreen)
                StepRow(number: 3, text: "Disable the submit button until isValid - prevent submission of incomplete data.", color: .formGreen)
                StepRow(number: 4, text: "Show inline success indicators (green checkmarks) alongside errors - reward correct input.", color: .formGreen)
                StepRow(number: 5, text: ".transition(.opacity) on error messages - animate them in/out smoothly.", color: .formGreen)
            }

            CalloutBox(style: .success, title: "Derived errors never go stale", contentBody: "Computing errors as var nameError: String? { } means they always reflect the current state. If you stored errors in @State and forgot to update them, they'd show stale messages. Computed properties are always current.")

            CalloutBox(style: .warning, title: "Don't validate on every keystroke", contentBody: "Showing 'Email is invalid' while the user is still typing 'alice@' is frustrating. Only show errors after the field has been touched (focus has moved away) or after the first submit attempt.")

            CodeBlock(code: """
@State private var email = ""
@State private var submitted = false

// Derived - never stale
var emailError: String? {
    // Only show after first submit or after user typed something
    guard submitted || !email.isEmpty else { return nil }
    if email.isEmpty { return "Required" }
    if !email.contains("@") { return "Invalid email" }
    return nil
}

var isValid: Bool {
    emailError == nil && !email.isEmpty
}

// Field with inline error
VStack(alignment: .leading) {
    TextField("Email", text: $email)
        .border(emailError != nil ? Color.red : Color.clear)

    if let error = emailError {
        Text(error)
            .foregroundStyle(.red)
            .font(.caption)
            .transition(.opacity)
    }
}
.animation(.easeInOut, value: emailError)

// Disabled submit
Button("Submit") { submitted = true }
    .disabled(!isValid)
""")
        }
    }
}
