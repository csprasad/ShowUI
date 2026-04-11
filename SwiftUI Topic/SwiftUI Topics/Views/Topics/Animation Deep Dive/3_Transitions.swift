//
//
//  3_Transitions.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Transitions
struct TransitionsVisual: View {
    @State private var isShowing     = true
    @State private var selected      = 0
    @State private var asymInsert    = 0
    @State private var asymRemove    = 1

    struct TransitionConfig: Identifiable {
        let id = UUID()
        let name: String
        let transition: AnyTransition
        let color: Color
    }

    let transitions: [TransitionConfig] = [
        TransitionConfig(name: ".opacity",         transition: .opacity,                                color: Color(hex: "#D97706")),
        TransitionConfig(name: ".scale",           transition: .scale,                                  color: Color(hex: "#7C3AED")),
        TransitionConfig(name: ".slide",           transition: .slide,                                  color: Color(hex: "#0F766E")),
        TransitionConfig(name: ".move(.top)",      transition: .move(edge: .top),                       color: Color(hex: "#C2410C")),
        TransitionConfig(name: ".push(.leading)",  transition: .push(from: .leading),                   color: Color(hex: "#1D4ED8")),
        TransitionConfig(name: "scale + opacity",  transition: .scale.combined(with: .opacity),         color: Color(hex: "#BE123C")),
        TransitionConfig(name: "blur scale",       transition: .modifier(active: BlurScaleModifier(isActive: true), identity: BlurScaleModifier(isActive: false)), color: Color(hex: "#0891B2")),
    ]

    let transitionNames = ["opacity", "scale", "slide", "move top", "push leading", "scale+opacity", "blur scale"]
    let insertNames    = ["opacity", "scale", "slide", "move(.top)", "push(.leading)"]
    let removeNames    = ["opacity", "scale", "slide", "move(.bottom)", "push(.trailing)"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Transitions", systemImage: "arrow.left.arrow.right.square.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.anAmber)

                // Transition selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(transitions.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selected = i; isShowing = false }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { isShowing = true }
                                }
                            } label: {
                                Text(transitions[i].name)
                                    .font(.system(size: 12, weight: selected == i ? .semibold : .regular, design: .monospaced))
                                    .foregroundStyle(selected == i ? .white : .secondary)
                                    .padding(.horizontal, 8).padding(.vertical, 5)
                                    .background(selected == i ? transitions[selected].color : Color(.systemFill))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }

                // Preview
                ZStack {
                    Color(.secondarySystemBackground)
                    if isShowing {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(LinearGradient(colors: [transitions[selected].color, transitions[selected].color.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 100, height: 70)
                                .overlay(Text(transitions[selected].name.prefix(10)).font(.system(size: 12, design: .monospaced)).foregroundStyle(.white))
                        }
                        .transition(transitions[selected].transition)
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isShowing)

                // Toggle + auto-replay
                HStack(spacing: 10) {
                    Button {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { isShowing.toggle() }
                    } label: {
                        Text(isShowing ? "Remove" : "Insert")
                            .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(transitions[selected].color)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(PressableButtonStyle())

                    Button {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { isShowing = false }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { isShowing = true }
                        }
                    } label: {
                        Image(systemName: "arrow.counterclockwise").font(.system(size: 16, weight: .bold))
                            .foregroundStyle(transitions[selected].color)
                            .frame(width: 35, height: 35)
                            .background(transitions[selected].color.opacity(0.3)).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(PressableButtonStyle())
                }
            }
        }
    }
}

struct BlurScaleModifier: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        if isActive {
            content                 // BlurActive
                .blur(radius: 12)
                .opacity(0)
                .scaleEffect(0.8)
        } else {
            content // BlurIdentity
        }
    }
}

struct TransitionsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: ".transition() - insert and remove animations")
            Text(".transition() defines how a view animates when it's inserted into or removed from the view hierarchy (via if/else or optional rendering). The transition only plays inside a withAnimation { } block.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".transition(.opacity) - fade in/out. The default. Very versatile.", color: .anAmber)
                StepRow(number: 2, text: ".transition(.scale) - grows from/shrinks to zero. Combine with opacity.", color: .anAmber)
                StepRow(number: 3, text: ".transition(.move(edge:)) - slides in from an edge, out to the same edge.", color: .anAmber)
                StepRow(number: 4, text: ".transition(.push(from:)) - pushes the old view out as the new one comes in. iOS 16+.", color: .anAmber)
                StepRow(number: 5, text: ".combined(with:) - combine two transitions: .scale.combined(with: .opacity).", color: .anAmber)
                StepRow(number: 6, text: ".asymmetric(insertion:removal:) - different animations for insert vs remove.", color: .anAmber)
            }

            CalloutBox(style: .warning, title: "Transitions need withAnimation", contentBody: "Without withAnimation, transitions don't animate - the view just appears/disappears instantly. The transition describes HOW to animate; withAnimation provides the timing to do so.")

            CodeBlock(code: """
// Basic transitions
view.transition(.opacity)
view.transition(.scale)
view.transition(.slide)
view.transition(.move(edge: .leading))

// iOS 16+
view.transition(.push(from: .trailing))
view.transition(.blurReplace)
view.transition(.symbolEffect)

// Combined
view.transition(.scale.combined(with: .opacity))

// Asymmetric - different in vs out
view.transition(.asymmetric(
    insertion: .move(edge: .top).combined(with: .opacity),
    removal: .move(edge: .bottom).combined(with: .opacity)
))

// Custom - via ViewModifier
AnyTransition.modifier(
    active: MyModifier(isActive: true),
    identity: MyModifier(isActive: false)
)
""")
        }
    }
}

