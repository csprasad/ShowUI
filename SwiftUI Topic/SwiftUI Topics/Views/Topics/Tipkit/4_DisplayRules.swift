//
//
//  4_DisplayRules.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import TipKit

// MARK: - LESSON 4: Display Rules
struct TKDisplayRulesVisual: View {
    @State private var selectedDemo    = 0
    @State private var appLaunchCount  = 0
    @State private var hasCompletedTour = false
    @State private var isProUser       = false
    @State private var tapCount        = 0

    // Simulate rule evaluation
    var ruleAResult: String {
        appLaunchCount >= 3 ? "✓ Pass (launches: \(appLaunchCount))" : "✗ Fail (need 3, have \(appLaunchCount))"
    }
    var ruleBResult: String {
        hasCompletedTour ? "✓ Pass" : "✗ Fail (tour not done)"
    }
    var ruleCResult: String {
        isProUser ? "✓ Pass" : "✗ Fail (not Pro)"
    }
    var allPass: Bool { appLaunchCount >= 3 && hasCompletedTour }
    var proTipEligible: Bool { isProUser && appLaunchCount >= 1 }

    let demos = ["#Rule anatomy", "Multiple rules", "MaxDisplayCount"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Display rules", systemImage: "checklist.checked")
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
                    // #Rule anatomy
                    VStack(spacing: 8) {
                        codeBlock("""
struct SearchTip: Tip {
    // @Parameter enables rules to observe this value
    @Parameter static var hasUsedSearch: Bool = false

    var rules: [Rule] {[
        // Rule 1: must have used search at least once
        #Rule(Self.$hasUsedSearch) { $0 == true },

        // Rule 2: parameter-based count threshold
        #Rule(Self.$searchCount) { $0 >= 3 },

        // Rule 3: applicationState (built-in)
        // Only show when app is in foreground
        #Rule(Tips.applicationState) {
            $0 == .active
        }
    ]}
}
""")

                        ruleTypeRow(icon: "#Rule(param) { condition }",      color: .tkAmber,
                                    desc: "Custom @Parameter - observe any static Bool, Int, etc.")
                        ruleTypeRow(icon: "#Rule(Tips.applicationState) { }", color: Color(hex: "#0F766E"),
                                    desc: "Built-in: app must be active, not in background")
                        ruleTypeRow(icon: "#Rule(Tips.isOnline) { $0 }",     color: Color(hex: "#1D4ED8"),
                                    desc: "Built-in: device must have network connectivity (iOS 18)")

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.tkAmber)
                            Text("ALL rules must pass for a tip to be eligible. Rules are AND-combined.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tkAmberLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // Multiple rules - live simulator
                    VStack(spacing: 10) {
                        Text("Adjust values to see tip eligibility change").font(.system(size: 11)).foregroundStyle(.secondary)

                        VStack(spacing: 8) {
                            // Launch count
                            HStack(spacing: 8) {
                                Text("App launches:").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 90)
                                Stepper(value: $appLaunchCount, in: 0...10) {
                                    Text("\(appLaunchCount)").font(.system(size: 14, weight: .bold, design: .monospaced)).foregroundStyle(Color.tkAmber)
                                        .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: appLaunchCount)
                                }
                            }
                            Toggle("Completed onboarding", isOn: $hasCompletedTour.animation()).tint(.tkAmber).font(.system(size: 13))
                        }
                        .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

                        // Rule results
                        ruleResult("launches >= 3", result: ruleAResult, pass: appLaunchCount >= 3)
                        ruleResult("hasCompletedTour == true", result: ruleBResult, pass: hasCompletedTour)

                        // Overall
                        HStack(spacing: 10) {
                            Image(systemName: allPass ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(allPass ? Color.formGreen : Color.animCoral)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(allPass ? "Tip is ELIGIBLE - would show now" : "Tip is BLOCKED - rules not met")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(allPass ? Color.formGreen : Color.animCoral)
                                Text("All rules must pass")
                                    .font(.system(size: 10)).foregroundStyle(.secondary)
                            }
                        }
                        .padding(10)
                        .background(allPass ? Color(hex: "#E1F5EE") : Color(hex: "#FCEBEB"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .animation(.spring(response: 0.3), value: allPass)
                    }

                default:
                    // MaxDisplayCount
                    VStack(spacing: 8) {
                        codeBlock("""
struct SearchTip: Tip {
    // Only show this tip at most 3 times
    var options: [Option] {[
        Tips.MaxDisplayCount(3)
    ]}

    // Or show only once:
    var options: [Option] {[
        Tips.MaxDisplayCount(1)
    ]}
}

// Invalidate manually from code:
myTip.invalidate(reason: .actionPerformed)
myTip.invalidate(reason: .tipClosed)

// Check current status:
switch myTip.status {
case .available:    showTip()
case .invalidated:  print("tip was dismissed")
case .pending:      print("rules not met yet")
}
""")
                        maxCountRow("MaxDisplayCount(1)",   desc: "Show exactly once. Best for critical one-time tips.")
                        maxCountRow("MaxDisplayCount(3)",   desc: "Show up to 3 times - user might need a reminder.")
                        maxCountRow("No option set",        desc: "Default: show indefinitely until dismissed or actioned.")

                        HStack(spacing: 6) {
                            Image(systemName: "lightbulb.fill").font(.system(size: 12)).foregroundStyle(Color.tkGold)
                            Text("MaxDisplayCount(1) is most common for production apps - show each tip once and trust the user.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tkAmberLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    func ruleTypeRow(icon: String, color: Color, desc: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(icon).font(.system(size: 9, design: .monospaced)).foregroundStyle(color)
                .padding(5).background(color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 5))
            Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
        }
        .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func ruleResult(_ rule: String, result: String, pass: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: pass ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 13)).foregroundStyle(pass ? Color.formGreen : Color.animCoral)
            Text(rule).font(.system(size: 10, design: .monospaced)).foregroundStyle(.primary)
            Spacer()
            Text(result).font(.system(size: 9)).foregroundStyle(pass ? Color.formGreen : Color.animCoral)
        }
        .padding(8).background(pass ? Color(hex: "#E1F5EE") : Color(hex: "#FCEBEB"))
        .clipShape(RoundedRectangle(cornerRadius: 7))
        .animation(.spring(response: 0.3), value: pass)
    }

