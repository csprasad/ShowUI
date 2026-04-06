//
//
//  8_custom&State.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Custom Gestures & GestureState
struct CustomGestureVisual: View {
    @State private var selectedDemo = 0
    @State private var scrubValue: Double = 0.5
    @State private var scrubbing = false
    @State private var shakeOffset: CGFloat = 0
    @State private var shakeCount = 0
    @GestureState private var gestureOffset = CGSize.zero
    @State private var savedOffset = CGSize.zero

    let demos = ["Scrub gesture", "@GestureState", "Shake detector"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Custom gestures", systemImage: "wand.and.stars")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gesturePink)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.gesturePink : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.gesturePinkLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    scrubDemo
                case 1:
                    gestureStateDemo
                default:
                    shakeDemo
                }
            }
        }
    }

    private var scrubDemo: some View {
        VStack(spacing: 10) {
            ZStack {
                Color(.secondarySystemBackground)
                VStack(spacing: 6) {
                    Text(String(format: "%.0f%%", scrubValue * 100))
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.gesturePink)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.05), value: Int(scrubValue * 100))
                    Text(scrubbing ? "Scrubbing…" : "Drag left / right")
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity).frame(height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(scrubbing ? 1.02 : 1.0)
            .animation(.spring(response: 0.3), value: scrubbing)
            .gesture(
                DragGesture(minimumDistance: 4)
                    .onChanged { value in
                        scrubbing = true
                        let delta = value.translation.width / 220
                        scrubValue = min(max(scrubValue + delta, 0), 1)
                    }
                    .onEnded { _ in scrubbing = false }
            )
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4).fill(Color(.systemFill)).frame(height: 8)
                    RoundedRectangle(cornerRadius: 4).fill(Color.gesturePink)
                        .frame(width: max(0, geo.size.width * scrubValue), height: 8)
                }
            }
            .frame(height: 8)
            .animation(.easeInOut(duration: 0.04), value: scrubValue)
        }
    }

    private var gestureStateDemo: some View {
        VStack(spacing: 10) {
            ZStack {
                Color(.secondarySystemBackground)
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.gesturePink)
                    .frame(width: 70, height: 70)
                    .overlay(
                        VStack(spacing: 3) {
                            Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                                .font(.system(size: 18)).foregroundStyle(.white)
                            Text("@GestureState").font(.system(size: 8, weight: .semibold)).foregroundStyle(.white.opacity(0.9))
                        }
                    )
                    .offset(x: gestureOffset.width + savedOffset.width,
                            y: gestureOffset.height + savedOffset.height)
                    .gesture(
                        DragGesture()
                            .updating($gestureOffset) { value, state, _ in
                                state = value.translation   // auto-resets to .zero on end
                            }
                            .onEnded { value in
                                savedOffset.width += value.translation.width
                                savedOffset.height += value.translation.height
                            }
                    )
                    .animation(.interactiveSpring(response: 0.22), value: gestureOffset)
            }
            .frame(maxWidth: .infinity).frame(height: 110)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "checkmark.circle.fill").font(.system(size: 11)).foregroundStyle(Color(hex: "#1D9E75"))
                Text("@GestureState auto-resets to .zero when the gesture ends - no need to reset in onEnded")
                    .font(.system(size: 11)).foregroundStyle(.secondary).lineSpacing(2)
            }
            .padding(8).background(Color.gesturePinkLight).clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var shakeDemo: some View {
        VStack(spacing: 10) {
            ZStack {
                Color(.secondarySystemBackground)
                VStack(spacing: 8) {
                    Image(systemName: shakeCount > 0 ? "checkmark.circle.fill" : "iphone.radiowaves.left.and.right")
                        .font(.system(size: 38))
                        .foregroundStyle(shakeCount > 0 ? Color.animTeal : Color(.systemGray3))
                        .offset(x: shakeOffset)
                        .animation(.spring(response: 0.12, dampingFraction: 0.25), value: shakeOffset)
                    Text(shakeCount > 0 ? "Shaken \(shakeCount)×!" : "Tap button to simulate")
                        .font(.system(size: 13)).foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity).frame(height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button {
                shakeCount += 1
                for i in 0..<7 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.065) {
                        shakeOffset = i % 2 == 0 ? 14 : -14
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { shakeOffset = 0 }
            } label: {
                Text("Simulate device shake")
                    .font(.system(size: 14, weight: .semibold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 11)
                    .background(Color.gesturePink).clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(PressableButtonStyle())
        }
    }
}

struct CustomGestureExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Custom gestures & @GestureState")
            Text("@GestureState stores transient gesture state and automatically resets to its initial value when the gesture ends. It eliminates the common bug of forgetting to reset state in onEnded.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@GestureState private var isDragging = false - declares transient state that resets automatically.", color: .gesturePink)
                StepRow(number: 2, text: ".updating($gestureState) { value, state, transaction in } - set state during the gesture. state is inout.", color: .gesturePink)
                StepRow(number: 3, text: "Combine @GestureState (transient) with @State (persistent) - GestureState for 'during drag', State for 'after drag'.", color: .gesturePink)
                StepRow(number: 4, text: "Custom gesture structs: conform to the Gesture protocol to build reusable encapsulated gestures.", color: .gesturePink)
            }

            CalloutBox(style: .success, title: "@GestureState eliminates reset bugs", contentBody: "@GestureState is perfect for 'current offset during drag' - it snaps back to .zero automatically when the finger lifts. You only need @State for the accumulated position saved in onEnded.")

            CalloutBox(style: .info, title: "Scrubbing pattern", contentBody: "A DragGesture where translation.width controls a value is called 'scrubbing' - the interaction Apple uses in video playback and the iOS Clock app. It's much more precise than a slider for fine-grained control.")

            CodeBlock(code: """
// @GestureState - auto-resets on gesture end
@GestureState private var dragAmount = CGSize.zero
@State private var position = CGSize.zero

View()
    .offset(x: position.width + dragAmount.width,
            y: position.height + dragAmount.height)
    .gesture(
        DragGesture()
            // updating sets GestureState during gesture
            .updating($dragAmount) { value, state, _ in
                state = value.translation  // auto-resets ✓
            }
            // onEnded saves to @State
            .onEnded { value in
                position.width  += value.translation.width
                position.height += value.translation.height
            }
    )

// Scrub pattern - drag to change a value
@State private var volume: Double = 0.5

.gesture(
    DragGesture(minimumDistance: 4)
        .onChanged { value in
            let delta = value.translation.width / 200
            volume = min(max(volume + delta, 0), 1)
        }
)
""")
        }
    }
}

