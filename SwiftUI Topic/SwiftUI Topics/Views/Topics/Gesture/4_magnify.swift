//
//
//  4_magnify.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: MagnifyGesture
struct MagnifyGestureVisual: View {
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var selectedDemo = 0

    let demos = ["Pinch to zoom", "With limits", "Image zoom"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("MagnifyGesture", systemImage: "arrow.up.left.and.arrow.down.right.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gestureOrange)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedDemo = i; scale = 1.0; lastScale = 1.0
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

                GesturePlayground(hint: "pinch with two fingers") {
                    switch selectedDemo {
                    case 0:
                        ZStack {
                            Circle().stroke(Color.gestureOrange.opacity(0.2), lineWidth: 1).frame(width: 60 * scale, height: 60 * scale)
                            RoundedRectangle(cornerRadius: 16 * scale)
                                .fill(Color.gestureOrangeLight)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    VStack(spacing: 4) {
                                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                                            .font(.system(size: 20)).foregroundStyle(Color.gestureOrange)
                                        Text(String(format: "×%.2f", scale))
                                            .font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.gestureOrange)
                                    }
                                )
                                .scaleEffect(scale)
                                .gesture(magnifyGesture(min: 0.1, max: 5.0))
                        }

                    case 1:
                        RoundedRectangle(cornerRadius: 12)
                            .fill(scale <= 0.75 ? Color.animCoral.opacity(0.1) :
                                  scale >= 3.0 ? Color.animTeal.opacity(0.1) : Color.gestureOrangeLight)
                            .frame(width: 90, height: 90)
                            .overlay(
                                VStack(spacing: 3) {
                                    Text(String(format: "×%.1f", scale))
                                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                                        .foregroundStyle(Color.gestureOrange)
                                    Text(scale <= 0.75 ? "min" : scale >= 3.0 ? "max" : "0.75×–3×")
                                        .font(.system(size: 9))
                                        .foregroundStyle(scale <= 0.75 ? Color.animCoral : scale >= 3.0 ? Color.animTeal : .secondary)
                                }
                            )
                            .scaleEffect(scale)
                            .gesture(magnifyGesture(min: 0.75, max: 3.0))

                    default:
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(LinearGradient(colors: [Color.gestureOrange, Color(hex: "#FF8C5A")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 120, height: 80)
                                .overlay(Text("Photo").font(.system(size: 14, weight: .semibold)).foregroundStyle(.white))
                                .scaleEffect(scale)
                                .gesture(magnifyGesture(min: 0.5, max: 4.0))
                            if scale > 1.5 {
                                Text("×\(String(format: "%.1f", scale))").font(.system(size: 10))
                                    .foregroundStyle(Color.gestureOrange).offset(y: 56)
                            }
                        }
                    }
                }

                HStack(spacing: 8) {
                    Text("Scale:").font(.system(size: 12)).foregroundStyle(.secondary)
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color(.systemFill)).frame(height: 6)
                            Capsule().fill(Color.gestureOrange)
                                .frame(width: max(0, min(geo.size.width, (scale / 4.0) * geo.size.width)), height: 6)
                                .animation(.easeInOut(duration: 0.05), value: scale)
                        }
                    }.frame(height: 6)
                    Text(String(format: "×%.2f", scale))
                        .font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.gestureOrange).frame(width: 44)
                    Button("Reset") {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { scale = 1.0; lastScale = 1.0 }
                    }
                    .font(.system(size: 12)).foregroundStyle(Color.gestureOrange).buttonStyle(PressableButtonStyle())
                }
            }
        }
    }

    func magnifyGesture(min minScale: CGFloat, max maxScale: CGFloat) -> some Gesture {
        MagnifyGesture()
            .onChanged { value in
                scale = min(max(lastScale * value.magnification, minScale), maxScale)
            }
            .onEnded { _ in lastScale = scale }
    }
}

struct MagnifyGestureExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "MagnifyGesture - pinch to zoom")
            Text("MagnifyGesture tracks a two-finger pinch. It provides a magnification value starting at 1.0 for each gesture. Accumulate with lastScale to persist zoom across gestures - the same pattern as DragGesture.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "value.magnification - scale factor for the current gesture, starting at 1.0.", color: .gestureOrange)
                StepRow(number: 2, text: "Accumulate: scale = lastScale × value.magnification. Save lastScale in onEnded.", color: .gestureOrange)
                StepRow(number: 3, text: "Clamp: scale = min(max(newScale, 0.5), 4.0) prevents over/under-zoom.", color: .gestureOrange)
                StepRow(number: 4, text: ".scaleEffect(scale) applies the zoom. Combine with offset for pan-and-zoom.", color: .gestureOrange)
            }

            CalloutBox(style: .info, title: "MagnifyGesture renamed in iOS 17", contentBody: "MagnifyGesture replaces MagnificationGesture on iOS 17+. Use value.magnification instead of the raw Angle. Both compile but MagnifyGesture is the current API.")

            CodeBlock(code: """
@State private var scale: CGFloat = 1.0
@State private var lastScale: CGFloat = 1.0

Image("photo")
    .scaleEffect(scale)
    .gesture(
        MagnifyGesture()
            .onChanged { value in
                let newScale = lastScale * value.magnification
                scale = min(max(newScale, 0.5), 4.0)
            }
            .onEnded { _ in
                lastScale = scale
            }
    )
    .onTapGesture(count: 2) {
        withAnimation(.spring()) { scale = 1; lastScale = 1 }
    }
""")
        }
    }
}
