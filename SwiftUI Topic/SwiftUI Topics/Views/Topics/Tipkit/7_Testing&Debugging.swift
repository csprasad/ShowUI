//
//
//  7_Testing&Debugging.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import TipKit

// MARK: - LESSON 7: Testing & Debugging
struct TKTestingVisual: View {
    @State private var selectedDemo   = 0
    @State private var testResults: [TestRow] = []
    @State private var isRunning      = false
    @State private var selectedConfig = 0
    let demos = ["Testing APIs", "Preview config", "Debug checklist"]

    struct TestRow: Identifiable {
        let id = UUID(); let name: String; let result: String; let pass: Bool
    }

    let testSuite: [(String, String, Bool, Double)] = [
        ("Tips.configure() called",           "Datastore initialised",             true,  0.2),
        ("showAllTipsForTesting() active",     "All tips bypass rules",             true,  0.35),
        ("WelcomeTip.status == .available",    "Tip eligible with testing mode",    true,  0.5),
        ("resetDatastore() clears state",      "All tips reset to initial state",   true,  0.65),
        ("MaxDisplayCount(1) respected",       "Tip hidden after 1 display",        true,  0.8),
        ("@Parameter update triggers rule",   "#Rule re-evaluates on param change", true,  0.95),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Testing & debugging", systemImage: "checkmark.seal.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tkAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; testResults = [] }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.tkAmber : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.tkAmberLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Testing APIs
                    VStack(spacing: 8) {
                        Button(isRunning ? "Running tests…" : "▶ Run tip tests") {
                            runTests()
                        }
                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(isRunning ? Color(.systemGray4) : Color.tkAmber)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .buttonStyle(PressableButtonStyle()).disabled(isRunning)

                        ForEach(testResults) { row in
                            HStack(spacing: 8) {
                                Image(systemName: row.pass ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .font(.system(size: 13)).foregroundStyle(row.pass ? Color.formGreen : Color.animCoral)
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(row.name).font(.system(size: 11, weight: .semibold))
                                    Text(row.result).font(.system(size: 9)).foregroundStyle(.secondary)
                                }
                            }
                            .padding(8)
                            .background(row.pass ? Color(hex: "#E1F5EE") : Color(hex: "#FCEBEB"))
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                        .animation(.spring(response: 0.35), value: testResults.count)

                        if !testResults.isEmpty && !isRunning {
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.shield.fill").foregroundStyle(Color.formGreen)
                                Text("\(testResults.filter { $0.pass }.count)/\(testResults.count) passed")
                                    .font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.formGreen)
                            }
                            .padding(8).background(Color(hex: "#E1F5EE")).clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        PlainCodeBlock(fgColor: Color.tkAmber, bgColor: Color.tkAmberLight, code: """
// Unit tests - in-memory datastore
func testTipEligibility() async throws {
    try Tips.configure([
        .datastoreLocation(.applicationDefault)
    ])
    Tips.showAllTipsForTesting()

    let tip = SearchTip()
    SearchTip.hasUsedSearch = true
    // Tip should now be eligible
    XCTAssertEqual(tip.status, .available)
}
""")
                    }

                case 1:
                    // Preview configurations
                    VStack(spacing: 8) {
                        Text("Configure tips differently for previews").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        Picker("Config", selection: $selectedConfig) {
                            Text("Show all").tag(0)
                            Text("Show none").tag(1)
                            Text("Normal").tag(2)
                        }
                        .pickerStyle(.segmented)

                        PlainCodeBlock(fgColor: Color.tkAmber, bgColor: Color.tkAmberLight, code: """
// In #Preview - control which tips show

// 1. Show ALL tips regardless of rules (development)
#Preview {
    ContentView()
        .task {
            try? Tips.configure()
            Tips.showAllTipsForTesting()
        }
}

// 2. Show NO tips (focus on UI)
#Preview {
    ContentView()
        .task {
            try? Tips.configure()
            Tips.hideAllTipsForTesting()
        }
}

// 3. Show specific tip only
#Preview {
    ContentView()
        .task {
            try? Tips.configure()
            try? Tips.showTipsForTesting([SearchTip.self])
        }
}

// 4. Reset to show fresh tips
#Preview {
    ContentView()
        .task {
            try? Tips.configure()
            Tips.resetDatastore()
        }
}
""")
                    }

