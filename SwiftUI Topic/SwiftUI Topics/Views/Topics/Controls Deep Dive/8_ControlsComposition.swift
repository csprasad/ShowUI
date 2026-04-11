//
//
//  8_ControlsComposition.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Controls Composition - real settings panel
struct ControlsCompositionVisual: View {
    // Toggle states
    @State private var notificationsOn = true
    @State private var soundOn         = true
    @State private var hapticOn        = false
    @State private var syncOn          = true

    // Picker states
    @State private var theme: PikerAppTheme   = .system
    @State private var sortOrder: SortOrder = .nameAZ

    // Slider states
    @State private var textSize: Double  = 16
    @State private var brightness: Double = 0.7

    // Stepper states
    @State private var cacheSize         = 256
    @State private var syncInterval      = 15

    @State private var selectedPanel     = 0
    let panels = ["Notifications", "Display", "Storage"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Controls composition", systemImage: "gearshape.2.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cdPurple)

                // Panel tabs
                HStack(spacing: 8) {
                    ForEach(panels.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedPanel = i }
                        } label: {
                            Text(panels[i])
                                .font(.system(size: 11, weight: selectedPanel == i ? .semibold : .regular))
                                .foregroundStyle(selectedPanel == i ? Color.cdPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedPanel == i ? Color.cdPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Settings panel
                NavigationStack {
                    Form {
                        switch selectedPanel {
                        case 0:
                            // Toggles + Picker
                            Section {
                                Toggle(isOn: $notificationsOn) { Label("Notifications", systemImage: "bell.fill") }
                                    .tint(.cdPurple)
                                Toggle(isOn: $soundOn) { Label("Sound", systemImage: "speaker.wave.2.fill") }
                                    .tint(.cdPurple).disabled(!notificationsOn).opacity(notificationsOn ? 1 : 0.5)
                                Toggle(isOn: $hapticOn) { Label("Haptics", systemImage: "hand.tap.fill") }
                                    .tint(.cdPurple).disabled(!notificationsOn).opacity(notificationsOn ? 1 : 0.5)
                            } header: { Text("Alerts") }
                            Section {
                                Picker("Sort items by", selection: $sortOrder) {
                                    ForEach(SortOrder.allCases) { s in Text(s.rawValue).tag(s) }
                                }
                            } header: { Text("Preferences") }.font(.system(size: 14))

                        case 1:
                            // Sliders + Picker
                            Section {
                                Picker("Theme", selection: $theme) {
                                    ForEach(PikerAppTheme.allCases) { t in Label(t.rawValue, systemImage: t.icon).tag(t) }
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Label("Text size", systemImage: "textformat.size")
                                        Spacer()
                                        Text("\(Int(textSize))pt").font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary)
                                    }
                                    Slider(value: $textSize, in: 10...28, step: 1).tint(.cdPurple)
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Label("Brightness", systemImage: "sun.max.fill")
                                        Spacer()
                                        Text("\(Int(brightness * 100))%").font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary)
                                    }
                                    Slider(value: $brightness, in: 0...1).tint(.cdPurple)
                                }
                            } header: { Text("Appearance") }.font(.system(size: 14))

                        default:
                            // Steppers + Toggle
                            Section {
                                Toggle(isOn: $syncOn) { Label("Background sync", systemImage: "arrow.triangle.2.circlepath") }
                                    .tint(.cdPurple)
                                Stepper(value: $syncInterval, in: 5...60, step: 5) {
                                    HStack {
                                        Label("Sync every", systemImage: "clock.fill")
                                        Spacer()
                                        Text("\(syncInterval) min").foregroundStyle(.secondary)
                                    }
                                }
                                .disabled(!syncOn).opacity(syncOn ? 1 : 0.5)
                            } header: { Text("Sync") }.font(.system(size: 14))
                            Section {
                                Stepper(value: $cacheSize, in: 64...2048, step: 64) {
                                    HStack {
                                        Label("Cache limit", systemImage: "internaldrive.fill")
                                        Spacer()
                                        Text("\(cacheSize) MB").foregroundStyle(.secondary)
                                    }
                                }
                                LabeledContent("Used", value: "\(cacheSize / 4) MB")
                            } header: { Text("Cache") }.font(.system(size: 12))
                        }
                        
                    }
                    .navigationTitle(panels[selectedPanel])
                    .navigationBarTitleDisplayMode(.inline)
                }
                .frame(height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemFill), lineWidth: 0.5))
                .animation(.spring(response: 0.35), value: selectedPanel)
                .onChange(of: notificationsOn) { _, on in
                    if !on { soundOn = false; hapticOn = false }
                }
            }
        }
    }
}

struct ControlsCompositionExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Composing all four controls")
            Text("Toggle, Picker, Slider and Stepper each have a natural role in settings UI. Toggle for boolean features, Picker for choosing from a set, Slider for continuous ranges, Stepper for precise numeric adjustment. Form + Section structures them cleanly.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Toggle in Form - full-row tap target, perfect system look with label on left, switch on right.", color: .cdPurple)
                StepRow(number: 2, text: "Picker in Form - navigationLink style by default, taps through to a selection screen.", color: .cdPurple)
                StepRow(number: 3, text: "Slider in Form - use VStack label + Slider to give it a header row with current value display.", color: .cdPurple)
                StepRow(number: 4, text: "Stepper in Form - put the current value in the label for a clean key-value row look.", color: .cdPurple)
                StepRow(number: 5, text: ".disabled(!parentToggle) on child controls - cascading enable/disable with visual opacity hint.", color: .cdPurple)
            }

            CalloutBox(style: .success, title: "Form applies system styling automatically", contentBody: "Put Toggle, Picker, Slider and Stepper inside Form and they all get the correct system inset-grouped appearance automatically. No custom padding, background or border code needed - Form handles it all.")

            CodeBlock(code: """
Form {
    Section("Notifications") {
        // Toggle - boolean
        Toggle("Push alerts", isOn: $pushOn)
            .tint(.purple)

        // Dependent toggle
        Toggle("Sound", isOn: $soundOn)
            .disabled(!pushOn)
    }

    Section("Appearance") {
        // Picker - selection
        Picker("Theme", selection: $theme) {
            ForEach(Theme.allCases) { t in
                Text(t.rawValue).tag(t)
            }
        }

        // Slider - continuous
        VStack(alignment: .leading) {
            HStack {
                Text("Text size")
                Spacer()
                Text("\\(Int(size))pt").foregroundStyle(.secondary)
            }
            Slider(value: $size, in: 10...28, step: 1)
        }
    }

    Section("Storage") {
        // Stepper - precise
        Stepper(value: $cache, in: 64...2048, step: 64) {
            HStack {
                Text("Cache")
                Spacer()
                Text("\\(cache) MB").foregroundStyle(.secondary)
            }
        }
    }
}
""")
        }
    }
}

