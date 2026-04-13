//
//
//  2_CustomEnvironmentKey.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `13/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Custom EnvironmentKey

// Real custom keys for the demo
private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: AppThemeEnv = .init()
}

struct AppThemeEnv {
    var primary: Color   = .envGreen
    var secondary: Color = Color(hex: "#0D9488")
    var radius: CGFloat  = 12
    var fontWeight: Font.Weight = .medium
}

private struct FeatureFlagsKey: EnvironmentKey {
    static let defaultValue: FeatureFlagsEnv = .init()
}

struct FeatureFlagsEnv {
    var showBeta: Bool    = false
    var debugMode: Bool   = false
    var maxItems: Int     = 50
}

extension EnvironmentValues {
    var appTheme: AppThemeEnv {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
    var featureFlags: FeatureFlagsEnv {
        get { self[FeatureFlagsKey.self] }
        set { self[FeatureFlagsKey.self] = newValue }
    }
}

// Convenience modifier
extension View {
    func withAppTheme(_ theme: AppThemeEnv) -> some View {
        environment(\.appTheme, theme)
    }
    func withFeatureFlags(_ flags: FeatureFlagsEnv) -> some View {
        environment(\.featureFlags, flags)
    }
}

struct CustomEnvKeyVisual: View {
    @Environment(\.appTheme)     var theme
    @Environment(\.featureFlags) var flags

    @State private var selectedDemo = 0
    @State private var primaryColor = Color.envGreen
    @State private var cornerRadius: CGFloat = 12
    @State private var showBeta   = false
    @State private var debugMode  = false
    @State private var maxItems   = 10

    let demos = ["AppTheme key", "FeatureFlags key", "Scoped injection"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Custom EnvironmentKey", systemImage: "key.horizontal.fill")
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
                    // AppTheme live demo
                    VStack(spacing: 10) {
                        // Controls
                        VStack(spacing: 6) {
                            HStack(spacing: 8) {
                                Text("Primary color:").font(.system(size: 12)).foregroundStyle(.secondary)
                                ForEach([Color.envGreen, Color.navBlue, Color(hex: "#7C3AED"), Color.animCoral], id: \.self) { c in
                                    Button { withAnimation { primaryColor = c } } label: {
                                        Circle().fill(c).frame(width: 22, height: 22)
                                            .overlay(Circle().stroke(.white, lineWidth: primaryColor == c ? 2 : 0))
                                    }.buttonStyle(PressableButtonStyle())
                                }
                            }
                            HStack(spacing: 8) {
                                Text("Radius: \(Int(cornerRadius))").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 72)
                                Slider(value: $cornerRadius, in: 0...24, step: 2).tint(.envGreen)
                            }
                        }
                        .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

                        // Preview using the theme
                        ThemePreviewChild()
                            .environment(\.appTheme, AppThemeEnv(
                                primary: primaryColor,
                                secondary: primaryColor.opacity(0.6),
                                radius: cornerRadius,
                                fontWeight: .semibold
                            ))
                    }

                case 1:
                    // Feature flags demo
                    VStack(spacing: 8) {
                        VStack(spacing: 6) {
                            Toggle("Show beta features", isOn: $showBeta.animation()).tint(.envGreen).font(.system(size: 13))
                            Toggle("Debug mode",         isOn: $debugMode.animation()).tint(.animAmber).font(.system(size: 13))
                            HStack(spacing: 8) {
                                Text("Max items: \(maxItems)").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 90)
                                Stepper(value: $maxItems, in: 5...100, step: 5) { EmptyView() }.labelsHidden()
                            }
                        }
                        .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

                        // Child reads flags
                        FeatureFlagChild()
                            .environment(\.featureFlags, FeatureFlagsEnv(
                                showBeta: showBeta,
                                debugMode: debugMode,
                                maxItems: maxItems
                            ))
                    }

