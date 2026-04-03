//
//
//  4_deepLinking.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `03/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Deep Linking
struct DeepLinkVisual: View {
    @State private var selectedSource = 0
    @State private var animating = false
    @State private var destination = "?"

    let sources: [(name: String, icon: String, url: String, dest: String)] = [
        ("URL scheme",     "link.circle.fill",         "app://topic/swift",              "Swift category"),
        ("Notification",   "bell.fill",                "notification: new lesson",        "Swift → Protocols"),
        ("Widget tap",     "square.grid.2x2.fill",     "widget://featured",              "SwiftUI category"),
        ("Spotlight",      "magnifyingglass.circle.fill","spotlight://item/protocols",    "Protocols item"),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Deep linking", systemImage: "link.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.navBlue)

                // Flow diagram
                ZStack {
                    Color(.secondarySystemBackground)
                    VStack(spacing: 10) {
                        // Source -> handler -> path
                        HStack(spacing: 0) {
                            // Source
                            VStack(spacing: 4) {
                                Image(systemName: sources[selectedSource].icon)
                                    .font(.system(size: 22)).foregroundStyle(Color.navBlue)
                                Text(sources[selectedSource].name)
                                    .font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.navBlue)
                                Text(sources[selectedSource].url)
                                    .font(.system(size: 8, design: .monospaced)).foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center).lineLimit(2)
                            }
                            .frame(width: 90)

                            // Arrow + handler label
                            VStack(spacing: 2) {
                                Image(systemName: "arrow.right").font(.system(size: 12)).foregroundStyle(.secondary)
                                Text("parse\n& route").font(.system(size: 8)).foregroundStyle(.tertiary).multilineTextAlignment(.center)
                            }
                            .frame(width: 50)

                            // Result
                            VStack(spacing: 4) {
                                Image(systemName: "rectangle.stack.fill")
                                    .font(.system(size: 22)).foregroundStyle(Color(hex: "#1D9E75"))
                                Text("NavigationPath")
                                    .font(.system(size: 10, weight: .semibold)).foregroundStyle(Color(hex: "#1D9E75"))
                                Text("→ \(sources[selectedSource].dest)")
                                    .font(.system(size: 8)).foregroundStyle(Color(hex: "#1D9E75"))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 90)
                        }
                        .animation(.spring(response: 0.35), value: selectedSource)
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Source selector
                let cols = Array(repeating: GridItem(.flexible(), spacing: 6), count: 2)
                LazyVGrid(columns: cols, spacing: 6) {
                    ForEach(sources.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedSource = i }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: sources[i].icon)
                                    .font(.system(size: 13))
                                    .foregroundStyle(selectedSource == i ? Color.navBlue : .secondary)
                                Text(sources[i].name)
                                    .font(.system(size: 11, weight: selectedSource == i ? .semibold : .regular))
                                    .foregroundStyle(selectedSource == i ? Color.navBlue : .secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 10).padding(.vertical, 7)
                            .background(selectedSource == i ? Color.navBlueLight : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Key requirement
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 12)).foregroundStyle(Color.animAmber)
                    Text("NavigationPath must live high enough in the view tree for deep link handlers to reach it")
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                }
                .padding(10).background(Color(hex: "#FAEEDA")).clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

struct DeepLinkExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Deep linking")
            Text("Deep linking drives navigation to a specific screen from outside the app - a URL, push notification, widget tap, or Spotlight result. With NavigationPath, you handle this by resetting the path to the desired destination.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "Hold NavigationPath in @State at the app or scene level - not buried in a child view.", color: .navBlue)
                StepRow(number: 2, text: "When a deep link arrives, parse it and build the full path: path = NavigationPath([category, item]).", color: .navBlue)
                StepRow(number: 3, text: ".onOpenURL handles universal links and custom URL schemes - fires when the app is opened via URL.", color: .navBlue)
                StepRow(number: 4, text: "For notifications, read the userInfo in UNUserNotificationCenterDelegate and update the path.", color: .navBlue)
            }
 
            CalloutBox(style: .success, title: "Path at the right level", contentBody: "NavigationPath should live at the scene or app level - in your App struct or a root view model. If it's buried deep in a child view, you can't manipulate it from notification handlers or URL handlers.")
 
            CalloutBox(style: .info, title: "Scene restoration", contentBody: "Use @SceneStorage to persist the encoded NavigationPath across app launches. When the user returns, restore the path so they land exactly where they left off.")
 
            CodeBlock(code: """
@main
struct MyApp: App {
    @State private var path = NavigationPath()
 
    var body: some Scene {
        WindowGroup {
            RootView()
                .navigationPath(path)          // pass down via environment
                .onOpenURL { url in
                    path = parseURL(url)        // handle deep link
                }
        }
    }
}
 
// Parse URL into navigation path
func parseURL(_ url: URL) -> NavigationPath {
    var path = NavigationPath()
    // app://topic/swift/protocols
    let components = url.pathComponents.dropFirst()
    if let topic = findTopic(components.first) {
        path.append(topic)
        if let item = findItem(topic, components.dropFirst().first) {
            path.append(item)
        }
    }
    return path
}
 
// Handle push notification
func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse
) {
    let info = response.notification.request.content.userInfo
    if let screen = info["screen"] as? String {
        path = buildPath(for: screen)
    }
}
""")
        }
    }
}
 