    func maxCountRow(_ title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "repeat.circle.fill").font(.system(size: 13)).foregroundStyle(Color.tkAmber)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(Color.tkAmber)
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }
        .padding(8).background(Color.tkAmberLight.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func codeBlock(_ t: String) -> some View {
        Text(t).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.tkAmber)
            .padding(8).background(Color.tkAmberLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct TKDisplayRulesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Display rules - when to show a tip")
            Text("#Rule macros define conditions that must ALL pass before a tip is eligible. Rules observe @Parameter properties and built-in conditions. Tips only appear when every rule passes - perfect for contextual feature discovery.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@Parameter static var myBool = false - declare a static parameter on the tip.", color: .tkAmber)
                StepRow(number: 2, text: "#Rule(Self.$myBool) { $0 == true } - rule that passes when myBool is true.", color: .tkAmber)
                StepRow(number: 3, text: "Update from outside: MyTip.myBool = true - setting triggers rule re-evaluation.", color: .tkAmber)
                StepRow(number: 4, text: "Tips.MaxDisplayCount(n) in options - limit how many times a tip can appear.", color: .tkAmber)
                StepRow(number: 5, text: "tip.invalidate(reason:) - programmatically dismiss a tip from code.", color: .tkAmber)
            }

            CalloutBox(style: .success, title: "Design rules thoughtfully", contentBody: "The best tips are contextually relevant - shown exactly when a user would benefit from knowing about a feature. Use @Parameter to track user actions (has used feature X, completed step Y) and only show tips after those conditions are met.")

            CodeBlock(code: """
struct ExportTip: Tip {
    // Parameters observe state changes
    @Parameter static var hasCreatedDocument: Bool = false
    @Parameter static var exportCount: Int = 0

    var rules: [Rule] {[
        // Show only after user has a document
        #Rule(Self.$hasCreatedDocument) { $0 == true },
        // Show only if they haven't exported yet
        #Rule(Self.$exportCount) { $0 == 0 }
    ]}

    var options: [Option] {[
        Tips.MaxDisplayCount(1)  // once only
    ]}
}

// Trigger rules from your view logic
func userCreatedDocument() {
    ExportTip.hasCreatedDocument = true  // may unlock tip
}

func userExported() {
    ExportTip.exportCount += 1           // may invalidate tip
}
""")
        }
    }
}

