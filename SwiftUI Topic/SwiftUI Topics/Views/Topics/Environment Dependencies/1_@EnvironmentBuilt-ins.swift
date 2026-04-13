//
//
//  1_@EnvironmentBuilt-ins.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `13/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: @Environment Built-ins
struct BuiltInEnvVisual: View {
    @Environment(\.colorScheme)     var colorScheme
    @Environment(\.dynamicTypeSize) var typeSize
    @Environment(\.locale)          var locale
    @Environment(\.calendar)        var calendar
    @Environment(\.timeZone)        var timeZone
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.isEnabled)       var isEnabled
    @Environment(\.dismiss)         var dismiss
    @Environment(\.openURL)         var openURL

    @State private var selectedDemo = 0
    @State private var forceScheme: ColorScheme? = nil
    @State private var forcedTypeSize: DynamicTypeSize = .large
    @State private var controlsEnabled = true

    let demos = ["Display values", "Override env", "Useful actions"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("@Environment built-ins", systemImage: "square.stack.3d.down.right.fill")
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
                    // Live environment values
                    VStack(spacing: 6) {
                        envRow("colorScheme",          value: colorScheme == .dark ? "dark" : "light",     icon: "circle.lefthalf.filled")
                        envRow("dynamicTypeSize",      value: "\(typeSize)",                               icon: "textformat.size")
                        envRow("locale.identifier",    value: locale.identifier,                           icon: "globe")
                        envRow("calendar.identifier",  value: "\(calendar.identifier)",                    icon: "calendar")
                        envRow("timeZone.identifier",  value: timeZone.identifier,                         icon: "clock")
                        envRow("horizontalSizeClass",  value: hSize == .compact ? "compact" : "regular",  icon: "rectangle.split.2x1")
                        envRow("isEnabled",            value: "\(isEnabled)",                              icon: "checkmark.circle")

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.envGreen)
                            Text("These values update automatically when the device changes - dark mode, font size, rotation etc.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.envGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // Override environment
                    VStack(spacing: 10) {
                        Toggle("Force dark mode", isOn: Binding(
                            get: { forceScheme == .dark },
                            set: { forceScheme = $0 ? .dark : .light }
                        ))
                        .tint(.envGreen).font(.system(size: 13))

                        // Inner view demonstrating override
                        VStack(spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "moon.fill").foregroundStyle(.yellow)
                                Text("This child's colorScheme:")
                                    .font(.system(size: 13))
                                Spacer()
                                Text(forceScheme == .dark ? "dark ✦" : "light ○")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(forceScheme == .dark ? .yellow : .secondary)
                            }
                            Text("Background responds to override")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(12)
                        .background(forceScheme == .dark ? Color(hex: "#1A1A2E") : Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemFill), lineWidth: 1))
                        .environment(\.colorScheme, forceScheme ?? colorScheme)
                        .animation(.easeInOut(duration: 0.3), value: forceScheme)

                        // Font size override
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Override dynamicTypeSize:").font(.system(size: 11)).foregroundStyle(.secondary)
                            Picker("Size", selection: $forcedTypeSize) {
                                Text("Small").tag(DynamicTypeSize.small)
                                Text("Large").tag(DynamicTypeSize.large)
                                Text("XXL").tag(DynamicTypeSize.xxLarge)
                                Text("Accessibility").tag(DynamicTypeSize.accessibility3)
                            }
                            .pickerStyle(.segmented)

                            Text("Preview text scales here")
                                .font(.body)
                                .frame(maxWidth: .infinity)
                                .environment(\.dynamicTypeSize, forcedTypeSize)
                                .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                                .animation(.spring(response: 0.3), value: forcedTypeSize)
                        }
                    }

                default:
                    // Action environments
                    VStack(spacing: 8) {
                        actionRow("\\.dismiss", icon: "chevron.left.circle.fill", desc: "Dismisses a sheet, popover, or navigation destination", example: ".toolbar { Button(\"Done\") { dismiss() } }")
                        actionRow("\\.openURL", icon: "safari.fill", desc: "Opens a URL - browser, app scheme, or mailto:", example: "Button(\"Docs\") { openURL(url) }")
                        actionRow("\\.openWindow", icon: "macwindow.badge.plus", desc: "Opens a named window group (macOS / iPadOS)", example: "openWindow(id: \"settings\")")
                        actionRow("\\.refresh", icon: "arrow.clockwise.circle.fill", desc: "Triggers the .refreshable pull-to-refresh action", example: "@Environment(\\.refresh) var refresh")
                        actionRow("\\.purchase", icon: "cart.circle.fill", desc: "StoreKit: trigger an in-app purchase flow", example: "@Environment(\\.purchase) var purchase")
                        actionRow("\\.requestReview", icon: "star.circle.fill", desc: "Request App Store review at the right moment", example: "@Environment(\\.requestReview) var req")
                    }
                }
            }
        }
    }

    func envRow(_ key: String, value: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 13)).foregroundStyle(Color.envGreen).frame(width: 20)
            Text(key).font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.envGreen).frame(maxWidth: .infinity, alignment: .leading)
            Text(value).font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10).padding(.vertical, 7)
        .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 7))
    }

    func actionRow(_ key: String, icon: String, desc: String, example: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon).font(.system(size: 14)).foregroundStyle(Color.envGreen).frame(width: 20)
            VStack(alignment: .leading, spacing: 3) {
                Text(key).font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(Color.envGreen)
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
                Text(example).font(.system(size: 8, design: .monospaced)).foregroundStyle(.secondary)
                    .padding(4).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(Color.envGreenLight.opacity(0.6)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct BuiltInEnvExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "@Environment - reading the system")
            Text("@Environment reads values injected into the view hierarchy by SwiftUI or the parent app. The framework provides dozens of built-in keys covering device state, accessibility settings, locale, actions, and scene phases.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@Environment(\\.colorScheme) var cs - reads the current light/dark mode.", color: .envGreen)
                StepRow(number: 2, text: "@Environment(\\.dynamicTypeSize) - the user's preferred accessibility font size.", color: .envGreen)
                StepRow(number: 3, text: "@Environment(\\.scenePhase) - .active, .inactive, .background - react to app lifecycle.", color: .envGreen)
                StepRow(number: 4, text: "@Environment(\\.dismiss) var dismiss - call dismiss() to pop navigation or close sheets.", color: .envGreen)
                StepRow(number: 5, text: ".environment(\\.colorScheme, .dark) - override any environment value for a subtree.", color: .envGreen)
            }

            CalloutBox(style: .success, title: "Override for previews and testing", contentBody: ".environment(\\.colorScheme, .dark) on a #Preview is the easiest way to test dark mode without changing system settings. Override any environment value to preview edge cases - large font, right-to-left locale, disabled state.")

            CodeBlock(code: """
// Read system environment
struct MyView: View {
    @Environment(\\.colorScheme)       var scheme
    @Environment(\\.dynamicTypeSize)   var typeSize
    @Environment(\\.locale)            var locale
    @Environment(\\.horizontalSizeClass) var hSize
    @Environment(\\.isEnabled)         var isEnabled

    var body: some View {
        Text(scheme == .dark ? "Dark" : "Light")
    }
}

// Action environments
struct DetailView: View {
    @Environment(\\.dismiss)   var dismiss
    @Environment(\\.openURL)   var openURL

    var body: some View {
        Button("Done")   { dismiss() }
        Button("Help")   { openURL(URL(string: "https://example.com")!) }
    }
}

// Override in previews
#Preview("Dark mode") {
    MyView()
        .environment(\\.colorScheme, .dark)
        .environment(\\.dynamicTypeSize, .accessibility1)
        .environment(\\.locale, Locale(identifier: "ar"))
}
""")
        }
    }
}
