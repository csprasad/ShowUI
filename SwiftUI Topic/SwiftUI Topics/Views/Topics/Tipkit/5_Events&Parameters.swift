//
//
//  5_Events&Parameters.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import TipKit

// MARK: - LESSON 5: Events & Parameters
struct TKEventsVisual: View {
    @State private var selectedDemo     = 0
    @State private var parameterValue   = false
    @State private var donationCount    = 0
    @State private var eventLog: [String] = []
    @State private var featureUseCount  = 0
    @State private var tipStatus        = "pending"
    let demos = ["@Parameter", "Events.donate()", "Trigger patterns"]

    var parameterTipEligible: Bool { parameterValue }
    var eventTipEligible: Bool { donationCount >= 3 }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Events & parameters", systemImage: "bolt.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tkAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; donationCount = 0; eventLog = []; parameterValue = false }
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
                    // @Parameter live demo
                    VStack(spacing: 10) {
                        PlainCodeBlock(fgColor: Color.tkAmber, bgColor: Color.tkAmberLight, code: """
struct FeatureTip: Tip {
    // Static @Parameter - observable by TipKit
    @Parameter
    static var hasCompletedOnboarding: Bool = false

    var rules: [Rule] {[
        #Rule(Self.$hasCompletedOnboarding) {
            $0 == true
        }
    ]}
}
""")

                        VStack(spacing: 8) {
                            Toggle("hasCompletedOnboarding", isOn: $parameterValue.animation())
                                .tint(.tkAmber).font(.system(size: 13))
                                .padding(.horizontal, 12).padding(.vertical, 10)
                                .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

                            // Simulated tip card appears when rule passes
                            Group {
                                if parameterTipEligible {
                                    simulatedTipCard(
                                        icon: "star.fill", iconColor: .tkGold,
                                        title: "You unlocked Pro tips!",
                                        message: "Since you've completed onboarding, here are some advanced features.",
                                        badge: "ELIGIBLE"
                                    )
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                } else {
                                    HStack(spacing: 8) {
                                        Image(systemName: "xmark.circle.fill").foregroundStyle(Color.animCoral)
                                        Text("Tip blocked - rule not met")
                                            .font(.system(size: 12)).foregroundStyle(.secondary)
                                    }
                                    .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                                    .transition(.opacity)
                                }
                            }
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: parameterTipEligible)

                            PlainCodeBlock(fgColor: Color.tkAmber, bgColor: Color.tkAmberLight, code: "// Update from anywhere:\nFeatureTip.hasCompletedOnboarding = true\n// TipKit observes the change - rule re-evaluates")
                        }
                    }

                case 1:
                    // Events.donate() demo
                    VStack(spacing: 10) {
                        PlainCodeBlock(fgColor: Color.tkAmber, bgColor: Color.tkAmberLight, code: """
struct SearchTip: Tip {
    // Event counts how many times action occurs
    static let searchPerformed = Event(
        id: "searchPerformed"
    )

    var rules: [Rule] {[
        // Show after 3 searches
        #Rule(Self.searchPerformed) {
            $0.donations.count >= 3
        }
    ]}
}
""")

                        VStack(spacing: 8) {
                            // Event counter
                            HStack(spacing: 10) {
                                VStack(spacing: 3) {
                                    Text("\(donationCount)").font(.system(size: 32, weight: .bold, design: .monospaced))
                                        .foregroundStyle(donationCount >= 3 ? Color.formGreen : Color.tkAmber)
                                        .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: donationCount)
                                    Text("donations").font(.system(size: 10)).foregroundStyle(.secondary)
                                }
                                .frame(width: 80)

                                VStack(spacing: 4) {
                                    Text("Need 3 to unlock").font(.system(size: 11)).foregroundStyle(.secondary)
                                    ProgressView(value: min(Double(donationCount), 3), total: 3)
                                        .tint(donationCount >= 3 ? Color.formGreen : Color.tkAmber)
                                        .animation(.spring(response: 0.3), value: donationCount)
                                }
                            }
                            .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

                            Button("Donate event (simulate search)") {
                                withAnimation(.spring(bounce: 0.3)) {
                                    donationCount = min(donationCount + 1, 10)
                                    eventLog.insert("Event donated (\(donationCount) total)", at: 0)
                                }
                            }
                            .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(donationCount >= 3 ? Color.formGreen : Color.tkAmber)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .buttonStyle(PressableButtonStyle())

                            if eventTipEligible {
                                simulatedTipCard(icon: "magnifyingglass", iconColor: .tkAmber,
                                                 title: "Try filters!", message: "Use filters to narrow your search results.",
                                                 badge: "UNLOCKED")
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }

                            // Log
                            VStack(alignment: .leading, spacing: 3) {
                                ForEach(eventLog.prefix(3), id: \.self) { entry in
                                    HStack(spacing: 5) {
                                        Circle().fill(Color.tkAmber).frame(width: 5, height: 5)
                                        Text(entry).font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                                    }
                                }
                                if eventLog.isEmpty { Text("(no events yet)").font(.system(size: 9)).foregroundStyle(Color(.systemGray4)) }
                            }
                            .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .animation(.spring(response: 0.4), value: eventTipEligible)
                    }

                default:
                    // Trigger patterns
                    VStack(spacing: 8) {
                        triggerRow(pattern: "After N uses",
                                   code: "#Rule(Self.featureUsed) { $0.donations.count >= 5 }",
                                   desc: "Show a tip after the user has used a feature 5 times - they're ready for advanced info")
                        triggerRow(pattern: "After time gap",
                                   code: "#Rule(Self.appOpened) {\n    $0.donations.last?.date < Date().addingTimeInterval(-86400)\n}",
                                   desc: "Show after 24 hours since last app open - avoids overwhelming new users")
                        triggerRow(pattern: "Boolean trigger",
                                   code: "@Parameter static var isPro = false\n#Rule(Self.$isPro) { $0 == true }",
                                   desc: "Show only to Pro users - set the @Parameter when subscription is confirmed")
                        triggerRow(pattern: "Combined events",
                                   code: "#Rule(Self.itemCreated) { $0.count >= 1 }\n#Rule(Self.$hasShared) { !$0 }",
                                   desc: "Show share tip after creating first item, but only if they've never shared")
                    }
                }
            }
        }
    }

    func simulatedTipCard(icon: String, iconColor: Color, title: String, message: String, badge: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon).font(.system(size: 22)).foregroundStyle(iconColor)
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(title).font(.system(size: 13, weight: .semibold))
                    Text(badge).font(.system(size: 8, weight: .bold)).foregroundStyle(.white)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(iconColor).clipShape(Capsule())
                }
                Text(message).font(.system(size: 11)).foregroundStyle(.secondary)
            }
        }
        .padding(12).background(iconColor.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(iconColor.opacity(0.3), lineWidth: 1))
    }

    func triggerRow(pattern: String, code: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(pattern).font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.tkAmber)
            Text(code).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.tkAmber)
                .padding(5).background(Color.tkAmberLight).clipShape(RoundedRectangle(cornerRadius: 5))
            Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(Color(.systemGray6)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct TKEventsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Events and @Parameter")
            Text("Events track how many times an action has occurred. Donating an event increments a counter that rules can check. @Parameter tracks any boolean or integer state. Together they let you show tips at exactly the right moment.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "static let myEvent = Event(id: \"eventId\") - declare on the Tip struct.", color: .tkAmber)
                StepRow(number: 2, text: "await MyTip.myEvent.donate() - call when the action occurs. async, safe to call on main actor.", color: .tkAmber)
                StepRow(number: 3, text: "#Rule(Self.myEvent) { $0.donations.count >= 3 } - trigger after 3 donations.", color: .tkAmber)
                StepRow(number: 4, text: "@Parameter static var myFlag: Bool - observable boolean or integer state.", color: .tkAmber)
                StepRow(number: 5, text: "MyTip.myFlag = true - setting triggers immediate rule re-evaluation.", color: .tkAmber)
            }

            CalloutBox(style: .info, title: "Events are persisted automatically", contentBody: "Event donations are stored in the TipKit datastore and persist across launches. You don't need to track them yourself - TipKit counts total lifetime donations and uses them to evaluate rules.")

            CodeBlock(code: """
struct FilterTip: Tip {
    // Event - counts occurrences
    static let searchPerformed = Event(id: "searchPerformed")

    // @Parameter - boolean state
    @Parameter static var hasEnabledFilters = false

    var rules: [Rule] {[
        // Show after 3 searches
        #Rule(Self.searchPerformed) {
            $0.donations.count >= 3
        },
        // Only if filters not yet enabled
        #Rule(Self.$hasEnabledFilters) { !$0 }
    ]}
}

// In your view - donate when search happens
Button("Search") {
    performSearch()
    Task { await FilterTip.searchPerformed.donate() }
}

// When user enables filters - rule becomes false
Button("Enable Filters") {
    FilterTip.hasEnabledFilters = true
}
""")
        }
    }
}
