//
//
//  7_CloudKit&Sync.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import SwiftData

// MARK: - LESSON 7: CloudKit & Sync
struct SDCloudKitVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Setup", "Requirements", "Conflict handling"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("CloudKit & sync", systemImage: "icloud.and.arrow.up.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sdBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.sdBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.sdBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Setup steps
                    VStack(spacing: 8) {
                        setupStep("1", icon: "gearshape.fill", color: .sdBlue,
                                  title: "Enable iCloud + CloudKit capability",
                                  desc: "In Xcode: Target → Signing & Capabilities → + iCloud → CloudKit")
                        setupStep("2", icon: "cylinder.fill", color: Color(hex: "#0891B2"),
                                  title: "Use ModelConfiguration with cloudKitDatabase",
                                  desc: "Specify your CloudKit container identifier in the configuration")
                        setupStep("3", icon: "app.fill", color: .formGreen,
                                  title: "App entry point",
                                  desc: ".modelContainer(for:) automatically enables sync - no extra code")

                        codeBlock("""
@main struct MyApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
            .modelContainer(for: TodoItem.self,
                cloudKitDatabase: .automatic)
    }
}

// OR explicit container identifier:
let config = ModelConfiguration(
    cloudKitDatabase: .private("iCloud.com.myapp.todos")
)
let container = try ModelContainer(
    for: TodoItem.self,
    configurations: config
)
""")
                    }

                case 1:
                    // CloudKit requirements
                    VStack(spacing: 8) {
                        Text("CloudKit sync requirements for @Model").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        reqRow(good: true,  text: "All properties must be Optional or have default values")
                        reqRow(good: true,  text: "No unique constraints - @Attribute(.unique) not allowed with CloudKit")
                        reqRow(good: true,  text: "No non-optional relationships without cascade rules defined")
                        reqRow(good: false, text: "Required (non-optional) properties without defaults will fail sync")
                        reqRow(good: false, text: "@Attribute(.unique) - CloudKit cannot guarantee uniqueness across devices")
                        reqRow(good: false, text: "Enums stored as raw values need to be explicitly Codable")

                        codeBlock("""
// ✓ CloudKit-compatible @Model
@Model class TodoItem {
    var title: String = ""           // has default
    var isCompleted: Bool = false    // has default
    var priority: Int? = nil         // optional
    var createdAt: Date = Date()     // has default
}
""")
                    }

//                case 2:
//                    EmptyView()

                default:
                    // Conflict handling
                    VStack(spacing: 8) {
                        Text("How SwiftData/CloudKit handles conflicts").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        conflictRow(strategy: "Last-write-wins (default)",
                                    desc: "The most recently modified record wins. CloudKit uses server timestamp.",
                                    icon: "clock.fill", color: .sdBlue)
                        conflictRow(strategy: "Persistent history",
                                    desc: "Enable history tracking to see what changed and when - useful for UI 'last synced' badges.",
                                    icon: "clock.arrow.circlepath", color: Color(hex: "#0891B2"))
                        conflictRow(strategy: "Custom merge",
                                    desc: "For complex models, implement your own merge by comparing local vs remote timestamps before saving.",
                                    icon: "arrow.triangle.merge", color: Color(hex: "#7C3AED"))

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.sdBlue)
                            Text("SwiftData with CloudKit uses CKSyncEngine under the hood. Conflicts are rare when models are simple value objects.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    func setupStep(_ num: String, icon: String, color: Color, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle().fill(color).frame(width: 26, height: 26)
                Text(num).font(.system(size: 12, weight: .bold)).foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 11, weight: .semibold))
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }
        .padding(8).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func reqRow(good: Bool, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: good ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 12)).foregroundStyle(good ? Color.formGreen : Color.animCoral)
            Text(text).font(.system(size: 11)).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(7).background(good ? Color(hex: "#E1F5EE") : Color(hex: "#FCEBEB")).clipShape(RoundedRectangle(cornerRadius: 7))
    }

    func conflictRow(strategy: String, desc: String, icon: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon).font(.system(size: 14)).foregroundStyle(color).frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(strategy).font(.system(size: 11, weight: .semibold)).foregroundStyle(color)
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func codeBlock(_ text: String) -> some View {
        Text(text).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdBlue)
            .padding(8).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct SDCloudKitExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "CloudKit sync with SwiftData")
            Text("SwiftData integrates with CloudKit through ModelConfiguration. Add cloudKitDatabase: .automatic and SwiftData automatically syncs the store to the user's private iCloud database - no manual CKRecord handling.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Enable iCloud + CloudKit capability in Xcode project settings.", color: .sdBlue)
                StepRow(number: 2, text: ".modelContainer(for:, cloudKitDatabase: .automatic) - one parameter enables sync.", color: .sdBlue)
                StepRow(number: 3, text: "All stored properties must be optional or have defaults - CloudKit requirement.", color: .sdBlue)
                StepRow(number: 4, text: "@Attribute(.unique) is incompatible with CloudKit - remove for synced stores.", color: .sdBlue)
                StepRow(number: 5, text: "Sync works on device - no extra code needed. Data appears on all user's devices.", color: .sdBlue)
            }

            CalloutBox(style: .warning, title: "Optional properties required", contentBody: "CloudKit cannot guarantee all properties are present when syncing across devices running different app versions. All @Model properties used with CloudKit must be Optional or have a default value - otherwise sync will fail silently.")

            CodeBlock(code: """
// Minimal CloudKit setup
@main struct MyApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
            .modelContainer(for: TodoItem.self,
                cloudKitDatabase: .automatic)
    }
}

// CloudKit-compatible model
@Model class TodoItem {
    var title: String = ""          // default required
    var isDone: Bool = false        // default required
    var createdAt: Date = Date()    // default required
    var priority: Int? = nil        // optional - fine
    // @Attribute(.unique) - REMOVE for CloudKit!
}

// Multiple containers (local + cloud)
let cloudConfig = ModelConfiguration(
    "cloud",
    cloudKitDatabase: .automatic
)
let localConfig = ModelConfiguration(
    "local",
    isStoredInMemoryOnly: false,
    cloudKitDatabase: .none
)
""")
        }
    }
}
