//
//
//  3_TransformingOperators.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `17/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine

// MARK: - LESSON 3: Transforming Operators
struct CBTransformVisual: View {
    @State private var selectedDemo  = 0
    @State private var inputValue    = "5"
    @State private var scanAccum     = 0
    @State private var scanHistory: [Int] = []
    @State private var collectCount  = 3
    @State private var cancellables  = Set<AnyCancellable>()
    @State private var outputLog: [String] = []

    let demos = ["map & flatMap", "scan & collect", "compactMap & more"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Transforming operators", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cbOrange)

                tabSelector(demos: demos, selected: $selectedDemo)

                switch selectedDemo {
                case 0: mapFlatMapView
                case 1: scanCollectView
                default: compactMapView
                }
            }
        }
    }

    // MARK: map & flatMap
    var mapFlatMapView: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text("Input:").font(.system(size: 12)).foregroundStyle(.secondary)
                TextField("Number", text: $inputValue)
                    .textFieldStyle(.roundedBorder).font(.system(size: 13))
                    .keyboardType(.numberPad).frame(width: 80)
                Button("Run map") { runMap() }
                    .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                    .padding(.horizontal, 12).padding(.vertical, 7)
                    .background(Color.cbOrange).clipShape(RoundedRectangle(cornerRadius: 8))
                    .buttonStyle(PressableButtonStyle())
            }

            // Pipeline diagram
            VStack(spacing: 4) {
                operatorStepRow(op: "Source: [\(inputValue)]", color: .cbOrange)
                operatorStepRow(op: ".map { $0 * 2 }  → [\(Int(inputValue) ?? 0) × 2 = \((Int(inputValue) ?? 0) * 2)]", color: Color(hex: "#0F766E"))
                operatorStepRow(op: ".map { String($0) } → \"\((Int(inputValue) ?? 0) * 2)\"", color: Color(hex: "#1D4ED8"))
            }

            logBox(entries: outputLog)

            Divider()

            // flatMap explanation
            VStack(alignment: .leading, spacing: 5) {
                Text("flatMap - transform then flatten").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.cbOrange)
                PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "// map wraps in a publisher - you get Publisher<Publisher<T>>\n// flatMap unwraps - you get Publisher<T>\n[\"hello\", \"world\"].publisher\n    .flatMap { word in word.publisher }  // Publisher<Character>\n    .collect()                           // [\"h\",\"e\",\"l\",\"l\",\"o\",\"w\",\"o\",\"r\",\"l\",\"d\"]\n\n// Network use: chaining requests\nuserPublisher\n    .flatMap { user in fetchProfile(user.id) }  // returns Publisher")
            }
        }
    }

    // MARK: scan & collect
    var scanCollectView: some View {
        VStack(spacing: 8) {
            // scan - running total
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text("scan - running accumulation").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.cbOrange)
                    Spacer()
                    Text("Total: \(scanAccum)").font(.system(size: 12, weight: .bold, design: .monospaced)).foregroundStyle(Color.cbOrange)
                        .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: scanAccum)
                }

                HStack(spacing: 6) {
                    ForEach([1, 5, 10, -3, 20], id: \.self) { val in
                        Button("\(val > 0 ? "+" : "")\(val)") {
                            withAnimation(.spring(bounce: 0.3)) {
                                scanAccum += val
                                scanHistory.append(scanAccum)
                            }
                        }
                        .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(val > 0 ? Color.cbOrange : Color.animCoral)
                        .clipShape(Capsule())
                        .buttonStyle(PressableButtonStyle())
                    }
                    Button("Reset") {
                        withAnimation { scanAccum = 0; scanHistory = [] }
                    }
                    .font(.system(size: 11)).foregroundStyle(Color.cbOrange)
                    .padding(.horizontal, 8).padding(.vertical, 6)
                    .background(Color.cbOrangeLight).clipShape(Capsule())
                    .buttonStyle(PressableButtonStyle())
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(scanHistory.suffix(12).indices, id: \.self) { i in
                            Text("\(scanHistory.suffix(12)[i])")
                                .font(.system(size: 10, design: .monospaced)).foregroundStyle(.white)
                                .padding(.horizontal, 7).padding(.vertical, 3)
                                .background(Color.cbOrange)
                                .clipShape(Capsule())
                        }
                    }
                }
                .frame(height: 24)

                PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: ".scan(0) { accumulated, next in\n    accumulated + next\n}  // emits running total after each value")
            }
            .padding(8).background(Color.cbOrangeLight.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 8))

            // collect
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text("collect - buffer N values into array").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color(hex: "#1D4ED8"))
                    Spacer()
                    Stepper(value: $collectCount, in: 2...6) {
                        Text("N=\(collectCount)").font(.system(size: 11, design: .monospaced)).foregroundStyle(Color(hex: "#1D4ED8"))
                    }
                }
                PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "(1...10).publisher\n    .collect(\(collectCount))  // groups into arrays of \(collectCount)\n    .sink { print($0) }\n// → [1,2,3] → [4,5,6] → [7,8,9] → [10]")
            }
            .padding(8).background(Color(hex: "#EFF6FF").opacity(0.7)).clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    // MARK: compactMap & others
    var compactMapView: some View {
        VStack(spacing: 8) {
            operatorCard("compactMap", color: .cbOrange,
                desc: "Like map but discards nil results - analogous to Swift's compactMap on sequences",
                code: "[\"1\",\"two\",\"3\",\"four\"].publisher\n    .compactMap { Int($0) }  // filters out nils\n    .sink { print($0) }     // → 1, 3")

            operatorCard("replaceNil(with:)", color: Color(hex: "#0F766E"),
                desc: "Replace nil values with a default - avoids force-unwrapping optionals",
                code: "[\"a\", nil, \"b\", nil].publisher\n    .replaceNil(with: \"default\")\n    .sink { print($0) }  // a, default, b, default")

            operatorCard("setFailureType(to:)", color: Color(hex: "#1D4ED8"),
                desc: "Converts a Publisher<Output, Never> to Publisher<Output, SomeError> for chaining with failable operators",
                code: "Just(42)\n    .setFailureType(to: URLError.self)\n    .flatMap { n in makeNetworkCall(n) }  // now types align")

            operatorCard("switchToLatest", color: Color(hex: "#7C3AED"),
                desc: "Flattens a Publisher<Publisher<T>, E> - cancels previous inner publisher when a new one arrives",
                code: "// Classic search: cancel inflight network call on new keypress\n$searchText\n    .map { makeSearchPublisher($0) }  // Publisher<Publisher<Results>>\n    .switchToLatest()                  // only latest search active")
        }
    }

    func runMap() {
        outputLog = []
        let num = Int(inputValue) ?? 5
        [num].publisher
            .map { $0 * 2 }
            .map { "String(\($0))" }
            .sink { _ in } receiveValue: { v in
                outputLog.insert("→ map result: \(v)", at: 0)
            }
            .store(in: &cancellables)
        outputLog.insert("→ source: \(num)", at: 0)
    }

    func operatorStepRow(op: String, color: Color) -> some View {
        Text(op).font(.system(size: 9, design: .monospaced)).foregroundStyle(color)
            .padding(6).frame(maxWidth: .infinity, alignment: .leading)
            .background(color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 6))
    }

    func operatorCard(_ name: String, color: Color, desc: String, code: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name).font(.system(size: 11, weight: .semibold, design: .monospaced)).foregroundStyle(color)
            Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            Text(code).font(.system(size: 8, design: .monospaced)).foregroundStyle(color)
                .padding(6).background(color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 5))
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(8).background(Color.cbOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func logBox(entries: [String]) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            ForEach(entries.prefix(5), id: \.self) { e in
                Text(e).font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
            }
            if entries.isEmpty { Text("(tap Run to see output)").font(.system(size: 10)).foregroundStyle(Color(.systemGray4)) }
        }
        .frame(maxWidth: .infinity, minHeight: 40, alignment: .topLeading)
        .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
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

