//
//
//  4_FilteringOperators.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `17/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine

// MARK: - LESSON 4: Filtering Operators
struct CBFilterVisual: View {
    @State private var selectedDemo = 0
    @State private var debounceText = ""
    @State private var debouncedResult = ""
    @State private var throttleCount  = 0
    @State private var cancellables   = Set<AnyCancellable>()
    @State private var debouncePublisher = PassthroughSubject<String, Never>()
    @State private var lastUpdate: Date = .now
    @State private var removeDupInput = ""
    @State private var dupLog: [String] = []

    let demos = ["filter & removeDups", "debounce & throttle", "drop & prefix"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Filtering operators", systemImage: "line.3.horizontal.decrease.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cbOrange)

                tabSelector(demos: demos, selected: $selectedDemo)

                switch selectedDemo {
                case 0: filterRemoveDupsView
                case 1: debounceThrottleView
                default: dropPrefixView
                }
            }
        }
        .onAppear { setupDebounce() }
    }

    // MARK: filter & removeDuplicates
    var filterRemoveDupsView: some View {
        VStack(spacing: 8) {
            // filter live
            VStack(alignment: .leading, spacing: 6) {
                Text("filter { condition }").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.cbOrange)
                let numbers = [1,2,3,4,5,6,7,8,9,10]
                HStack(spacing: 4) {
                    ForEach(numbers, id: \.self) { n in
                        Text("\(n)").font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(n % 2 == 0 ? Color.white : Color(.systemGray3))
                            .frame(width: 24, height: 24)
                            .background(n % 2 == 0 ? Color.cbOrange : Color(.systemFill))
                            .clipShape(Circle())
                    }
                }
                Text("Only even numbers pass through (n % 2 == 0)").font(.system(size: 10)).foregroundStyle(.secondary)
                codeSnip("(1...10).publisher\n    .filter { $0 % 2 == 0 }\n    .sink { print($0) }  // 2, 4, 6, 8, 10")
            }.frame(maxWidth: .infinity)
            .padding(8).background(Color.cbOrangeLight.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 8))

            // removeDuplicates
            VStack(alignment: .leading, spacing: 6) {
                Text("removeDuplicates - drop consecutive repeats").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color(hex: "#1D4ED8"))
                HStack(spacing: 8) {
                    TextField("Type same letter twice…", text: $removeDupInput)
                        .textFieldStyle(.roundedBorder).font(.system(size: 12))
                        .autocorrectionDisabled().textInputAutocapitalization(.never)
                        .onChange(of: removeDupInput) { _, v in
                            if v != dupLog.last {
                                withAnimation { dupLog.append(v) }
                            }
                        }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(dupLog.suffix(8), id: \.self) { val in
                            Text("\"\(val)\"").font(.system(size: 9, design: .monospaced)).foregroundStyle(.white)
                                .padding(.horizontal, 5).padding(.vertical, 2)
                                .background(Color(hex: "#1D4ED8"))
                                .clipShape(Capsule())
                        }
                    }
                }
                .frame(height: 22)
                codeSnip("subject.removeDuplicates()  // only emit when value changes\n// For custom types: .removeDuplicates(by: { $0.id == $1.id })")
            }
            .padding(8).background(Color(hex: "#EFF6FF").opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    // MARK: debounce & throttle
    var debounceThrottleView: some View {
        VStack(spacing: 10) {
            // Debounce demo
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "clock.badge.checkmark").foregroundStyle(Color.cbOrange)
                    Text("debounce - wait for pause before emitting").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.cbOrange)
                }
                Text("Type quickly - only the final value (after 0.5s silence) passes through. Used for search bars.").font(.system(size: 10)).foregroundStyle(.secondary)

                TextField("Type quickly to test debounce…", text: $debounceText)
                    .textFieldStyle(.roundedBorder).font(.system(size: 13))
                    .autocorrectionDisabled().textInputAutocapitalization(.never)
                    .onChange(of: debounceText) { _, v in
                        debouncePublisher.send(v)
                    }

                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Raw input:").font(.system(size: 9)).foregroundStyle(.secondary)
                        Text("\"\(debounceText)\"").font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.cbOrange)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Debounced (0.5s):").font(.system(size: 9)).foregroundStyle(.secondary)
                        Text("\"\(debouncedResult)\"").font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(Color.formGreen)
                    }
                }
                .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(8).background(Color.cbOrangeLight.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 8))

            // throttle explanation
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "metronome").foregroundStyle(Color(hex: "#7C3AED"))
                    Text("throttle - max one value per time window").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color(hex: "#7C3AED"))
                }
                HStack(spacing: 16) {
                    compareCard("debounce(0.5s)", color: .cbOrange,
                                when: "After N seconds of silence",
                                use: "Search bars, autocomplete")
                    compareCard("throttle(0.5s)", color: Color(hex: "#7C3AED"),
                                when: "At most once per N seconds",
                                use: "Button rate-limit, scroll events")
                }
            }
        }
    }

    // MARK: drop & prefix
    var dropPrefixView: some View {
        VStack(spacing: 8) {
            let items = (1...8).map { $0 }
            let dropped = Array(items.dropFirst(2))
            let prefixed = Array(items.prefix(3))

            opDemoRow("dropFirst(2)", color: .cbOrange, input: items, output: dropped,
                      desc: "Ignore first N values then pass everything through")
            opDemoRow("prefix(3)", color: Color(hex: "#1D4ED8"), input: items, output: prefixed,
                      desc: "Only pass first N values, then complete")

            VStack(spacing: 6) {
                filterCodeRow("drop(while:)", code: ".drop(while: { $0 < 5 })  // skip until condition false")
                filterCodeRow("prefix(while:)", code: ".prefix(while: { $0 < 5 })  // take until condition false")
                filterCodeRow("dropFirst()",    code: ".dropFirst()  // ignore the very first value")
                filterCodeRow("first()",        code: ".first()  // complete after first value")
                filterCodeRow("last()",         code: ".last()  // emit only last value on completion")
                filterCodeRow("output(at:)",    code: ".output(at: 2)  // emit only element at index 2")
            }
        }
    }

    func setupDebounce() {
        debouncePublisher
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { v in withAnimation { debouncedResult = v } }
            .store(in: &cancellables)
    }

    func opDemoRow(_ op: String, color: Color, input: [Int], output: [Int], desc: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(op).font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(color)
            HStack(spacing: 4) {
                ForEach(input, id: \.self) { n in
                    Text("\(n)").font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(output.contains(n) ? .white : Color(.systemGray3))
                        .frame(width: 22, height: 22)
                        .background(output.contains(n) ? color : Color(.systemFill))
                        .clipShape(Circle())
                }
            }
            Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func compareCard(_ title: String, color: Color, when: String, use: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title).font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(color)
            Text("When: \(when)").font(.system(size: 9)).foregroundStyle(.secondary)
            Text("Use: \(use)").font(.system(size: 9)).foregroundStyle(color)
        } .frame(maxWidth: .infinity, alignment: .leading)
        .padding(7).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 7))
    }

    func filterCodeRow(_ name: String, code: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text(name).font(.system(size: 9, weight: .semibold, design: .monospaced)).foregroundStyle(Color.cbOrange).frame(width: 80, alignment: .leading)
            Text(code).font(.system(size: 8, design: .monospaced)).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(6).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 6))
    }

    func codeSnip(_ t: String) -> some View {
        Text(t).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.cbOrange)
            .padding(6).background(Color.cbOrangeLight).clipShape(RoundedRectangle(cornerRadius: 6))
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

