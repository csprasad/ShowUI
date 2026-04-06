//
//
//  1_Tap.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: TapGesture
struct TapGestureVisual: View {
    @State private var singleCount = 0
    @State private var doubleCount = 0
    @State private var tripleCount = 0
    @State private var lastTap = "–"
    @State private var rippleScale: CGFloat = 0.1
    @State private var rippleOpacity: Double = 0

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("TapGesture", systemImage: "hand.tap.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gesturePink)

                // Main tap target
                ZStack {
                    Color(.secondarySystemBackground)
                    Circle()
                        .stroke(Color.gesturePink.opacity(0.2), lineWidth: 1)
                        .scaleEffect(rippleScale)
                        .opacity(rippleOpacity)
                    VStack(spacing: 6) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 32)).foregroundStyle(Color.gesturePink)
                        Text(lastTap).font(.system(size: 13, weight: .semibold)).foregroundStyle(Color.gesturePink)
                        Text("Tap - double tap - triple tap").font(.system(size: 11)).foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .onTapGesture(count: 3) {
                    tripleCount += 1; lastTap = "Triple tap! ✕3"
                    fireRipple()
                }
                .onTapGesture(count: 2) {
                    doubleCount += 1; lastTap = "Double tap ✕2"
                    fireRipple()
                }
                .onTapGesture {
                    singleCount += 1; lastTap = "Single tap"
                    fireRipple()
                }

                // Counters
                HStack(spacing: 8) {
                    counterChip("Single", count: singleCount, color: .gesturePink)
                    counterChip("Double", count: doubleCount, color: Color(hex: "#9B1A3F"))
                    counterChip("Triple", count: tripleCount, color: Color(hex: "#E05C82"))
                }

                // .gesture syntax demo
                VStack(alignment: .leading, spacing: 6) {
                    sectionLabel(".gesture() vs .onTapGesture()")
                    HStack(spacing: 6) {
                        tapSyntaxChip(".onTapGesture { }", note: "shorthand")
                        tapSyntaxChip(".gesture(TapGesture())", note: "composable")
                    }
                }
            }
        }
    }

    func fireRipple() {
        rippleScale = 0.1; rippleOpacity = 0.6
        withAnimation(.easeOut(duration: 0.6)) { rippleScale = 2.5; rippleOpacity = 0 }
    }

    func counterChip(_ label: String, count: Int, color: Color) -> some View {
        VStack(spacing: 2) {
            Text("\(count)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(color)
                .contentTransition(.numericText())
                .animation(.spring(duration: 0.3), value: count)
            Text(label).font(.system(size: 10)).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 8)
        .background(color.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func tapSyntaxChip(_ code: String, note: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(code).font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.gesturePink)
            Text(note).font(.system(size: 9)).foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(Color.gesturePinkLight)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func sectionLabel(_ t: String) -> some View {
        Text(t).font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
    }
}

struct TapGestureExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "TapGesture")
            Text("TapGesture recognises single or multi-tap sequences. .onTapGesture is the shorthand for the most common cases. When stacking multiple tap counts on the same view, register higher counts first - SwiftUI tries the highest count first.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".onTapGesture { } - single tap, simplest form.", color: .gesturePink)
                StepRow(number: 2, text: ".onTapGesture(count: 2) { } - double tap. Register before single tap or single tap always wins.", color: .gesturePink)
                StepRow(number: 3, text: ".gesture(TapGesture(count: 2)) - composable form, required when combining with other gestures.", color: .gesturePink)
                StepRow(number: 4, text: "TapGesture provides no location data. Use SpatialTapGesture(count:) if you need where the tap landed.", color: .gesturePink)
            }

            CalloutBox(style: .warning, title: "Register higher counts first", contentBody: "If you attach .onTapGesture(count: 2) after .onTapGesture on the same view, single tap always fires before the double tap gets its second tap. Register double-tap first so SwiftUI waits to see if it becomes a double.")

            CalloutBox(style: .info, title: "SpatialTapGesture for location", contentBody: "TapGesture doesn't tell you where the tap happened. SpatialTapGesture(count:coordinateSpace:) gives you a CGPoint so you can respond at the tap location - useful for placing objects on a canvas.")

            CodeBlock(code: """
// Single tap
Text("Tap me")
    .onTapGesture { print("tapped") }

// Double tap - register BEFORE single tap
Image("photo")
    .onTapGesture(count: 2) { toggleLike() }
    .onTapGesture { showDetail() }

// Composable form (needed for gesture combining)
.gesture(
    TapGesture(count: 2)
        .onEnded { likePost() }
)

// Location-aware tap
.gesture(
    SpatialTapGesture()
        .onEnded { value in
            let location = value.location  // CGPoint
            addPin(at: location)
        }
)
""")
        }
    }
}

