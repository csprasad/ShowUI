//
//
//  5_KeyboardToolbar.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Keyboard Toolbar

struct KeyboardToolbarVisual: View {
    @State private var notes = ""
    @State private var amount = ""
    @FocusState private var focused: Bool
    @State private var insertedSymbol = ""

    let symbols = ["$", "%", "@", "#", "&", "→", "≈", "°"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {
                Label("Keyboard toolbar", systemImage: "rectangle.topthird.inset.filled")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#185FA5"))

                Text("Tap the field - buttons appear above the keyboard")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)

                // Notes field with toolbar
                VStack(alignment: .leading, spacing: 4) {
                    Text("Notes")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                    TextField("Tap to open keyboard with toolbar...", text: $notes, axis: .vertical)
                        .lineLimit(3)
                        .focused($focused)
                        .padding(12)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                            focused ? Color(hex: "#185FA5") : Color(.systemFill),
                            lineWidth: focused ? 1.5 : 0.5
                        ))
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                // Symbol insert buttons
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(symbols, id: \.self) { sym in
                                            Button(sym) {
                                                notes.append(sym)
                                                insertedSymbol = sym
                                            }
                                            .font(.system(size: 15, weight: .medium))
                                            .frame(width: 34, height: 34)
                                            .background(Color(.systemFill))
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .buttonStyle(PressableButtonStyle())
                                        }
                                    }
                                }
                                Spacer()
                                Button("Done") {
                                    focused = false
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(hex: "#185FA5"))
                            }
                        }
                }

                if !insertedSymbol.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color(hex: "#1D9E75"))
                            .font(.system(size: 13))
                        Text("Inserted '\(insertedSymbol)' via toolbar")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                    .transition(.opacity)
                }

                CalloutBox(style: .warning, title: "Essential for numPad", contentBody: ".numberPad and .decimalPad have no Return key. Always add a 'Done' button in the toolbar so users can dismiss.")
            }
        }
    }
}

struct KeyboardToolbarExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Adding buttons above the keyboard")
            Text("ToolbarItemGroup(placement: .keyboard) adds a bar directly above the keyboard. It's the standard place for a Done button, formatting shortcuts, or any action tied to text input.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Add .toolbar { } to the TextField, not to a parent view.", color: Color(hex: "#185FA5"))
                StepRow(number: 2, text: "Use ToolbarItemGroup(placement: .keyboard) to place items in the input accessory bar.", color: Color(hex: "#185FA5"))
                StepRow(number: 3, text: "Always include a Done button that sets your @FocusState to nil.", color: Color(hex: "#185FA5"))
            }

            CalloutBox(style: .success, title: "Rich toolbar pattern", contentBody: "Combine a ScrollView(.horizontal) of action buttons on the left with a Spacer() and a Done button on the right - the standard iOS pattern.")

            CodeBlock(code: """
TextField("Amount", text: $amount)
    .keyboardType(.decimalPad)
    .focused($focused)
    .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
            Button("Insert %") { amount += "%" }
            Spacer()
            Button("Done") { focused = nil }
                .fontWeight(.semibold)
        }
    }
""")
        }
    }
}

