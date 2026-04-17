//
//
//  5_CombiningOperators.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `17/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine

// MARK: - LESSON 5: Combining Operators
struct CBCombiningVisual: View {
    @State private var selectedDemo = 0
    @State private var cancellables = Set<AnyCancellable>()
    @State private var mergeLog: [String] = []
    @State private var zipLog:   [String] = []
    @State private var clLog:    [String] = []
    @State private var aValue    = 0
    @State private var bValue    = 0
    let demos = ["merge & zip", "combineLatest", "append & prepend"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Combining operators", systemImage: "arrow.triangle.merge")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cbOrange)

                tabSelector(demos: demos, selected: $selectedDemo)

                switch selectedDemo {
                case 0: mergeZipView
                case 1: combineLatestView
                default: appendPrependView
                }
            }
        }
    }

    // MARK: merge & zip
    var mergeZipView: some View {
        VStack(spacing: 8) {
            // Marble diagrams
            VStack(spacing: 6) {
                mergeZipDiagram(
                    op: "merge",
                    color: .cbOrange,
                    streamA: [(15,"A1"),(45,"A2"),(75,"A3")],
                    streamB: [(30,"B1"),(60,"B2")],
                    output:  [(15,"A1"),(30,"B1"),(45,"A2"),(60,"B2"),(75,"A3")],
                    desc: "Interleaves values from both - as soon as either emits"
                )
                mergeZipDiagram(
                    op: "zip",
                    color: Color(hex: "#1D4ED8"),
                    streamA: [(15,"A1"),(45,"A2"),(75,"A3")],
                    streamB: [(30,"B1"),(60,"B2")],
                    output:  [(30,"(A1,B1)"),(60,"(A2,B2)")],
                    desc: "Pairs values one-to-one - waits for both sides"
                )
            }

            // Live demo
            HStack(spacing: 8) {
                streamButton("Send A \(aValue + 1)", color: .cbOrange) {
                    aValue += 1
                    withAnimation { mergeLog.insert("A→ \(aValue)", at: 0) }
                }
                streamButton("Send B \(bValue + 1)", color: Color(hex: "#1D4ED8")) {
                    bValue += 1
                    withAnimation {
                        mergeLog.insert("B→ \(bValue)", at: 0)
                        if aValue > 0 && bValue > 0 {
                            zipLog.insert("zip: (A\(aValue), B\(bValue))", at: 0)
                        }
                    }
                }
                streamButton("Reset", color: .secondary) {
                    withAnimation { aValue = 0; bValue = 0; mergeLog = []; zipLog = [] }
                }
            }

            HStack(spacing: 8) {
                logMini(title: "merge output", entries: mergeLog, color: .cbOrange)
                logMini(title: "zip output", entries: zipLog, color: Color(hex: "#1D4ED8"))
            }
        }
    }

    // MARK: combineLatest
    var combineLatestView: some View {
        VStack(spacing: 10) {
            Text("combineLatest - emit when EITHER changes, using latest from both").font(.system(size: 11)).foregroundStyle(.secondary)

            // Two sliders → combineLatest
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Text("A:").font(.system(size: 12)).foregroundStyle(Color.cbOrange).frame(width: 16)
                    Slider(value: Binding(get: { CGFloat(aValue) }, set: { v in aValue = Int(v)
                        withAnimation { clLog.insert("(A=\(aValue), B=\(bValue))", at: 0) }
                    }), in: 0...10, step: 1).tint(.cbOrange)
                    Text("\(aValue)").font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.cbOrange).frame(width: 20)
                }
                HStack(spacing: 8) {
                    Text("B:").font(.system(size: 12)).foregroundStyle(Color(hex: "#1D4ED8")).frame(width: 16)
                    Slider(value: Binding(get: { CGFloat(bValue) }, set: { v in bValue = Int(v)
                        withAnimation { clLog.insert("(A=\(aValue), B=\(bValue))", at: 0) }
                    }), in: 0...10, step: 1).tint(Color(hex: "#1D4ED8"))
                    Text("\(bValue)").font(.system(size: 12, design: .monospaced)).foregroundStyle(Color(hex: "#1D4ED8")).frame(width: 20)
                }
            }
            .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

            // combineLatest result
            HStack(spacing: 10) {
                Image(systemName: "arrow.triangle.merge").foregroundStyle(Color.cbOrange)
                Text("combineLatest: (\(aValue), \(bValue)) = \(aValue + bValue)")
                    .font(.system(size: 13, weight: .semibold))
                    .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: aValue + bValue)
                Spacer()
            }
            .padding(10).background(Color.cbOrangeLight).clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                ForEach(clLog.prefix(4), id: \.self) { e in
                    Text(e).font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 40, alignment: .topLeading)
            .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))

            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "Publishers.CombineLatest(publisherA, publisherB)\n    .map { a, b in a + b }\n    .sink { sum in print(sum) }\n\n// Form validation: username AND password both valid\nPublishers.CombineLatest($username, $password)\n    .map { u, p in !u.isEmpty && p.count >= 8 }\n    .assign(to: &$isFormValid)")
        }
    }

    // MARK: append & prepend
    var appendPrependView: some View {
        VStack(spacing: 8) {
            appendRow("prepend([0,0])",   color: .cbOrange,
                      input: [1,2,3], prepend: [0,0], append: nil,
                      desc: "Add values BEFORE the publisher starts")
            appendRow("append([98,99])",  color: Color(hex: "#1D4ED8"),
                      input: [1,2,3], prepend: nil, append: [98,99],
                      desc: "Add values AFTER the publisher completes")
            appendRow("prepend + append", color: Color(hex: "#0F766E"),
                      input: [1,2,3], prepend: [0], append: [99],
                      desc: "Both - output: 0, 1, 2, 3, 99")

            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: """
(1...3).publisher
    .prepend(0, 0)    // prepend values  → 0, 0, 1, 2, 3
    .append(98, 99)   // append values   → 0, 0, 1, 2, 3, 98, 99
    .sink { print($0) }

// prepend another publisher
publisher1
    .prepend(publisher0)  // publisher0 emits first, then publisher1

// append with sequence
publisher
    .append([100, 200, 300])
""")
        }
    }

    func mergeZipDiagram(op: String, color: Color, streamA: [(Double,String)], streamB: [(Double,String)], output: [(Double,String)], desc: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Text(op).font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(color)
                    .padding(.horizontal, 8).padding(.vertical, 3).background(color.opacity(0.12)).clipShape(Capsule())
                Text(desc).font(.system(size: 9)).foregroundStyle(.secondary)
            }
            timelineRow("A:", marbles: streamA, color: color)
            timelineRow("B:", marbles: streamB, color: color.opacity(0.6))
            Image(systemName: "arrow.down").font(.system(size: 9)).foregroundStyle(.secondary).padding(.leading, 20)
            timelineRow("→:", marbles: output, color: color)
        }
        .padding(8).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func timelineRow(_ label: String, marbles: [(Double, String)], color: Color) -> some View {
        HStack(spacing: 0) {
            Text(label).font(.system(size: 9)).foregroundStyle(.secondary).frame(width: 20)
            GeometryReader { geo in
                let w = max(1, geo.size.width)
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(.systemGray4)).frame(height: 1.5).frame(maxWidth: .infinity)
                    ForEach(marbles, id: \.1) { (pos, val) in
                        ZStack {
                            Circle().fill(color).frame(width: 20, height: 20)
                            Text(val).font(.system(size: 7, weight: .bold)).foregroundStyle(.white).minimumScaleFactor(0.5)
                        }
                        .offset(x: w * pos / 100 - 10)
                    }
                }
            }
            .frame(height: 22)
        }
    }

    func appendRow(_ op: String, color: Color, input: [Int], prepend: [Int]?, append: [Int]?, desc: String) -> some View {
        let full: [Int] = (prepend ?? []) + input + (append ?? [])
        return VStack(alignment: .leading, spacing: 4) {
            Text(op).font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(color)
            HStack(spacing: 4) {
                ForEach(full, id: \.self) { n in
                    let isPrepend = prepend?.contains(n) == true && !input.contains(n)
                    let isAppend  = append?.contains(n) == true && !input.contains(n)
                    Text("\(n)").font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(isPrepend || isAppend ? .white : color)
                        .frame(width: 24, height: 24)
                        .background(isPrepend || isAppend ? color : color.opacity(0.15))
                        .clipShape(Circle())
                }
            }.frame(maxWidth: .infinity)
            Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity)
        .padding(8).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func streamButton(_ title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 8)
            .background(color).clipShape(RoundedRectangle(cornerRadius: 8))
            .buttonStyle(PressableButtonStyle())
    }

    func logMini(title: String, entries: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title).font(.system(size: 9, weight: .semibold)).foregroundStyle(color)
            ForEach(entries.prefix(3), id: \.self) { e in
                Text(e).font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
            }
            if entries.isEmpty { Text("(empty)").font(.system(size: 9)).foregroundStyle(Color(.systemGray4)) }
        }
        .frame(maxWidth: .infinity, minHeight: 48, alignment: .topLeading)
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

