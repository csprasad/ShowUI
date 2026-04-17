//
//
//  7_Schedulers&Threading.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `17/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine

// MARK: - LESSON 7: Schedulers & Threading
struct CBSchedulersVisual: View {
    @State private var selectedDemo = 0
    @State private var log: [ThreadEntry] = []
    @State private var isRunning = false
    @State private var cancellables = Set<AnyCancellable>()
    let demos = ["receive vs subscribe", "Scheduler types", "Common patterns"]

    struct ThreadEntry: Identifiable {
        let id = UUID()
        let text: String
        let isMain: Bool
        let color: Color
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Schedulers & threading", systemImage: "cpu.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cbOrange)

                tabSelector(demos: demos, selected: $selectedDemo)

                switch selectedDemo {
                case 0: receiveSubscribeView
                case 1: schedulerTypesView
                default: patternsView
                }
            }
        }
    }

    var receiveSubscribeView: some View {
        VStack(spacing: 8) {
            // Two-panel diagram
            HStack(spacing: 8) {
                schedulerCard(
                    icon: "arrow.down.to.line.circle.fill",
                    title: "subscribe(on:)",
                    color: Color(hex: "#7C3AED"),
                    desc: "Where the subscription SETUP and UPSTREAM work runs",
                    example: ".subscribe(on: DispatchQueue.global())\n// Heavy work on background thread"
                )
                schedulerCard(
                    icon: "arrow.up.to.line.circle.fill",
                    title: "receive(on:)",
                    color: .cbOrange,
                    desc: "Where VALUES are delivered DOWNSTREAM",
                    example: ".receive(on: RunLoop.main)\n// UI updates on main thread"
                )
            }

            // Simulate pipeline
            Button(isRunning ? "Running…" : "▶ Run thread simulation") {
                runThreadSim()
            }
            .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 10)
            .background(isRunning ? Color(.systemGray4) : Color.cbOrange)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .buttonStyle(PressableButtonStyle()).disabled(isRunning)

            VStack(alignment: .leading, spacing: 4) {
                ForEach(log) { entry in
                    HStack(spacing: 6) {
                        Circle().fill(entry.color).frame(width: 7, height: 7)
                        Text(entry.text).font(.system(size: 10)).foregroundStyle(.secondary)
                    }
                }
                if log.isEmpty { Text("(tap button to see thread transitions)").font(.system(size: 10)).foregroundStyle(Color(.systemGray4)) }
            }
            .frame(maxWidth: .infinity, minHeight: 56, alignment: .topLeading)
            .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))

            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "// Classic pattern: work on bg, deliver on main\nexpensivePublisher\n    .subscribe(on: DispatchQueue.global(qos: .userInitiated))\n    .map { doExpensiveWork($0) }  // runs on global queue\n    .receive(on: RunLoop.main)    // deliver here\n    .sink { updateUI($0) }        // main thread ✓")
        }
    }

    var schedulerTypesView: some View {
        VStack(spacing: 8) {
            ForEach([
                ("RunLoop.main", Color.cbOrange,
                 "The main run loop. Used for UI updates. Same as DispatchQueue.main but run-loop aware. Best for .receive(on:) in views.",
                 ".receive(on: RunLoop.main)"),
                ("DispatchQueue.main", Color(hex: "#1D4ED8"),
                 "Main dispatch queue. Equivalent to RunLoop.main for most use cases. Direct, explicit main thread delivery.",
                 ".receive(on: DispatchQueue.main)"),
                ("DispatchQueue.global()", Color(hex: "#0F766E"),
                 "Background thread. Use for heavy work in .subscribe(on:). qos levels: .userInteractive, .userInitiated, .utility, .background.",
                 ".subscribe(on: DispatchQueue.global(qos: .background))"),
                ("ImmediateScheduler", Color(hex: "#7C3AED"),
                 "Executes work synchronously, on whatever thread calls it. Good for tests - no async delays.",
                 ".receive(on: ImmediateScheduler.shared)"),
                ("OperationQueue.main", Color(hex: "#D97706"),
                 "Foundation's OperationQueue wrapping. Less common - use RunLoop.main or DispatchQueue.main instead.",
                 ".subscribe(on: OperationQueue())"),
            ], id: \.0) { name, color, desc, example in
                schedulerTypeRow(name: name, color: color, desc: desc, example: example)
            }
        }
    }

    var patternsView: some View {
        VStack(spacing: 8) {
            patternCard(
                icon: "iphone.gen3",
                title: "UI update from network",
                color: .cbOrange,
                code: "networkPublisher\n    .subscribe(on: DispatchQueue.global())\n    .receive(on: RunLoop.main)\n    .sink { items in self.items = items }"
            )
            patternCard(
                icon: "clock.fill",
                title: "Debounce on main thread",
                color: Color(hex: "#1D4ED8"),
                code: "$searchText\n    .debounce(for: .milliseconds(300),\n              scheduler: RunLoop.main)  // debounce on main\n    .sink { search($0) }"
            )
            patternCard(
                icon: "wrench.fill",
                title: "Test scheduler",
                color: Color(hex: "#7C3AED"),
                code: "// In tests - no async delays\npublisher\n    .receive(on: ImmediateScheduler.shared)\n    .sink { ... }\n\n// Or use Combine's TestScheduler (external library)"
            )
            patternCard(
                icon: "exclamationmark.triangle.fill",
                title: "⚠ Main thread pitfall",
                color: Color(hex: "#E11D48"),
                code: "// WRONG: forgetting receive(on: RunLoop.main)\n// @Published updates from background thread\n// → purple runtime warning in Xcode\n\n// ALWAYS add .receive(on: RunLoop.main)\n// before assigning to UI-bound @Published")
        }
    }

    func runThreadSim() {
        isRunning = true; log = []
        let steps: [(Double, String, Bool, Color)] = [
            (0.0,  "1. .subscribe(on: DispatchQueue.global()) - setup on background", false, Color(hex: "#7C3AED")),
            (0.4,  "2. Publisher starts work on global queue (background)", false, Color(hex: "#0F766E")),
            (0.8,  "3. Heavy computation running on background thread…", false, Color(hex: "#0F766E")),
            (1.2,  "4. .receive(on: RunLoop.main) - hop to main thread", true,  .cbOrange),
            (1.6,  "5. Value delivered on main thread ✓", true,  .cbOrange),
            (2.0,  "6. Sink receives value → safe to update UI", true,  Color.formGreen),
        ]
        for (delay, text, isMain, color) in steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation { log.append(ThreadEntry(text: text, isMain: isMain, color: color)) }
                if delay == 2.0 { isRunning = false }
            }
        }
    }

    func schedulerCard(icon: String, title: String, color: Color, desc: String, example: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 5) {
                Image(systemName: icon).font(.system(size: 13)).foregroundStyle(color)
                Text(title).font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(color)
            }
            Text(desc).font(.system(size: 9)).foregroundStyle(.secondary)
            Text(example).font(.system(size: 8, design: .monospaced)).foregroundStyle(color)
                .padding(4).background(color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 4))
        }.frame(maxWidth: .infinity)
        .padding(8).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 8))
        
    }

    func schedulerTypeRow(name: String, color: Color, desc: String, example: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name).font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(color)
            Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            Text(example).font(.system(size: 8, design: .monospaced)).foregroundStyle(color)
                .padding(5).background(color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 5))
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(8).background(Color.cbOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func patternCard(icon: String, title: String, color: Color, code: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon).font(.system(size: 14)).foregroundStyle(color).frame(width: 18)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.system(size: 11, weight: .semibold))
                Text(code).font(.system(size: 8, design: .monospaced)).foregroundStyle(color)
                    .padding(5).background(color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(8).background(Color.cbOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func tabSelector(demos: [String], selected: Binding<Int>) -> some View {
        HStack(spacing: 8) {
            ForEach(demos.indices, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.3)) { selected.wrappedValue = i }
                } label: {
                    Text(demos[i])
                        .font(.system(size: 11, weight: selected.wrappedValue == i ? .semibold : .regular))
                        .foregroundStyle(selected.wrappedValue == i ? Color.cbOrange : .secondary)
                        .frame(maxWidth: .infinity).padding(.vertical, 7)
                        .background(selected.wrappedValue == i ? Color.cbOrangeLight : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
    }
}

struct CBSchedulersExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Schedulers - where work happens")
            Text("Schedulers control WHICH thread or queue processes pipeline events. subscribe(on:) moves upstream work to a background thread. receive(on:) delivers values back to the main thread for UI updates. Both are essential for correct concurrent apps.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "subscribe(on: DispatchQueue.global()) - run upstream work (network calls, parsing) on background.", color: .cbOrange)
                StepRow(number: 2, text: "receive(on: RunLoop.main) - deliver values to main thread. REQUIRED before UI updates.", color: .cbOrange)
                StepRow(number: 3, text: "RunLoop.main vs DispatchQueue.main - both work for .receive(on:). RunLoop.main is preferred in SwiftUI.", color: .cbOrange)
                StepRow(number: 4, text: "ImmediateScheduler - synchronous, no thread hopping. Use in unit tests to avoid async complexity.", color: .cbOrange)
                StepRow(number: 5, text: "Missing .receive(on: RunLoop.main) causes purple Xcode warnings for @Published mutations from background threads.", color: .cbOrange)
            }

            CalloutBox(style: .danger, title: "Always receive on main before UI updates", contentBody: "Any @Published property that drives a SwiftUI view MUST be updated on the main thread. Combine pipelines from network calls run on background threads. Always add .receive(on: RunLoop.main) as the last operator before .sink or .assign that touches UI state.")

            CodeBlock(code: """
// The essential pattern
URLSession.shared.dataTaskPublisher(for: url)
    .subscribe(on: DispatchQueue.global(qos: .userInitiated))
    .map(\\.data)
    .decode(type: [Item].self, decoder: JSONDecoder())
    .replaceError(with: [])
    .receive(on: RunLoop.main)          // ← CRITICAL
    .assign(to: &$items)               // safe - on main

// Timer on main
Timer.publish(every: 1, on: .main, in: .common)
    .autoconnect()
    .sink { date in self.currentTime = date }

// debounce must specify scheduler too
$text
    .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
    .sink { search($0) }
""")
        }
    }
}
