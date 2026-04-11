//
//
//  2_@BindingDeepDive.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: @Binding Deep Dive
struct BindingDeepDiveVisual: View {
    // Parent owns the truth
    @State private var parentText   = "Hello"
    @State private var parentToggle = true
    @State private var parentCount  = 0
    @State private var selectedDemo = 0
    let demos = ["Parent → child", "Custom binding", "Binding transforms"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("@Binding deep dive", systemImage: "arrow.left.arrow.right.circle.fill")
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
                    // Parent-child flow
                    VStack(spacing: 10) {
                        // Parent state display
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Image(systemName: "crown.fill").font(.system(size: 11)).foregroundStyle(Color.obsGreen)
                                Text("Parent owns @State").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.obsGreen)
                            }
                            HStack(spacing: 12) {
                                stateChip("text", value: "\"\(parentText)\"", color: .obsGreen)
                                stateChip("toggle", value: parentToggle ? "true" : "false", color: .obsEmerald)
                                stateChip("count", value: "\(parentCount)", color: .obsGreen)
                            }.frame(maxWidth: .infinity)
                        }
                        .padding(10).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 10))

                        // Arrow
                        HStack {
                            Spacer()
                            VStack(spacing: 2) {
                                Image(systemName: "arrow.down").font(.system(size: 12)).foregroundStyle(Color.obsGreen)
                                Text("$binding").font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.obsGreen)
                            }
                            Spacer()
                        }

                        // Child receives binding
                        BindingChildView(text: $parentText, isOn: $parentToggle, count: $parentCount)
                    }

                case 1:
                    // Custom Binding(get:set:)
                    VStack(spacing: 10) {
                        // Positive-only binding
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Constrained binding - positive only").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            let positiveBinding = Binding<Int>(
                                get: { parentCount },
                                set: { parentCount = max(0, $0) }  // clamp to positive
                            )
                            Stepper(value: positiveBinding, in: 0...100) {
                                HStack {
                                    Text("Count (≥ 0)").font(.system(size: 13))
                                    Spacer()
                                    Text("\(parentCount)")
                                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                                        .foregroundStyle(Color.obsGreen)
                                        .contentTransition(.numericText())
                                        .animation(.spring(duration: 0.2), value: parentCount)
                                }
                            }
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        // String ↔ Int bridging
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Bridge binding - String from Int").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            let intAsString = Binding<String>(
                                get: { "\(parentCount)" },
                                set: { parentCount = Int($0) ?? parentCount }
                            )
                            HStack(spacing: 8) {
                                Text("Int source: \(parentCount)").font(.system(size: 13)).foregroundStyle(Color.obsGreen)
                                Spacer()
                                TextField("type number", text: intAsString)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numberPad)
                                    .frame(width: 100)
                            }
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }

                default:
                    // Binding transforms
                    VStack(alignment: .leading, spacing: 10) {
                        // Negated binding
                        HStack {
                            Text("isOn = \(parentToggle ? "true" : "false")").font(.system(size: 13))
                            Spacer()
                            Toggle("", isOn: $parentToggle).labelsHidden().tint(.obsGreen)
                        }
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

                        HStack {
                            Text("isOff (negated) = \(!parentToggle ? "true" : "false")").font(.system(size: 13)).foregroundStyle(.secondary)
                            Spacer()
                            Toggle("", isOn: Binding(
                                get: { !parentToggle },
                                set: { parentToggle = !$0 }
                            )).labelsHidden().tint(.animCoral)
                        }
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

                        // .constant()
                        VStack(alignment: .leading, spacing: 6) {
                            Text(".constant() - read-only binding for previews").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            Toggle("Read-only toggle", isOn: .constant(true)).disabled(true)
                                .padding(.horizontal, 12).padding(.vertical, 8)
                                .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        codeChip("Binding.constant(true) - preview-only, read-only")
                        codeChip("Binding(get: { }, set: { }) - full custom bridge")
                    }
                }
            }
        }
    }

    func stateChip(_ label: String, value: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.system(size: 11, weight: .semibold, design: .monospaced)).foregroundStyle(color)
            Text(label).font(.system(size: 9)).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity)
        .padding(.horizontal, 8).padding(.vertical, 4)
        .background(color.opacity(0.12)).clipShape(RoundedRectangle(cornerRadius: 6))
    }

    func codeChip(_ code: String) -> some View {
        Text(code)
            .font(.system(size: 9, design: .monospaced))
            .foregroundStyle(Color.obsGreen)
            .padding(7).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

// Child view that receives bindings
struct BindingChildView: View {
    @Binding var text:  String
    @Binding var isOn:  Bool
    @Binding var count: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "square.fill").font(.system(size: 11)).foregroundStyle(.secondary)
                Text("Child receives @Binding").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
            }
            HStack(spacing: 8) {
                TextField("Edit text", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 13))
                Toggle("", isOn: $isOn).labelsHidden().tint(.obsGreen)
                Stepper("", value: $count).labelsHidden()
            }
            Text("Changes here update the parent automatically")
                .font(.system(size: 10)).foregroundStyle(.secondary)
        }
        .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct BindingDeepDiveExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "@Binding - two-way connection")
            Text("@Binding creates a two-way connection to state owned elsewhere. Changes in the child propagate back to the parent automatically. The child doesn't own the data - it borrows a reference to the parent's storage.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "struct Child { @Binding var value: Int } - declare. Parent passes: Child(value: $state).", color: .obsGreen)
                StepRow(number: 2, text: "Never @State in child for shared data - that creates a copy, changes don't propagate.", color: .obsGreen)
                StepRow(number: 3, text: "Binding(get:set:) - construct a custom binding with arbitrary logic (clamping, transforms, bridges).", color: .obsGreen)
                StepRow(number: 4, text: ".constant(value) - read-only binding. Perfect for SwiftUI previews or disabled controls.", color: .obsGreen)
                StepRow(number: 5, text: "$binding - prefix creates a Binding from an @State, @Binding, or @Published property.", color: .obsGreen)
            }

            CalloutBox(style: .info, title: "Binding(get:set:) for logic", contentBody: "Custom Binding(get:set:) lets you clamp values (min 0), bridge types (String from Int), negate booleans, or derive a Binding from unrelated storage. All without extra @State.")

            CodeBlock(code: """
// Basic - pass down with $
struct Parent: View {
    @State private var isOn = false
    var body: some View {
        ChildView(isOn: $isOn)   // ← $ creates Binding
    }
}

struct ChildView: View {
    @Binding var isOn: Bool       // ← receives Binding
    var body: some View {
        Toggle("Active", isOn: $isOn)
    }
}

// Custom Binding - clamped value
let clamped = Binding<Int>(
    get: { rawValue },
    set: { rawValue = max(0, min(100, $0)) }
)

// Negated boolean
let isOff = Binding(
    get: { !isOn },
    set: { isOn = !$0 }
)

// Preview constant
ChildView(isOn: .constant(true))
""")
        }
    }
}

