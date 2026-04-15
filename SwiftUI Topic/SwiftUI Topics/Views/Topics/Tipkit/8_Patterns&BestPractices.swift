//
//
//  8_Patterns&BestPractices.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Patterns & Best Practices
struct TKPatternsVisual: View {
    @State private var selectedDemo      = 0
    @State private var onboardingStep    = 0
    @State private var showOnboarding    = false
    let demos = ["Tip sequencing", "Onboarding flow", "Best practices"]

    let onboardingTips: [(icon: String, title: String, desc: String, color: Color)] = [
        ("plus.circle.fill",       "Create items",     "Tap the + button to add your first item to the list.", .tkAmber),
        ("magnifyingglass",        "Search & filter",  "Use the search bar to quickly find any item by name.", Color(hex: "#0F766E")),
        ("heart.fill",             "Save favourites",  "Tap the heart icon on any item to save it for later.", Color(hex: "#C2410C")),
        ("square.and.arrow.up",   "Share easily",     "Tap share to send items to friends via any app.",      Color(hex: "#7C3AED")),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Patterns & best practices", systemImage: "star.bubble.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tkAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; onboardingStep = 0; showOnboarding = false }
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
                    // Tip sequencing
                    VStack(spacing: 8) {
                        Text("Only one tip should appear at a time").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        PlainCodeBlock(fgColor: Color.tkAmber, bgColor: Color.tkAmberLight, code: """
// Sequencing via @Parameter dependencies
struct Step2Tip: Tip {
    // Only show step 2 after step 1 was seen
    @Parameter static var step1Completed = false

    var rules: [Rule] {[
        #Rule(Self.$step1Completed) { $0 == true }
    ]}
    var options: [Option] {[ Tips.MaxDisplayCount(1) ]}
}

struct Step3Tip: Tip {
    @Parameter static var step2Completed = false

    var rules: [Rule] {[
        #Rule(Self.$step2Completed) { $0 == true }
    ]}
    var options: [Option] {[ Tips.MaxDisplayCount(1) ]}
}

// In your view logic:
// After step 1 tip dismissed:
Step2Tip.step1Completed = true  // unlocks step 2
// After step 2 tip dismissed:
Step3Tip.step2Completed = true  // unlocks step 3
""")

                        sequenceRow(step: "1", tip: "WelcomeTip",  unlock: "Set Step2Tip.step1Completed = true on dismiss")
                        sequenceRow(step: "2", tip: "SearchTip",   unlock: "Set Step3Tip.step2Completed = true on dismiss")
                        sequenceRow(step: "3", tip: "FavouriteTip",unlock: "All tips complete - no further tips")
                    }

                case 1:
                    // Onboarding flow simulation
                    VStack(spacing: 10) {
                        if showOnboarding {
                            // Tip card
                            let tip = onboardingTips[onboardingStep]
                            VStack(spacing: 12) {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: tip.icon)
                                        .font(.system(size: 28)).foregroundStyle(tip.color)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(tip.title).font(.system(size: 15, weight: .bold))
                                        Text(tip.desc).font(.system(size: 12)).foregroundStyle(.secondary)
                                    }
                                }
                                .padding(14)
                                .background(tip.color.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(tip.color.opacity(0.3), lineWidth: 1))

                                // Progress dots
                                HStack(spacing: 6) {
                                    ForEach(onboardingTips.indices, id: \.self) { i in
                                        Circle()
                                            .fill(i <= onboardingStep ? tip.color : Color(.systemGray4))
                                            .frame(width: 6, height: 6)
                                    }
                                    Spacer()
                                    Text("\(onboardingStep + 1) of \(onboardingTips.count)")
                                        .font(.system(size: 11)).foregroundStyle(.secondary)
                                }

