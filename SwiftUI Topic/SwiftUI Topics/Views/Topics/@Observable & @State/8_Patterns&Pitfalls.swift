//
//
//  8_ Patterns&Pitfalls.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Patterns & Pitfalls
struct ObsPatternsVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Common mistakes", "Derived state", "Identity"]

    // Models for demos
    @State private var mistakeCounter = 0

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Patterns & pitfalls", systemImage: "exclamationmark.triangle.fill")
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
                    // Common mistakes
                    VStack(spacing: 8) {
                        mistakeRow(bad: true,
                                   code: "@State private var m = MyModel()\n// in ForEach row - recreated on identity change",
                                   fix: "Keep model in parent or in @State at a stable level")
                        mistakeRow(bad: true,
                                   code: "let model = MyModel()\n// @State not used - recreated every render",
                                   fix: "@State private var model = MyModel()")
                        mistakeRow(bad: true,
                                   code: "// Mutating @Observable in background thread\nTask { model.count += 1 }",
                                   fix: "Use @MainActor on the model class or await MainActor.run { }")
                        mistakeRow(bad: true,
                                   code: "// Class stored in @State without @Observable\n@State var m = MyPlainClass()",
                                   fix: "Add @Observable to the class")
                        mistakeRow(bad: false,
                                   code: "@State private var model = MyModel()\n// Correct - @State keeps model alive",
                                   fix: "✓ This is the correct pattern")
                    }

                case 1:
                    // Derived state patterns
                    VStack(spacing: 10) {
                        Text("Build derived state as computed properties, not stored").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        VStack(spacing: 6) {
                            derivedRow(good: false,
                                       code: "@State private var fullName = \"\"\n// Syncing firstName + lastName manually",
                                       desc: "Requires manual sync - can get out of date")
                            derivedRow(good: true,
                                       code: "// In @Observable model:\nvar fullName: String { \"\\(first) \\(last)\" }",
                                       desc: "Computed - always current, tracked automatically")
                            derivedRow(good: false,
                                       code: "@State private var itemCount = 0\nitems.onChange { itemCount = items.count }",
                                       desc: "Duplicate state - use items.count directly")
                            derivedRow(good: true,
                                       code: "// Directly: Text(\"\\(items.count) items\")\n// Or: var count: Int { items.count }",
                                       desc: "Derived from source of truth - never stale")
                        }
                    }

                default:
                    // Identity
                    VStack(spacing: 8) {
                        Text("View identity determines when @State resets").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        identityRow(good: true,
                                    desc: ".id(item.id) - stable ID keeps @State alive across list re-renders",
                                    code: "ForEach(items) { item in\n  RowView(item: item).id(item.id)\n}")
                        identityRow(good: false,
                                    desc: "No .id - list reorder reuses views, @State may bleed between items",
                                    code: "ForEach(items, id: \\.index) { ... }")
                        identityRow(good: true,
                                    desc: "Structural identity - if/else always resets @State in each branch",
                                    code: "if showA { ViewA() } else { ViewB() }\n// SwiftUI knows these are different")

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.obsGreen)
                            Text("SwiftUI uses view type + position in the tree as default identity. Explicit .id() overrides this.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    func mistakeRow(bad: Bool, code: String, fix: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 6) {
                Image(systemName: bad ? "xmark.circle.fill" : "checkmark.circle.fill")
                    .font(.system(size: 12)).foregroundStyle(bad ? Color.animCoral : Color.obsGreen)
                Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(bad ? Color.animCoral : Color.obsGreen)
            }
            if bad {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.right").font(.system(size: 9)).foregroundStyle(Color.obsGreen)
                    Text(fix).font(.system(size: 10)).foregroundStyle(Color.obsGreen)
                }
                .padding(.leading, 18)
            }
        } .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(bad ? Color(hex: "#FCEBEB") : Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func derivedRow(good: Bool, code: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: good ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 12)).foregroundStyle(good ? Color.obsGreen : Color.animCoral).padding(.top, 1)
            VStack(alignment: .leading, spacing: 2) {
                Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(good ? Color.obsGreen : Color.animCoral)
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(good ? Color.obsGreenLight.opacity(0.6) : Color(hex: "#FCEBEB")).clipShape(RoundedRectangle(cornerRadius: 7))
    }

    func identityRow(good: Bool, desc: String, code: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: good ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .font(.system(size: 12)).foregroundStyle(good ? Color.obsGreen : Color.animAmber).padding(.top, 1)
            VStack(alignment: .leading, spacing: 3) {
                Text(desc).font(.system(size: 11))
                Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(good ? Color.obsGreen : Color.animAmber)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(good ? Color.obsGreenLight.opacity(0.6) : Color(hex: "#FAEEDA")).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ObsPatternsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Patterns & pitfalls")
            Text("Most state bugs fall into a few categories: wrong ownership level, mutating on background threads, duplicate state, and identity confusion. Understanding the rules prevents the most common mistakes.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Wrong level: if two views need the same state, lift it to their common parent.", color: .obsGreen)
                StepRow(number: 2, text: "Background mutation: @Observable and @State must only be mutated on the main thread. Use @MainActor.", color: .obsGreen)
                StepRow(number: 3, text: "Duplicate state: don't mirror one source of truth into another @State. Use computed properties.", color: .obsGreen)
                StepRow(number: 4, text: "Identity: use stable IDs in ForEach - index-based IDs reset @State on reorder.", color: .obsGreen)
                StepRow(number: 5, text: "Forgetting @State: let model = MyModel() in a View is recreated every render. Always @State.", color: .obsGreen)
            }

            CalloutBox(style: .danger, title: "Always mutate on main thread", contentBody: "@Observable and @State must be read and written on the main thread. Mutating them from a Task or background queue causes data races. Mark your model class @MainActor or use await MainActor.run { }.")

            CodeBlock(code: """
// ✗ Background mutation
Task {
    let data = await fetchData()
    model.items = data  // ← data race!
}

// ✓ Main actor
@MainActor
@Observable
class Store {
    var items: [Item] = []

    func load() async {
        let data = await fetchData()
        items = data  // ← safe, MainActor
    }
}

// ✗ Duplicate state
@State private var count = 0
@State private var isZero = true
onChange(of: count) { isZero = count == 0 }  // fragile

// ✓ Computed property
@State private var count = 0
var isZero: Bool { count == 0 }  // always current
""")
        }
    }
}

