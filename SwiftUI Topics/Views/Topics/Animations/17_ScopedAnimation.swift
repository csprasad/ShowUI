//
//
//  17_ScopedAnimation.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 17: Scoped Animation — animation(_:body:)
struct ScopedAnimationVisual: View {
    @State private var isOn = false
    @State private var selectedDemo = 0

    let demos = ["Side effect problem", "Scoped fix", "Compare both"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("animation(_:body:)", systemImage: "scope")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.animCoral)

                // Demo selector
                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button(demos[i]) {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; isOn = false }
                        }
                        .font(.system(size: 10, weight: selectedDemo == i ? .semibold : .regular))
                        .foregroundStyle(selectedDemo == i ? Color.animCoral : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(selectedDemo == i ? Color(hex: "#FAECE7") : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Preview
                ZStack {
                    Color(.secondarySystemBackground)
                    demoView
                }
                .frame(maxWidth: .infinity)
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Toggle button
                Button{
                    isOn.toggle()
                } label: {
                    Text(isOn ? "Reverse" : "Trigger")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.animCoral)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }.buttonStyle(PressableButtonStyle())

                // Description
                let descriptions = [
                    ".animation(_, value:) animates EVERY animatable property on the view including ones you didn't intend. Toggle the box and watch the text also animate.",
                    "animation(_:body:) scopes the animation to exactly the properties changed inside the closure nothing else is affected.",
                    "Side by side: old .animation() vs new animation(_:body:). Notice how the scoped version leaves the text instant while only animating the shape."
                ]
                Text(descriptions[selectedDemo])
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .animation(.easeInOut(duration: 0.15), value: selectedDemo)
            }
        }
    }

    @ViewBuilder
    private var demoView: some View {
        switch selectedDemo {
        case 0:
            // Problem — .animation() affects everything including the text
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.animCoral)
                    .frame(width: isOn ? 140 : 60, height: 50)
                    .animation(.spring(duration: 0.6, bounce: 0.4), value: isOn)

                // Unintended: this Text also animates its number change
                Text("Count: \(isOn ? 100 : 0)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.primary)
                    .animation(.spring(duration: 0.6, bounce: 0.4), value: isOn) // ← affects text too
            }

        case 1:
            // Fix — animation scoped only to the shape change
            VStack(spacing: 12) {
                animation(.spring(duration: 0.6, bounce: 0.4)) { _ in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.animTeal)
                        .frame(width: isOn ? 140 : 60, height: 50)
                }

                // Text is NOT affected — no animation applied to it
                Text("Count: \(isOn ? 100 : 0)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())
                    .animation(.spring(duration: 0.3), value: isOn)
            }

        default:
            // Side by side comparison
            HStack(spacing: 20) {
                VStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.animCoral)
                        .frame(width: isOn ? 80 : 40, height: 40)
                        .animation(.spring(duration: 0.6, bounce: 0.4), value: isOn)
                    Text("\(isOn ? 100 : 0)")
                        .font(.system(size: 14, weight: .bold))
                        .animation(.spring(duration: 0.6, bounce: 0.4), value: isOn)
                    Text(".animation()")
                        .font(.system(size: 9)).foregroundStyle(.secondary)
                }

                VStack(spacing: 6) {
                    animation(.spring(duration: 0.6, bounce: 0.4)) { _ in 
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.animTeal)
                            .frame(width: isOn ? 80 : 40, height: 40)
                    }
                    Text("\(isOn ? 100 : 0)")
                        .font(.system(size: 14, weight: .bold))
                    Text("animation(body:)")
                        .font(.system(size: 9)).foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct ScopedAnimationExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "animation(_:body:) — scoped animation")
            Text("The .animation(_ , value:) modifier is a shotgun, it animates every animatable property on the view whenever value changes. animation(_:body:) is a scalpel, it only animates the properties changed inside its body closure.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".animation(_, value:) on a view animates ALL its animatable properties — offset, scale, color, opacity, frame — anything that can animate.", color: .animCoral)
                StepRow(number: 2, text: "This causes unintended side effects — a Text inside the view may animate its content change when you only wanted the frame to animate.", color: .animCoral)
                StepRow(number: 3, text: "animation(_:body:) wraps only the properties you want animated, and everything else in the view remains instant.", color: .animCoral)
                StepRow(number: 4, text: "Use it whenever you need animation on one property of a view without animating others, especially in list rows or complex layouts.", color: .animCoral)
            }

            CalloutBox(style: .success, title: "The modern preferred API", contentBody: "Apple introduced animation(_:body:) specifically to fix the side-effect problem. In new code, prefer it over .animation(_, value:) for precise control.")

            CalloutBox(style: .info, title: "withAnimation still has its place", contentBody: "withAnimation animates all state changes in the block. animation(_:body:) is for view-level scoping. Use withAnimation at the call site, animation(body:) at the view level when you need precision.")

            CodeBlock(code: """
// OLD — animates everything including unintended properties
Text("\\(count)")
    .animation(.spring(), value: count)  // animates text transition too

// NEW — scoped to exact properties in the body
animation(.spring(duration: 0.4)) {
    RoundedRectangle(cornerRadius: 12)
        .frame(width: isOn ? 200 : 80)  // only this width animates
}
// Text below is NOT affected
Text("\\(count)")
    .contentTransition(.numericText())
    .animation(.spring(duration: 0.2), value: count)  // separate, controlled

// Practical pattern — animate layout without affecting content
animation(.bouncy) {
    HStack {
        if isExpanded { Spacer() }
        icon
        if !isExpanded { Spacer() }
    }
}
""")
        }
    }
}