struct CBCombiningExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Combining multiple publishers")
            Text("Combining operators join multiple publishers into one. merge interleaves values from all sources. zip pairs values one-to-one. combineLatest emits a new pair whenever either source changes - perfect for form validation.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Publishers.MergeMany / .merge - interleave values from multiple publishers as they arrive.", color: .cbOrange)
                StepRow(number: 2, text: "Publishers.Zip / .zip - pair values one-to-one. Waits until both sides have a value.", color: .cbOrange)
                StepRow(number: 3, text: "Publishers.CombineLatest - emit (latest-A, latest-B) whenever EITHER side emits. Requires one value from each side first.", color: .cbOrange)
                StepRow(number: 4, text: ".append(values) - add values/publisher AFTER the upstream completes.", color: .cbOrange)
                StepRow(number: 5, text: ".prepend(values) - add values/publisher BEFORE the upstream starts.", color: .cbOrange)
                StepRow(number: 6, text: ".switchToLatest - subscribe to latest inner publisher, cancel previous. Use after .map { innerPublisher }.", color: .cbOrange)
            }

            CodeBlock(code: """
// merge - interleave
let a = [1, 3, 5].publisher
let b = [2, 4, 6].publisher
a.merge(with: b)             // any order: 1,2,3,4,5,6 or similar
    .sink { print($0) }

// zip - pair one-to-one
Publishers.Zip(a, b)         // (1,2), (3,4), (5,6)
    .sink { print($0, $1) }

// combineLatest - form validation
Publishers.CombineLatest($username, $password)
    .map { user, pass in
        user.count >= 3 && pass.count >= 8
    }
    .assign(to: &$isValid)

// append + prepend
(1...5).publisher
    .prepend(-1, 0)          // -1, 0, 1, 2, 3, 4, 5
    .append(6, 7)            // -1, 0, 1, 2, 3, 4, 5, 6, 7
""")
        }
    }
}
