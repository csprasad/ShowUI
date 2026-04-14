//
//
//  6_TipCustomisation.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Tip Customisation
struct TKCustomisationVisual: View {
    @State private var selectedDemo   = 0
    @State private var showCustom1    = true
    @State private var showCustom2    = true
    @State private var showCustom3    = true
    let demos = ["Content options", "Custom actions", "TipViewStyle"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Tip customisation", systemImage: "paintbrush.pointed.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tkAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; showCustom1 = true; showCustom2 = true; showCustom3 = true }
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
                    // Content options
                    VStack(spacing: 10) {
                        // Title only
                        if showCustom1 {
                            customCard(
                                icon: nil, iconColor: nil,
                                title: "Title only tip",
                                message: nil,
                                actions: []
                            )
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        // Title + message
                        if showCustom2 {
                            customCard(
                                icon: "sparkles", iconColor: .tkGold,
                                title: "With icon & message",
                                message: "This tip has both an icon and a supporting message that explains the feature.",
                                actions: []
                            )
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        // Full tip
                        if showCustom3 {
                            customCard(
                                icon: "arrow.up.circle.fill", iconColor: .tkAmber,
                                title: "Full tip with actions",
                                message: "This tip shows all elements: icon, title, message, and action buttons.",
                                actions: [("Learn more", .tkAmber), ("Dismiss", .secondary)]
                            )
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        HStack(spacing: 8) {
                            Button("Reset") {
                                withAnimation(.spring(response: 0.4)) { showCustom1 = true; showCustom2 = true; showCustom3 = true }
                            }.smallTipButton()
                        }
                    }
                    .animation(.spring(response: 0.4), value: showCustom1)
                    .animation(.spring(response: 0.4), value: showCustom2)
                    .animation(.spring(response: 0.4), value: showCustom3)

                case 1:
                    // Custom actions
                    VStack(spacing: 8) {
                        codeBlock("""
struct ProTip: Tip {
    var title: Text { Text("Unlock Pro features") }
    var message: Text? {
        Text("Get unlimited exports and custom themes.")
    }
    var image: Image? { Image(systemName: "star.fill") }

    var actions: [Action] {[
        // Primary action
        Action(
            id: "upgrade",
            title: "Upgrade to Pro",
            perform: {
                // Called when action is tapped
                showUpgradeSheet = true
            }
        ),
        // Secondary action
        Action(id: "later", title: "Maybe later"),
    ]}
}

// Handle in popoverTip callback:
.popoverTip(proTip) { action in
    switch action.id {
    case "upgrade":
        showUpgradeSheet = true
        proTip.invalidate(reason: .actionPerformed)
    case "later":
        proTip.invalidate(reason: .actionPerformed)
    default: break
    }
}
""")
                    }

                default:
                    // TipViewStyle
                    VStack(spacing: 8) {
                        codeBlock("""
// Custom TipViewStyle
struct CompactTipStyle: TipViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 10) {
            configuration.image?
                .resizable().scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundStyle(.orange)

            VStack(alignment: .leading, spacing: 2) {
                configuration.title
                    .font(.system(size: 13, weight: .semibold))
                configuration.message?
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                configuration.tip.invalidate(
                    reason: .tipClosed
                )
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(Color.yellow.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// Apply
TipView(myTip)
    .tipViewStyle(CompactTipStyle())
""")

                        // Simulated compact style
                        HStack(spacing: 10) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 24)).foregroundStyle(Color.tkGold)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Compact tip style").font(.system(size: 13, weight: .semibold))
                                Text("This is a custom TipViewStyle - fully your own layout.").font(.system(size: 11)).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "xmark").font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(12)
                        .background(Color.tkAmberLight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.tkAmber.opacity(0.3), lineWidth: 1))
                    }
                }
            }
        }
    }

    func customCard(icon: String?, iconColor: Color?, title: String, message: String?, actions: [(String, Color)]) -> some View {
        HStack(alignment: .top, spacing: 10) {
            if let icon = icon, let color = iconColor {
                Image(systemName: icon).font(.system(size: 22)).foregroundStyle(color)
            }
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title).font(.system(size: 13, weight: .semibold))
                    Spacer()
                    Image(systemName: "xmark.circle.fill").font(.system(size: 16)).foregroundStyle(Color(.systemGray3))
                }
                if let message = message {
                    Text(message).font(.system(size: 11)).foregroundStyle(.secondary)
                }
                if !actions.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(actions, id: \.0) { action in
                            Text(action.0).font(.system(size: 12, weight: .semibold)).foregroundStyle(action.1)
                        }
                    }
                }
            }
        }
        .padding(12).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 12))
    }

    func smallTipButton() -> some View {
        self.font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 8)
            .background(Color.tkAmber).clipShape(RoundedRectangle(cornerRadius: 8))
            .buttonStyle(PressableButtonStyle())
    }

    func codeBlock(_ t: String) -> some View {
        Text(t).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.tkAmber)
            .padding(8).background(Color.tkAmberLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct TKCustomisationExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Customising tips")
            Text("Tips support image, title, message, and action buttons. TipViewStyle protocol lets you completely replace the default layout with your own. This powers compact banners, full-screen onboarding cards, and branded tip experiences.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "image, title, message - all computed properties returning Image? and Text.", color: .tkAmber)
                StepRow(number: 2, text: "var actions: [Action] - array of buttons shown at the bottom of the tip.", color: .tkAmber)
                StepRow(number: 3, text: "Action(id:title:) - action with a stable ID for handling taps.", color: .tkAmber)
                StepRow(number: 4, text: "struct MyStyle: TipViewStyle { func makeBody(configuration:) } - full layout control.", color: .tkAmber)
                StepRow(number: 5, text: "configuration.title / .message / .image - access tip content in custom style.", color: .tkAmber)
                StepRow(number: 6, text: "configuration.tip.invalidate(reason: .tipClosed) - dismiss from custom style.", color: .tkAmber)
            }

            CodeBlock(code: """
// Full tip definition
struct OnboardingTip: Tip {
    var title: Text {
        Text("Create your first project")
    }
    var message: Text? {
        Text("Projects help you organise your work by client or goal.")
    }
    var image: Image? {
        Image(systemName: "folder.badge.plus")
    }
    var actions: [Action] {[
        Action(id: "create", title: "Create Project"),
        Action(id: "skip", title: "Not now")
    ]}
}

// Custom style
struct BannerTipStyle: TipViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 12) {
            configuration.image?.foregroundStyle(.orange)
            configuration.title.font(.headline)
            Spacer()
            ForEach(configuration.actions, id: \\.id) { action in
                Button(action.title) {
                    configuration.tip.invalidate(reason: .actionPerformed)
                }
            }
        }
        .padding()
        .background(.yellow.opacity(0.2))
    }
}
""")
        }
    }
}

private extension View {
    func smallTipButton() -> some View {
        self.font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 8)
            .background(Color.tkAmber).clipShape(RoundedRectangle(cornerRadius: 8))
            .buttonStyle(PressableButtonStyle())
    }
}

