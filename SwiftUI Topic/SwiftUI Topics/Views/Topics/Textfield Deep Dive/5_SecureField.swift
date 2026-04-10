//
//
//  5_SecureField.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: SecureField
struct SecureFieldVisual: View {
    @State private var password     = ""
    @State private var confirm      = ""
    @State private var showPassword = false
    @State private var selectedDemo = 0
    @FocusState private var pwFocus: Bool
    @FocusState private var cfFocus: Bool

    let demos = ["Show/hide toggle", "Strength meter", "Confirmation"]

    var strength: Int {
        var s = 0
        if password.count >= 8      { s += 1 }
        if password.range(of: "[A-Z]", options: .regularExpression) != nil { s += 1 }
        if password.range(of: "[0-9]", options: .regularExpression) != nil { s += 1 }
        if password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil { s += 1 }
        return s
    }

    var strengthLabel: String { ["", "Weak", "Fair", "Good", "Strong"][min(strength, 4)] }
    var strengthColor: Color  { [Color.secondary, .animCoral, .animAmber, .navBlue, .formGreen][min(strength, 4)] }
    var passwordsMatch: Bool  { !confirm.isEmpty && password == confirm }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("SecureField", systemImage: "lock.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tfOrange)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
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
                    // Show/hide toggle
                    VStack(spacing: 10) {
                        ZStack(alignment: .trailing) {
                            Group {
                                if showPassword {
                                    TextField("Password", text: $password)
                                        .focused($pwFocus)
                                } else {
                                    SecureField("Password", text: $password)
                                        .focused($pwFocus)
                                }
                            }
                            .textContentType(.password)
                            .padding(.horizontal, 12).padding(.trailing, 44).padding(.vertical, 11)
                            .background(Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                            Button {
                                showPassword.toggle()
                                pwFocus = true
                            } label: {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.secondary)
                                    .frame(width: 44, height: 44)
                            }
                            .buttonStyle(PressableButtonStyle())
                        }

                        HStack(spacing: 8) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundStyle(Color.tfOrange).font(.system(size: 12))
                            Text(showPassword ? "Showing plain text" : "Password hidden (dots)")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tfOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
                        .animation(.easeInOut(duration: 0.2), value: showPassword)

                        // Note about focus preservation
                        Text("Tip: retain focus when toggling by setting focus = true after the state change.")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }

                case 1:
                    // Strength meter
                    VStack(spacing: 10) {
                        ZStack(alignment: .trailing) {
                            Group {
                                if showPassword {
                                    TextField("Create password", text: $password)
                                } else {
                                    SecureField("Create password", text: $password)
                                }
                            }
                            .padding(.horizontal, 12).padding(.trailing, 44).padding(.vertical, 11)
                            .background(Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                            Button { showPassword.toggle() } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundStyle(.secondary).frame(width: 44, height: 44)
                            }
                            .buttonStyle(PressableButtonStyle())
                        }

                        if !password.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 4) {
                                    ForEach(0..<4, id: \.self) { i in
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(i < strength ? strengthColor : Color(.systemFill))
                                            .frame(maxWidth: .infinity).frame(height: 5)
                                            .animation(.spring(response: 0.3), value: strength)
                                    }
                                }
                                HStack {
                                    Text(strengthLabel)
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundStyle(strengthColor)
                                    Spacer()
                                    Text("\(password.count) chars")
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            requirementRow("8+ characters",      met: password.count >= 8)
                            requirementRow("Uppercase letter",   met: password.range(of: "[A-Z]", options: .regularExpression) != nil)
                            requirementRow("Number",             met: password.range(of: "[0-9]", options: .regularExpression) != nil)
                            requirementRow("Special character",  met: password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil)
                        }
                        .animation(.easeInOut(duration: 0.2), value: strength)
                    }

                default:
                    // Confirmation
                    VStack(spacing: 8) {
                        ZStack(alignment: .trailing) {
                            SecureField("New password", text: $password)
                                .focused($pwFocus)
                                .padding(.horizontal, 12).padding(.vertical, 11)
                                .background(Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            if !password.isEmpty {
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(Color.tfOrange)
                                    .frame(width: 44, height: 44)
                            }
                        }

                        ZStack(alignment: .trailing) {
                            SecureField("Confirm password", text: $confirm)
                                .focused($cfFocus)
                                .padding(.horizontal, 12).padding(.vertical, 11)
                                .background(!confirm.isEmpty && !passwordsMatch ? Color(hex: "#FCEBEB") : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(!confirm.isEmpty && !passwordsMatch ? Color.animCoral.opacity(0.5) : Color.clear, lineWidth: 1.5)
                                )
                                .animation(.spring(response: 0.25), value: passwordsMatch)

                            if !confirm.isEmpty {
                                Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(passwordsMatch ? Color.formGreen : Color.animCoral)
                                    .frame(width: 44, height: 44)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }

                        if !confirm.isEmpty && !passwordsMatch {
                            Label("Passwords don't match", systemImage: "exclamationmark.triangle.fill")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(Color.animCoral)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .animation(.spring(response: 0.3), value: passwordsMatch)
                }
            }
        }
    }

    func requirementRow(_ text: String, met: Bool) -> some View {
        HStack(spacing: 6) {
            Image(systemName: met ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 12))
                .foregroundStyle(met ? Color.formGreen : Color(.systemGray3))
            Text(text)
                .font(.system(size: 11))
                .foregroundStyle(met ? .primary : .secondary)
        }
    }
}

struct SecureFieldExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "SecureField")
            Text("SecureField replaces TextField for passwords - it renders dots instead of characters and disables autocomplete. Build show/hide toggle, strength meters, and confirmation matching on top of it.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "SecureField(\"Password\", text: $pass) - same API as TextField but masks input.", color: .tfOrange)
                StepRow(number: 2, text: "Show/hide: swap between SecureField and TextField in an if/else based on showPassword state.", color: .tfOrange)
                StepRow(number: 3, text: "Retain focus when toggling: store @FocusState and set it = true after toggling show/hide.", color: .tfOrange)
                StepRow(number: 4, text: ".textContentType(.password) - existing password autofill. .textContentType(.newPassword) - strong suggestion.", color: .tfOrange)
                StepRow(number: 5, text: "Strength: regex on the password string for uppercase, digits, specials. Display as progress segments.", color: .tfOrange)
            }

            CalloutBox(style: .warning, title: "Focus is lost when swapping field types", contentBody: "SwiftUI treats SecureField and TextField as different views. Switching between them with if/else destroys one and creates the other - focus is lost. Store @FocusState and re-set it to true immediately after the toggle.")

            CodeBlock(code: """
@State private var password = ""
@State private var showPassword = false
@FocusState private var isFocused: Bool

ZStack(alignment: .trailing) {
    Group {
        if showPassword {
            TextField("Password", text: $password)
                .focused($isFocused)
        } else {
            SecureField("Password", text: $password)
                .focused($isFocused)
        }
    }
    .textContentType(.password)
    .padding(.trailing, 44)

    Button {
        showPassword.toggle()
        isFocused = true   // re-focus after swap
    } label: {
        Image(systemName: showPassword ? "eye.slash" : "eye")
    }
}

// Confirmation matching
var passwordsMatch: Bool {
    !confirm.isEmpty && password == confirm
}

SecureField("Confirm", text: $confirm)
    .overlay(
        Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
            .foregroundStyle(passwordsMatch ? .green : .red),
        alignment: .trailing
    )
""")
        }
    }
}
