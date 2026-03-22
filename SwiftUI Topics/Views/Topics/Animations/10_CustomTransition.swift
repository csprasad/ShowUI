//
//
//  10_CustomTransition.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Custom Transitions
struct CustomTransitionVisual: View {
    @State private var isVisible = false
    @State private var selectedTransition = 0

    struct TransitionOption {
        let name: String
        let description: String
        let transition: AnyTransition
    }

    let transitions: [TransitionOption] = [
        TransitionOption(name: "slide",       description: "Slides in from the leading edge",     transition: .slide),
        TransitionOption(name: "scale",       description: "Scales from zero to full size",        transition: .scale),
        TransitionOption(name: "opacity",     description: "Fades in and out",                    transition: .opacity),
        TransitionOption(name: "move(.bottom)", description: "Moves up from the bottom",          transition: .move(edge: .bottom)),
        TransitionOption(name: "asymmetric",  description: "Different insert and removal",        transition: .asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .move(edge: .trailing).combined(with: .opacity))),
        TransitionOption(name: "scale + blur", description: "Scale with opacity combined",        transition: .scale(scale: 0.6).combined(with: .opacity)),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Custom transitions", systemImage: "arrow.left.arrow.right.square")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.animAmber)

                // Stage area
                ZStack {
                    Color(.secondarySystemBackground)

                    if isVisible {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.animAmber, Color(hex: "#633806")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "sparkles")
                                    .font(.system(size: 32))
                                    .foregroundStyle(.white)
                            )
                            .transition(transitions[selectedTransition].transition)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Toggle button
                Button(isVisible ? "Remove" : "Insert") {
                    withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
                        isVisible.toggle()
                    }
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.animAmber)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .buttonStyle(PressableButtonStyle())

                // Description
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 12)).foregroundStyle(Color.animAmber)
                    Text(transitions[selectedTransition].description)
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                }

                // Transition selector
                VStack(spacing: 6) {
                    ForEach(transitions.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedTransition = i
                                isVisible = false
                            }
                        } label: {
                            HStack {
                                Text(transitions[i].name)
                                    .font(.system(size: 12, weight: selectedTransition == i ? .semibold : .regular, design: .monospaced))
                                    .foregroundStyle(selectedTransition == i ? Color.animAmber : .primary)
                                Spacer()
                                if selectedTransition == i {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(Color.animAmber)
                                }
                            }
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(selectedTransition == i ? Color(hex: "#FAEEDA") : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
        }
    }
}

struct CustomTransitionExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Custom transitions")
            Text("Transitions define how a view enters and leaves the screen when it's inserted or removed from the view hierarchy. SwiftUI has built-in transitions and lets you compose and combine them.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".slide, .scale, .opacity, .move(edge:) — built-in transitions.", color: .animAmber)
                StepRow(number: 2, text: ".combined(with:) — layer two transitions together.", color: .animAmber)
                StepRow(number: 3, text: ".asymmetric(insertion:removal:) — different transitions for enter and exit.", color: .animAmber)
                StepRow(number: 4, text: "Build a custom one with ViewModifier + extension on AnyTransition.", color: .animAmber)
            }

            CalloutBox(style: .info, title: "Transitions need if/else", contentBody: "A transition only fires when a view is inserted into or removed from the hierarchy, not just when it's hidden. Use if/else, not opacity(0).")

            CalloutBox(style: .success, title: "Asymmetric is underused", contentBody: "Having content slide in from the left and exit to the right (or slide in from bottom and fade out) feels much more polished than the same transition in both directions.")

            CodeBlock(code: """
// Built-in
.transition(.slide)
.transition(.scale)
.transition(.move(edge: .bottom))

// Combined
.transition(.scale.combined(with: .opacity))

// Asymmetric — different insert and removal
.transition(.asymmetric(
    insertion: .move(edge: .leading).combined(with: .opacity),
    removal:   .move(edge: .trailing).combined(with: .opacity)
))

// Custom transition via ViewModifier
extension AnyTransition {
    static var spin: AnyTransition {
        .modifier(
            active: SpinModifier(angle: 180, opacity: 0),
            identity: SpinModifier(angle: 0, opacity: 1)
        )
    }
}
""")
        }
    }
}
