//
//
//  3_ binding.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `01/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: @Binding

struct BindingVisual: View {
    @State private var isOn = false
    @State private var sliderValue: CGFloat = 0.5
    @State private var selectedColor = 0

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("@Binding", systemImage: "arrow.left.and.right.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sbOrange)

                // Ownership diagram
                ZStack {
                    Color(.secondarySystemBackground)
                    VStack(spacing: 8) {
                        // Parent owns state
                        HStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.sbOrangeLight)
                                .frame(height: 36)
                                .overlay(
                                    Text("Parent - @State private var isOn = \(isOn ? "true" : "false")")
                                        .font(.system(size: 10, design: .monospaced))
                                        .foregroundStyle(Color.sbOrange)
                                )
                        }

                        // Arrow showing binding
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                            Text("$isOn (Binding<Bool>)")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundStyle(.secondary)
                            Image(systemName: "arrow.up")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }

                        // Child receives binding
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemFill))
                            .frame(height: 36)
                            .overlay(
                                Text("Child - @Binding var isOn: Bool")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundStyle(.primary)
                            )
                    }
                    .padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.easeInOut(duration: 0.2), value: isOn)

                // Live demos
                // Toggle child
                BindingToggleChild(isOn: $isOn)

                // Slider child
                BindingSliderChild(value: $sliderValue)

                // Color picker child - multiple bindings
                BindingColorChild(selected: $selectedColor)
            }
        }
    }
}

// Child views that receive @Binding

struct BindingToggleChild: View {
    @Binding var isOn: Bool  // doesn't own - just a reference

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: isOn ? "lightbulb.fill" : "lightbulb")
                .font(.system(size: 20))
                .foregroundStyle(isOn ? .yellow : .secondary)
                .animation(.spring(duration: 0.3, bounce: 0.4), value: isOn)
            Text("Child toggle - changes parent @State")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.sbOrange)
        }
        .padding(10)
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct BindingSliderChild: View {
    @Binding var value: CGFloat

    var body: some View {
        HStack(spacing: 10) {
            Text("Child slider")
                .font(.system(size: 12)).foregroundStyle(.secondary)
            Slider(value: $value, in: 0...1).tint(.sbOrange)
            Text("\(Int(value * 100))%")
                .font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary)
                .frame(width: 36)
        }
        .padding(10)
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct BindingColorChild: View {
    @Binding var selected: Int
    let colors: [(name: String, color: Color)] = [
        ("Orange", .sbOrange), ("Teal", .animTeal), ("Purple", .animPurple)
    ]

    var body: some View {
        HStack(spacing: 8) {
            Text("Child picker")
                .font(.system(size: 12)).foregroundStyle(.secondary)
            ForEach(colors.indices, id: \.self) { i in
                Button {
                    withAnimation(.spring(duration: 0.3)) { selected = i }
                } label: {
                    Circle()
                        .fill(colors[i].color)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Circle().stroke(.white, lineWidth: selected == i ? 2.5 : 0)
                        )
                        .shadow(color: colors[i].color.opacity(0.4), radius: selected == i ? 4 : 0)
                }
                .buttonStyle(PressableButtonStyle())
            }
            Spacer()
            Text(colors[selected].name)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(colors[selected].color)
                .animation(.easeInOut(duration: 0.2), value: selected)
        }
        .padding(10)
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct BindingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "@Binding - sharing state downward")
            Text("@Binding creates a two-way connection to state owned elsewhere. The child view can read and write the value, but it doesn't own it - the parent does. When the child writes, the parent's @State updates, which re-renders both views.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Parent declares @State. Only the parent owns and initializes the value.", color: .sbOrange)
                StepRow(number: 2, text: "Parent passes $stateName to the child - the $ prefix creates a Binding<T> from the @State.", color: .sbOrange)
                StepRow(number: 3, text: "Child declares @Binding var name: T - no initial value, it receives the reference.", color: .sbOrange)
                StepRow(number: 4, text: "Child writes to $name - the mutation propagates back to the parent's @State, triggering re-renders in both.", color: .sbOrange)
            }

            CalloutBox(style: .info, title: "The $ prefix explained", contentBody: "Writing count gives you the Int value. Writing $count gives you a Binding<Int> - a reference to the storage, not the value itself. Pass $count when you want a child to be able to write back.")

            CalloutBox(style: .success, title: "Single source of truth", contentBody: "@Binding enforces one of SwiftUI's core principles: one view owns the state, others reference it. This prevents the bugs that come from multiple views each holding their own copy of the same value.")

            CalloutBox(style: .warning, title: "Don't create @Binding yourself", contentBody: "Almost always, @Binding comes from a parent's @State via $. Constructing Binding(get:set:) manually is a code smell - if you find yourself doing that, reconsider where the state lives.")

            CodeBlock(code: """
// Parent - owns the state
struct ParentView: View {
    @State private var isOn = false  // ← owns it

    var body: some View {
        ChildToggle(isOn: $isOn)     // ← passes binding
    }
}

// Child - references the state
struct ChildToggle: View {
    @Binding var isOn: Bool          // ← no initial value

    var body: some View {
        Toggle("Enable", isOn: $isOn) // ← can read & write
    }
}

// Multiple bindings to the same state
struct ColorPicker: View {
    @Binding var red: Double
    @Binding var green: Double
    @Binding var blue: Double
    // All write back to different @State in the parent
}
""")
        }
    }
}
