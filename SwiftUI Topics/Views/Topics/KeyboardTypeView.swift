//
//  KeyboardTypeView.swift
//  SwiftUI Topics
//
//  Created by codeAlligator on 19/02/26.
//

import SwiftUI

struct KeyboardTypeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var inputText: String = ""
    @State private var selectedKeyboardType: KeyboardOption = .default
    @FocusState private var isTextFieldFocused: Bool

    enum KeyboardOption: String, CaseIterable, Identifiable {
        case `default`              = "Default"
        case numberPad              = "Number Pad"
        case decimalPad             = "Decimal Pad"
        case phonePad               = "Phone Pad"
        case namePhonePad           = "Name & Phone"
        case emailAddress           = "Email"
        case URL                    = "URL"
        case twitter                = "Twitter"
        case webSearch              = "Web Search"
        case numbersAndPunctuations = "Numbers & Punctuation"
        case asciiCapable           = "ASCII"
        case asciiCapableNumberPad  = "ASCII Number"
        case alphabet               = "Alphabet"

        var id: String { rawValue }

        var icon: String {
            switch self {
            case .default:               return "keyboard"
            case .numberPad:             return "number"
            case .decimalPad:            return "percent"
            case .phonePad:              return "phone"
            case .namePhonePad:          return "person.text.rectangle"
            case .emailAddress:          return "envelope"
            case .URL:                   return "link"
            case .twitter:               return "at"
            case .webSearch:             return "binoculars"
            case .numbersAndPunctuations: return "textformat.123"
            case .asciiCapable:          return "pencil"
            case .asciiCapableNumberPad: return "character.cursor.ibeam"
            case .alphabet:              return "text.cursor"
            }
        }

        var uiKeyboardType: UIKeyboardType {
            switch self {
            case .default:               return .default
            case .numberPad:             return .numberPad
            case .decimalPad:            return .decimalPad
            case .phonePad:              return .phonePad
            case .namePhonePad:          return .namePhonePad
            case .emailAddress:          return .emailAddress
            case .URL:                   return .URL
            case .twitter:               return .twitter
            case .webSearch:             return .webSearch
            case .numbersAndPunctuations: return .numbersAndPunctuation
            case .asciiCapable:          return .asciiCapable
            case .asciiCapableNumberPad: return .asciiCapableNumberPad
            case .alphabet:              return .alphabet
            }
        }

        var accentColor: Color {
            switch self {
            case .default:               return Color(hex: "6C63FF")
            case .numberPad:             return Color(hex: "FF6B6B")
            case .decimalPad:            return Color(hex: "FFA94D")
            case .phonePad:              return Color(hex: "51CF66")
            case .namePhonePad:          return Color(hex: "339AF0")
            case .emailAddress:          return Color(hex: "CC5DE8")
            case .URL:                   return Color(hex: "20C997")
            case .twitter:               return Color(hex: "74C0FC")
            case .webSearch:             return Color(hex: "FF8787")
            case .numbersAndPunctuations: return Color(hex: "FAB005")
            case .asciiCapable:          return Color(hex: "94D82D")
            case .asciiCapableNumberPad: return Color(hex: "63E6BE")
            case .alphabet:              return Color(hex: "DA77F2")
            }
        }
    }

    // MARK: - Adaptive Colors

    var backgroundPrimary: Color {
        colorScheme == .dark ? Color(hex: "0F0F14") : Color(hex: "F2F2F7")
    }

    var backgroundSecondary: Color {
        colorScheme == .dark ? Color(hex: "1A1A24") : Color(hex: "FFFFFF")
    }

    var textPrimary: Color {
        colorScheme == .dark ? .white : Color(hex: "1A1A2E")
    }

    var textSecondary: Color {
        colorScheme == .dark ? Color(hex: "888899") : Color(hex: "6E6E80")
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            backgroundPrimary.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    header
                        .padding(.top, 16)
                        .padding(.horizontal, 24)

                    Spacer(minLength: 20)

                    keyboardButtonsGrid
                        .padding(.horizontal, 20)

                    Spacer(minLength: 24)

                    inputPreviewLabel
                        .padding(.horizontal, 24)
                        .padding(.bottom, 12)

                    keyboardInputArea
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .onAppear {
            isTextFieldFocused = true
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Keyboard Types")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(textPrimary)
                Text("Tap a type to switch keyboard")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(textSecondary)
            }
            Spacer()

            HStack(spacing: 6) {
                Circle()
                    .fill(selectedKeyboardType.accentColor)
                    .frame(width: 8, height: 8)
                    .overlay(
                        Circle()
                            .fill(selectedKeyboardType.accentColor.opacity(0.3))
                            .frame(width: 14, height: 14)
                    )
                Text(selectedKeyboardType.rawValue)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(selectedKeyboardType.accentColor)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(selectedKeyboardType.accentColor.opacity(0.12))
                    .overlay(
                        Capsule()
                            .strokeBorder(selectedKeyboardType.accentColor.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }

    // MARK: - Keyboard Buttons Grid

    private var keyboardButtonsGrid: some View {
        let columns = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]

        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(KeyboardOption.allCases) { option in
                KeyboardTypeButton(
                    option: option,
                    isSelected: selectedKeyboardType == option,
                    colorScheme: colorScheme
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedKeyboardType = option
                        inputText = ""
                    }
                    isTextFieldFocused = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        isTextFieldFocused = true
                    }
                }
            }
        }
    }

    // MARK: - Input Preview Label

    private var inputPreviewLabel: some View {
        HStack {
            Image(systemName: selectedKeyboardType.icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(selectedKeyboardType.accentColor)

            Text(inputText.isEmpty ? "Start typing..." : inputText)
                .font(.system(size: 16, weight: .medium, design: .monospaced))
                .foregroundColor(inputText.isEmpty ? textSecondary : textPrimary)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer()

            if !inputText.isEmpty {
                Button {
                    inputText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(textSecondary)
                        .font(.system(size: 15))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(selectedKeyboardType.accentColor.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(
            color: colorScheme == .dark ? .clear : Color.black.opacity(0.06),
            radius: 8, x: 0, y: 2
        )
    }

    // MARK: - Keyboard Input Area

    private var keyboardInputArea: some View {
        TextField("", text: $inputText)
            .keyboardType(selectedKeyboardType.uiKeyboardType)
            .focused($isTextFieldFocused)
            .frame(width: 1, height: 1)
            .opacity(0.01)
    }
}

// MARK: - Keyboard Type Button

struct KeyboardTypeButton: View {
    let option: KeyboardTypeView.KeyboardOption
    let isSelected: Bool
    let colorScheme: ColorScheme
    let action: () -> Void

    @State private var isPressed = false

    var cardBackground: Color {
        isSelected
            ? option.accentColor.opacity(0.07)
            : (colorScheme == .dark ? Color(hex: "141420") : Color(hex: "FFFFFF"))
    }

    var cardBorder: Color {
        isSelected
            ? option.accentColor.opacity(0.4)
            : (colorScheme == .dark ? Color(hex: "2A2A38") : Color(hex: "E0E0EB"))
    }

    var circleBackground: Color {
        isSelected
            ? option.accentColor.opacity(0.2)
            : (colorScheme == .dark ? Color(hex: "1C1C28") : Color(hex: "EFEFEF"))
    }

    var circleBorder: Color {
        isSelected
            ? option.accentColor
            : (colorScheme == .dark ? Color(hex: "2A2A38") : Color(hex: "D0D0DC"))
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(circleBackground)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle()
                                .strokeBorder(circleBorder, lineWidth: isSelected ? 1.5 : 1)
                        )

                    Image(systemName: option.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isSelected ? option.accentColor : .secondary)
                }
                .scaleEffect(isSelected ? 1.08 : 1.0)

                Text(option.rawValue)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(isSelected ? option.accentColor : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(cardBorder, lineWidth: 1)
                    )
            )
            .shadow(
                color: isSelected
                    ? option.accentColor.opacity(colorScheme == .dark ? 0.2 : 0.15)
                    : Color.black.opacity(colorScheme == .dark ? 0 : 0.04),
                radius: 8, x: 0, y: 4
            )
            .scaleEffect(isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.65), value: isSelected)
        }
        .buttonStyle(PressableButtonStyle(isPressed: $isPressed))
    }
}

// MARK: - Pressable Button Style

struct PressableButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { newValue in
                isPressed = newValue
            }
    }
}

// MARK: - Preview

#Preview {
    KeyboardTypeView()
}

