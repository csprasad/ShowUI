//
//
//  7_composition.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Gesture Composition
struct GestureCompositionVisual: View {
    @State private var selectedMode = 0
    @State private var log: [String] = ["Interact with the card below"]
    @State private var isLongPressed = false
    @State private var dragOffset = CGSize.zero
    @State private var lastOffset = CGSize.zero
    @State private var tapCount = 0

    let modes = [".sequenced", ".exclusively", "highPriority"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Gesture composition", systemImage: "square.stack.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gesturePink)

                HStack(spacing: 8) {
                    ForEach(modes.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedMode = i
                                log = ["Interact with the card below"]
                                isLongPressed = false
                                dragOffset = .zero; lastOffset = .zero; tapCount = 0
                            }
                        } label: {
                            Text(modes[i])
                                .font(.system(size: 10, weight: selectedMode == i ? .semibold : .regular, design: .monospaced))
                                .foregroundStyle(selectedMode == i ? Color.gesturePink : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedMode == i ? Color.gesturePinkLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                ZStack {
                    Color(.secondarySystemBackground)
                    interactiveCard
                }
                .frame(maxWidth: .infinity).frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Log
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(Array(log.prefix(3).enumerated()), id: \.offset) { _, entry in
                        HStack(spacing: 5) {
                            Circle().fill(Color.gesturePink).frame(width: 5, height: 5)
                            Text(entry).font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(10).frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gesturePinkLight).clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    @ViewBuilder
    private var interactiveCard: some View {
        let card = RoundedRectangle(cornerRadius: 16)
            .fill(LinearGradient(colors: [.gesturePink, Color(hex: "#9B1A3F")],
                                 startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 90, height: 90)
            .overlay(
                VStack(spacing: 4) {
                    Image(systemName: modeIcon).font(.system(size: 20)).foregroundStyle(.white)
                    Text(modeHint).font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.9)).multilineTextAlignment(.center)
                }
            )
            .scaleEffect(isLongPressed ? 1.1 : 1.0)
            .shadow(color: .gesturePink.opacity(isLongPressed ? 0.5 : 0.25),
                    radius: isLongPressed ? 14 : 6, y: isLongPressed ? 8 : 3)
            .animation(.spring(response: 0.3, dampingFraction: 0.65), value: isLongPressed)

        switch selectedMode {
        case 0:
            card
                .offset(x: dragOffset.width, y: dragOffset.height)
                .animation(.interactiveSpring(response: 0.25), value: dragOffset)
                .gesture(
                    LongPressGesture(minimumDuration: 0.4)
                        .onEnded { _ in isLongPressed = true; addLog("Long press ✓ - now drag") }
                        .sequenced(before: DragGesture(minimumDistance: 0))
                        .onChanged { value in
                            switch value {
                            case .second(_, let drag):
                                if let drag {
                                    dragOffset = CGSize(
                                        width: lastOffset.width + drag.translation.width,
                                        height: lastOffset.height + drag.translation.height
                                    )
                                }
                            default: break
                            }
                        }
                        .onEnded { _ in isLongPressed = false; lastOffset = dragOffset; addLog("Drag ended") }
                )
        case 1:
            card
                .gesture(
                    TapGesture()
                        .exclusively(before: DragGesture(minimumDistance: 10))
                        .onEnded { value in
                            switch value {
                            case .first: tapCount += 1; addLog("Tap won ×\(tapCount)")
                            case .second: addLog("Drag won")
                            }
                        }
                )
        default:
            card
                .highPriorityGesture(
                    TapGesture().onEnded { tapCount += 1; addLog("High priority tap ×\(tapCount)") }
                )
        }
    }

    var modeIcon: String {
        switch selectedMode {
        case 0: return "arrow.right.circle.fill"
        case 1: return "exclamationmark.circle.fill"
        default: return "hand.raised.circle.fill"
        }
    }

    var modeHint: String {
        switch selectedMode {
        case 0: return "Long press\nthen drag"
        case 1: return "Tap or drag\n(one wins)"
        default: return "Tap me\n(high priority)"
        }
    }

    func addLog(_ text: String) {
        withAnimation { log.insert(text, at: 0) }
    }
}

struct GestureCompositionExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Gesture composition")
            Text("Beyond .simultaneously, SwiftUI has three more composition tools - .sequenced requires the first gesture to complete before the second starts, .exclusively lets only one win, and .highPriorityGesture overrides child view gestures.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".sequenced(before:) - first gesture must succeed before second starts. Classic: long-press-then-drag.", color: .gesturePink)
                StepRow(number: 2, text: ".exclusively(before:) - tries the first gesture; if it fails, tries the second. Only one ever fires.", color: .gesturePink)
                StepRow(number: 3, text: ".highPriorityGesture - the gesture wins over gestures defined by child views.", color: .gesturePink)
                StepRow(number: 4, text: ".gesture loses to child gestures by default. highPriorityGesture reverses this.", color: .gesturePink)
            }

            CalloutBox(style: .success, title: "sequenced for drag-to-reorder", contentBody: "LongPressGesture().sequenced(before: DragGesture()) is the standard drag-to-reorder pattern. The item 'unlocks' on long press (showing visual feedback), then the subsequent drag moves it.")

            CodeBlock(code: """
// .sequenced - long press THEN drag
LongPressGesture(minimumDuration: 0.5)
    .sequenced(before: DragGesture())
    .onChanged { value in
        switch value {
        case .first(let pressing):
            isActivated = pressing
        case .second(_, let drag):
            if let drag { offset = drag.translation }
        }
    }

// .exclusively - tap OR drag
TapGesture()
    .exclusively(before: DragGesture(minimumDistance: 10))
    .onEnded { value in
        switch value {
        case .first:  handleTap()
        case .second: handleDrag()
        }
    }

// highPriorityGesture - beats child gestures
ParentView()
    .highPriorityGesture(
        TapGesture().onEnded { parentHandlesTap() }
    )
""")
        }
    }
}
