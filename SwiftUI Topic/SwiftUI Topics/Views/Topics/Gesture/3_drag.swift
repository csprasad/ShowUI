//
//
//  3_drag.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: DragGesture
struct DragGestureVisual: View {
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var velocity: CGSize = .zero
    @State private var isDragging = false
    @State private var selectedDemo = 0

    let demos = ["Free drag", "Constrained", "Snap back"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("DragGesture", systemImage: "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gestureOrange)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedDemo = i
                                offset = .zero; lastOffset = .zero
                            }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 12, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.gestureOrange : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.gestureOrangeLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                GesturePlayground(hint: "drag the shape") {
                    switch selectedDemo {
                    case 0:
                        ZStack {
                            Circle().fill(Color(.systemFill)).frame(width: 8, height: 8)
                            RoundedRectangle(cornerRadius: 16)
                                .fill(isDragging ? Color.gestureOrange : Color.gestureOrangeLight)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    VStack(spacing: 2) {
                                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                                            .font(.system(size: 18))
                                            .foregroundStyle(isDragging ? .white : .gestureOrange)
                                        if isDragging {
                                            Text("(\(Int(offset.width)), \(Int(offset.height)))")
                                                .font(.system(size: 8, design: .monospaced))
                                                .foregroundStyle(.white.opacity(0.8))
                                        }
                                    }
                                )
                                .scaleEffect(isDragging ? 1.05 : 1.0)
                                .shadow(color: isDragging ? Color.gestureOrange.opacity(0.3) : .clear, radius: 8)
                                .offset(offset)
                                .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isDragging)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            isDragging = true
                                            offset = CGSize(
                                                width: lastOffset.width + value.translation.width,
                                                height: lastOffset.height + value.translation.height
                                            )
                                        }
                                        .onEnded { value in
                                            isDragging = false
                                            lastOffset = offset
                                            velocity = value.velocity
                                        }
                                )
                        }

                    case 1:
                        ZStack {
                            Capsule().fill(Color(.systemFill)).frame(width: 240, height: 8)
                            Circle()
                                .fill(isDragging ? Color.gestureOrange : Color.gestureOrangeLight)
                                .frame(width: 48, height: 48)
                                .overlay(Image(systemName: "arrow.left.and.right").font(.system(size: 14))
                                    .foregroundStyle(isDragging ? .white : .gestureOrange))
                                .shadow(color: isDragging ? Color.gestureOrange.opacity(0.3) : .clear, radius: 6)
                                .offset(x: min(max(offset.width, -100), 100))
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            isDragging = true
                                            offset = CGSize(
                                                width: min(max(lastOffset.width + value.translation.width, -100), 100),
                                                height: 0
                                            )
                                        }
                                        .onEnded { _ in
                                            isDragging = false
                                            lastOffset = offset
                                        }
                                )
                        }

                    default:
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isDragging ? Color.gestureOrange : Color.gestureOrangeLight)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: isDragging ? "xmark" : "arrow.uturn.backward")
                                    .font(.system(size: 20))
                                    .foregroundStyle(isDragging ? .white : .gestureOrange)
                            )
                            .offset(offset)
                            .animation(isDragging ? nil : .spring(response: 0.4, dampingFraction: 0.6), value: offset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        isDragging = true
                                        offset = value.translation
                                    }
                                    .onEnded { _ in
                                        isDragging = false
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                            offset = .zero
                                        }
                                        lastOffset = .zero
                                    }
                            )
                    }
                }

                HStack(spacing: 16) {
                    statChip("X", value: "\(Int(offset.width))pt")
                    statChip("Y", value: "\(Int(offset.height))pt")
                    if selectedDemo == 0 {
                        statChip("vX", value: String(format: "%.0f", velocity.width))
                        statChip("vY", value: String(format: "%.0f", velocity.height))
                    }
                }
                .animation(.easeInOut(duration: 0.1), value: offset.width)
            }
        }
    }

    func statChip(_ label: String, value: String) -> some View {
        HStack(spacing: 4) {
            Text(label).font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
            Text(value).font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.gestureOrange)
        }
        .padding(.horizontal, 8).padding(.vertical, 4)
        .background(Color.gestureOrangeLight)
        .clipShape(Capsule())
    }
}

struct DragGestureExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "DragGesture")
            Text("DragGesture tracks a finger moving across the screen. It provides translation, location, predicted end location, and velocity. The key pattern: accumulate offset from the last position so dragging resumes where it left off.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "value.translation - distance moved since gesture started. Always relative to the start position.", color: .gestureOrange)
                StepRow(number: 2, text: "value.location - current finger position in the view's coordinate space.", color: .gestureOrange)
                StepRow(number: 3, text: "value.predictedEndLocation - where the finger would land if released at current velocity.", color: .gestureOrange)
                StepRow(number: 4, text: "value.velocity - how fast the finger is moving. Use to add momentum or trigger swipe-away.", color: .gestureOrange)
                StepRow(number: 5, text: "Accumulate: newOffset = lastOffset + translation. Store lastOffset in onEnded.", color: .gestureOrange)
            }

            CalloutBox(style: .warning, title: "Don't use translation directly as offset", contentBody: "DragGesture.translation resets to zero each time a new gesture starts. If you set offset = value.translation, the view jumps back to its original position at the start of every drag. Always accumulate: offset = lastOffset + translation.")

            CalloutBox(style: .info, title: "minimumDistance prevents accidental drags", contentBody: "DragGesture(minimumDistance: 10) won't start until the finger has moved 10 points. Prevents drag from interfering with taps and scroll views. Default is 10pt.")

            CodeBlock(code: """
@State private var offset: CGSize = .zero
@State private var lastOffset: CGSize = .zero

SomeView()
    .offset(offset)
    .gesture(
        DragGesture()
            .onChanged { value in
                offset = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
            }
            .onEnded { value in
                lastOffset = offset
                if value.velocity.width > 500 {
                    dismissCard()
                }
            }
    )

// Constrain to horizontal
.onChanged { value in
    offset = CGSize(
        width: lastOffset.width + value.translation.width,
        height: 0
    )
}
""")
        }
    }
}