struct CBFilterExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Filtering operators")
            Text("Filtering operators selectively pass values downstream, discard duplicates, rate-limit emissions, or skip/take a certain count. debounce and throttle are especially important for search bars and user input handling.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "filter { bool } - pass values where the condition is true, discard the rest.", color: .cbOrange)
                StepRow(number: 2, text: "removeDuplicates() - only emit when value changes from the previous emission.", color: .cbOrange)
                StepRow(number: 3, text: "debounce(for: .seconds(0.5), scheduler: RunLoop.main) - wait for silence before emitting.", color: .cbOrange)
                StepRow(number: 4, text: "throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true) - max one per interval.", color: .cbOrange)
                StepRow(number: 5, text: "dropFirst(n) - skip first n values. drop(while:) - skip while condition true.", color: .cbOrange)
                StepRow(number: 6, text: "prefix(n) - emit n values then complete. first() / last() - single value variants.", color: .cbOrange)
            }

            CalloutBox(style: .success, title: "debounce for search bars", contentBody: "Pair debounce(for: .milliseconds(300), scheduler: RunLoop.main) with a text field publisher to avoid firing a network request on every keystroke. The pipeline only fires 300ms after the user stops typing.")

            CodeBlock(code: """
// Search bar pipeline
@Published var searchText = ""

$searchText
    .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
    .removeDuplicates()           // don't re-search same text
    .filter { $0.count >= 2 }     // require at least 2 chars
    .flatMap { text in
        searchPublisher(text)
    }
    .receive(on: RunLoop.main)
    .assign(to: &$searchResults)

// throttle - rate-limit button taps
buttonTapSubject
    .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: false)
    .sink { performExpensiveAction() }

// drop & prefix
(1...10).publisher
    .dropFirst(3)           // skip 1,2,3
    .prefix(4)              // take 4,5,6,7 then stop
    .drop(while: { $0 < 5 })   // skip 4 → 5,6,7
""")
        }
    }
}

