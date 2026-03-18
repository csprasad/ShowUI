//
//
//  Lessons4to6 .swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Input Validation

struct InputValidationVisual: View {
    @State private var email = ""
    @State private var phone = ""
    @State private var price = ""
    @FocusState private var focused: Int?

    var emailState: ValidationState {
        if email.isEmpty { return .empty }
        return email.contains("@") && email.contains(".") ? .valid : .invalid
    }

    var phoneState: ValidationState {
        let digits = phone.filter { $0.isNumber }
        if phone.isEmpty { return .empty }
        return digits.count >= 10 ? .valid : .invalid
    }

    var priceState: ValidationState {
        if price.isEmpty { return .empty }
        return Double(price) != nil ? .valid : .invalid
    }

    enum ValidationState {
        case empty, valid, invalid
        var color: Color {
            switch self {
            case .empty:   return Color(.systemFill)
            case .valid:   return Color(hex: "#1D9E75")
            case .invalid: return Color(hex: "#E24B4A")
            }
        }
        var icon: String? {
            switch self {
            case .empty:   return nil
            case .valid:   return "checkmark.circle.fill"
            case .invalid: return "xmark.circle.fill"
            }
        }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {
                Label("Input validation", systemImage: "checkmark.shield")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#185FA5"))

                validatedField(
                    label: "Email",
                    placeholder: "you@example.com",
                    text: $email,
                    state: emailState,
                    keyboard: .emailAddress,
                    tag: 0,
                    hint: emailState == .invalid ? "Must contain @ and ." : nil
                )

                validatedField(
                    label: "Phone",
                    placeholder: "+1 (555) 000-0000",
                    text: $phone,
                    state: phoneState,
                    keyboard: .phonePad,
                    tag: 1,
                    hint: phoneState == .invalid ? "Needs at least 10 digits" : nil
                )

                validatedField(
                    label: "Price",
                    placeholder: "0.00",
                    text: $price,
                    state: priceState,
                    keyboard: .decimalPad,
                    tag: 2,
                    hint: priceState == .invalid ? "Numbers only" : nil
                )

                // Submit button — only enabled when all valid
                let allValid = emailState == .valid && phoneState == .valid && priceState == .valid
                Button("Submit") {}
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(allValid ? .white : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(allValid ? Color(hex: "#1D9E75") : Color(.systemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(!allValid)
                    .animation(.easeInOut(duration: 0.2), value: allValid)
                    .buttonStyle(PressableButtonStyle())
            }
        }
    }

    func validatedField(
        label: String,
        placeholder: String,
        text: Binding<String>,
        state: ValidationState,
        keyboard: UIKeyboardType,
        tag: Int,
        hint: String?
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)

            HStack {
                TextField(placeholder, text: text)
                    .keyboardType(keyboard)
                    .focused($focused, equals: tag)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)

                if let icon = state.icon {
                    Image(systemName: icon)
                        .foregroundStyle(state.color)
                        .font(.system(size: 16))
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(12)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(state.color, lineWidth: state == .empty ? 0.5 : 1.5)
            )
            .animation(.easeInOut(duration: 0.2), value: state.color)

            if let hint {
                Text(hint)
                    .font(.system(size: 11))
                    .foregroundStyle(Color(hex: "#E24B4A"))
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: hint)
    }
}

struct InputValidationExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Validating as you type")
            Text("React to text changes in real time using computed properties or onChange. Give users immediate feedback — change border colour, show an icon, and disable the submit button until all fields are valid.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Use a computed property that returns a ValidationState enum from the current text value.", color: Color(hex: "#185FA5"))
                StepRow(number: 2, text: "Drive the field's border colour and trailing icon from that state.", color: Color(hex: "#185FA5"))
                StepRow(number: 3, text: "Disable the submit button until all states are .valid.", color: Color(hex: "#185FA5"))
            }

            CalloutBox(style: .info, title: "Format as you type", contentBody: "Use onChange to reformat input — e.g. insert dashes into a phone number automatically as the user types digits.")

            CodeBlock(code: """
var emailValid: Bool {
    email.contains("@") && email.contains(".")
}

TextField("Email", text: $email)
    .keyboardType(.emailAddress)
    .overlay(alignment: .trailing) {
        if !email.isEmpty {
            Image(systemName: emailValid
                ? "checkmark.circle.fill"
                : "xmark.circle.fill")
            .foregroundStyle(emailValid ? .green : .red)
            .padding(.trailing, 10)
        }
    }

Button("Submit") { submit() }
    .disabled(!emailValid)
""")
        }
    }
}
