//
//
//  8_SwiftUIIntegration.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `17/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine

// MARK: - LESSON 8: SwiftUI Integration
struct CBSwiftUIVisual: View {
    @State private var selectedDemo = 0
    @State private var cancellables = Set<AnyCancellable>()
    let demos = ["@Published & sink", "assign(to:)", "onReceive"]

    // Demo observable object
    @State private var publishedValue = 0
    @State private var sinkLog: [String] = []
    @State private var assignResult = "initial"
    @State private var timerCount = 0
    @State private var timerRunning = false
    @State private var timerCancellable: AnyCancellable?

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("SwiftUI integration", systemImage: "iphone.gen3")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cbOrange)

                tabSelector(demos: demos, selected: $selectedDemo)

                switch selectedDemo {
                case 0: publishedSinkView
                case 1: assignToView
                default: onReceiveView
                }
            }
        }
    }

    var publishedSinkView: some View {
        VStack(spacing: 8) {
            // @Published simulation
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "at").foregroundStyle(Color.cbOrange)
                    Text("@Published - automatic publisher for properties").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.cbOrange)
                }
                HStack(spacing: 8) {
                    Stepper(value: $publishedValue, in: 0...100) {
                        Text("@Published var count = \(publishedValue)")
                            .font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.cbOrange)
                    }
                    .onChange(of: publishedValue) { _, v in
                        withAnimation { sinkLog.insert("→ sink received: \(v)", at: 0) }
                    }
                }
                // Simulated sink log
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(sinkLog.prefix(4), id: \.self) { e in
                        Text(e).font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                    }
                    if sinkLog.isEmpty { Text("(change value to see sink output)").font(.system(size: 10)).foregroundStyle(Color(.systemGray4)) }
                }
                .frame(maxWidth: .infinity, minHeight: 36, alignment: .topLeading)
                .padding(7).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 7))

                PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "class MyViewModel: ObservableObject {\n    @Published var count = 0  // auto-synthesises publisher\n}\n// Use:\nviewModel.$count  // Publisher<Int, Never>\n    .sink { value in print(value) }\n    .store(in: &cancellables)")
            }
            .padding(8).background(Color.cbOrangeLight.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 8))

            // ObservableObject
            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "class Store: ObservableObject {\n    @Published var items: [Item] = []\n    @Published var isLoading = false\n\n    // objectWillChange fires before ANY @Published changes\n    func load() {\n        isLoading = true\n        api.items()\n            .receive(on: RunLoop.main)\n            .sink(\n                receiveCompletion: { _ in self.isLoading = false },\n                receiveValue: { self.items = $0 }\n            )\n            .store(in: &cancellables)\n    }\n}")
        }
    }

    var assignToView: some View {
        VStack(spacing: 8) {
            Text("assign(to:on:) vs assign(to:) - two variants").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.cbOrange)

            VStack(spacing: 6) {
                assignVariantRow(
                    title: "assign(to: \\.text, on: self)",
                    color: .cbOrange,
                    desc: "Old API - strong reference to self. Can cause retain cycles! Use [weak self] in closures instead.",
                    warning: true
                )
                assignVariantRow(
                    title: "assign(to: &$publishedProp)",
                    color: Color.formGreen,
                    desc: "New API (Combine+Swift 5.3) - binds directly to @Published property. No retain cycle. No AnyCancellable needed.",
                    warning: false
                )
            }

            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: """
// Old: retain cycle risk
publisher
    .assign(to: \\.title, on: self)  // strong ref to self
    .store(in: &cancellables)

// New: no retain cycle, no cancellable storage needed
publisher
    .assign(to: &$title)  // binds to @Published var title

// With ObservableObject:
class ViewModel: ObservableObject {
    @Published var items: [Item] = []
    var cancellables = Set<AnyCancellable>()

    init() {
        fetchItems()
            .receive(on: RunLoop.main)
            .replaceError(with: [])
            .assign(to: &$items)  // ← clean, no retain cycle
    }
}
""")
        }
    }

    var onReceiveView: some View {
        VStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "timer").foregroundStyle(Color.cbOrange)
                    Text("onReceive - attach publisher to a SwiftUI view").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.cbOrange)
                }
                Text("Attaches a publisher subscription to the view's lifetime. Auto-cancels when the view disappears.").font(.system(size: 10)).foregroundStyle(.secondary)

                // Timer demo
                HStack(spacing: 10) {
                    Text("\(timerCount)")
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                        .foregroundStyle(timerRunning ? Color.cbOrange : Color(.systemGray3))
                        .frame(width: 60)
                        .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: timerCount)

                    VStack(spacing: 6) {
                        Button(timerRunning ? "⏸ Stop timer" : "▶ Start timer") {
                            if timerRunning {
                                timerCancellable?.cancel(); timerCancellable = nil; timerRunning = false
                            } else {
                                timerRunning = true
                                timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
                                    .autoconnect()
                                    .sink { _ in withAnimation { timerCount += 1 } }
                            }
                        }
                        .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 8)
                        .background(timerRunning ? Color.animCoral : Color.cbOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .buttonStyle(PressableButtonStyle())

                        Button("Reset") {
                            timerCancellable?.cancel(); timerCancellable = nil
                            withAnimation { timerCount = 0; timerRunning = false }
                        }
                        .font(.system(size: 11)).foregroundStyle(Color.cbOrange)
                        .frame(maxWidth: .infinity).padding(.vertical, 6)
                        .background(Color.cbOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
                        .buttonStyle(PressableButtonStyle())
                    }
                }
                .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(8).background(Color.cbOrangeLight.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 8))

            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "struct CountdownView: View {\n    @State private var seconds = 60\n\n    var body: some View {\n        Text(\"\\(seconds)\")\n            .onReceive(\n                Timer.publish(every: 1, on: .main, in: .common)\n                    .autoconnect()\n            ) { _ in\n                seconds -= 1\n            }\n    }\n}")
        }
    }

    func assignVariantRow(title: String, color: Color, desc: String, warning: Bool) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: warning ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                .font(.system(size: 13)).foregroundStyle(warning ? Color.animAmber : Color.formGreen)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(color)
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(warning ? Color(hex: "#FAEEDA") : Color(hex: "#E1F5EE")).clipShape(RoundedRectangle(cornerRadius: 8))
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

