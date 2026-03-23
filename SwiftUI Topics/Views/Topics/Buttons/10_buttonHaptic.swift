//
//
//  10_buttonHaptic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 10: Haptic Feedback
struct HapticVisual: View {
    @State private var lastFeedback = "None yet"
    @State private var rippleID = UUID()
 
    struct HapticOption {
        let name: String
        let subtitle: String
        let color: Color
        let action: () -> Void
    }
 
    var options: [HapticOption] {[
        HapticOption(name: "Light impact", subtitle: ".light — subtle, non-intrusive", color: Color(hex: "#B5D4F4")) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        },
        HapticOption(name: "Medium impact", subtitle: ".medium — standard interaction", color: Color.btnPurple) {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        },
        HapticOption(name: "Heavy impact", subtitle: ".heavy — strong, noticeable", color: Color(hex: "#3C3489")) {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        },
        HapticOption(name: "Rigid", subtitle: ".rigid — sharp, mechanical", color: Color.animAmber) {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        },
        HapticOption(name: "Soft", subtitle: ".soft — muffled, cushioned", color: Color.animTeal) {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        },
        HapticOption(name: "Success", subtitle: "Notification — task completed", color: Color.sfGreen) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        },
        HapticOption(name: "Warning", subtitle: "Notification — needs attention", color: Color.animAmber) {
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        },
        HapticOption(name: "Error", subtitle: "Notification — something failed", color: Color.animCoral) {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        },
        HapticOption(name: "Selection", subtitle: "UISelectionFeedbackGenerator — picker change", color: Color.animPink) {
            UISelectionFeedbackGenerator().selectionChanged()
        },
    ]}
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Haptic feedback", systemImage: "waveform.path")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.btnPurple)
 
                // Last feedback
                HStack(spacing: 6) {
                    Image(systemName: "waveform").font(.system(size: 11)).foregroundStyle(.secondary)
                    Text(lastFeedback).font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
 
                // Haptic buttons grid
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 1)
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(options.indices, id: \.self) { i in
                        let opt = options[i]
                        Button {
                            opt.action()
                            lastFeedback = opt.name
                            rippleID = UUID()
                        } label: {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(opt.color)
                                    .frame(width: 10, height: 10)
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(opt.name)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(.primary)
                                    Text(opt.subtitle)
                                        .font(.system(size: 11))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "waveform.path")
                                    .font(.system(size: 14))
                                    .foregroundStyle(opt.color)
                            }
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .background(lastFeedback == opt.name ? opt.color.opacity(0.08) : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
 
                Text("Tap each button to feel the difference")
                    .font(.system(size: 11)).foregroundStyle(.tertiary)
            }
        }
    }
}
 
struct HapticExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Haptic feedback")
            Text("Haptic feedback communicates information through touch. Apple's Taptic Engine can produce precise, nuanced patterns, which can use them to confirm actions, signal errors, and make interactions feel physical.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            SectionHeader(text: "UIImpactFeedbackGenerator — physical collisions")
            VStack(spacing: 8) {
                hapticRow(".light",  "Subtle confirmation. Toggle switches, quiet acknowledgements.")
                hapticRow(".medium", "Standard tap feedback. Most button presses.")
                hapticRow(".heavy",  "Strong impact. Drag-and-drop drops, significant actions.")
                hapticRow(".rigid",  "Sharp mechanical feel. Snapping into place.")
                hapticRow(".soft",   "Muffled, cushioned. Gentle interactions.")
            }
 
            SectionHeader(text: "UINotificationFeedbackGenerator — outcomes")
            VStack(spacing: 8) {
                hapticRow(".success", "Task completed successfully.")
                hapticRow(".warning", "Something needs attention.")
                hapticRow(".error",   "Something went wrong.")
            }
 
            SectionHeader(text: "UISelectionFeedbackGenerator — value changes")
            VStack(spacing: 8) {
                hapticRow(".selectionChanged", "Picker scrolls, slider value changes, segment changes.")
            }
 
            CalloutBox(style: .warning, title: "Prepare for lower latency", contentBody: "Call .prepare() on a generator before you need it, especially for time-critical interactions like gesture-driven feedback. The engine warms up and reduces the delay between trigger and physical output.")
 
            CalloutBox(style: .info, title: "Use sparingly", contentBody: "Haptics are powerful precisely because they're rare. Triggering impact feedback on every keystroke or scroll event desensitises users and drains the battery. Use them for meaningful moments only.")
 
            CodeBlock(code: """
// Impact — most common
let impact = UIImpactFeedbackGenerator(style: .medium)
impact.prepare()  // warm up the engine
impact.impactOccurred()
 
// Notification — outcomes
let notification = UINotificationFeedbackGenerator()
notification.notificationOccurred(.success)
notification.notificationOccurred(.warning)
notification.notificationOccurred(.error)
 
// Selection — value changes
let selection = UISelectionFeedbackGenerator()
selection.selectionChanged()
 
// In a Button action
Button { 
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    performAction()
} label: { Text("Confirm") }
 
// In SwiftUI via sensoryFeedback (iOS 17+)
Button("Like") { isLiked.toggle() }
    .sensoryFeedback(.impact, trigger: isLiked)
""")
        }
    }
 
    func hapticRow(_ name: String, _ description: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(name)
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundStyle(Color.btnPurple)
                .frame(width: 120, alignment: .leading)
            Text(description)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .lineSpacing(2)
            Spacer()
        }
        .padding(10)
        .background(Color.btnPurpleLight)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
 
