//
//
//  5_@AppStorage&@SceneStorage.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `13/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: @AppStorage & @SceneStorage
struct StorageVisual: View {
    // AppStorage - persists across launches
    @AppStorage("username")         var username    = "Alice"
    @AppStorage("fontSize")         var fontSize    = 16.0
    @AppStorage("isDarkMode")       var isDarkMode  = false
    @AppStorage("launchCount")      var launchCount = 0
    @AppStorage("accentColorName")  var accentName  = "green"

    // SceneStorage - per scene, restored on relaunch
    @SceneStorage("draftMessage")   var draft       = ""
    @SceneStorage("currentTab")     var currentTab  = 0
    @SceneStorage("scrollPosition") var scrollPos   = 0.0

    @State private var selectedDemo = 0
    let demos = ["@AppStorage", "@SceneStorage", "Custom types"]

    var accentColor: Color {
        switch accentName {
        case "blue":   return Color.navBlue
        case "purple": return Color.ssPurple
        case "orange": return Color.scrollOrange
        default:        return Color.envGreen
        }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                storageHeader()

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
                    // AppStorage demo - changes actually persist via UserDefaults
                    VStack(spacing: 10) {
                        HStack(spacing: 6) {
                            Image(systemName: "externaldrive.badge.checkmark").foregroundStyle(Color.envGreen).font(.system(size: 12))
                            Text("Changes persist in UserDefaults - survive app restarts")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.envGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))

                        // Username
                        HStack(spacing: 8) {
                            Text("Username:").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 70)
                            TextField("Name", text: $username)
                                .textFieldStyle(.roundedBorder).font(.system(size: 13))
                        }

                        // Font size
                        HStack(spacing: 8) {
                            Text("Font size:").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 70)
                            Slider(value: $fontSize, in: 10...28, step: 1).tint(.envGreen)
                            Text("\(Int(fontSize))pt").font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.envGreen).frame(width: 32)
                        }

                        // Accent color
                        HStack(spacing: 8) {
                            Text("Accent:").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 70)
                            ForEach(["green", "blue", "purple", "orange"], id: \.self) { name in
                                Button { withAnimation { accentName = name } } label: {
                                    let color: Color = {
                                        switch name {
                                        case "green": return Color.envGreen
                                        case "blue": return Color.navBlue
                                        case "purple": return Color.ssPurple
                                        default: return Color.scrollOrange
                                        }
                                    }()
                                    Circle()
                                        .fill(color)
                                        .frame(width: 22, height: 22)
                                        .overlay(
                                            Circle().stroke(Color.white, lineWidth: accentName == name ? 2.5 : 0)
                                        )
                                }.buttonStyle(PressableButtonStyle())
                            }
                        }

                        // Preview
                        VStack(spacing: 6) {
                            HStack(spacing: 8) {
                                Image(systemName: "person.circle.fill").font(.system(size: CGFloat(fontSize))).foregroundStyle(accentColor)
                                Text("Hello, \(username)!")
                                    .font(.system(size: CGFloat(fontSize), weight: .bold))
                                    .foregroundStyle(accentColor)
                                    .animation(.spring(response: 0.2), value: CGFloat(fontSize))
                                    .contentTransition(.opacity)
                            }
                            Button("Track launch") {
                                withAnimation { launchCount += 1 }
                            }
                            .font(.system(size: CGFloat(fontSize), weight: .semibold)).foregroundStyle(.white)
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(accentColor).clipShape(RoundedRectangle(cornerRadius: 8))
                            .buttonStyle(PressableButtonStyle())
                            Text("Launches tracked: \(launchCount)")
                                .font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary)
                        }.frame(maxWidth: .infinity)
                        .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                case 1:
                    // SceneStorage
                    VStack(spacing: 10) {
                        HStack(spacing: 6) {
                            Image(systemName: "rectangle.on.rectangle.angled").foregroundStyle(Color.envGreen).font(.system(size: 12))
                            Text("@SceneStorage restores per-scene state after app is killed - great for draft text and scroll position")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.envGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))

                        // Draft message
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Draft message (restored after force-quit)").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            TextEditor(text: $draft)
                                .frame(height: 70).font(.system(size: 13))
                                .padding(6).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                            Text("\(draft.count) chars - saved automatically").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                        }

                        // Tab selection
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Active tab (per-scene)").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            Picker("Tab", selection: $currentTab) {
                                Text("Feed").tag(0); Text("Search").tag(1); Text("Profile").tag(2)
                            }
                            .pickerStyle(.segmented)
                        }

                        // Comparison table
                        HStack(spacing: 8) {
                            compCell("@AppStorage", bullets: ["UserDefaults backed", "Shared across all scenes", "Persists forever"], color: Color.envGreen)
                            compCell("@SceneStorage", bullets: ["Scene state backed", "Per-window / scene", "Cleared on scene end"], color: Color.envTeal)
                        }
                    }

                default:
                    // Custom types with AppStorage
                    VStack(spacing: 8) {
                        PlainCodeBlock(fgColor: Color.envGreen, bgColor: Color.envGreenLight, code: """
// Store Codable types in AppStorage
struct UserPrefs: Codable {
    var theme: String = "default"
    var notificationsOn: Bool = true
    var badgeCount: Int = 0
}

// Via RawRepresentable conformance
extension UserPrefs: RawRepresentable {
    init?(rawValue: String) {
        guard let d = rawValue.data(using: .utf8),
              let v = try? JSONDecoder().decode(Self.self, from: d)
        else { return nil }
        self = v
    }
    var rawValue: String {
        (try? String(data: JSONEncoder().encode(self), encoding: .utf8)) ?? ""
    }
}

// Now use directly
@AppStorage("userPrefs") var prefs = UserPrefs()
// Reads/writes entire struct as JSON string in UserDefaults
""")

                        PlainCodeBlock(fgColor: Color.envGreen, bgColor: Color.envGreenLight, code: """
// Enum with RawRepresentable (simpler)
enum SortOrder: String {
    case nameAZ, nameZA, newest
}
@AppStorage("sortOrder") var sort = SortOrder.newest

// Then just:
sort = .nameAZ   // auto-persisted
""")
                    }
                }
            }
        }
    }

    @ViewBuilder
    func storageHeader() -> some View {
        Label("@AppStorage & @SceneStorage", systemImage: "externaldrive.fill")
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Color.envGreen)
    }

    func compCell(_ title: String, bullets: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.system(size: 10, weight: .semibold)).foregroundStyle(color)
            ForEach(bullets, id: \.self) { b in
                HStack(spacing: 3) { Text("·").foregroundStyle(color); Text(b).font(.system(size: 9)).foregroundStyle(.secondary) }
            }
        }.frame(maxWidth: .infinity)
        .padding(8).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 8)).frame(maxWidth: .infinity)
    }
}

