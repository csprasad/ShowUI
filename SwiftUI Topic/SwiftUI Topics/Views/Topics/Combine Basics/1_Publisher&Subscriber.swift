//
//
//  1_Publisher&Subscriber.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `17/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine

// MARK: - LESSON 1: Publisher & Subscriber
struct CBPubSubVisual: View {
    @State private var selectedDemo = 0
    @State private var log: [LogEntry]  = []
    @State private var isRunning        = false
    @State private var cancellables     = Set<AnyCancellable>()
    @State private var stepIndex        = 0

    struct LogEntry: Identifiable {
        let id = UUID()
        let text: String
        let kind: Kind
        enum Kind { case publisher, operator_, subscriber, lifecycle, error }
        var color: Color {
            switch kind {
            case .publisher:  return .cbOrange
            case .operator_:  return Color(hex: "#0F766E")
            case .subscriber: return Color(hex: "#1D4ED8")
            case .lifecycle:  return Color(hex: "#7C3AED")
            case .error:      return Color(hex: "#E11D48")
            }
        }
        var icon: String {
            switch kind {
            case .publisher:  return "antenna.radiowaves.left.and.right"
            case .operator_:  return "arrow.triangle.2.circlepath"
            case .subscriber: return "tray.fill"
            case .lifecycle:  return "circle.dashed"
            case .error:      return "xmark.circle.fill"
            }
        }
    }

    let demos = ["Anatomy", "Lifecycle sim", "Marble diagram"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Publisher & Subscriber", systemImage: "antenna.radiowaves.left.and.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cbOrange)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; log = []; stepIndex = 0 }
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
                    anatomyView
                case 1:
                    lifecycleSimulator
                default:
                    marbleDiagram
                }
            }
        }
    }

    // MARK: Anatomy
    var anatomyView: some View {
        VStack(spacing: 8) {
            // Pipeline visual
            HStack(spacing: 0) {
                pipeNode("Publisher", icon: "antenna.radiowaves.left.and.right", color: .cbOrange,
                         note: "Produces values\nover time")
                pipeArrow
                pipeNode("Operator", icon: "arrow.triangle.2.circlepath", color: Color(hex: "#0F766E"),
                         note: "Transforms\nvalues")
                pipeArrow
                pipeNode("Subscriber", icon: "tray.fill", color: Color(hex: "#1D4ED8"),
                         note: "Consumes\nvalues")
            }

            // Three signals
            VStack(spacing: 6) {
                signalRow("Output<T>", color: .cbOrange,   desc: "Normal value emitted down the pipeline")
                signalRow("failure(E)", color: Color(hex: "#E11D48"), desc: "Error terminates the stream permanently")
                signalRow("finished",   color: Color(hex: "#7C3AED"), desc: "Completion - stream ends normally")
            }

            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "// The Publisher protocol\npublisher                         // emits: Output, Failure\n    .map { transform($0) }          // operator\n    .sink(                          // subscriber\n        receiveCompletion: { ... },\n        receiveValue: { value in ... }\n    )\n    .store(in: &cancellables)       // retain the subscription")
        }
    }

    // MARK: Lifecycle
    var lifecycleSimulator: some View {
        VStack(spacing: 10) {
            // Animated pipeline steps
            let steps: [(String, LogEntry.Kind, String)] = [
                ("Publisher created - no work starts yet", .lifecycle,   "1. Create"),
                ("Subscriber calls subscribe() - demand sent upstream", .subscriber, "2. Subscribe"),
                ("Publisher sends subscription to subscriber", .publisher, "3. Handshake"),
                ("Subscriber requests .unlimited demand", .subscriber,   "4. Demand"),
                ("Publisher emits value: 42", .publisher,  "5. Emit 42"),
                ("Operator maps: 42 → \"answer: 42\"", .operator_,      "6. Transform"),
                ("Subscriber receives \"answer: 42\"", .subscriber,      "7. Receive"),
                ("Publisher sends .finished", .publisher,  "8. Finish"),
                ("Subscription cancelled - memory freed", .lifecycle,    "9. Cancel"),
            ]

            // Log
            VStack(alignment: .leading, spacing: 4) {
                ForEach(log.suffix(6)) { entry in
                    HStack(spacing: 6) {
                        Image(systemName: entry.icon).font(.system(size: 10)).foregroundStyle(entry.color)
                        Text(entry.text).font(.system(size: 10)).foregroundStyle(.secondary)
                    }
                }
                if log.isEmpty {
                    Text("Tap the button to walk through the lifecycle")
                        .font(.system(size: 10)).foregroundStyle(Color(.systemGray4))
                }
            }
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .topLeading)
            .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))

            // Step / Reset
            if stepIndex < steps.count {
                Button(stepIndex == 0 ? "▶ Start lifecycle" : "Next step →") {
                    withAnimation(.spring(response: 0.3)) {
                        let step = steps[stepIndex]
                        log.append(LogEntry(text: step.0, kind: step.1))
                        stepIndex += 1
                    }
                }
                .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 10)
                .background(Color.cbOrange).clipShape(RoundedRectangle(cornerRadius: 10))
                .buttonStyle(PressableButtonStyle())
            } else {
                Button("↩ Reset") {
                    withAnimation { log = []; stepIndex = 0 }
                }
                .font(.system(size: 13, weight: .semibold)).foregroundStyle(Color.cbOrange)
                .frame(maxWidth: .infinity).padding(.vertical, 10)
                .background(Color.cbOrangeLight).clipShape(RoundedRectangle(cornerRadius: 10))
                .buttonStyle(PressableButtonStyle())
            }
        }
    }

    // MARK: Marble diagram
    var marbleDiagram: some View {
        VStack(spacing: 10) {
            Text("Marble diagram - time flows left → right").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

            VStack(spacing: 12) {
                marbleRow(label: "Publisher", marbles: [(20,"1",.cbOrange),(40,"2",.cbOrange),(60,"3",.cbOrange),(80,"4",.cbOrange)], hasEnd: true, endColor: .cbOrange)
                Image(systemName: "arrow.down").font(.system(size: 11)).foregroundStyle(.secondary).frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 60)
                marbleRow(label: ".filter{$0>1}", marbles: [(40,"2",Color(hex: "#0F766E")),(60,"3",Color(hex: "#0F766E")),(80,"4",Color(hex: "#0F766E"))], hasEnd: true, endColor: Color(hex: "#0F766E"))
                Image(systemName: "arrow.down").font(.system(size: 11)).foregroundStyle(.secondary).frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 60)
                marbleRow(label: ".map{$0*10}", marbles: [(40,"20",Color(hex: "#1D4ED8")),(60,"30",Color(hex: "#1D4ED8")),(80,"40",Color(hex: "#1D4ED8"))], hasEnd: true, endColor: Color(hex: "#1D4ED8"))
            }

            HStack(spacing: 8) {
                legendDot(.cbOrange, "Emitted value")
                legendDot(Color(hex: "#7C3AED"), "Completion |")
                legendDot(Color(hex: "#E11D48"), "Error ×")
            }
        }
    }

    func pipeNode(_ title: String, icon: String, color: Color, note: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 18)).foregroundStyle(color)
            Text(title).font(.system(size: 10, weight: .semibold)).foregroundStyle(color)
            Text(note).font(.system(size: 8)).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(8).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    var pipeArrow: some View {
        Image(systemName: "chevron.right.2")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color(.systemGray3))
            .padding(.horizontal, 4)
    }

    func signalRow(_ name: String, color: Color, desc: String) -> some View {
        HStack(spacing: 8) {
            Text(name).font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(color)
                .frame(width: 80, alignment: .leading)
            Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(7).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 7))
    }

    func marbleRow(label: String, marbles: [(Double, String, Color)], hasEnd: Bool, endColor: Color) -> some View {
        HStack(spacing: 0) {
            Text(label).font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                .frame(width: 80, alignment: .trailing)
            GeometryReader { geo in
                let w = max(1, geo.size.width)
                ZStack(alignment: .leading) {
                    // Timeline
                    Capsule().fill(Color(.systemGray4)).frame(height: 2).frame(maxWidth: .infinity)
                    // Marbles
                    ForEach(marbles, id: \.1) { (pos, val, color) in
                        ZStack {
                            Circle().fill(color).frame(width: 22, height: 22)
                            Text(val).font(.system(size: 9, weight: .bold)).foregroundStyle(.white)
                        }
                        .offset(x: w * pos / 100 - 11)
                    }
                    // End marker
                    if hasEnd {
                        Rectangle().fill(endColor).frame(width: 3, height: 18)
                            .offset(x: w * 0.95 - 1)
                    }
                }
            }
            .frame(height: 24)
        }
    }

    func legendDot(_ color: Color, _ label: String) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label).font(.system(size: 9)).foregroundStyle(.secondary)
        }
    }
}