                                HStack(spacing: 8) {
                                    if onboardingStep < onboardingTips.count - 1 {
                                        Button("Next →") {
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { onboardingStep += 1 }
                                        }
                                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                                        .background(tip.color).clipShape(RoundedRectangle(cornerRadius: 10))
                                        .buttonStyle(PressableButtonStyle())
                                    } else {
                                        Button("Done ✓") {
                                            withAnimation(.spring(response: 0.4)) { showOnboarding = false; onboardingStep = 0 }
                                        }
                                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                                        .background(Color.formGreen).clipShape(RoundedRectangle(cornerRadius: 10))
                                        .buttonStyle(PressableButtonStyle())
                                    }

                                    Button("Skip") {
                                        withAnimation { showOnboarding = false; onboardingStep = 0 }
                                    }
                                    .font(.system(size: 13)).foregroundStyle(.secondary)
                                    .padding(.horizontal, 16).padding(.vertical, 10)
                                    .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }
                            .transition(.opacity.combined(with: .scale(scale: 0.97)))
                        } else {
                            Button("▶ Start onboarding flow") {
                                withAnimation(.spring(response: 0.4)) { showOnboarding = true; onboardingStep = 0 }
                            }
                            .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 12)
                            .background(Color.tkAmber).clipShape(RoundedRectangle(cornerRadius: 10))
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: onboardingStep)
                    .animation(.spring(response: 0.4), value: showOnboarding)

                default:
                    // Best practices
                    VStack(spacing: 8) {
                        practiceRow(good: true,
                                    title: "One tip at a time",
                                    desc: "Never show multiple tips simultaneously. Use @Parameter chaining to sequence them.")
                        practiceRow(good: true,
                                    title: "MaxDisplayCount(1) by default",
                                    desc: "Most tips should show exactly once. Trust the user.")
                        practiceRow(good: true,
                                    title: "Contextual timing via events",
                                    desc: "Show the share tip after user creates content - not at first launch.")
                        practiceRow(good: false,
                                    title: "Don't tip-bomb new users",
                                    desc: "Too many tips at launch is overwhelming. Gate tips behind meaningful interactions.")
                        practiceRow(good: false,
                                    title: "Don't tip critical UI",
                                    desc: "Tips are for feature discovery, not instructions for basic navigation.")
                        practiceRow(good: true,
                                    title: "Track tip interactions for analytics",
                                    desc: "Log when tips are shown and actioned to measure feature discovery effectiveness.")
                    }
                }
            }
        }
    }

    func sequenceRow(step: String, tip: String, unlock: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle().fill(Color.tkAmber).frame(width: 22, height: 22)
                Text(step).font(.system(size: 11, weight: .bold)).foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(tip).font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.tkAmber)
                Text(unlock).font(.system(size: 9)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(Color.tkAmberLight.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func practiceRow(good: Bool, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: good ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 12)).foregroundStyle(good ? Color.formGreen : Color.animCoral)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 11, weight: .semibold))
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(good ? Color(hex: "#E1F5EE") : Color(hex: "#FCEBEB"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct TKPatternsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "TipKit patterns and best practices")
            Text("Great tip design is about timing and restraint. Show tips when they're maximally useful - after a user has encountered the problem the feature solves. Never tip-bomb, always sequence, and respect that users learn at their own pace.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Sequence tips with @Parameter chaining - only unlock step N+1 after step N is dismissed.", color: .tkAmber)
                StepRow(number: 2, text: "MaxDisplayCount(1) by default - every tip should show exactly once in production.", color: .tkAmber)
                StepRow(number: 3, text: "Gate tips behind events - show the export tip after user creates their first document.", color: .tkAmber)
                StepRow(number: 4, text: "Track tip analytics - log .available, action tapped, .invalidated events.", color: .tkAmber)
                StepRow(number: 5, text: "Test with showAllTipsForTesting() in previews - iterate on copy and layout freely.", color: .tkAmber)
            }

            CalloutBox(style: .info, title: "Tips are not tutorials", contentBody: "TipKit is for feature discovery - highlighting things users might not find on their own. Don't use it to explain basic navigation or required steps. Those belong in onboarding screens, not tips. Tips are for the 'did you know?' moments.")

            CodeBlock(code: """
// Production app pattern - full setup
@main struct MyApp: App {
    init() {
        try? Tips.configure([
            .datastoreLocation(.applicationDefault),
            .displayFrequency(.immediate)
        ])

        #if DEBUG
        // Always show tips during development
        Tips.showAllTipsForTesting()
        #endif
    }
}

// Sequenced tip flow
struct FeatureTip1: Tip {
    var options: [Option] {[ Tips.MaxDisplayCount(1) ]}
}
struct FeatureTip2: Tip {
    @Parameter static var tip1Dismissed = false
    var rules: [Rule] {[
        #Rule(Self.$tip1Dismissed) { $0 }
    ]}
    var options: [Option] {[ Tips.MaxDisplayCount(1) ]}
}

// When tip 1 is dismissed
TipView(tip1)
    .onDisappear {
        FeatureTip2.tip1Dismissed = true
    }
""")
        }
    }
}

