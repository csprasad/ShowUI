//
//
//  6_DependencyInjectionPatterns.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Dependency Injection Patterns
// Service protocols for DI demo
protocol AnalyticsServiceProtocol {
    func track(_ event: String)
    var eventLog: [String] { get }
}

@Observable
class LiveAnalyticsService: AnalyticsServiceProtocol {
    var eventLog: [String] = []
    func track(_ event: String) { eventLog.insert("[\(Date().formatted(.dateTime.hour().minute().second()))] \(event)", at: 0) }
}

@Observable
class MockAnalyticsService: AnalyticsServiceProtocol {
    var eventLog: [String] = []
    func track(_ event: String) { eventLog.insert("[MOCK] \(event)", at: 0) }
}

// Environment key for the service
private struct AnalyticsKey: EnvironmentKey {
    static var defaultValue: any AnalyticsServiceProtocol = LiveAnalyticsService()
}
extension EnvironmentValues {
    var analytics: any AnalyticsServiceProtocol {
        get { self[AnalyticsKey.self] }
        set { self[AnalyticsKey.self] = newValue }
    }
}

struct DIPatternVisual: View {
    @State private var selectedDemo = 0
    @State private var useMock      = false
    @State private var liveService  = LiveAnalyticsService()
    @State private var mockService  = MockAnalyticsService()
    let demos = ["Protocol + Env key", "Service locator", "Container pattern"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Dependency injection patterns", systemImage: "arrow.triangle.branch")
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
                    // Protocol + EnvironmentKey DI
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Text("Analytics impl:").font(.system(size: 12)).foregroundStyle(.secondary)
                            Toggle("Use mock", isOn: $useMock.animation()).tint(.envGreen).font(.system(size: 12))
                        }

                        // Analytics consumer - reads from environment
                        AnalyticsConsumer()
                            .environment(\.analytics, (useMock ? mockService : liveService) as any AnalyticsServiceProtocol)

                        // Event log
                        let service: any AnalyticsServiceProtocol = (useMock ? mockService : liveService)
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Image(systemName: "list.bullet.rectangle").foregroundStyle(Color.envGreen).font(.system(size: 11))
                                Text("Event log (\(useMock ? "mock" : "live"))").font(.system(size: 11, weight: .semibold))
                            }
                            
                            ForEach(service.eventLog.prefix(4), id: \.self) { entry in
                                Text(entry).font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            if service.eventLog.isEmpty {
                                Text("(no events yet)").font(.system(size: 9)).foregroundStyle(Color(.systemGray4))
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // Service locator
                    VStack(spacing: 8) {
                        PlainCodeBlock(fgColor: Color.envGreen, bgColor: Color.envGreenLight, code: """
// Service Locator - global registry
final class ServiceLocator {
    static let shared = ServiceLocator()
    private var services: [ObjectIdentifier: Any] = [:]

    func register<T>(_ service: T) {
        services[ObjectIdentifier(T.self)] = service
    }
    func resolve<T>() -> T {
        guard let s = services[ObjectIdentifier(T.self)] as? T
        else { fatalError("\\(T.self) not registered") }
        return s
    }
}

// Register at app start
ServiceLocator.shared.register(
    LiveAnalytics() as AnalyticsProtocol
)
ServiceLocator.shared.register(
    NetworkService() as NetworkProtocol
)

// Resolve anywhere
let analytics: AnalyticsProtocol
    = ServiceLocator.shared.resolve()
""")

                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 12)).foregroundStyle(Color.animAmber)
                            Text("Service locator hides dependencies - prefer environment-based DI for SwiftUI. Use locator only for non-view code like background tasks.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color(hex: "#FAEEDA")).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // Container pattern
                    VStack(spacing: 8) {
                        PlainCodeBlock(fgColor: Color.envGreen, bgColor: Color.envGreenLight, code: """
// AppContainer holds all dependencies
@Observable
final class AppContainer {
    // Lazy service initialisation
    lazy var analytics: AnalyticsProtocol = {
        #if DEBUG
        return MockAnalytics()
        #else
        return LiveAnalytics()
        #endif
    }()
    lazy var network: NetworkProtocol = {
        NetworkService(baseURL: Config.apiURL)
    }()
    lazy var auth: AuthService = {
        AuthService(network: network)
    }()
}

// Inject once at root
@main struct App: App {
    @State private var container = AppContainer()

    var body: some Scene {
        WindowGroup { RootView() }
            .environment(container)
    }
}

// Child views access via environment
struct ProfileView: View {
    @Environment(AppContainer.self) var container

    var body: some View {
        Button("Logout") {
            container.auth.logout()
            container.analytics.track("logout")
        }
    }
}
""")
                    }
                }
            }
        }
    }
}

private struct AnalyticsConsumer: View {
    @Environment(\.analytics) var analytics

    var body: some View {
        VStack(spacing: 6) {
            Text("Analytics consumer view").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
            HStack(spacing: 6) {
                ForEach(["tap", "view", "purchase", "error"], id: \.self) { event in
                    Button(event) { analytics.track(event) }
                        .font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
                        .frame(minWidth: 30)
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(Color.envGreen).clipShape(RoundedRectangle(cornerRadius: 7))
                        .buttonStyle(PressableButtonStyle())
                }
            }
        }.frame(maxWidth: .infinity)
        .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct DIPatternExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Dependency injection in SwiftUI")
            Text("SwiftUI's environment is a first-class DI container. Protocol-backed services injected via custom EnvironmentKey give you testable, swappable dependencies without any third-party frameworks.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Protocol → struct EnvironmentKey { defaultValue: Protocol = LiveImpl() }", color: .envGreen)
                StepRow(number: 2, text: ".environment(\\.analytics, MockAnalytics()) in tests/previews - swap implementation.", color: .envGreen)
                StepRow(number: 3, text: "@Environment(\\.analytics) var analytics - read the current implementation.", color: .envGreen)
                StepRow(number: 4, text: "AppContainer pattern - @Observable class holding all lazy service properties.", color: .envGreen)
                StepRow(number: 5, text: "#if DEBUG checks inside container give correct impl automatically.", color: .envGreen)
            }

            CalloutBox(style: .success, title: "Environment DI is testable by default", contentBody: "Every SwiftUI view can be tested in isolation by providing mock implementations via the environment. No static singletons, no global state - each view subtree gets exactly the dependencies it needs.")

            CodeBlock(code: """
// Protocol
protocol AnalyticsProtocol {
    func track(_ event: String)
}

// Key with live default
struct AnalyticsKey: EnvironmentKey {
    static var defaultValue: any AnalyticsProtocol
        = LiveAnalytics()
}

extension EnvironmentValues {
    var analytics: any AnalyticsProtocol {
        get { self[AnalyticsKey.self] }
        set { self[AnalyticsKey.self] = newValue }
    }
}

// Production injection
App().environment(\\.analytics, LiveAnalytics())

// Test / preview injection
MyView().environment(\\.analytics, MockAnalytics())

// Usage in view
@Environment(\\.analytics) var analytics
analytics.track("button_tapped")
""")
        }
    }
}


