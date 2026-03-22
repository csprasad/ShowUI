//
//
//  8_ContentTransition.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Content Transitions
struct ContentTransitionVisual: View {
    @State private var value = 1000
    @State private var text = "Hello"
    @State private var selectedTransition = 0
    @State private var useNumeric = true

    let textOptions = ["Hello", "SwiftUI", "Animate", "Show UI", "Swift"]
    let transitions = ["numericText", "interpolate", "identity", "opacity"]

    var contentTransition: ContentTransition {
        switch selectedTransition {
        case 0: return .numericText()
        case 1: return .interpolate
        case 2: return .identity
        default: return .opacity
        }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Content transitions", systemImage: "textformat.123")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.animBlue)

                // Mode toggle
                HStack(spacing: 8) {
                    Button {
                        withAnimation(.spring(response: 0.3)) { useNumeric = true }
                    } label: {
                     Text("Numbers")
                        .font(.system(size: 12, weight: useNumeric ? .semibold : .regular))
                        .foregroundStyle(useNumeric ? Color.animBlue : .secondary)
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(useNumeric ? Color(hex: "#E6F1FB") : Color(.systemFill))
                        .clipShape(Capsule())
                    }.buttonStyle(PressableButtonStyle())

                    Button {
                        withAnimation(.spring(response: 0.3)) { useNumeric = false }
                    } label : {
                        Text("Text")
                            .font(.system(size: 12, weight: !useNumeric ? .semibold : .regular))
                            .foregroundStyle(!useNumeric ? Color.animBlue : .secondary)
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(!useNumeric ? Color(hex: "#E6F1FB") : Color(.systemFill))
                            .clipShape(Capsule())
                    }.buttonStyle(PressableButtonStyle())

                    Spacer()
                }

                // Preview
                ZStack {
                    Color(.secondarySystemBackground)
                    if useNumeric {
                        Text("\(value)")
                            .font(.system(size: 52, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.animBlue)
                            .contentTransition(contentTransition)
                            .animation(.spring(duration: 0.5, bounce: 0.2), value: value)
                    } else {
                        Text(text)
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.animBlue)
                            .contentTransition(contentTransition)
                            .animation(.spring(duration: 0.5, bounce: 0.2), value: text)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Controls
                if useNumeric {
                    HStack(spacing: 8) {
                        Button("−100") { withAnimation { value -= 100 } }
                        Button("−10")  { withAnimation { value -= 10  } }
                        Button("−1")   { withAnimation { value -= 1   } }
                        Spacer()
                        Button("+1")   { withAnimation { value += 1   } }
                        Button("+10")  { withAnimation { value += 10  } }
                        Button("+100") { withAnimation { value += 100 } }
                    }
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundStyle(Color.animBlue)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(textOptions, id: \.self) { option in
                                Button(option) {
                                    withAnimation { text = option }
                                }
                                .font(.system(size: 12, weight: text == option ? .semibold : .regular))
                                .foregroundStyle(text == option ? Color.animBlue : .secondary)
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(text == option ? Color(hex: "#E6F1FB") : Color(.systemFill))
                                .clipShape(Capsule())
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                    }
                }

                // Transition selector
                HStack(spacing: 8) {
                    ForEach(transitions.indices, id: \.self) { i in
                        Button(transitions[i]) {
                            withAnimation(.spring(response: 0.3)) { selectedTransition = i }
                        }
                        .font(.system(size: 10, weight: selectedTransition == i ? .semibold : .regular, design: .monospaced))
                        .foregroundStyle(selectedTransition == i ? Color.animBlue : .secondary)
                        .padding(.horizontal, 8).padding(.vertical, 5)
                        .background(selectedTransition == i ? Color(hex: "#E6F1FB") : Color(.systemFill))
                        .clipShape(Capsule())
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
        }
    }
}

struct ContentTransitionExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Content transitions")
            Text("ContentTransition controls how a view animates when its content changes, not its position or size, but the actual text or image inside it. Essential for counters, scoreboards, live data displays and morphing labels.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".numericText() — digits animate up or down individually. Perfect for counters, prices, scores.", color: .animBlue)
                StepRow(number: 2, text: ".numericText(countsDown: true) — reverses the digit scroll direction for countdown timers.", color: .animBlue)
                StepRow(number: 3, text: ".interpolate — morphs between glyphs. Smooth for short text changes.", color: .animBlue)
                StepRow(number: 4, text: ".opacity — simply cross-fades. Safe fallback for any content.", color: .animBlue)
                StepRow(number: 5, text: ".identity — no transition, snaps immediately. Use to disable the default cross-fade.", color: .animBlue)
            }

            CalloutBox(style: .success, title: "numericText is the secret sauce", contentBody: "It makes number changes look like a physical counter or odometer. Apple uses it throughout iOS in the dynamic island, live activities, and the calculator app.")

            CalloutBox(style: .warning, title: "Requires animation context", contentBody: "contentTransition only fires inside a withAnimation block or when a value driving an .animation() modifier changes. Without an animation, content snaps.")

            CodeBlock(code: """
// Animated counter
Text("\\(score)")
    .contentTransition(.numericText())
    .animation(.spring(duration: 0.4), value: score)

// Countdown timer
Text("\\(timeRemaining)")
    .contentTransition(.numericText(countsDown: true))
    .animation(.linear(duration: 1), value: timeRemaining)

// Morphing label
Text(status)
    .contentTransition(.interpolate)
    .animation(.easeInOut(duration: 0.3), value: status)

// Formatted number
Text(amount, format: .currency(code: "USD"))
    .contentTransition(.numericText())
    .animation(.spring(), value: amount)
""")
        }
    }
}
