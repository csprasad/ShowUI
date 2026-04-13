//
//
//  14_SDPerformance&Debugging.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 14: Performance & Debugging
struct PerformanceDebugVisual: View {
    @State private var selectedDemo = 0
    let demos = ["SQL logging", "N+1 problem", "Instruments tips"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Performance & debugging", systemImage: "chart.xyaxis.line")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sdPurple)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.sdPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.sdPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // SQL logging
                    VStack(spacing: 8) {
                        codeBlock("""
// Enable CoreData SQL debug output
// In Xcode: Edit Scheme → Run → Arguments → + flag:
-com.apple.CoreData.SQLDebug 1
// Level 1 = SQL statements
// Level 3 = full verbosity with bind params

// Console output looks like:
// CoreData: sql: SELECT Z_PK, Z_OPT, ... FROM ZTODOITEM
//           WHERE ZISCOMPLETED = 0
//           ORDER BY ZCREATEDAT DESC LIMIT 20
// CoreData: annotation: fetched 7 objects

// Programmatic logging (for debugging in code)
UserDefaults.standard.set(1, forKey: "com.apple.CoreData.SQLDebug")
""")

                        codeBlock("""
// Swift Concurrency + SwiftData logging
// Set environment variable:
SWIFTDATA_VERBOSE_LOGGING=1

// Or enable CloudKit logging:
CK_LOGGING_LEVEL=5
""")

                        HStack(spacing: 6) {
                            Image(systemName: "terminal.fill").font(.system(size: 12)).foregroundStyle(Color.sdPurple)
                            Text("SQL Debug flag in scheme arguments is the quickest way to verify your queries are efficient.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // N+1 problem
                    VStack(spacing: 8) {
                        Text("The N+1 query problem").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        nPlusOneCard(
                            label: "✗ N+1 - bad",
                            code: "@Query var projects: [Project]\n\nbody {\n    ForEach(projects) { project in\n        Text(project.tasks.count)  // ← fault! 1 SQL per project\n        // 20 projects = 21 queries\n    }\n}",
                            color: .animCoral,
                            note: "Each project.tasks access fires a separate SELECT"
                        )
                        nPlusOneCard(
                            label: "✓ Prefetch - good",
                            code: "var descriptor = FetchDescriptor<Project>()\ndescriptor.relationshipKeyPathsForPrefetching\n    = [\\.tasks]\nlet projects = try context.fetch(descriptor)\n// 1 query for projects + 1 for all tasks = 2 total",
                            color: .formGreen,
                            note: "prefetching joins the relationship in one query"
                        )
                        nPlusOneCard(
                            label: "✓ fetchCount - counts only",
                            code: "// Don't fetch objects just to count them\nlet count = try context.fetchCount(\n    FetchDescriptor<Task>(\n        predicate: #Predicate { !$0.isDone }\n    )\n)  // SELECT COUNT(*) - zero objects materialised",
                            color: .formGreen,
                            note: "fetchCount generates a COUNT query, not a full fetch"
                        )
                    }

                default:
                    // Instruments tips
                    VStack(spacing: 8) {
                        instrumentTip(icon: "waveform.path.ecg",
                                      title: "Core Data Instrument",
                                      desc: "Profile → Add Instrument → Core Data. Shows every fetch, save, and fault. Identify slow queries and excessive faulting.")
                        instrumentTip(icon: "memorychip",
                                      title: "Memory Graph Debugger",
                                      desc: "Debug → Memory Graph in Xcode. Look for retain cycles involving @Model objects - common with closures capturing model objects.")
                        instrumentTip(icon: "clock.badge.fill",
                                      title: "Time Profiler",
                                      desc: "Time Profiler + Core Data together. Look for heavy main-thread time in -[NSManagedObjectContext save:] - move large saves to background.")
                        instrumentTip(icon: "list.bullet.clipboard",
                                      title: "SQLite Expert / DB Browser",
                                      desc: "Find the .sqlite file in app container. Open in DB Browser for SQLite to inspect the actual schema and data. Confirm indexes exist on frequently queried columns.")
                    }
                }
            }
        }
    }

    func nPlusOneCard(label: String, code: String, color: Color, note: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.system(size: 10, weight: .semibold)).foregroundStyle(color)
            Text(code).font(.system(size: 8, design: .monospaced)).foregroundStyle(color)
                .padding(6).background(color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 5))
            Text(note).font(.system(size: 10)).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func instrumentTip(icon: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon).font(.system(size: 14)).foregroundStyle(Color.sdPurple).frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 11, weight: .semibold))
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(Color.sdPurpleLight.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func codeBlock(_ text: String) -> some View {
        Text(text).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdPurple).frame(maxWidth: .infinity, alignment: .leading)
            .padding(8).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct PerformanceDebugExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Performance and debugging")
            Text("SwiftData generates SQL under the hood - understanding that SQL lets you identify and fix performance problems. SQL Debug logging, relationship prefetching, and Instruments are your primary tools.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "-com.apple.CoreData.SQLDebug 1 in launch arguments - prints every SQL statement to the console.", color: .sdPurple)
                StepRow(number: 2, text: "N+1 problem: accessing relationship in a ForEach fires 1 SQL per row - use prefetching.", color: .sdPurple)
                StepRow(number: 3, text: "descriptor.relationshipKeyPathsForPrefetching = [\\.tasks] - join relationship in one query.", color: .sdPurple)
                StepRow(number: 4, text: "context.fetchCount() - generates SELECT COUNT(*) without materialising objects.", color: .sdPurple)
                StepRow(number: 5, text: "Instruments → Core Data instrument - shows every fetch, save, fault and their duration.", color: .sdPurple)
            }

            CalloutBox(style: .warning, title: "Watch for faulting in lists", contentBody: "When SwiftData fetches objects, relationships start as 'faults' - placeholders. Accessing them triggers a SQL SELECT per object. In a list of 100 items, accessing item.category fires 100 extra queries. Enable SQL logging to spot this pattern immediately.")

            CodeBlock(code: """
// 1. Enable SQL logging in scheme
// Edit Scheme → Arguments → -com.apple.CoreData.SQLDebug 1

// 2. Fix N+1 with prefetching
var descriptor = FetchDescriptor<Post>(
    sortBy: [SortDescriptor(\\.publishedAt, order: .reverse)]
)
descriptor.relationshipKeyPathsForPrefetching = [
    \\.author,    // to-one
    \\.comments   // to-many
]
descriptor.fetchLimit = 20
let posts = try context.fetch(descriptor)
// Now: 1 query for posts + 1 for authors + 1 for comments

// 3. Count without fetching
let pendingCount = try context.fetchCount(
    FetchDescriptor<Order>(
        predicate: #Predicate { $0.status == "pending" }
    )
)
// SELECT COUNT(*) FROM ZORDER WHERE ZSTATUS = 'pending'
""")
        }
    }
}

