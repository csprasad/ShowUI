//
//
//  8_SettingsUI.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Settings Screen
struct SettingsScreenVisual: View {
    @State private var notifications = true
    @State private var darkMode = false
    @State private var haptics = true
    @State private var language = "English"
    @State private var fontSize = 1  // 0=small, 1=medium, 2=large
    @State private var accentChoice = 0
    @State private var showDeleteAlert = false
    @State private var selectedSection = 0

    let fontLabels = ["Small", "Medium", "Large"]
    let accentColors: [(name: String, color: Color)] = [
        ("Blue", .blue), ("Green", .formGreen), ("Orange", .gestureOrange), ("Purple", .ssPurple)
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Settings screen", systemImage: "gear")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.formGreen)

                // Live settings form
                NavigationStack {
                    Form {
                        // Profile section
                        Section {
                            HStack(spacing: 14) {
                                Circle()
                                    .fill(accentColors[accentChoice].color)
                                    .frame(width: 50, height: 50)
                                    .overlay(Text("AC").font(.system(size: 18, weight: .bold)).foregroundStyle(.white))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Alice Chen").font(.system(size: 15, weight: .semibold))
                                    Text("alice@example.com").font(.system(size: 13)).foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }

                        // Notifications
                        Section("Notifications") {
                            Toggle(isOn: $notifications) {
                                Label("Push notifications", systemImage: "bell.fill")
                            }
                            .tint(.formGreen)
                            if notifications {
                                Toggle(isOn: $haptics) {
                                    Label("Haptic feedback", systemImage: "hand.tap.fill")
                                }
                                .tint(.formGreen)
                            }
                        }

                        // Appearance
                        Section("Appearance") {
                            Toggle(isOn: $darkMode) {
                                Label("Dark mode", systemImage: "moon.fill")
                            }
                            .tint(.formGreen)

                            Picker(selection: $fontSize) {
                                ForEach(fontLabels.indices, id: \.self) { Text(fontLabels[$0]).tag($0) }
                            } label: {
                                Label("Text size", systemImage: "textformat.size")
                            }

                            // Accent color picker
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Accent color", systemImage: "paintpalette.fill")
                                    .font(.system(size: 14))
                                HStack(spacing: 10) {
                                    ForEach(accentColors.indices, id: \.self) { i in
                                        Button {
                                            withAnimation(.spring(response: 0.3)) { accentChoice = i }
                                        } label: {
                                            Circle()
                                                .fill(accentColors[i].color)
                                                .frame(width: 28, height: 28)
                                                .overlay(Circle().stroke(.white, lineWidth: accentChoice == i ? 3 : 0))
                                                .shadow(color: accentColors[i].color.opacity(0.4), radius: accentChoice == i ? 4 : 0)
                                        }
                                        .buttonStyle(PressableButtonStyle())
                                    }
                                }
                            }
                        }

                        // About
                        Section("About") {
                            LabeledContent("Version", value: "2.4.1")
                            LabeledContent("Build", value: "142")
                            Link(destination: URL(string: "https://example.com")!) {
                                Label("Privacy Policy", systemImage: "lock.shield.fill")
                            }
                        }

                        // Danger zone
                        Section {
                            Button(role: .destructive) {
                                showDeleteAlert = true
                            } label: {
                                Label("Delete Account", systemImage: "trash.fill")
                            }
                        }
                    }
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.inline)
                    .alert("Delete Account?", isPresented: $showDeleteAlert) {
                        Button("Delete", role: .destructive) { }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("This cannot be undone.")
                    }
                }
                .frame(height: 320)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemFill), lineWidth: 0.5))
            }
        }
    }
}

struct SettingsScreenExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Building a settings screen")
            Text("A settings screen is a Form with multiple Sections. Each section groups related preferences. The structure follows a well-established pattern: profile at the top, preferences in the middle, danger zone at the bottom.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Profile section first - user identity at the top as a NavigationLink to an edit screen.", color: .formGreen)
                StepRow(number: 2, text: "Group related settings into named sections - Notifications, Appearance, Privacy, About.", color: .formGreen)
                StepRow(number: 3, text: "Use Label(title, systemImage:) for rows - icon + text is the standard settings row pattern.", color: .formGreen)
                StepRow(number: 4, text: "LabeledContent(key, value:) for read-only info rows - version, build number, account info.", color: .formGreen)
                StepRow(number: 5, text: "Destructive actions in their own section at the bottom - Button(role: .destructive).", color: .formGreen)
                StepRow(number: 6, text: "Link(destination:) for external URLs - privacy policy, terms, support - opens in Safari.", color: .formGreen)
            }

            CalloutBox(style: .success, title: "Conditional rows with if inside Form", contentBody: "Use if statements inside Form to show/hide rows based on state - e.g., show 'Haptic feedback' only when notifications are enabled. SwiftUI animates the show/hide automatically.")

            CodeBlock(code: """
Form {
    // Profile
    Section {
        NavigationLink { EditProfileView() } label: {
            ProfileRow(user: user)
        }
    }

    // Preferences
    Section("Notifications") {
        Toggle("Push", isOn: $notifications)
        if notifications {          // conditional row
            Toggle("Sounds", isOn: $sounds)
        }
    }

    Section("Appearance") {
        Picker("Theme", selection: $theme) {
            Text("Light").tag("light")
            Text("Dark").tag("dark")
        }
    }

    // Info
    Section("About") {
        LabeledContent("Version", value: "1.0.0")
        Link("Privacy Policy",
             destination: URL(string: "https://...")!)
    }

    // Danger
    Section {
        Button("Sign Out", role: .destructive) { signOut() }
    }
}
.navigationTitle("Settings")
""")
        }
    }
}
