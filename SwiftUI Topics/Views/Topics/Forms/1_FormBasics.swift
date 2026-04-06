//
//
//  1_FormBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: Form Basics
struct FormBasicsVisual: View {
    @State private var selectedStyle = 0
    @State private var notifications = true
    @State private var selectedTab = 0

    let styles = ["automatic", "grouped", "columns"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Form basics", systemImage: "list.bullet.rectangle.portrait.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.formGreen)

                // Style selector
                HStack(spacing: 8) {
                    ForEach(styles.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedStyle = i }
                        } label: {
                            Text(".\(styles[i])")
                                .font(.system(size: 10, weight: selectedStyle == i ? .semibold : .regular, design: .monospaced))
                                .foregroundStyle(selectedStyle == i ? Color.formGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedStyle == i ? Color.formGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Live form demo
                formDemo
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemFill), lineWidth: 0.5))
                    .animation(.spring(response: 0.35), value: selectedStyle)

                // Form vs List note
                HStack(spacing: 6) {
                    Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.formGreen)
                    Text("Form uses .insetGrouped list style by default on iOS. Use it instead of List for settings and data entry screens.")
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                }
                .padding(10).background(Color.formGreenLight).clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    @ViewBuilder
    private var formDemo: some View {
        let content = Group {
            Section("Account") {
                LabeledContent("Username", value: "alice_dev")
                LabeledContent("Plan", value: "Pro")
            }
            Section("Preferences") {
                Toggle("Notifications", isOn: $notifications)
                Toggle("Dark mode", isOn: .constant(false))
            }
            Section {
                NavigationLink("Privacy") { Text("Privacy settings") }
                NavigationLink("Security") { Text("Security settings") }
            } header: {
                Text("More")
            } footer: {
                Text("Version 2.4.1 (build 142)")
            }
        }

        switch selectedStyle {
        case 1:
            NavigationStack {
                Form { content }.formStyle(.grouped).navigationTitle("Settings").navigationBarTitleDisplayMode(.inline)
            }
        case 2:
            NavigationStack {
                Form { content }.formStyle(.columns).navigationTitle("Settings").navigationBarTitleDisplayMode(.inline)
            }
        default:
            NavigationStack {
                Form { content }.navigationTitle("Settings").navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct FormBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Form - the settings container")
            Text("Form is a container view optimized for data entry and settings UI. It applies platform-appropriate styling to its children - toggles, pickers, text fields, and navigation links all get the correct system appearance automatically.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Form { } uses .insetGrouped list style by default on iOS - the standard settings look.", color: .formGreen)
                StepRow(number: 2, text: "Section { } inside Form creates grouped rows with optional header and footer.", color: .formGreen)
                StepRow(number: 3, text: ".formStyle(.grouped) - explicit grouped. .formStyle(.columns) - two-column layout for macOS/iPad.", color: .formGreen)
                StepRow(number: 4, text: "Controls inside Form get automatic styling - Toggle shows a switch, Picker shows a row with value, Slider gets full width.", color: .formGreen)
            }

            CalloutBox(style: .success, title: "Form vs List", contentBody: "Use Form for settings and data entry - it applies the right styling to interactive controls automatically. Use List for displaying data. Both support Section, but Form is semantically correct for input screens.")

            CalloutBox(style: .info, title: "Section header and footer", contentBody: "Section headers appear as uppercase labels above the group. Footers appear as small gray text below - perfect for help text, warnings, or version numbers.")

            CodeBlock(code: """
Form {
    Section("Account") {
        LabeledContent("Email", value: user.email)
        Toggle("Marketing emails", isOn: $marketing)
    }

    Section {
        Picker("Language", selection: $language) {
            ForEach(languages, id: \\.self) { Text($0) }
        }
        Picker("Theme", selection: $theme) {
            Text("Light").tag("light")
            Text("Dark").tag("dark")
        }
    } header: {
        Text("Appearance")
    } footer: {
        Text("Changes take effect immediately.")
    }

    Section("Danger zone") {
        Button("Delete account", role: .destructive) { }
    }
}
.formStyle(.grouped)   // or .automatic (default)
""")
        }
    }
}
