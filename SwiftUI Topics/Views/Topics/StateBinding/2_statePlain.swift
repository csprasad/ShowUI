//
//
//  2_ statePlain.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `01/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: State vs Plain Property

struct StatePlainVisual: View {
    // @State - causes re-render
    @State private var stateCount = 0

    // Plain var - does NOT cause re-render
    var plainCount = 0

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("State vs plain property", systemImage: "exclamationmark.triangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sbOrange)

                // Side by side comparison
                HStack(spacing: 10) {
                    // @State version
                    VStack(spacing: 10) {
                        Text("@State")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundStyle(Color.sbOrange)
                            .padding(.horizontal, 10).padding(.vertical, 4)
                            .background(Color.sbOrangeLight)
                            .clipShape(Capsule())

                        ZStack {
                            Color(.secondarySystemBackground)
                            VStack(spacing: 6) {
                                Text("\(stateCount)")
                                    .font(.system(size: 36, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.sbOrange)
                                    .contentTransition(.numericText())
                                    .animation(.spring(duration: 0.3), value: stateCount)
                                Text("updates ✓")
                                    .font(.system(size: 11)).foregroundStyle(Color.sbOrange)
                            }
                        }
                        .frame(height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        Button {
                            stateCount += 1
                        } label: {
                            Text("Tap me")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 9)
                                .background(Color.sbOrange)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                    .frame(maxWidth: .infinity)

                    // Plain var version — shows the problem
                    PlainCounterView()
                        .frame(maxWidth: .infinity)
                }

                // Explanation
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color(hex: "#1D9E75")).font(.system(size: 12))
                        Text("@State - SwiftUI watches this, re-renders on change")
                            .font(.system(size: 12)).foregroundStyle(.secondary)
                    }
                    HStack(spacing: 6) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color(hex: "#E24B4A")).font(.system(size: 12))
                        Text("var - changes silently, SwiftUI never knows, view stays stale")
                            .font(.system(size: 12)).foregroundStyle(.secondary)
                    }
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

// Separate struct to demonstrate plain var problem
// (mutating var in a struct requires mutating func,
//  and SwiftUI Views can't have mutating body)
struct PlainCounterView: View {
    @State private var fakeTapCount = 0  // just to show the button works
    @State private var displayCount = 0  // we'll deliberately not update this

    var body: some View {
        VStack(spacing: 10) {
            Text("plain var")
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundStyle(Color(hex: "#E24B4A"))
                .padding(.horizontal, 10).padding(.vertical, 4)
                .background(Color(hex: "#FCEBEB"))
                .clipShape(Capsule())

            ZStack {
                Color(.secondarySystemBackground)
                VStack(spacing: 6) {
                    Text("\(displayCount)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(.systemGray3))
                    Text("stuck at 0 ✗")
                        .font(.system(size: 11)).foregroundStyle(Color(hex: "#E24B4A"))
                }
            }
            .frame(height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button {
                fakeTapCount += 1
                // displayCount += 1 would work if it were @State
                // without @State, SwiftUI never re-renders
            } label: {
                Text("Tap me")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background(Color(.systemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(PressableButtonStyle())
        }
    }
}

struct StatePlainExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Why plain var doesn't work")
            Text("SwiftUI views are structs, and structs are value types. Every time body is called, a brand new struct is created. A plain var on that struct has no special status - SwiftUI doesn't watch it, so changes to it never trigger a re-render.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "SwiftUI calls body to produce a view description. It doesn't re-call body unless it knows something changed.", color: .sbOrange)
                StepRow(number: 2, text: "The only way SwiftUI knows to re-call body is if a @State, @Binding, @Observable, or @Environment value changes.", color: .sbOrange)
                StepRow(number: 3, text: "A plain var mutates silently. SwiftUI has no observer on it — the view stays stale.", color: .sbOrange)
                StepRow(number: 4, text: "You can't even write 'count += 1' in a Button action if count is a plain var — structs require mutating functions, and body can't be mutating.", color: .sbOrange)
            }

            CalloutBox(style: .info, title: "The mental model", contentBody: "Think of @State as a signal flare. When the value changes, it fires a signal to SwiftUI: 'this view needs to be redrawn.' Plain properties have no flare - the change happens in silence and SwiftUI never reacts.")

            CalloutBox(style: .success, title: "When plain let/var IS correct", contentBody: "Data that comes from outside and never changes inside this view - like a title string or a fixed color — should be a plain let or var property. If the view receives it and never modifies it, @State would be wrong.")

            CodeBlock(code: """
// ✗ Plain var — SwiftUI can't observe this
struct BrokenCounter: View {
    var count = 0  // plain property

    var body: some View {
        Button("Tap") {
            count += 1  // ← compile error: cannot mutate
        }
    }
}

// ✓ @State — SwiftUI observes and re-renders
struct WorkingCounter: View {
    @State private var count = 0  // watched by SwiftUI

    var body: some View {
        Button("Tap: \\(count)") {
            count += 1  // ← triggers re-render ✓
        }
    }
}

// ✓ Plain let — data from outside, never mutated
struct TitleView: View {
    let title: String  // correct - this view doesn't own it

    var body: some View {
        Text(title)
    }
}
""")
        }
    }
}