                default:
                    // Scoped injection - same key, different values at different levels
                    VStack(spacing: 8) {
                        Text("Environment values scope to their subtree").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        VStack(spacing: 6) {
                            scopeBlock("Root (.envGreen)", color: .envGreen, depth: 0)
                            HStack(spacing: 6) {
                                scopeBlock("Left branch\n(.navBlue override)", color: .navBlue, depth: 1)
                                scopeBlock("Right branch\n(.animCoral override)", color: .animCoral, depth: 1)
                            }
                            HStack(spacing: 6) {
                                scopeBlock("Deep child inherits\nLeft (.navBlue)", color: .navBlue, depth: 2)
                                scopeBlock("Deep child inherits\nRight (.animCoral)", color: .animCoral, depth: 2)
                            }
                        }

                        codeSnip(".environment(\\.appTheme, blueTheme)  // only left branch\n.environment(\\.appTheme, redTheme)   // only right branch")
                    }
                }
            }
        }
    }

    func scopeBlock(_ label: String, color: Color, depth: Int) -> some View {
        Text(label)
            .font(.system(size: 9, weight: .medium)).foregroundStyle(.white).multilineTextAlignment(.center)
            .frame(maxWidth: .infinity).padding(.vertical, 8)
            .background(color.opacity(0.8 - Double(depth) * 0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func codeSnip(_ text: String) -> some View {
        Text(text).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.envGreen)
            .padding(8).background(Color.envGreenLight).clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

private struct ThemePreviewChild: View {
    @Environment(\.appTheme) var theme

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "paintpalette.fill").foregroundStyle(theme.primary)
                Text("Themed child view").font(.system(size: 13, weight: theme.fontWeight))
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(theme.secondary)
            }
            .padding(12)
            .background(theme.primary.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: theme.radius))

            HStack(spacing: 8) {
                Text("Button").foregroundStyle(.white)
                    .font(.system(size: 12, weight: theme.fontWeight))
                    .padding(.horizontal, 16).padding(.vertical, 8)
                    .background(theme.primary)
                    .clipShape(RoundedRectangle(cornerRadius: theme.radius * 0.7))
                Spacer()
                Circle().fill(theme.secondary).frame(width: 32, height: 32)
            }
        }
        .animation(.spring(response: 0.3), value: theme.radius)
    }
}

private struct FeatureFlagChild: View {
    @Environment(\.featureFlags) var flags

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "flag.fill").foregroundStyle(Color.envGreen).font(.system(size: 11))
                Text("Feature flag state:").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.envGreen)
            }
            flagRow("showBeta",  value: flags.showBeta,  color: flags.showBeta ? .ssPurple : .secondary)
            flagRow("debugMode", value: flags.debugMode, color: flags.debugMode ? .animAmber : .secondary)
            HStack(spacing: 8) {
                Text("maxItems").font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.envGreen)
                Spacer()
                Text("\(flags.maxItems)").font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
            }
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding(10).background(Color.envGreenLight.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func flagRow(_ name: String, value: Bool, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: value ? "checkmark.circle.fill" : "circle").foregroundStyle(color)
            Text(name).font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.envGreen)
            Spacer()
            Text(value ? "true" : "false").font(.system(size: 10, design: .monospaced)).foregroundStyle(color)
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct CustomEnvKeyExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Custom EnvironmentKey")
            Text("EnvironmentKey lets you define your own typed values that flow down the view tree. Perfect for themes, feature flags, service objects, and configuration. Any view in the subtree can read the value without prop drilling.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "struct MyKey: EnvironmentKey { static let defaultValue: T = … } - declare the key with a default.", color: .envGreen)
                StepRow(number: 2, text: "extension EnvironmentValues { var myKey: T { get/set } } - expose via EnvironmentValues.", color: .envGreen)
                StepRow(number: 3, text: ".environment(\\.myKey, value) - inject at any level. Only that subtree receives the override.", color: .envGreen)
                StepRow(number: 4, text: "@Environment(\\.myKey) var myKey - read in any descendant view.", color: .envGreen)
                StepRow(number: 5, text: "extension View { func withTheme(_ t: Theme) -> some View { environment(\\.theme, t) } } - convenience modifier.", color: .envGreen)
            }

            CalloutBox(style: .info, title: "Default value matters", contentBody: "The defaultValue in EnvironmentKey is used when no parent has injected a value. Make it a sensible production default - never force-unwrap or use a dummy. This way views work correctly even when used outside a fully configured environment.")

            CodeBlock(code: """
// 1. Declare the key
struct ThemeKey: EnvironmentKey {
    static let defaultValue = AppTheme.default
}

// 2. Extend EnvironmentValues
extension EnvironmentValues {
    var theme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// 3. Convenience modifier (optional)
extension View {
    func themed(_ theme: AppTheme) -> some View {
        environment(\\.theme, theme)
    }
}

// 4. Inject at root
ContentView()
    .themed(.brand)

// 5. Read anywhere in subtree
struct CardView: View {
    @Environment(\\.theme) var theme
    var body: some View {
        RoundedRectangle(cornerRadius: theme.cornerRadius)
            .fill(theme.primaryColor)
    }
}
""")
        }
    }
}

