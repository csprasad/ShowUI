//
//
//  5_environment.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `01/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI


// MARK: - LESSON 5: @Environment
struct EnvironmentVisual: View {
    // Read system environment values
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.horizontalSizeClass) var sizeClass

    @State private var showChild = true
    @State private var customTheme = AppTheme(accentColor: .sbOrange, isDense: false)

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("@Environment", systemImage: "leaf.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sbOrange)

                // System environment values
                VStack(alignment: .leading, spacing: 8) {
                    sectionLabel("System environment values")
                    VStack(spacing: 6) {
                        envRow("colorScheme", value: colorScheme == .dark ? ".dark" : ".light", icon: "circle.lefthalf.filled")
                        envRow("dynamicTypeSize", value: ".\(dynamicTypeSize)", icon: "textformat.size")
                        envRow("horizontalSizeClass", value: sizeClass == .compact ? ".compact" : ".regular", icon: "rectangle.split.2x1")
                    }
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Custom environment injection
                VStack(alignment: .leading, spacing: 8) {
                    sectionLabel("Custom value injected via .environment()")

                    HStack(spacing: 10) {
                        Toggle("Dense layout", isOn: $customTheme.isDense)
                            .font(.system(size: 13)).tint(.sbOrange)
                    }

                    // Child reads from environment
                    EnvironmentChildView()
                        .environment(customTheme)
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    func sectionLabel(_ text: String) -> some View {
        Text(text).font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
    }

    func envRow(_ key: String, value: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 13)).foregroundStyle(Color.sbOrange).frame(width: 20)
            Text(key).font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary)
            Spacer()
            Text(value).font(.system(size: 12, weight: .semibold, design: .monospaced)).foregroundStyle(.primary)
        }
    }
}

// Custom environment value
@Observable
class AppTheme {
    var accentColor: Color
    var isDense: Bool
    init(accentColor: Color, isDense: Bool) {
        self.accentColor = accentColor
        self.isDense = isDense
    }
}

struct EnvironmentChildView: View {
    @Environment(AppTheme.self) var theme

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(theme.accentColor)
                .frame(width: 16, height: 16)
            Text("Child reads AppTheme from environment")
                .font(.system(size: theme.isDense ? 11 : 13))
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(theme.isDense ? 8 : 12)
        .background(theme.accentColor.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .animation(.spring(duration: 0.3), value: theme.isDense)
    }
}

struct EnvironmentExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "@Environment")
            Text("@Environment reads values from the surrounding view tree - either system-provided values like colorScheme and locale, or custom values you inject with .environment(). It's how SwiftUI passes shared context without threading it through every view's init.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@Environment(\\.colorScheme) reads the current appearance. Many system values are available this way.", color: .sbOrange)
                StepRow(number: 2, text: "@Environment(MyType.self) reads a custom @Observable object injected by an ancestor.", color: .sbOrange)
                StepRow(number: 3, text: ".environment(myObject) on a parent injects it into the entire subtree - all descendants can read it.", color: .sbOrange)
                StepRow(number: 4, text: "@Environment(\\.dismiss) and @Environment(\\.openURL) are SwiftUI actions passed the same way.", color: .sbOrange)
            }

            CalloutBox(style: .success, title: "Great for app-wide values", contentBody: "Theme, user session, feature flags, localization - things many views need but that don't belong in every view's init parameters. Inject once at the root, read anywhere.")

            CalloutBox(style: .info, title: "System environment keys", contentBody: "SwiftUI provides dozens: colorScheme, locale, calendar, timeZone, dynamicTypeSize, horizontalSizeClass, verticalSizeClass, layoutDirection, undoManager, dismiss, openURL, and more.")

            CodeBlock(code: """
// Read system values
@Environment(\\.colorScheme) var scheme
@Environment(\\.dismiss) var dismiss
@Environment(\\.dynamicTypeSize) var typeSize

// Inject custom @Observable at root
@main struct MyApp: App {
    @State var theme = AppTheme()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(theme)  // available everywhere
        }
    }
}

// Read custom value anywhere in the tree
struct DeepChildView: View {
    @Environment(AppTheme.self) var theme

    var body: some View {
        Text("Hello")
            .foregroundStyle(theme.accentColor)
    }
}
""")
        }
    }
}