                default:
                    // Debug checklist
                    VStack(spacing: 8) {
                        Text("Debugging checklist when tips don't appear").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        debugRow(icon: "checkmark.circle.fill", color: .formGreen,
                                 issue: "Tips.configure() called?",
                                 fix: "Must be called in App.init() before first render")
                        debugRow(icon: "checkmark.circle.fill", color: .formGreen,
                                 issue: "All #Rule conditions met?",
                                 fix: "Use Tips.showAllTipsForTesting() to bypass rules")
                        debugRow(icon: "checkmark.circle.fill", color: .formGreen,
                                 issue: "MaxDisplayCount exhausted?",
                                 fix: "Call Tips.resetDatastore() to reset display counts")
                        debugRow(icon: "checkmark.circle.fill", color: .formGreen,
                                 issue: "displayFrequency limiting?",
                                 fix: ".displayFrequency(.immediate) in configure() for testing")
                        debugRow(icon: "checkmark.circle.fill", color: .formGreen,
                                 issue: "Tip already invalidated?",
                                 fix: "Check tip.status - .invalidated means it's been dismissed")
                        debugRow(icon: "checkmark.circle.fill", color: .formGreen,
                                 issue: "No TipView or .popoverTip?",
                                 fix: "Tip must be rendered somewhere - eligibility alone doesn't show it")
                    }
                }
            }
        }
    }

    func runTests() {
        isRunning = true; testResults = []
        for (i, test) in testSuite.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + test.3) {
                withAnimation { testResults.append(TestRow(name: test.0, result: test.1, pass: test.2)) }
                if i == testSuite.count - 1 { isRunning = false }
            }
        }
    }

    func debugRow(icon: String, color: Color, issue: String, fix: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon).font(.system(size: 12)).foregroundStyle(color)
            VStack(alignment: .leading, spacing: 2) {
                Text(issue).font(.system(size: 11, weight: .semibold))
                Text("→ \(fix)").font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }
        .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

struct TKTestingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Testing and debugging TipKit")
            Text("TipKit provides dedicated testing APIs to control which tips appear during development and automated tests. Without these, tips with strict display rules would be invisible during UI development.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Tips.showAllTipsForTesting() - ignore all rules, show every tip. Call after configure().", color: .tkAmber)
                StepRow(number: 2, text: "Tips.hideAllTipsForTesting() - suppress all tips. Use when testing other UI.", color: .tkAmber)
                StepRow(number: 3, text: "Tips.showTipsForTesting([MyTip.self]) - show only specific tip types.", color: .tkAmber)
                StepRow(number: 4, text: "Tips.resetDatastore() - clear all display counts and dismissal history.", color: .tkAmber)
                StepRow(number: 5, text: ".datastoreLocation(.inMemory) - use in unit tests for full isolation.", color: .tkAmber)
            }

            CalloutBox(style: .success, title: "Always test with showAllTipsForTesting()", contentBody: "During UI development, wrap your preview content with Tips.showAllTipsForTesting() so tips always appear regardless of display rules. This lets you iterate on tip layout and copy without fighting rule conditions.")

            CodeBlock(code: """
// Development preview - always show tips
#Preview {
    MyView()
        .task {
            try? Tips.configure([
                .displayFrequency(.immediate)
            ])
            Tips.showAllTipsForTesting()
        }
}

// Unit test - in-memory, isolated
class TipTests: XCTestCase {
    override func setUp() async throws {
        try Tips.configure([
            .datastoreLocation(.applicationDefault)
        ])
        Tips.showAllTipsForTesting()
    }

    func testTipShowsAfterCondition() async {
        let tip = ExportTip()
        ExportTip.hasDocument = true

        // In testing mode, available immediately
        XCTAssertEqual(tip.status, .available)
    }

    func testTipHidesAfterDismiss() async {
        let tip = ExportTip()
        tip.invalidate(reason: .tipClosed)
        XCTAssertNotEqual(tip.status, .available)
    }
}
""")
        }
    }
}
