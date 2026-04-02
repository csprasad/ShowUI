//
//
//  1_stateBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `01/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: @State Basics

struct StateBasicsVisual: View {
    @State private var count = 0
    @State private var isOn = false
    @State private var name = "World"
    @State private var progress: CGFloat = 0.4

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("@State basics", systemImage: "circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sbOrange)

                // Counter — the classic @State demo
                VStack(spacing: 10) {
                    sectionLabel("Counter")
                    HStack(spacing: 16) {
                        Button {
                            withAnimation(.spring(duration: 0.3, bounce: 0.4)) { count -= 1 }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(count == 0 ? Color(.systemGray4) : Color.sbOrange)
                        }
                        .buttonStyle(PressableButtonStyle())
                        .disabled(count == 0)

                        Text("\(count)")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.sbOrange)
                            .frame(minWidth: 60)
                            .contentTransition(.numericText())
                            .animation(.spring(duration: 0.3), value: count)

                        Button {
                            withAnimation(.spring(duration: 0.3, bounce: 0.4)) { count += 1 }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(Color.sbOrange)
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                // Toggle
                VStack(spacing: 8) {
                    sectionLabel("Bool state")
                    HStack {
                        Image(systemName: isOn ? "sun.max.fill" : "moon.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(isOn ? .yellow : .indigo)
                            .animation(.spring(duration: 0.4, bounce: 0.3), value: isOn)
                        Text(isOn ? "Light mode" : "Dark mode")
                            .font(.system(size: 14, weight: .medium))
                        Spacer()
                        Toggle("", isOn: $isOn)
                            .labelsHidden()
                            .tint(.sbOrange)
                    }
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // String state
                VStack(spacing: 8) {
                    sectionLabel("String state")
                    HStack(spacing: 8) {
                        ForEach(["World", "SwiftUI", "iOS"], id: \.self) { n in
                            Button {
                                withAnimation(.spring(duration: 0.3)) { name = n }
                            } label: {
                                Text(n)
                                    .font(.system(size: 12, weight: name == n ? .semibold : .regular))
                                    .foregroundStyle(name == n ? Color.sbOrange : .secondary)
                                    .padding(.horizontal, 12).padding(.vertical, 6)
                                    .background(name == n ? Color.sbOrangeLight : Color(.systemFill))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                    Text("Hello, \(name)!")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .animation(.spring(duration: 0.3), value: name)
                }

                // State drives the code label
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 12)).foregroundStyle(Color.sbOrange)
                    Text("Every @State change above triggers a view re-render automatically")
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                }
                .padding(10)
                .background(Color.sbOrangeLight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(.secondary)
    }
}

struct StateBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "What is @State?")
            Text("@State is a property wrapper that tells SwiftUI: \"this value belongs to this view, and when it changes, re-render the view.\" It is the foundation of all interactivity in SwiftUI.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@State stores a value inside the view. SwiftUI manages the storage - not the struct itself.", color: .sbOrange)
                StepRow(number: 2, text: "When a @State value changes, SwiftUI automatically calls body again to re-render the view.", color: .sbOrange)
                StepRow(number: 3, text: "Always mark @State as private - it belongs to this view only. Never pass @State to another view directly.", color: .sbOrange)
                StepRow(number: 4, text: "@State works for value types: Bool, Int, String, CGFloat, arrays, structs.", color: .sbOrange)
            }

            CalloutBox(style: .info, title: "SwiftUI owns the storage", contentBody: "Even though a SwiftUI View is a struct and gets recreated constantly, @State values persist across re-renders. SwiftUI stores them in a separate heap allocation tied to the view's identity - not the struct itself.")

            CalloutBox(style: .warning, title: "private is important", contentBody: "@State is local to this view. If you find yourself wanting to pass @State up to a parent or sideways to a sibling, that's a signal the state belongs higher up the tree - use @Binding or @Observable instead.")

            CodeBlock(code: """
struct CounterView: View {
    @State private var count = 0      // owned by this view
    @State private var isVisible = true

    var body: some View {
        VStack {
            if isVisible {
                Text("Count: \\(count)")
            }

            Button("Increment") {
                count += 1            // triggers re-render
            }

            Button("Toggle") {
                isVisible.toggle()    // triggers re-render
            }
        }
    }
}
""")
        }
    }
}