struct StorageExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "@AppStorage and @SceneStorage")
            Text("@AppStorage binds directly to UserDefaults - changes persist across app launches automatically. @SceneStorage binds to per-scene state that SwiftUI restores when the scene reactivates - perfect for draft text and scroll position.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@AppStorage(\"key\") var x = default - reads/writes UserDefaults. Standard, suite, or iCloud KV.", color: .envGreen)
                StepRow(number: 2, text: "Supported types: Bool, Int, Double, String, URL, Data - and RawRepresentable.", color: .envGreen)
                StepRow(number: 3, text: "Custom types: conform to RawRepresentable with JSON encoding/decoding.", color: .envGreen)
                StepRow(number: 4, text: "@SceneStorage(\"key\") var x = default - per scene, restored on scene activation.", color: .envGreen)
                StepRow(number: 5, text: "@AppStorage(\"key\", store: .suite) - use a custom UserDefaults suite (e.g. App Groups).", color: .envGreen)
            }

            CalloutBox(style: .info, title: "App Group for widget and extension sharing", contentBody: "@AppStorage(\"key\", store: UserDefaults(suiteName: \"group.com.yourapp\")) - use the same suite name in your widget and app extension. Both read and write to the shared container.")

            CodeBlock(code: """
// Basic types - auto-persisted
@AppStorage("isDarkMode") var isDark = false
@AppStorage("fontSize")   var size: Double = 16
@AppStorage("username")   var name = ""

// Custom UserDefaults suite (App Groups)
@AppStorage("count", store: UserDefaults(
    suiteName: "group.com.myapp.shared"
)) var sharedCount = 0

// SceneStorage - per-window draft
@SceneStorage("draft") var draft = ""
@SceneStorage("selectedTab") var tab = 0

// Codable struct via RawRepresentable
@AppStorage("settings") var settings = AppSettings()

// React to external changes
.onChange(of: isDark) { _, newValue in
    applyTheme(dark: newValue)
}
""")
        }
    }
}