struct CBPubSubExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Publisher, Subscriber, and the contract")
            Text("Combine is Apple's reactive programming framework. A Publisher emits a sequence of values over time - or never. A Subscriber receives those values. Between them, Operators transform the stream. The entire chain is lazy: nothing runs until a Subscriber attaches.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Publisher<Output, Failure> - declares what it emits and what errors it can throw.", color: .cbOrange)
                StepRow(number: 2, text: "Subscriber attaches via .sink() or .assign(). Until then, nothing happens.", color: .cbOrange)
                StepRow(number: 3, text: "Three events flow downstream: value (Output), completion (.finished), failure (.failure(E)).", color: .cbOrange)
                StepRow(number: 4, text: "AnyCancellable - the token returned by .sink(). Store it or the subscription cancels immediately.", color: .cbOrange)
                StepRow(number: 5, text: ".store(in: &cancellables) - retains subscriptions for the lifetime of the Set<AnyCancellable>.", color: .cbOrange)
                StepRow(number: 6, text: "Backpressure - subscribers can request demand; publishers respect it. Most built-in publishers use .unlimited.", color: .cbOrange)
            }

            CalloutBox(style: .danger, title: "Store the AnyCancellable", contentBody: "If you discard the AnyCancellable returned by .sink(), the subscription immediately cancels and you'll receive no values. Always store it: assign to a property, or call .store(in: &cancellables) on a Set<AnyCancellable>.")

            CodeBlock(code: """
import Combine

var cancellables = Set<AnyCancellable>()

// Basic subscription
[1, 2, 3].publisher
    .map { $0 * 2 }
    .sink(
        receiveCompletion: { completion in
            switch completion {
            case .finished:       print("Done")
            case .failure(let e): print("Error:", e)
            }
        },
        receiveValue: { value in
            print("Got:", value)  // 2, 4, 6
        }
    )
    .store(in: &cancellables)

// Publisher protocol (simplified)
protocol Publisher {
    associatedtype Output
    associatedtype Failure: Error
    func receive<S: Subscriber>(subscriber: S)
        where S.Input == Output, S.Failure == Failure
}
""")
        }
    }
}
