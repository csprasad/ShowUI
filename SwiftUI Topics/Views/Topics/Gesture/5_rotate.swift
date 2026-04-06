//
//
//  5_rotate.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: RotateGesture
struct RotateGestureVisual: View {
    @State private var angle: Angle = .zero
    @State private var lastAngle: Angle = .zero
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var selectedDemo = 0

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("RotateGesture", systemImage: "arrow.clockwise.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gesturePink)

                HStack(spacing: 8) {
                    ForEach(["Rotate", "Snap 45°", "+ scale"].indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedDemo = i
                                angle = .zero; lastAngle = .zero
                                scale = 1.0; lastScale = 1.0
                            }
                        } label: {
                            Text(["Rotate", "Snap 45°", "+ scale"][i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.gesturePink : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.gesturePinkLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                ZStack {
                    Color(.secondarySystemBackground)
                    if selectedDemo == 1 {
                        ForEach([0, 45, 90, 135], id: \.self) { deg in
                            Rectangle().fill(Color.gesturePink.opacity(0.1)).frame(width: 100, height: 1)
                                .rotationEffect(.degrees(Double(deg)))
                        }
                    }
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(colors: [.gesturePink, Color(hex: "#9B1A3F")],
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 90, height: 90)
                        .overlay(
                            VStack(spacing: 4) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 20)).foregroundStyle(.white)
                                Text("\(Int(angle.degrees))°")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced)).foregroundStyle(.white)
                            }
                        )
                        .rotationEffect(angle)
                        .scaleEffect(selectedDemo == 2 ? scale : 1.0)
                        .shadow(color: .gesturePink.opacity(0.3), radius: 8, y: 4)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: angle)
                        .animation(.spring(response: 0.2, dampingFraction: 0.75), value: scale)
                        .gesture(rotateGesture)
                }
                .frame(maxWidth: .infinity).frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise.circle").font(.system(size: 12)).foregroundStyle(Color.gesturePink)
                    Text(String(format: "%.1f°", angle.degrees))
                        .font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.gesturePink)
                    if selectedDemo == 2 {
                        Text("·").foregroundStyle(.secondary)
                        Text(String(format: "%.2f×", scale))
                            .font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.gesturePink)
                    }
                    Spacer()
                    Button("Reset") {
                        withAnimation(.spring()) { angle = .zero; lastAngle = .zero; scale = 1; lastScale = 1 }
                    }
                    .font(.system(size: 12)).foregroundStyle(Color.gesturePink)
                }
                .padding(10).background(Color.gesturePinkLight).clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    var rotateGesture: some Gesture {
        if selectedDemo == 2 {
            return AnyGesture(
                RotateGesture()
                    .simultaneously(with: MagnifyGesture())
                    .onChanged { value in
                        let rotation = value.first?.rotation ?? .zero
                        let magnification = value.second?.magnification ?? 1.0
                        
                        angle = lastAngle + rotation
                        scale = lastScale * magnification
                    }
                    .onEnded { _ in
                        lastAngle = angle
                        lastScale = scale
                    }
                    .map { _ in } // Transform to AnyGesture<Void>
            )
        }
        
        return AnyGesture(
            RotateGesture()
                .onChanged { value in
                    angle = lastAngle + value.rotation
                }
                .onEnded { value in
                    if selectedDemo == 1 {
                        let snapped = ((lastAngle + value.rotation).degrees / 45.0).rounded() * 45.0
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            angle = .degrees(snapped)
                        }
                        lastAngle = .degrees(snapped)
                    } else {
                        lastAngle = angle
                    }
                }
                .map { _ in } // Transform to AnyGesture<Void>
        )
    }}

struct RotateGestureExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "RotateGesture")
            Text("RotateGesture tracks a two-finger twist. It provides a rotation Angle - positive is clockwise. Like MagnifyGesture, the value resets to .zero at the start of each new gesture, so you must accumulate it using lastAngle.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "value.rotation - Angle relative to the start of the current gesture. Resets to .zero each twist.", color: .gesturePink)
                StepRow(number: 2, text: "Accumulate: angle = lastAngle + value.rotation. Save lastAngle = angle in onEnded.", color: .gesturePink)
                StepRow(number: 3, text: "Snap in onEnded: (degrees / 45.0).rounded() * 45.0 for a satisfying grid snap.", color: .gesturePink)
                StepRow(number: 4, text: "Combine with MagnifyGesture using .simultaneously for a full photo-editor interaction.", color: .gesturePink)
            }

            CalloutBox(style: .success, title: "Rotate + scale together", contentBody: "RotateGesture().simultaneously(with: MagnifyGesture()) gives both values at once. value.first is the rotation, value.second is the magnification. This is the standard sticker/photo editing pattern.")

            CodeBlock(code: """
@State private var angle: Angle = .zero
@State private var lastAngle: Angle = .zero

.rotationEffect(angle)
.gesture(
    RotateGesture()
        .onChanged { value in
            angle = lastAngle + value.rotation
        }
        .onEnded { _ in
            lastAngle = angle
        }
)

// Snap to 45° grid on release
.onEnded { value in
    let raw = (lastAngle + value.rotation).degrees
    let snapped = (raw / 45.0).rounded() * 45.0
    withAnimation(.spring()) { angle = .degrees(snapped) }
    lastAngle = angle
}

// Pinch + rotate simultaneously
RotateGesture()
    .simultaneously(with: MagnifyGesture())
    .onChanged { value in
        angle = lastAngle + (value.first ?? .zero)
        scale = lastScale * (value.second?.magnification ?? 1)
    }
""")
        }
    }
}
