//
//
//  1_TipKitFundamentals.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import TipKit

// MARK: - LESSON 1: TipKit Fundamentals

struct TKFundamentalsVisual: View {
    @State private var selectedDemo = 0
    @State private var showingTip   = true
    @State private var dismissCount = 0
    let demos = ["Tip anatomy", "configure()", "Tip lifecycle"]

    let welcomeTip = WelcomeTip()

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("TipKit fundamentals", systemImage: "lightbulb.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tkAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.tkAmber : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.tkAmberLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Annotated anatomy
                    VStack(spacing: 8) {
                        anatomyBlock(icon: "lightbulb.circle.fill", color: .tkAmber,
                                     label: "struct MyTip: Tip",
                                     desc: "Conform any struct to the Tip protocol. Each tip is a unique type.")
                        anatomyBlock(icon: "textformat", color: Color(hex: "#0F766E"),
                                     label: "var title: Text { Text(\"…\") }",
                                     desc: "Required. Bold title shown at the top of the tip card.")
                        anatomyBlock(icon: "text.alignleft", color: Color(hex: "#1D4ED8"),
                                     label: "var message: Text? { Text(\"…\") }",
                                     desc: "Optional. Supporting description below the title.")
                        anatomyBlock(icon: "photo.fill", color: Color(hex: "#7C3AED"),
                                     label: "var image: Image? { Image(systemName: \"…\") }",
                                     desc: "Optional. SF Symbol or custom image shown on the leading side.")
                        anatomyBlock(icon: "bolt.circle.fill", color: Color(hex: "#C2410C"),
                                     label: "var rules: [Rule] { … }",
                                     desc: "Optional. Conditions that must be true for the tip to display.")
                        anatomyBlock(icon: "hand.tap.fill", color: Color(hex: "#4D7C0F"),
                                     label: "var actions: [Action] { … }",
                                     desc: "Optional. Buttons shown at the bottom - 'Learn more', 'Got it', etc.")
                    }

                case 1:
                    // Tips.configure()
                    VStack(spacing: 8) {
                        Text("Required: configure once at app startup").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        configStep(step: "1", title: "@main App entry", color: .tkAmber,
                                   code: "import TipKit\n\n@main struct MyApp: App {\n    init() {\n        try? Tips.configure([\n            .datastoreLocation(.applicationDefault)\n        ])\n    }\n}",
                                   desc: "Call Tips.configure() in init() - before the first body render")

                        configStep(step: "2", title: "Configuration options", color: Color(hex: "#0F766E"),
                                   code: "Tips.configure([\n    .datastoreLocation(.applicationDefault), // persisted\n    .displayFrequency(.immediate),            // show right away\n    .displayFrequency(.daily),                // once per day\n    .displayFrequency(.weekly),               // once per week\n])",
                                   desc: ".displayFrequency controls how often tips can appear globally")

                        configStep(step: "3", title: "Reset for testing", color: Color(hex: "#7C3AED"),
                                   code: "// In DEBUG - reset all tip state\nTips.resetDatastore()\n// OR show all tips regardless of rules:\nTips.showAllTipsForTesting()",
                                   desc: "Essential for development - see every tip every time")
                    }

                default:
                    // Tip lifecycle diagram
                    VStack(spacing: 6) {
                        lifecycleStep(icon: "plus.circle.fill",        color: .tkAmber,   title: "Created",       desc: "Tip struct instantiated. Not yet visible.")
                        lifArrow
                        lifecycleStep(icon: "checkmark.circle.fill",   color: .formGreen, title: "Eligible",      desc: "All #Rule conditions pass. TipKit may show it.")
                        lifArrow
                        lifecycleStep(icon: "eye.fill",                color: .navBlue,   title: "Displayed",     desc: "TipView or .popoverTip() renders the tip card.")
                        lifArrow
                        HStack(spacing: 6) {
                            lifecycleStep(icon: "hand.tap.fill",       color: .envGreen,  title: "Actioned",      desc: "User tapped an action button.")
                            lifecycleStep(icon: "xmark.circle.fill",   color: .animCoral, title: "Invalidated",   desc: "User dismissed or max count reached.")
                        }
                        lifArrow
                        lifecycleStep(icon: "archivebox.fill",         color: .secondary, title: "Finished",      desc: "Tip won't show again. State persisted in datastore.")

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.tkAmber)
                            Text("TipKit persists tip state to disk - dismissals and action events survive app restarts.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tkAmberLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    var lifArrow: some View {
        HStack { Spacer(); Image(systemName: "arrow.down").font(.system(size: 11)).foregroundStyle(.secondary); Spacer() }
    }

    func anatomyBlock(icon: String, color: Color, label: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon).font(.system(size: 13)).foregroundStyle(color).frame(width: 18)
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.system(size: 9, weight: .semibold, design: .monospaced)).foregroundStyle(color)
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func configStep(step: String, title: String, color: Color, code: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle().fill(color).frame(width: 22, height: 22)
                Text(step).font(.system(size: 11, weight: .bold)).foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 11, weight: .semibold))
                Text(code).font(.system(size: 8, design: .monospaced)).foregroundStyle(color)
                    .padding(5).background(color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 5))
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(8).background(Color(.systemFill).opacity(0.3)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func lifecycleStep(icon: String, color: Color, title: String, desc: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 14)).foregroundStyle(color).frame(width: 18)
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.system(size: 11, weight: .semibold)).foregroundStyle(color)
                Text(desc).font(.system(size: 9)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct TKFundamentalsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "TipKit - in-app feature tips")
            Text("TipKit (iOS 17+) provides a standardised system for showing feature discovery tips. Tips persist their state across launches, respect display frequency, support display rules, and integrate with the system tip store.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "import TipKit - add the framework. No SPM package needed, it's built in.", color: .tkAmber)
                StepRow(number: 2, text: "try? Tips.configure() in App.init() - must run before any view renders.", color: .tkAmber)
                StepRow(number: 3, text: "struct MyTip: Tip - define title, message, image, rules, actions.", color: .tkAmber)
                StepRow(number: 4, text: "TipView(tip) or .popoverTip(tip) - present the tip inline or as a popover.", color: .tkAmber)
                StepRow(number: 5, text: "TipKit persists all state - dismissed tips stay dismissed across app restarts.", color: .tkAmber)
            }

            CalloutBox(style: .warning, title: "Configure before first render", contentBody: "Tips.configure() must be called before SwiftUI renders any view that contains tips. The best place is App.init(). Calling it later can cause tips to not appear correctly or state to be inconsistent.")

            CodeBlock(code: """
import TipKit

// 1. App setup
@main struct MyApp: App {
    init() {
        try? Tips.configure([
            .datastoreLocation(.applicationDefault)
        ])
    }
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

// 2. Define a tip
struct MyTip: Tip {
    var title: Text    { Text("Did you know?") }
    var message: Text? { Text("Long press any item to see more options.") }
    var image: Image?  { Image(systemName: "hand.tap.fill") }
}

// 3. Show it
struct ContentView: View {
    let tip = MyTip()
    var body: some View {
        TipView(tip)           // inline card
        // OR
        Button("Action") { }
            .popoverTip(tip)   // floating popover
    }
}
""")
        }
    }
}
