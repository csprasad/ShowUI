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
    @State private var path = NavigationPath()
    @State private var selectedSection: String? = nil
    @State private var lastLink = "None"
 
    // Simulate different deep link scenarios
    let deepLinks: [(label: String, icon: String, description: String, action: String)] = [
        ("Open Swift",      "swift",                   "app://topic/swift",         "swift"),
        ("Open SwiftUI",    "rectangle.3.group.fill",  "app://topic/swiftui",       "swiftui"),
        ("Open item",       "doc.plaintext.fill",       "app://topic/swift/protocols","swift/protocols"),
        ("Reset to root",   "house.fill",               "app://",                    "root"),
    ]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Deep linking", systemImage: "link.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.navBlue)
 
                // Navigation stack that responds to deep links
                NavigationStack(path: $path) {
                    List(NavCategory.samples) { cat in
                        NavigationLink(value: cat) {
                            Label(cat.name, systemImage: cat.icon).foregroundStyle(cat.color)
                        }
                    }
                    .navigationTitle("Topics")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(for: NavCategory.self) { cat in
                        List(cat.items) { item in
                            NavigationLink(value: item) {
                                Label(item.name, systemImage: item.icon)
                            }
                        }
                        .navigationTitle(cat.name)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationDestination(for: NavItem.self) { item in
                            TypedItemDetail(item: item)
                        }
                    }
                }
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemFill), lineWidth: 1))
 
                // Simulated deep link triggers
                sectionLabel("Simulate incoming deep links")
                VStack(spacing: 6) {
                    ForEach(deepLinks, id: \.label) { link in
                        Button {
                            handleDeepLink(link.action)
                            lastLink = link.description
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: link.icon)
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.navBlue)
                                    .frame(width: 24)
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(link.label)
                                        .font(.system(size: 13, weight: .semibold))
                                    Text(link.description)
                                        .font(.system(size: 10, design: .monospaced))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "arrow.right.circle")
                                    .font(.system(size: 14)).foregroundStyle(Color.navBlue)
                            }
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
 
                HStack(spacing: 6) {
                    Image(systemName: "link").font(.system(size: 11)).foregroundStyle(Color.navBlue)
                    Text("Last: \(lastLink)")
                        .font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                }
                .padding(8).background(Color.navBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                .animation(.easeInOut(duration: 0.2), value: lastLink)
            }
        }
    }
 
    func handleDeepLink(_ action: String) {
        withAnimation(.spring(duration: 0.4)) {
            switch action {
            case "root":
                path = NavigationPath()
            case "swift":
                path = NavigationPath()
                path.append(NavCategory.samples[0])
            case "swiftui":
                path = NavigationPath()
                path.append(NavCategory.samples[1])
            case "swift/protocols":
                path = NavigationPath()
                path.append(NavCategory.samples[0])
                path.append(NavCategory.samples[0].items[0])
            default:
                break
            }
        }
    }
 
    func sectionLabel(_ text: String) -> some View {
        Text(text).font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
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
 
