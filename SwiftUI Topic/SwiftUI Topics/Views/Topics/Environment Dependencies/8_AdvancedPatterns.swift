//
//
//  8_AdvancedPatterns.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Advanced Patterns
struct AdvancedEnvVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Nested overrides", "Namespace isolation", "Common pitfalls"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Advanced patterns", systemImage: "exclamationmark.triangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.envGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.envGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.envGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Nested overrides - inner wins
                    VStack(spacing: 8) {
                        Text("Inner .environment wins - closest ancestor's value is used").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        nestedBlock(
                            title: "Root: .environment(\\.font, .body)",
                            color: .envGreen,
                            children: [
                                ("Middle: .environment(\\.font, .title2)", Color.navBlue, [
                                    ("Leaf: no override - reads .title2", Color(hex: "#7C3AED")),
                                    ("Leaf override: .environment(\\.font, .caption) → reads .caption", Color(hex: "#C2410C")),
                                ]),
                            ]
                        )

                        PlainCodeBlock(fgColor: Color.envGreen, bgColor: Color.envGreenLight, code:"""
VStack {
    Text("body")             // inherits root: .body

    VStack {
        Text("title2")       // inherits middle: .title2
        Text("caption")      // reads its own: .caption
            .environment(\\.font, .caption)
    }
    .environment(\\.font, .title2)
}
.environment(\\.font, .body)
""")
                    }

                case 1:
                    // Namespace isolation
                    VStack(spacing: 8) {
                        Text("Inject different values in different branches").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        HStack(spacing: 8) {
                            branchBlock("Branch A\nAdmin panel", color: .envGreen,
                                        env: ".environment(\\.featureFlags, adminFlags)")
                            branchBlock("Branch B\nGuest panel", color: .navBlue,
                                        env: ".environment(\\.featureFlags, guestFlags)")
                        }

                        PlainCodeBlock(fgColor: Color.envGreen, bgColor: Color.envGreenLight, code:"""
// Different feature flags per branch
HStack {
    AdminPanel()
        .environment(\\.featureFlags,
            FeatureFlags(showBeta: true, debugMode: true))

    GuestPanel()
        .environment(\\.featureFlags,
            FeatureFlags(showBeta: false, debugMode: false))
}
// Each branch reads its own flags - fully isolated
""")
                    }

                default:
                    // Pitfalls
                    VStack(spacing: 8) {
                        pitfall(bad: true,  title: "Injecting in wrong direction",
                                code: "// Child trying to push env to parent - won't work!\nparentView.environment(\\.key, value)",
                                fix: "Environment flows DOWN only. Use PreferenceKey to pass data up.")
                        pitfall(bad: true,  title: "Mutable reference type as EnvironmentKey",
                                code: "struct MyKey: EnvironmentKey {\n    static var defaultValue = SomeClass()\n    // Shared mutable reference - mutations leak across subtrees!",
                                fix: "Use @Observable class injected via .environment(model), or a value type for EnvironmentKey.")
                        pitfall(bad: true,  title: "Reading environment outside body",
                                code: "let x = @Environment(\\.myKey) var key\n// Accessing outside body - invalid",
                                fix: "@Environment is only valid during body evaluation. Never store/pass the wrapper.")
                        pitfall(bad: true,  title: "Forgetting environmentObject crash",
                                code: "@EnvironmentObject var store: Store\n// Crash: 'No Store in view hierarchy'",
                                fix: "Always inject .environmentObject(store) at the root. Or switch to @Observable + .environment(store).")
                        pitfall(bad: false, title: "Correct: type-safe @Observable injection",
                                code: "ContentView()\n    .environment(myStore)  // inject @Observable\n\n// Read:\n@Environment(Store.self) var store  // type-safe",
                                fix: "✓ No crash - type-based lookup with optional variant available.")
                    }
                }
            }
        }
    }

    func nestedBlock(title: String, color: Color, children: [(String, Color, [(String, Color)])]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.system(size: 9, design: .monospaced)).foregroundStyle(.white)
                .padding(6).frame(maxWidth: .infinity, alignment: .leading)
                .background(color).clipShape(RoundedRectangle(cornerRadius: 6))
            ForEach(children, id: \.0) { child in
                VStack(alignment: .leading, spacing: 4) {
                    Text(child.0).font(.system(size: 9, design: .monospaced)).foregroundStyle(.white)
                        .padding(5).frame(maxWidth: .infinity, alignment: .leading)
                        .background(child.1).clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.leading, 8)
                    ForEach(child.2, id: \.0) { leaf in
                        Text(leaf.0).font(.system(size: 8, design: .monospaced)).foregroundStyle(.white)
                            .padding(5).frame(maxWidth: .infinity, alignment: .leading)
                            .background(leaf.1).clipShape(RoundedRectangle(cornerRadius: 5))
                            .padding(.leading, 16)
                    }
                }
            }
        }
    }

    func branchBlock(_ title: String, color: Color, env: String) -> some View {
        VStack(spacing: 4) {
            Text(title).font(.system(size: 10, weight: .semibold)).foregroundStyle(.white).multilineTextAlignment(.center)
            Text(env).font(.system(size: 8, design: .monospaced)).foregroundStyle(.white.opacity(0.8)).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(10)
        .background(color.opacity(0.7)).clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func pitfall(bad: Bool, title: String, code: String, fix: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: bad ? "xmark.circle.fill" : "checkmark.circle.fill")
                    .font(.system(size: 12)).foregroundStyle(bad ? Color.animCoral : Color.formGreen)
                Text(title).font(.system(size: 11, weight: .semibold))
            }
            Text(code).font(.system(size: 8, design: .monospaced)).foregroundStyle(bad ? Color.animCoral : Color.formGreen)
                .padding(5).background(bad ? Color(hex: "#FCEBEB") : Color(hex: "#E1F5EE")).clipShape(RoundedRectangle(cornerRadius: 5))
            if bad {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.right").font(.system(size: 9)).foregroundStyle(Color.envGreen)
                    Text(fix).font(.system(size: 10)).foregroundStyle(Color.envGreen)
                }
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(bad ? Color(hex: "#FCEBEB") : Color(hex: "#E1F5EE")).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct AdvancedEnvExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Advanced environment patterns")
            Text("Understanding how environment values scope and override enables powerful architectural patterns - per-branch configuration, preview isolation, and conditional feature flags - while avoiding the common pitfalls that cause crashes and hard-to-debug bugs.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Inner override wins - the closest ancestor's .environment() call takes precedence.", color: .envGreen)
                StepRow(number: 2, text: "Subtree isolation - inject different values in different branches for independent configuration.", color: .envGreen)
                StepRow(number: 3, text: "Preview isolation - override any environment value in #Preview to test edge cases.", color: .envGreen)
                StepRow(number: 4, text: "Don't use class instances as EnvironmentKey defaultValue - shared mutable state leaks.", color: .envGreen)
                StepRow(number: 5, text: "Environment flows down only - use PreferenceKey for up, @Observable model for sideways.", color: .envGreen)
            }

            CalloutBox(style: .success, title: "The three data flow directions", contentBody: "Down: @Environment, @EnvironmentObject - parent → child. Up: PreferenceKey - child → ancestor. Sideways/shared: @Observable injected via .environment() - any view in the subtree reads and writes the same instance.")

            CodeBlock(code: """
// Nested overrides - inner wins
Text("Large")
    .environment(\\.font, .largeTitle)
    .overlay(
        Text("Small")
            .environment(\\.font, .caption) // this wins
    )

// Subtree isolation - A/B config
HStack {
    FeatureView()
        .environment(\\.flags, .beta)     // beta features

    LegacyView()
        .environment(\\.flags, .stable)   // stable only
}

// Preview isolation
#Preview("RTL Arabic") {
    MyView()
        .environment(\\.locale, Locale(identifier: "ar"))
        .environment(\\.layoutDirection, .rightToLeft)
}

#Preview("Accessibility XL") {
    MyView()
        .environment(\\.dynamicTypeSize, .accessibility3)
        .environment(\\.colorScheme, .dark)
}
""")
        }
    }
}

