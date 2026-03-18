//
//
//  1_keyboardtypes.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Keyboard Option Model
enum KeyboardOption: String, CaseIterable, Identifiable {
    case `default`             = "Default"
    case numberPad             = "Number Pad"
    case decimalPad            = "Decimal Pad"
    case phonePad              = "Phone Pad"
    case namePhonePad          = "Name & Phone"
    case emailAddress          = "Email"
    case URL                   = "URL"
    case webSearch             = "Web Search"
    case numbersAndPunctuations = "Numbers & Punct."
    case asciiCapable          = "ASCII"
    case alphabet              = "Alphabet"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .default:              return "keyboard"
        case .numberPad:            return "number"
        case .decimalPad:           return "percent"
        case .phonePad:             return "phone"
        case .namePhonePad:         return "person.text.rectangle"
        case .emailAddress:         return "envelope"
        case .URL:                  return "link"
        case .webSearch:            return "magnifyingglass"
        case .numbersAndPunctuations: return "textformat.123"
        case .asciiCapable:         return "pencil"
        case .alphabet:             return "text.cursor"
        }
    }

    var uiKeyboardType: UIKeyboardType {
        switch self {
        case .default:              return .default
        case .numberPad:            return .numberPad
        case .decimalPad:           return .decimalPad
        case .phonePad:             return .phonePad
        case .namePhonePad:         return .namePhonePad
        case .emailAddress:         return .emailAddress
        case .URL:                  return .URL
        case .webSearch:            return .webSearch
        case .numbersAndPunctuations: return .numbersAndPunctuation
        case .asciiCapable:         return .asciiCapable
        case .alphabet:             return .alphabet
        }
    }

    var accentColor: Color {
        switch self {
        case .default:              return Color(hex: "#534AB7")
        case .numberPad:            return Color(hex: "#E24B4A")
        case .decimalPad:           return Color(hex: "#BA7517")
        case .phonePad:             return Color(hex: "#1D9E75")
        case .namePhonePad:         return Color(hex: "#185FA5")
        case .emailAddress:         return Color(hex: "#993556")
        case .URL:                  return Color(hex: "#0F6E56")
        case .webSearch:            return Color(hex: "#993C1D")
        case .numbersAndPunctuations: return Color(hex: "#854F0B")
        case .asciiCapable:         return Color(hex: "#3B6D11")
        case .alphabet:             return Color(hex: "#534AB7")
        }
    }

    var bgColor: Color { accentColor.opacity(0.1) }

    var useCase: String {
        switch self {
        case .default:              return "General text input"
        case .numberPad:            return "PIN, OTP, quantity"
        case .decimalPad:           return "Price, weight, measurement"
        case .phonePad:             return "Phone number entry"
        case .namePhonePad:         return "Contact name + number"
        case .emailAddress:         return "Login, signup email"
        case .URL:                  return "Browser address bar"
        case .webSearch:            return "Search fields"
        case .numbersAndPunctuations: return "Code, formatting"
        case .asciiCapable:         return "Passwords, usernames"
        case .alphabet:             return "Name-only fields"
        }
    }
}

// MARK: - Visual
struct KeyboardTypesVisual: View {
    @State private var selected: KeyboardOption = .default
    @State private var inputText = ""
    @FocusState private var focused: Bool

    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {

                // Header chip
                HStack {
                    Label("Keyboard types", systemImage: "keyboard")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#185FA5"))
                    Spacer()
                    // Active type chip
                    HStack(spacing: 5) {
                        Circle()
                            .fill(selected.accentColor)
                            .frame(width: 7, height: 7)
                        Text(selected.rawValue)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(selected.accentColor)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(selected.bgColor)
                    .clipShape(Capsule())
                    .animation(.spring(response: 0.3), value: selected)
                }

                // Type grid
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(KeyboardOption.allCases) { option in
                        typeButton(option)
                    }
                }

                // Use case callout
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(selected.accentColor)
                    Text("Use for: \(selected.useCase)")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(selected.bgColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut(duration: 0.2), value: selected)

                // Live input preview
                HStack(spacing: 8) {
                    Image(systemName: selected.icon)
                        .font(.system(size: 13))
                        .foregroundStyle(selected.accentColor)
                    Text(inputText.isEmpty ? "Tap a type, then type here..." : inputText)
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundStyle(inputText.isEmpty ? .tertiary : .primary)
                        .lineLimit(1)
                    Spacer()
                    if !inputText.isEmpty {
                        Button { inputText = "" } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                                .font(.system(size: 14))
                        }
                    }
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onTapGesture { focused = true }

                // Hidden text field drives keyboard
                TextField("", text: $inputText)
                    .keyboardType(selected.uiKeyboardType)
                    .focused($focused)
                    .frame(width: 1, height: 1)
                    .opacity(0.01)
            }
        }
        .onAppear { focused = true }
    }

    func typeButton(_ option: KeyboardOption) -> some View {
        let isSelected = selected == option
        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selected = option
                inputText = ""
            }
            focused = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                focused = true
            }
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(isSelected ? option.accentColor.opacity(0.18) : Color(.systemFill))
                        .frame(width: 40, height: 40)
                    if isSelected {
                        Circle()
                            .stroke(option.accentColor, lineWidth: 1.5)
                            .frame(width: 40, height: 40)
                    }
                    Image(systemName: option.icon)
                        .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                        .foregroundStyle(isSelected ? option.accentColor : .secondary)
                }
                .scaleEffect(isSelected ? 1.08 : 1.0)
                .animation(.spring(response: 0.25), value: isSelected)

                Text(option.rawValue)
                    .font(.system(size: 9, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? option.accentColor : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? option.bgColor : Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        isSelected ? option.accentColor.opacity(0.4) : Color(.systemFill),
                        lineWidth: isSelected ? 1 : 0.5
                    )
            )
        }
        .buttonStyle(PressableButtonStyle())
    }
}

// MARK: - Explanation
struct KeyboardTypesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Choosing the right type")
            Text("SwiftUI exposes every UIKit keyboard type through the .keyboardType() modifier. Picking the right one reduces friction — a number pad for a PIN means the user never has to switch modes.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Numeric input — use .numberPad for integers, .decimalPad when decimals are needed.", color: Color(hex: "#185FA5"))
                StepRow(number: 2, text: "Contact fields — .emailAddress shows @, .URL shows /, .phonePad shows the dialpad.", color: Color(hex: "#185FA5"))
                StepRow(number: 3, text: "Passwords and usernames — .asciiCapable prevents autocorrect and emoji.", color: Color(hex: "#185FA5"))
                StepRow(number: 4, text: "Search fields — .webSearch shows a Search return key instead of Return.", color: Color(hex: "#185FA5"))
            }

            CalloutBox(style: .warning, title: "numberPad has no return key", contentBody: "On .numberPad and .decimalPad there is no return/done button. Always pair these with a keyboard toolbar (Lesson 5) so the user can dismiss.")

            CalloutBox(style: .info, title: "This is a hint, not a filter", contentBody: "keyboardType only changes what the keyboard looks like — it doesn't prevent other input. Always validate programmatically too.")

            CodeBlock(code: """
TextField("Email", text: $email)
    .keyboardType(.emailAddress)
    .textContentType(.emailAddress)
    .autocorrectionDisabled()

TextField("Price", text: $price)
    .keyboardType(.decimalPad)

TextField("Search", text: $query)
    .keyboardType(.webSearch)
""")
        }
    }
}
