//
//
//  11_SubjectsDeepDive.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `17/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine

// MARK: - LESSON 11: Subjects Deep Dive
struct CBSubjectsVisual: View {
    @State private var selectedDemo = 0
    @State private var cancellables = Set<AnyCancellable>()

    @State private var ptSubject = PassthroughSubject<String, Never>()
    @State private var cvSubject = CurrentValueSubject<Int, Never>(0)
    @State private var ptLog: [String] = []
    @State private var cvLog: [String] = []
    @State private var sharedCount = 0
    @State private var subscriber1Log: [String] = []
    @State private var subscriber2Log: [String] = []

    let demos = ["Passthrough subj", "CurrentValue subj", "share & multicast"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Subjects deep dive", systemImage: "dot.radiowaves.left.and.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cbOrange)

                tabSelector(demos: demos, selected: $selectedDemo)

                switch selectedDemo {
                case 0: passthroughView
                case 1: currentValueView
                default: shareMulticastView
                }
            }
        }
        .onAppear { setupSubjects() }
    }

    var passthroughView: some View {
        VStack(spacing: 8) {
            Text("PassthroughSubject - push values imperatively").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.cbOrange)

            HStack(spacing: 6) {
                ForEach(["Hello", "World", "Combine", "Swift"], id: \.self) { word in
                    Button(word) {
                        ptSubject.send(word)
                        withAnimation { ptLog.insert("→ \"\(word)\"", at: 0) }
                    }
                    .font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(Color.cbOrange).clipShape(Capsule())
                    .buttonStyle(PressableButtonStyle())
                }
            }

            Button("send(completion: .finished)") {
                ptSubject.send(completion: .finished)
                withAnimation { ptLog.insert("⟳ .finished - stream ends", at: 0) }
            }
            .font(.system(size: 12)).foregroundStyle(Color.animCoral)
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(Color(hex: "#FCEBEB")).clipShape(Capsule())
            .buttonStyle(PressableButtonStyle())

            logBox(entries: ptLog)

            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "let subject = PassthroughSubject<String, Never>()\n\n// Subscriber 1 attaches\nsubject.sink { print(\"S1:\", $0) }.store(in: &c)\n\nsubject.send(\"A\")  // S1: A\n\n// Subscriber 2 attaches later\nsubject.sink { print(\"S2:\", $0) }.store(in: &c)\n\nsubject.send(\"B\")  // S1: B, S2: B  - both receive\n// (S2 does NOT receive past values)")
        }
    }

    var currentValueView: some View {
        VStack(spacing: 8) {
            Text("CurrentValueSubject - stores & replays current value").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color(hex: "#1D4ED8"))

            VStack(spacing: 6) {
                HStack(spacing: 8) {
                    Text("Value:").font(.system(size: 12)).foregroundStyle(.secondary)
                    Stepper(value: Binding(
                        get: { cvSubject.value },
                        set: { v in cvSubject.send(v); withAnimation { cvLog.insert("→ .value = \(v)", at: 0) } }
                    ), in: -10...10) {
                        Text("\(cvSubject.value)").font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color(hex: "#1D4ED8"))
                            .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: cvSubject.value)
                    }
                }
                Text("cvSubject.value = \(cvSubject.value)  ← read anytime")
                    .font(.system(size: 10, design: .monospaced)).foregroundStyle(Color(hex: "#1D4ED8"))
                    .padding(6).background(Color(hex: "#EFF6FF")).clipShape(RoundedRectangle(cornerRadius: 6))
            }

            logBox(entries: cvLog)

            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "// Late subscriber gets current value immediately\nlet subject = CurrentValueSubject<Bool, Never>(false)\n\nsubject.send(true)\n// Now subject.value == true\n\n// New subscriber:\nsubject.sink { print($0) }  // immediately prints: true")
        }
    }

    var shareMulticastView: some View {
        VStack(spacing: 8) {
            Text("share() - one upstream subscription for multiple subscribers").font(.system(size: 11)).foregroundStyle(.secondary)

            HStack(spacing: 8) {
                Button("Emit value") {
                    sharedCount += 1
                    withAnimation {
                        subscriber1Log.insert("S1 → \(sharedCount)", at: 0)
                        subscriber2Log.insert("S2 → \(sharedCount)", at: 0)
                    }
                }
                .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 8)
                .background(Color.cbOrange).clipShape(RoundedRectangle(cornerRadius: 8))
                .buttonStyle(PressableButtonStyle())

                Button("Reset") { withAnimation { sharedCount = 0; subscriber1Log = []; subscriber2Log = [] } }
                    .font(.system(size: 11)).foregroundStyle(Color.cbOrange)
                    .frame(maxWidth: .infinity).padding(.vertical, 8)
                    .background(Color.cbOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    .buttonStyle(PressableButtonStyle())
            }

            HStack(spacing: 8) {
                logBox2(title: "Subscriber 1", entries: subscriber1Log, color: .cbOrange)
                logBox2(title: "Subscriber 2", entries: subscriber2Log, color: Color(hex: "#1D4ED8"))
            }

            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "// Without share: two separate network calls\nlet p = fetchData()   // Publisher\np.sink { ... }        // network call 1\np.sink { ... }        // network call 2!\n\n// With share: one call, two subscribers\nlet shared = fetchData().share()\nshared.sink { A in ... }  // one network call\nshared.sink { B in ... }  // same call, both get values")
        }
    }

    func setupSubjects() {
        ptSubject.sink { _ in }.store(in: &cancellables)
        cvSubject.sink { _ in }.store(in: &cancellables)
    }

    func logBox(entries: [String]) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            ForEach(entries.prefix(4), id: \.self) { e in
                Text(e).font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
            }
            if entries.isEmpty { Text("(tap to send values)").font(.system(size: 10)).foregroundStyle(Color(.systemGray4)) }
        }
        .frame(maxWidth: .infinity, minHeight: 40, alignment: .topLeading)
        .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func logBox2(title: String, entries: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title).font(.system(size: 10, weight: .semibold)).foregroundStyle(color)
            ForEach(entries.prefix(4), id: \.self) { e in
                Text(e).font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
            }
            if entries.isEmpty { Text("(no values yet)").font(.system(size: 9)).foregroundStyle(Color(.systemGray4)) }
        }
        .frame(maxWidth: .infinity, minHeight: 52, alignment: .topLeading)
        .padding(7).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 7))
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

