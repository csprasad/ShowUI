//
//
//  6_simultaneous.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Simultaneous Gestures
struct SimultaneousVisual: View {
    @State private var offset = CGSize.zero
    @State private var lastOffset = CGSize.zero
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var angle: Angle = .zero
    @State private var lastAngle: Angle = .zero
    @State private var tapCount = 0
    @State private var activeGestures: Set<String> = []

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Simultaneous gestures", systemImage: "hand.raised.fingers.spread.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gesturePink)

                HStack(spacing: 6) {
                    ForEach(["Drag", "Pinch", "Rotate", "Tap"], id: \.self) { name in
                        Text(name)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(activeGestures.contains(name) ? .white : .secondary)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(activeGestures.contains(name) ? Color.gesturePink : Color(.systemFill))
                            .clipShape(Capsule())
                            .animation(.spring(response: 0.2), value: activeGestures.contains(name))
                    }
                    Spacer()
                    Text("×\(tapCount)").font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                }

                ZStack {
                    Color(.secondarySystemBackground)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(
                            colors: [.gesturePink, Color(hex: "#9B1A3F"), Color(hex: "#E05C82")],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                        .frame(width: 100, height: 100)
                        .overlay(
                            VStack(spacing: 4) {
                                Image(systemName: "hand.raised.fingers.spread.fill")
                                    .font(.system(size: 22)).foregroundStyle(.white)
                                Text("All at once").font(.system(size: 10, weight: .semibold)).foregroundStyle(.white.opacity(0.9))
                            }
                        )
                        .shadow(color: .gesturePink.opacity(0.35), radius: 10, y: 5)
                        .offset(x: offset.width, y: offset.height)
                        .scaleEffect(scale)
                        .rotationEffect(angle)
                        .gesture(combinedGesture)
                        .animation(.interactiveSpring(response: 0.2), value: offset)
                        .animation(.interactiveSpring(response: 0.2), value: scale)
                        .animation(.interactiveSpring(response: 0.2), value: angle)
                }
                .frame(maxWidth: .infinity).frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                HStack(spacing: 6) {
                    statBadge("X", Int(offset.width))
                    statBadge("Y", Int(offset.height))
                    statBadge("S", Int(scale * 100), suffix: "%")
                    statBadge("R", Int(angle.degrees), suffix: "°")
                    Spacer()
                    Button("Reset") {
                        withAnimation(.spring()) {
                            offset = .zero; lastOffset = .zero
                            scale = 1; lastScale = 1
                            angle = .zero; lastAngle = .zero
                            tapCount = 0
                        }
                    }
                    .font(.system(size: 12)).foregroundStyle(Color.gesturePink)
                }
            }
        }
    }

    var combinedGesture: some Gesture {
        let drag = DragGesture(minimumDistance: 0)
            .onChanged { v in
                _ = withAnimation(.none) { activeGestures.insert("Drag") }
                offset = CGSize(width: lastOffset.width + v.translation.width,
                                height: lastOffset.height + v.translation.height)
            }
            .onEnded { _ in activeGestures.remove("Drag"); lastOffset = offset }

        let pinch = MagnifyGesture()
            .onChanged { v in _ = withAnimation(.none) { activeGestures.insert("Pinch") }; scale = lastScale * v.magnification }
            .onEnded { _ in activeGestures.remove("Pinch"); lastScale = scale }

        let rotate = RotateGesture()
            .onChanged { v in _ = withAnimation(.none) { activeGestures.insert("Rotate") }; angle = lastAngle + v.rotation }
            .onEnded { _ in activeGestures.remove("Rotate"); lastAngle = angle }

        let tap = TapGesture()
            .onEnded {
               _ = withAnimation(.none) { activeGestures.insert("Tap") }
                tapCount += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { _ = withAnimation { activeGestures.remove("Tap") } }
            }

        return drag.simultaneously(with: pinch).simultaneously(with: rotate).simultaneously(with: tap)
    }

    func statBadge(_ label: String, _ value: Int, suffix: String = "") -> some View {
        Text("\(label):\(value)\(suffix)")
            .font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.gesturePink)
            .padding(.horizontal, 6).padding(.vertical, 3)
            .background(Color.gesturePinkLight).clipShape(Capsule())
            .animation(.easeInOut(duration: 0.08), value: value)
    }
}

struct SimultaneousExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Simultaneous gestures")
            Text(".simultaneously(with:) runs two gestures at the same time - both can be active and recognised together. This is the foundation of any photo-editor-style interaction where the user drags, pinches, and rotates at once.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "gesture1.simultaneously(with: gesture2) - both receive events at the same time.", color: .gesturePink)
                StepRow(number: 2, text: "Chain: drag.simultaneously(with: pinch).simultaneously(with: rotate) for all three.", color: .gesturePink)
                StepRow(number: 3, text: "Each gesture's onChanged and onEnded fire independently - handle state variables separately.", color: .gesturePink)
                StepRow(number: 4, text: "Contrast with .exclusively - only ONE wins. Contrast with .sequenced - second only starts after first ends.", color: .gesturePink)
            }

            CalloutBox(style: .success, title: "The photo editor pattern", contentBody: "Drag + MagnifyGesture + RotateGesture simultaneously is the standard pattern for any movable, scalable, rotatable element. Chain all three with .simultaneously and handle each @State variable independently.")

            CodeBlock(code: """
let drag = DragGesture()
    .onChanged { v in offset = lastOffset + v.translation }
    .onEnded { _ in lastOffset = offset }

let pinch = MagnifyGesture()
    .onChanged { v in scale = lastScale * v.magnification }
    .onEnded { _ in lastScale = scale }

let rotate = RotateGesture()
    .onChanged { v in angle = lastAngle + v.rotation }
    .onEnded { _ in lastAngle = angle }

// All three simultaneously
.gesture(
    drag
        .simultaneously(with: pinch)
        .simultaneously(with: rotate)
)
.offset(x: offset.width, y: offset.height)
.scaleEffect(scale)
.rotationEffect(angle)
""")
        }
    }
}