struct CBTransformExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Transforming operators")
            Text("Transforming operators change the Output type or structure of a publisher stream. map, flatMap, compactMap, and scan mirror their Swift sequence counterparts - but operate on asynchronous streams of values.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "map { transform } - synchronously transform each value. Can change Output type.", color: .cbOrange)
                StepRow(number: 2, text: "flatMap { value in anotherPublisher } - transform and flatten inner publishers. Use for async chaining.", color: .cbOrange)
                StepRow(number: 3, text: "compactMap { optionalTransform } - like map but drops nil results. Useful for parsing.", color: .cbOrange)
                StepRow(number: 4, text: "scan(initial) { acc, next in } - running accumulation. Emits after each input.", color: .cbOrange)
                StepRow(number: 5, text: "collect(n) - buffers n values then emits as [Output]. collect() (no arg) collects ALL then emits on completion.", color: .cbOrange)
                StepRow(number: 6, text: "switchToLatest - for Publisher<Publisher<T>>: cancels previous inner publisher when new one arrives.", color: .cbOrange)
            }

            CalloutBox(style: .info, title: "flatMap vs switchToLatest", contentBody: "flatMap merges ALL inner publishers concurrently - results from all are interleaved. switchToLatest subscribes to the latest inner publisher only and cancels the previous one. Use switchToLatest for search-as-you-type (cancel inflight request on new keystroke).")

            CodeBlock(code: """
// map - transform each value
[1, 2, 3].publisher
    .map { $0 * $0 }          // → 1, 4, 9
    .map { "num: \\($0)" }    // → "num: 1", "num: 4", "num: 9"

// flatMap - network chain
usersPublisher
    .flatMap { user in
        fetchOrders(for: user.id)  // returns Publisher<[Order], Error>
    }
    .sink { orders in print(orders) }

// compactMap - parse with fallback
["1", "abc", "2"].publisher
    .compactMap { Int($0) }   // drops nil → 1, 2

// scan - running total
scoreEvents.publisher
    .scan(0) { total, score in total + score }
    .sink { print("Score:", $0) }

// collect - group into arrays
URLSession.shared.dataTaskPublisher(for: url)
    .map(\\.data)
    .collect()   // waits for completion, emits [Data]
""")
        }
    }
}
