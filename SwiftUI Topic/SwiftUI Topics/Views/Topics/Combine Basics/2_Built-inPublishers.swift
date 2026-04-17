//
//
//  2_Built-inPublishers.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `17/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine

// MARK: - LESSON 2: Built-in Publishers
struct CBBuiltInPublishersVisual: View {
    @State private var selectedDemo = 0
    @State private var cancellables = Set<AnyCancellable>()
    @State private var outputLog: [String] = []
    @State private var selectedPublisher = 0
    @State private var subjectValue      = ""
    @State private var cvSubjectValue    = "Hello"
    @State private var futureResult: String = ""
    @State private var futureRunning = false

    let demos = ["Just / Empty / Fail", "Subject types", "Future & Deferred"]
    let publishers = ["Just(42)", "Empty", "Fail(MyError)", "[1,2,3].publisher", "sequence"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Built-in publishers", systemImage: "shippingbox.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cbOrange)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; outputLog = [] }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.cbOrange : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.cbOrangeLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Just / Empty / Fail gallery
                    VStack(spacing: 8) {
                        ForEach([
                            ("Just(42)",          "Emits 42, then .finished immediately", "→ 42, .finished",           Color.cbOrange),
                            ("Empty()",           "Emits .finished with no values",       "→ .finished",               Color(hex: "#0F766E")),
                            ("Fail(URLError…)",   "Immediately emits .failure(error)",    "→ .failure(URLError(…))",   Color(hex: "#E11D48")),
                            ("[1,2,3].publisher", "Synchronously emits all, then done",   "→ 1 → 2 → 3 → .finished",  Color(hex: "#1D4ED8")),
                        ], id: \.0) { name, desc, output, color in
                            publisherRow(name: name, desc: desc, output: output, color: color)
                        }

                        // Run button
                        HStack(spacing: 6) {
                            ForEach(["Just", "Empty", "Fail", "Array"].indices, id: \.self) { i in
                                Button(["Just", "Empty", "Fail", "Array"][i]) {
                                    runBuiltIn(index: i)
                                }
                                .font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
                                .padding(.horizontal, 8).padding(.vertical, 6)
                                .background(Color.cbOrange).clipShape(RoundedRectangle(cornerRadius: 7))
                                .buttonStyle(PressableButtonStyle())
                            }
                        }

                        logBox(entries: outputLog)
                    }

                case 1:
                    // Subject types - live demo
                    VStack(spacing: 8) {
                        // PassthroughSubject
                        VStack(alignment: .leading, spacing: 6) {
                            Text("PassthroughSubject<String, Never>").font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.cbOrange)
                            Text("Emits only NEW values - no memory of past").font(.system(size: 10)).foregroundStyle(.secondary)
                            HStack(spacing: 8) {
                                TextField("Send value…", text: $subjectValue)
                                    .textFieldStyle(.roundedBorder).font(.system(size: 12))
                                    .autocorrectionDisabled().textInputAutocapitalization(.never)
                                Button("Send") {
                                    let val = subjectValue.trimmingCharacters(in: .whitespaces)
                                    guard !val.isEmpty else { return }
                                    withAnimation { outputLog.insert("PT → \"\(val)\"", at: 0); subjectValue = "" }
                                }
                                .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                                .padding(.horizontal, 12).padding(.vertical, 6)
                                .background(Color.cbOrange).clipShape(RoundedRectangle(cornerRadius: 7))
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                        .padding(8).background(Color.cbOrangeLight.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 8))

                        // CurrentValueSubject
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CurrentValueSubject<String, Never>").font(.system(size: 10, weight: .semibold)).foregroundStyle(Color(hex: "#1D4ED8"))
                            Text("Holds current value - new subscribers get it immediately").font(.system(size: 10)).foregroundStyle(.secondary)
                            HStack(spacing: 8) {
                                TextField("Current value…", text: $cvSubjectValue)
                                    .textFieldStyle(.roundedBorder).font(.system(size: 12))
                                    .autocorrectionDisabled().textInputAutocapitalization(.never)
                                    .onChange(of: cvSubjectValue) { _, v in
                                        withAnimation { outputLog.insert("CV.value = \"\(v)\"", at: 0) }
                                    }
                            }
                            Text("current: \"\(cvSubjectValue)\"")
                                .font(.system(size: 10, design: .monospaced)).foregroundStyle(Color(hex: "#1D4ED8"))
                        }
                        .padding(8).background(Color(hex: "#EFF6FF").opacity(0.7)).clipShape(RoundedRectangle(cornerRadius: 8))

                        logBox(entries: outputLog)
                    }

                default:
                    // Future & Deferred
                    VStack(spacing: 8) {
                        futureCard
                        deferredCard
                    }
                }
            }
        }
    }

    var futureCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "clock.arrow.circlepath").foregroundStyle(Color.cbOrange)
                Text("Future - single async value").font(.system(size: 11, weight: .semibold))
            }
            Text("Wraps a callback-based async operation. Executes immediately (even without a subscriber).").font(.system(size: 10)).foregroundStyle(.secondary)

            HStack(spacing: 8) {
                Button(futureRunning ? "Running…" : "Simulate async task") {
                    guard !futureRunning else { return }
                    futureRunning = true; futureResult = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation { futureResult = "✓ Result: 42"; futureRunning = false }
                    }
                }
                .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 8)
                .background(futureRunning ? Color(.systemGray4) : Color.cbOrange)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .buttonStyle(PressableButtonStyle())
                .disabled(futureRunning)

                if !futureResult.isEmpty {
                    Text(futureResult).font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.formGreen)
                }
            }

            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "Future<Int, Never> { promise in\n    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {\n        promise(.success(42))  // or .failure(error)\n    }\n}")
        }
        .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    var deferredCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "timer").foregroundStyle(Color(hex: "#7C3AED"))
                Text("Deferred - lazy publisher factory").font(.system(size: 11, weight: .semibold))
            }
            Text("Wraps a publisher factory closure. Unlike Future, only creates the publisher when subscribed - no early side effects.").font(.system(size: 10)).foregroundStyle(.secondary)
            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "Deferred {\n    Future<Int, Never> { promise in\n        promise(.success(Int.random(in: 1...100)))\n    }\n}\n// Each subscriber gets a FRESH Future → different random value")
        }
        .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func runBuiltIn(index: Int) {
        var newLogs: [String] = []
        switch index {
        case 0: // Just
            Just(42).sink { c in newLogs.append("⟳ \(c)") } receiveValue: { v in newLogs.append("→ Just: \(v)") }.store(in: &cancellables)
        case 1: // Empty
            Empty<Int, Never>().sink { c in newLogs.append("⟳ \(c)") } receiveValue: { _ in }.store(in: &cancellables)
        case 2: // Fail
            Fail<Int, URLError>(error: URLError(.notConnectedToInternet)).sink { c in newLogs.append("⟳ \(c)") } receiveValue: { _ in }.store(in: &cancellables)
        default: // Array
            [1,2,3,4].publisher.sink { c in newLogs.append("⟳ \(c)") } receiveValue: { v in newLogs.append("→ \(v)") }.store(in: &cancellables)
        }
        withAnimation { outputLog = newLogs + outputLog }
    }

    func publisherRow(name: String, desc: String, output: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(name).font(.system(size: 9, weight: .semibold, design: .monospaced)).foregroundStyle(color)
                .frame(width: 100, alignment: .leading)
            VStack(alignment: .leading, spacing: 2) {
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
                Text(output).font(.system(size: 9, design: .monospaced)).foregroundStyle(color)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(7).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 7))
    }

    func logBox(entries: [String]) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            ForEach(entries.prefix(5), id: \.self) { e in
                Text(e).font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
            }
            if entries.isEmpty { Text("(output will appear here)").font(.system(size: 10)).foregroundStyle(Color(.systemGray4)) }
        }
        .frame(maxWidth: .infinity, minHeight: 48, alignment: .topLeading)
        .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct CBBuiltInPublishersExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Built-in publishers")
            Text("Combine ships with several concrete publishers for common scenarios. Just wraps a single value. Empty finishes immediately. Fail immediately errors. Sequence publishers emit array elements. Subjects are the bridge between imperative and reactive code.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Just(value) - emits one value then finishes. Failure type is Never.", color: .cbOrange)
                StepRow(number: 2, text: "Empty() - immediately sends .finished. Useful as a no-op placeholder.", color: .cbOrange)
                StepRow(number: 3, text: "Fail(error:) - immediately sends .failure(error). Useful for error injection in tests.", color: .cbOrange)
                StepRow(number: 4, text: "PassthroughSubject - push values imperatively. send(_:), send(completion:). No stored value.", color: .cbOrange)
                StepRow(number: 5, text: "CurrentValueSubject - like PassthroughSubject but stores current value. New subscribers get it immediately via .value.", color: .cbOrange)
                StepRow(number: 6, text: "Future - wraps a single async Promise callback. Executes eagerly (even without subscribers).", color: .cbOrange)
                StepRow(number: 7, text: "Deferred - wraps a publisher factory closure. Only creates the publisher on subscription - lazy evaluation.", color: .cbOrange)
            }

            CalloutBox(style: .info, title: "PassthroughSubject vs CurrentValueSubject", contentBody: "Use PassthroughSubject for events (button taps, notifications) where new subscribers should NOT get the last event. Use CurrentValueSubject for state (isLoggedIn, currentUser) where new subscribers should receive the current state immediately via .value.")

            CodeBlock(code: """
// PassthroughSubject - imperative push
let events = PassthroughSubject<String, Never>()
events.send("login")
events.send("purchase")
events.send(completion: .finished)

// CurrentValueSubject - holds state
let isLoading = CurrentValueSubject<Bool, Never>(false)
isLoading.value = true              // read or write
isLoading.send(false)               // equivalent to .value =

// Future - single async result
let future = Future<Data, URLError> { promise in
    URLSession.shared.dataTask(with: url) { data, _, error in
        if let data { promise(.success(data)) }
        else { promise(.failure(error as! URLError)) }
    }.resume()
}

// Deferred - lazy Future
let lazy = Deferred { Future<Int, Never> { p in p(.success(42)) } }
""")
        }
    }
}