struct CBSwiftUIExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Combine in SwiftUI")
            Text("@Published, ObservableObject, onReceive, and assign(to:) are SwiftUI's native Combine integration points. These connect reactive streams directly to SwiftUI's rendering engine.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@Published var x - synthesises objectWillChange.send() before mutations. View re-renders when any @Published changes.", color: .cbOrange)
                StepRow(number: 2, text: "viewModel.$property - access the Publisher<T, Never> for any @Published property.", color: .cbOrange)
                StepRow(number: 3, text: ".assign(to: &$property) - bind pipeline output to a @Published property. No retain cycle, no AnyCancellable.", color: .cbOrange)
                StepRow(number: 4, text: ".assign(to: \\.property, on: object) - older API, creates strong reference. Use [weak self] in closures to break cycles.", color: .cbOrange)
                StepRow(number: 5, text: ".onReceive(publisher) { value in } - view modifier that subscribes for the view's lifetime. Auto-cancels on disappear.", color: .cbOrange)
                StepRow(number: 6, text: "Prefer @Observable + AsyncStream in new code (iOS 17+). Use ObservableObject+Combine for iOS 14-16 targets.", color: .cbOrange)
            }

            CodeBlock(code: """
// Full ViewModel pattern
class SearchViewModel: ObservableObject {
    @Published var query     = ""
    @Published var results: [String] = []
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        $query
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .handleEvents(receiveOutput: { _ in self.isLoading = true })
            .flatMap { query in
                self.search(query)
                    .catch { _ in Just([]) }
            }
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { _ in self.isLoading = false })
            .assign(to: &$results)
    }
}

// View usage
@StateObject var vm = SearchViewModel()
TextField("Search", text: $vm.query)
if vm.isLoading { ProgressView() }
List(vm.results, id: \\.self) { Text($0) }
""")
        }
    }
}

