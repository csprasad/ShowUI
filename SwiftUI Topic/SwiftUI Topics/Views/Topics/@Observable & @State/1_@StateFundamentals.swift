//
//
//  1_@StateFundamentals.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: @State Fundamentals
struct StateFoundationsVisual: View {
    // Each @State creates a slot owned by this view
    @State private var counter     = 0
    @State private var text        = ""
    @State private var isOn        = false
    @State private var items       = ["Apple", "Banana", "Cherry"]
    @State private var renderCount = 0
    @State private var selectedDemo = 0

    let demos = ["Ownership", "Value types", "Render tracking"]

    var body: some View {
         VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("@State fundamentals", systemImage: "circle.dashed.inset.filled")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.obsGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.obsGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.obsGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    VStack(alignment:.leading, spacing: 10) {
                        // Visual ownership diagram
                        VStack(alignment:.leading, spacing: 0) {
                            ownershipRow(icon: "rectangle.fill",     label: "View body",         desc: "Recomputed on state change",     color: .obsGreen)
                            ownershipRow(icon: "tray.fill",          label: "@State counter",    desc: "Persists between re-renders",    color: .obsEmerald)
                            ownershipRow(icon: "tray.fill",          label: "@State text",       desc: "Lives as long as view exists",   color: .obsEmerald)
                            ownershipRow(icon: "tray.fill",          label: "@State isOn",       desc: "Destroyed when view disappears", color: Color(hex: "#4ADE80"))
                        }
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                        // Live state demo
                        HStack(spacing: 12) {
                            counterCard("counter", value: counter, color: .obsGreen)
                            counterCard("items", value: items.count, color: .obsEmerald)
                        }
                        HStack(spacing: 8) {
                            Button("+ counter") {
                                withAnimation(.spring(bounce: 0.3)) { counter += 1 }
                            }.smallButton(color: .obsGreen)
                            Button("+ item") {
                                withAnimation(.spring(bounce: 0.3)) { items.append("Item \(items.count + 1)") }
                            }.smallButton(color: .obsEmerald)
                            Button("reset") {
                                withAnimation { counter = 0; items = ["Apple", "Banana", "Cherry"] }
                            }.smallButton(color: .animCoral)
                        }
                    }

                case 1:
                    VStack(alignment:.leading, spacing: 10) {
                        Text("@State wraps value types - SwiftUI detects any mutation")
                            .font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        VStack(spacing: 6) {
                            typeRow("Int",    code: "@State var count = 0",            ok: true)
                            typeRow("String", code: "@State var name = \"\"",          ok: true)
                            typeRow("Bool",   code: "@State var flag = false",         ok: true)
                            typeRow("Array",  code: "@State var items: [String] = []", ok: true)
                            typeRow("Struct", code: "@State var model = MyStruct()",   ok: true)
                            typeRow("class",  code: "@State var obj = MyClass()",      ok: false)
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 12)).foregroundStyle(Color.animAmber)
                            Text("A class inside @State won't trigger re-renders when its properties change - use @Observable instead.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color(hex: "#FAEEDA")).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    VStack(spacing: 10) {
                        Text("Tap anything to see the render counter increment")
                            .font(.system(size: 11)).foregroundStyle(.secondary)

                        VStack(spacing: 10) {
                            VStack(spacing: 4) {
                                Text("\(renderCount)")
                                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                                    .foregroundStyle(Color.obsGreen)
                                    .contentTransition(.numericText())
                                    .animation(.spring(duration: 0.2), value: renderCount)
                                Text("renders").font(.system(size: 11)).foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(12).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 12))

                            HStack(spacing: 8) {
                                Button("Toggle") { isOn.toggle() }.smallButton(color: .obsGreen).buttonStyle(PressableButtonStyle())
                                Button("Type")   { text = text.isEmpty ? "Hello" : "" }.smallButton(color: .obsEmerald).buttonStyle(PressableButtonStyle())
                                Button("Count")  { counter += 1 }.smallButton(color: Color(hex: "#4ADE80"))  .buttonStyle(PressableButtonStyle())
                            }
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.obsGreen)
                            Text("Every @State change triggers a body re-evaluation. SwiftUI diffs the result against the previous render - only changed views update in UIKit.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .onAppear { renderCount += 1 }
        .onChange(of: counter) { _, _ in renderCount += 1 }
        .onChange(of: text) { _, _ in renderCount += 1 }
        .onChange(of: isOn) { _, _ in renderCount += 1 }
        .onChange(of: items) { _, _ in renderCount += 1 }
        .onChange(of: selectedDemo) { _, _ in renderCount += 1 }
    }

    func ownershipRow(icon: String, label: String, desc: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 14)).foregroundStyle(color).frame(width: 22)
            VStack(alignment: .leading, spacing: 1) {
                Text(label).font(.system(size: 12, weight: .semibold))
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
    }

    func counterCard(_ label: String, value: Int, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundStyle(color)
                .contentTransition(.numericText())
                .animation(.spring(duration: 0.2), value: value)
            Text(label).font(.system(size: 11)).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity).padding(10)
        .background(color.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func typeRow(_ type: String, code: String, ok: Bool) -> some View {
        HStack(spacing: 8) {
            Text(type).font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary).frame(width: 42)
            Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(ok ? Color.obsGreen : Color.animCoral)
            Spacer()
            Image(systemName: ok ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 13)).foregroundStyle(ok ? Color.obsGreen : Color.animCoral)
        }
        .padding(7).background(ok ? Color.obsGreenLight.opacity(0.6) : Color(hex: "#FCEBEB")).clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

private extension View {
    func smallButton(color: Color) -> some View {
        self
            .font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
            .padding(.horizontal, 12).padding(.vertical, 7)
            .background(color).clipShape(RoundedRectangle(cornerRadius: 8))
            .buttonStyle(PressableButtonStyle())
    }
}

struct StateFoundationsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "@State - source of truth")
            Text("@State allocates storage managed by SwiftUI outside the view struct. When the value changes, SwiftUI invalidates the view and calls body again. The state persists as long as the view stays in the hierarchy.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@State var x = 0 - SwiftUI owns the storage. Never put it in init without @State.", color: .obsGreen)
                StepRow(number: 2, text: "Always private - @State is local truth. If siblings need it, lift it to the parent.", color: .obsGreen)
                StepRow(number: 3, text: "Value types only - structs, enums, primitives. A class inside @State doesn't trigger re-renders.", color: .obsGreen)
                StepRow(number: 4, text: "Body re-evaluates on every @State mutation - SwiftUI diffs and only redraws what changed.", color: .obsGreen)
                StepRow(number: 5, text: "Initial value is only used when the view first appears - not on re-renders.", color: .obsGreen)
            }

            CalloutBox(style: .warning, title: "@State is private source of truth", contentBody: "If two sibling views both need the same value, @State is in the wrong place - lift it to their shared parent and pass $binding down. @State should never be public or passed between unrelated views.")

            CodeBlock(code: """
struct CounterView: View {
    @State private var count = 0    // ← owned here

    var body: some View {
        VStack {
            Text("\\(count)")
                .contentTransition(.numericText())
            Button("Increment") { count += 1 }
            ChildView(count: $count)  // pass as Binding
        }
    }
}

// ✗ Wrong - don't set @State from outside
struct BadView: View {
    @State var value: Int  // public - wrong!
    init(v: Int) { _value = State(initialValue: v) }
}

// ✓ Better - pass as let
struct GoodView: View {
    let initialValue: Int
    @State private var value: Int
    init(initialValue: Int) {
        self.initialValue = initialValue
        _value = State(initialValue: initialValue)
    }
}
""")
        }
    }
}
