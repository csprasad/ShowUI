//
//
//  3_keyboardavoidance.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Visual
struct KeyboardAvoidanceVisual: View {
    enum AvoidanceMode: String, CaseIterable {
        case automatic  = "Automatic"
        case ignored    = "Ignored"
        case padding    = "Safe Area Padding"
    }

    @State private var selectedMode: AvoidanceMode = .automatic
    @State private var text = ""
    @FocusState private var focused: Bool

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("Keyboard avoidance", systemImage: "arrow.up.to.line")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#185FA5"))
                    Spacer()
                }

                // Mode selector
                HStack(spacing: 8) {
                    ForEach(AvoidanceMode.allCases, id: \.rawValue) { mode in
                        Button(mode.rawValue) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedMode = mode
                            }
                        }
                        .font(.system(size: 11, weight: selectedMode == mode ? .semibold : .regular))
                        .foregroundStyle(selectedMode == mode ? Color(hex: "#185FA5") : .secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(selectedMode == mode
                                    ? Color(hex: "#E6F1FB")
                                    : Color(.systemFill))
                        )
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Phone mockup showing behavior
                mockupPreview

                // Mode description
                modeDescription

                // Code sample
                CodeBlock(code: modeCode)
            }
        }
    }

    private var mockupPreview: some View {
        ZStack(alignment: .bottom) {
            // Phone frame
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .frame(height: 200)

            // Content area
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "#B5D4F4"))
                    .frame(height: 36)
                    .overlay(
                        Text("TextField")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(Color(hex: "#0C447C"))
                    )
                    .padding(.horizontal, 16)
                    .offset(y: selectedMode == .automatic ? -80 : 0)
                    .animation(.spring(response: 0.4), value: selectedMode)
            }
            .frame(maxWidth: .infinity)

            // Keyboard representation
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#E6F1FB"))
                .frame(height: selectedMode == .ignored ? 0 : 80)
                .overlay(
                    VStack(spacing: 6) {
                        Text("⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜")
                            .font(.system(size: 10))
                            .foregroundStyle(Color(hex: "#185FA5").opacity(0.5))
                        Text("⬜⬜⬜⬜⬜⬜⬜⬜⬜")
                            .font(.system(size: 10))
                            .foregroundStyle(Color(hex: "#185FA5").opacity(0.5))
                        Text("⬜⬜⬜⬜⬜⬜⬜")
                            .font(.system(size: 10))
                            .foregroundStyle(Color(hex: "#185FA5").opacity(0.5))
                    }
                )
                .animation(.spring(response: 0.4), value: selectedMode)

            // Overlap indicator
            if selectedMode == .ignored {
                Text("TextField hidden behind keyboard")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color(hex: "#A32D2D"))
                    .padding(6)
                    .background(Color(hex: "#FCEBEB"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.bottom, 8)
                    .transition(.opacity)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var modeDescription: some View {
        Group {
            switch selectedMode {
            case .automatic:
                CalloutBox(style: .success, title: "Default behaviour", contentBody: "SwiftUI automatically pushes the view up when the keyboard appears. Works well for most layouts.")
            case .ignored:
                CalloutBox(style: .danger, title: "Keyboard overlaps content", contentBody: "Use .ignoresSafeArea(.keyboard) when you're handling avoidance yourself or the default behaviour breaks your layout.")
            case .padding:
                CalloutBox(style: .info, title: "Manual safe area padding", contentBody: "Adds bottom padding equal to the keyboard height. Gives you fine control - useful when the automatic push isn't quite right.")
            }
        }
    }

    private var modeCode: String {
        switch selectedMode {
        case .automatic:
            return """
// Default - SwiftUI handles it
ScrollView {
    TextField("Message", text: $text)
}
"""
        case .ignored:
            return """
// Opt out of automatic avoidance
ScrollView {
    TextField("Message", text: $text)
}
.ignoresSafeArea(.keyboard)
"""
        case .padding:
            return """
// Manual padding approach
ScrollView {
    TextField("Message", text: $text)
}
.safeAreaInset(edge: .bottom) {
    Color.clear.frame(height: 0)
}
"""
        }
    }
}

// MARK: - Explanation
struct KeyboardAvoidanceExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "How avoidance works")
            Text("When the keyboard appears it reduces the visible safe area. SwiftUI automatically adjusts scroll views and form content - but sometimes the default behaviour conflicts with your layout.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "By default ScrollView and Form push their content up automatically.", color: Color(hex: "#185FA5"))
                StepRow(number: 2, text: ".ignoresSafeArea(.keyboard) opts out entirely - useful for chat screens where you want manual control.", color: Color(hex: "#185FA5"))
                StepRow(number: 3, text: ".scrollDismissesKeyboard(.interactively) lets users drag the scroll view to dismiss the keyboard.", color: Color(hex: "#185FA5"))
            }

            CalloutBox(style: .warning, title: "Chat screen pattern", contentBody: "For a chat-style layout with a fixed input bar at the bottom, use .ignoresSafeArea(.keyboard) on the scroll view and animate the input bar with the keyboard height manually.")

            CodeBlock(code: """
// Dismiss keyboard when scrolling
ScrollView {
    // messages...
}
.scrollDismissesKeyboard(.interactively)

// Chat-style fixed input bar
VStack {
    ScrollView { /* messages */ }
    messageInputBar
        .padding(.bottom, keyboardHeight)
}
.ignoresSafeArea(.keyboard)
""")
        }
    }
}
