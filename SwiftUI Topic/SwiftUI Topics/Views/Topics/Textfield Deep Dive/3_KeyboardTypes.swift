//
//
//  3_KeyboardTypes.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Keyboard Types
struct TxtKeyboardTypesVisual: View {
    @State private var values: [String: String] = [:]
    @State private var selectedDemo = 0
    let demos = ["Keyboard types", "Content types", "Autocorrect"]

    struct KeyboardConfig: Identifiable {
        let id = UUID()
        let label: String
        let keyType: UIKeyboardType
        let placeholder: String
        let icon: String
    }

    let keyboardConfigs: [KeyboardConfig] = [
        .init(label: "Default", keyType: .default, placeholder: "Type anything", icon: "a.square"),
        .init(label: ".emailAddress", keyType: .emailAddress, placeholder: "user@example.com", icon: "envelope"),
        .init(label: ".numberPad", keyType: .numberPad, placeholder: "Numbers only", icon: "number.square"),
        .init(label: ".decimalPad", keyType: .decimalPad, placeholder: "0.00", icon: "plusminus.circle"),
        .init(label: ".phonePad", keyType: .phonePad, placeholder: "+1 (555) 000-0000", icon: "phone"),
        .init(label: ".URL", keyType: .URL, placeholder: "https://example.com", icon: "globe"),
        .init(label: ".twitter", keyType: .twitter, placeholder: "@username or #tag", icon: "at"),
        .init(label: ".webSearch", keyType: .webSearch, placeholder: "Search the web…", icon: "magnifyingglass"),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Keyboard types", systemImage: "keyboard.fill")
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
                    // Keyboard type gallery
                    VStack(spacing: 6) {
                        ForEach(keyboardConfigs) { config in
                            HStack(spacing: 10) {
                                Image(systemName: config.icon)
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.tfOrange)
                                    .frame(width: 20)
                                TextField(config.placeholder, text: Binding(
                                    get: { values[config.label] ?? "" },
                                    set: { values[config.label] = $0 }
                                ))
                                .keyboardType(config.keyType)
                                .textFieldStyle(.plain)
                                .font(.system(size: 13))
                                Text(config.label)
                                    .font(.system(size: 9, design: .monospaced))
                                    .foregroundStyle(.secondary)
                                    .frame(width: 88, alignment: .trailing)
                                    .lineLimit(1).minimumScaleFactor(0.7)
                            }
                            .padding(.horizontal, 10).padding(.vertical, 8)
                            .background(Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }

                case 1:
                    // textContentType (semantic autofill hints)
                    VStack(spacing: 6) {
                        let configs: [(icon: String, label: String, hint: String, ct: UITextContentType)] = [
                            ("person.fill",     "Name",     "name", .name),
                            ("envelope.fill",   "Email",    "emailAddress", .emailAddress),
                            ("lock.fill",       "Password", "password", .password),
                            ("phone.fill",      "Phone",    "telephoneNumber", .telephoneNumber),
                            ("mappin",     "City",     "addressCity", .addressCity),
                            ("creditcard.fill", "CC num",   "creditCardNumber", .creditCardNumber),
                        ]
                        ForEach(configs, id: \.label) { c in
                            HStack(spacing: 10) {
                                Image(systemName: c.icon).font(.system(size: 13)).foregroundStyle(Color.tfOrange).frame(width: 18)
                                TextField(c.label, text: Binding(get: { values[c.label] ?? "" }, set: { values[c.label] = $0 }))
                                    .textFieldStyle(.plain).font(.system(size: 13))
                                    .textContentType(c.ct)
                                Spacer()
                                Text(".contentType(.\(c.hint))")
                                    .font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                                    .lineLimit(1).minimumScaleFactor(0.6)
                            }
                            .padding(.horizontal, 10).padding(.vertical, 8)
                            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }

                default:
                    // autocorrect / autocapitalization
                    VStack(spacing: 8) {
                        let rows: [(label: String, autoCorr: Bool, autoCap: TextInputAutocapitalization, desc: String)] = [
                            ("All defaults",    true,  .sentences, "default behaviour - sentence caps, autocorrect on"),
                            ("Username",        false, .never,     "autocorrectionDisabled + autocap .never"),
                            ("Hashtag",         false, .never,     "no autocorrect, no caps - ideal for handles"),
                            ("Title case",      true,  .words,     ".words - capitalises every word"),
                            ("Shout",           false, .characters,"ALL CAPS - .characters for caps lock"),
                        ]
                        ForEach(rows, id: \.label) { row in
                            HStack(spacing: 8) {
                                TextField(row.label, text: Binding(get: { values[row.label] ?? "" }, set: { values[row.label] = $0 }))
                                    .textFieldStyle(.plain).font(.system(size: 13))
                                    .autocorrectionDisabled(!row.autoCorr)
                                    .textInputAutocapitalization(row.autoCap)
                                Spacer()
                                Text(row.desc).font(.system(size: 9)).foregroundStyle(.secondary).lineLimit(2).multilineTextAlignment(.trailing).frame(width: 110)
                            }
                            .padding(.horizontal, 10).padding(.vertical, 8)
                            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
        }
    }
}

struct TxtKeyboardTypesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Keyboard types & input hints")
            Text("The right keyboard type and content type dramatically improve UX. keyboardType controls which keyboard layout appears. textContentType gives iOS semantic hints to power autofill from iCloud Keychain and Contacts.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".keyboardType(.emailAddress) - @ and . keys prominent. Use for email fields.", color: .tfOrange)
                StepRow(number: 2, text: ".keyboardType(.numberPad) - digits only, no decimal. Use for PINs, OTPs.", color: .tfOrange)
                StepRow(number: 3, text: ".keyboardType(.decimalPad) - digits + decimal point. Use for currency, measurements.", color: .tfOrange)
                StepRow(number: 4, text: ".textContentType(.emailAddress) - signals iOS to offer autofill from Contacts and Keychain.", color: .tfOrange)
                StepRow(number: 5, text: ".textContentType(.newPassword) - triggers strong password suggestion in iOS 12+.", color: .tfOrange)
                StepRow(number: 6, text: ".autocorrectionDisabled() - turn off autocorrect for usernames, codes, technical terms.", color: .tfOrange)
                StepRow(number: 7, text: ".textInputAutocapitalization(.never / .words / .sentences / .characters)", color: .tfOrange)
            }

            CalloutBox(style: .success, title: "textContentType unlocks autofill", contentBody: "Setting both .keyboardType and .textContentType correctly enables powerful iOS autofill - passwords from iCloud Keychain, email from Contacts, phone numbers, addresses and more. Always set both for user-facing form fields.")

            CodeBlock(code: """
// Email field - full hints
TextField("Email", text: $email)
    .keyboardType(.emailAddress)
    .textContentType(.emailAddress)
    .textInputAutocapitalization(.never)
    .autocorrectionDisabled()

// Password with new password suggestion
SecureField("Password", text: $password)
    .textContentType(.newPassword)

// OTP / PIN code
TextField("6-digit code", text: $pin)
    .keyboardType(.numberPad)
    .textContentType(.oneTimeCode)   // SMS autofill!

// Username
TextField("@username", text: $handle)
    .keyboardType(.twitter)
    .autocorrectionDisabled()
    .textInputAutocapitalization(.never)
""")
        }
    }
}
