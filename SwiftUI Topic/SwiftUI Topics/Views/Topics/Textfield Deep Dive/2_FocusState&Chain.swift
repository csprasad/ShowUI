//
//
//  2_FocusState&Chain.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: FocusState & Focus Chain
enum LoginField: Hashable, CaseIterable {
    case name, email, password, confirm
    var label: String {
        switch self { case .name: "Full name"; case .email: "Email"; case .password: "Password"; case .confirm: "Confirm" }
    }
    var placeholder: String {
        switch self { case .name: "Alice Chen"; case .email: "alice@example.com"; case .password: "8+ characters"; case .confirm: "Repeat password" }
    }
    var icon: String {
        switch self { case .name: "person.fill"; case .email: "envelope.fill"; case .password: "lock.fill"; case .confirm: "lock.fill" }
    }
    var isSecure: Bool { self == .password || self == .confirm }
    var next: LoginField? {
        switch self { case .name: .email; case .email: .password; case .password: .confirm; case .confirm: nil }
    }
    var submitLabel: SubmitLabel {
        next == nil ? .done : .next
    }
}

struct FocusChainVisual: View {
    @FocusState private var focus: LoginField?
    @State private var values: [LoginField: String] = [:]
    @State private var submitted   = false
    @State private var selectedDemo = 0
    let demos = ["Focus chain", "Auto-focus", "Program control"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("FocusState & focus chain", systemImage: "arrow.right.to.line")
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
                    // Full focus chain demo
                    VStack(spacing: 8) {
                        ForEach(LoginField.allCases, id: \.self) { field in
                            focusRow(field)
                        }
                        Button {
                            submitted = true
                            focus = nil
                        } label: {
                            Text(submitted ? "✓ Submitted" : "Submit")
                                .font(.system(size: 14, weight: .semibold)).foregroundStyle(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(submitted ? Color.formGreen : Color.tfOrange)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressableButtonStyle())
                        .animation(.spring(response: 0.3), value: submitted)
                    }

                case 1:
                    // Auto-focus on appear
                    VStack(spacing: 10) {
                        focusRow(.name)
                        Button("Tap to focus email") {
                            withAnimation { focus = .email }
                        }
                        .font(.system(size: 13)).foregroundStyle(Color.tfOrange)
                        .buttonStyle(PressableButtonStyle())
                        focusRow(.email)
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.tfOrange)
                            Text("focus = .email - set @FocusState to programmatically move focus to any field")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tfOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { focus = .name } }

                default:
                    // Focus indicator readout
                    VStack(spacing: 10) {
                        ForEach([LoginField.name, .email], id: \.self) { field in
                            focusRow(field)
                        }
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("focus state").font(.system(size: 10)).foregroundStyle(.secondary)
                                Text(focus.map { $0.label } ?? "nil (no focus)")
                                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                                    .foregroundStyle(focus != nil ? Color.tfOrange : .secondary)
                                    .contentTransition(.opacity)
                                    .animation(.easeInOut(duration: 0.2), value: focus?.label)
                            }
                            Spacer()
                            VStack(spacing: 6) {
                                Button("→ name")  { focus = .name }
                                    .focusControlButton()
                                Button("→ email") { focus = .email }
                                    .focusControlButton()
                                Button("dismiss") { focus = nil }
                                    .focusControlButton(tint: .secondary)
                            }
                        }
                        .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }

    func focusRow(_ field: LoginField) -> some View {
        HStack(spacing: 10) {
            Image(systemName: field.icon)
                .font(.system(size: 14))
                .foregroundStyle(focus == field ? Color.tfOrange : .secondary)
                .frame(width: 20)
            if field.isSecure {
                SecureField(field.placeholder, text: Binding(
                    get: { values[field] ?? "" },
                    set: { values[field] = $0 }
                ))
                .focused($focus, equals: field)
                .submitLabel(field.submitLabel)
                .onSubmit { if let next = field.next { focus = next } else { focus = nil } }
            } else {
                TextField(field.placeholder, text: Binding(
                    get: { values[field] ?? "" },
                    set: { values[field] = $0 }
                ))
                .focused($focus, equals: field)
                .textInputAutocapitalization(field == .email ? .never : .words)
                .submitLabel(field.submitLabel)
                .onSubmit { if let next = field.next { focus = next } else { focus = nil } }
            }
        }
        .padding(.horizontal, 12).padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(focus == field ? Color.tfOrangeLight : Color(.systemFill))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(focus == field ? Color.tfOrange : Color.clear, lineWidth: 1.5)
        )
        .animation(.spring(response: 0.25), value: focus == field)
    }
}

private extension View {
    func focusControlButton(tint: Color = .tfOrange) -> some View {
        self
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(tint)
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(tint.opacity(0.1))
            .clipShape(Capsule())
            .buttonStyle(PressableButtonStyle())
    }
}

struct FocusChainExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "FocusState & focus chain")
            Text("@FocusState tracks which field is active and lets you move focus programmatically. Combined with .onSubmit and .submitLabel, you create a focus chain where tapping the Return key advances through form fields automatically.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@FocusState var focus: MyField? - declare with your field enum or Bool.", color: .tfOrange)
                StepRow(number: 2, text: ".focused($focus, equals: .email) - binds the field to the focus state.", color: .tfOrange)
                StepRow(number: 3, text: ".submitLabel(.next / .done / .search) - changes the Return key label.", color: .tfOrange)
                StepRow(number: 4, text: ".onSubmit { focus = .nextField } - fires when Return is tapped; advance focus.", color: .tfOrange)
                StepRow(number: 5, text: "focus = nil - dismisses the keyboard (no focused field).", color: .tfOrange)
                StepRow(number: 6, text: ".onAppear { focus = .firstField } - auto-focuses the first field when screen appears.", color: .tfOrange)
            }

            CalloutBox(style: .success, title: "Use an enum for multi-field forms", contentBody: "Declare an enum conforming to Hashable for your form fields (case name, email, password) and use it as the FocusState type. Much cleaner than multiple Bool @FocusState properties.")

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
        .submitLabel(.next)
        .onSubmit { focus = .password }

    SecureField("Password", text: $password)
        .focused($focus, equals: .password)
        .submitLabel(.done)
        .onSubmit { focus = nil; submit() }
}
.onAppear { focus = .name }   // auto-focus

// Programmatic dismiss
Button("Done") { focus = nil }
""")
        }
    }
}