struct CBSubjectsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Subjects - the imperative bridge")
            Text("Subjects are the bridge between imperative and reactive code. They're both publishers and subscribers. Use PassthroughSubject for events, CurrentValueSubject for state. .share() prevents multiple upstream subscriptions for the same pipeline.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "PassthroughSubject - .send(value), no memory. New subscribers miss past values.", color: .cbOrange)
                StepRow(number: 2, text: "CurrentValueSubject - .value property holds latest. New subscribers get it immediately.", color: .cbOrange)
                StepRow(number: 3, text: "subject.send(completion: .finished) - terminate the stream. Subsequent .send() calls are ignored.", color: .cbOrange)
                StepRow(number: 4, text: ".share() - multicasts one upstream subscription to all downstream subscribers. Prevents duplicate side effects.", color: .cbOrange)
                StepRow(number: 5, text: ".multicast(subject:) - manually controlled sharing. Call .connect() to start the upstream.", color: .cbOrange)
            }

            CodeBlock(code: """
// PassthroughSubject as event bus
class EventBus {
    static let shared = EventBus()
    let events = PassthroughSubject<AppEvent, Never>()

    func emit(_ event: AppEvent) {
        events.send(event)
    }
}

// CurrentValueSubject as state store
class AuthStore {
    let isLoggedIn = CurrentValueSubject<Bool, Never>(false)

    func login() { isLoggedIn.send(true) }
    func logout() { isLoggedIn.send(false) }
}

// .share() - prevent double network call
let shared = URLSession.shared
    .dataTaskPublisher(for: url)
    .share()                    // ONE network request

shared.sink { ... }.store(in: &c)
shared.sink { ... }.store(in: &c)
// Both receive the SAME response
""")
        }
    }
}

