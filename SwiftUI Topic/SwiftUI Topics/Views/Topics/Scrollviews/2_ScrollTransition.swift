//
//
//  2_ScrollTransition.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: scrollTransition
struct ScrollTransitionVisual: View {
    @State private var selectedEffect = 0
    @State private var selectedAxis   = 0
    let effects = ["Scale fade", "Slide in", "Rotate", "Blur", "Custom"]
    let cards   = ScrollCard.samples(10)

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("scrollTransition", systemImage: "sparkles.rectangle.stack.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.scrollOrange)

                // Effect selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(effects.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedEffect = i }
                            } label: {
                                Text(effects[i])
                                    .font(.system(size: 11, weight: selectedEffect == i ? .semibold : .regular))
                                    .foregroundStyle(selectedEffect == i ? Color.scrollOrange : .secondary)
                                    .padding(.horizontal, 10).padding(.vertical, 6)
                                    .background(selectedEffect == i ? Color.scrollOrangeLight : Color(.systemFill))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }

                // Axis toggle
                HStack(spacing: 8) {
                    ForEach(["Vertical", "Horizontal"].indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedAxis = i }
                        } label: {
                            Text(["Vertical", "Horizontal"][i])
                                .font(.system(size: 11, weight: selectedAxis == i ? .semibold : .regular))
                                .foregroundStyle(selectedAxis == i ? Color.scrollOrange : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 6)
                                .background(selectedAxis == i ? Color.scrollOrangeLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Live demo
                if selectedAxis == 0 {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 10) {
                            ForEach(cards) { card in
                                transitionCell(card)
                                    .scrollTransition { [selectedEffect] content, phase in
                                        applyEffect(content, phase: phase, selectedEffect: selectedEffect)
                                    }
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 10) {
                            ForEach(cards) { card in
                                transitionCell(card, horizontal: true)
                                    .scrollTransition { [selectedEffect] content, phase in
                                        applyEffect(content, phase: phase, selectedEffect: selectedEffect)
                                    }
                            }
                        }
                        .padding(.vertical, 2)
                    }
                    .frame(height: 110)
                }

                infoChip
            }
        }
    }

    nonisolated private func applyEffect(_ content: EmptyVisualEffect, phase: ScrollTransitionPhase, selectedEffect: Int) -> some VisualEffect {
        content
            // Effect 0 & 2 & Default: Scale
            .scaleEffect(
                selectedEffect == 0 ? (phase.isIdentity ? 1 : 0.7) :
                selectedEffect == 2 ? (phase.isIdentity ? 1 : 0.85) :
                selectedEffect == 4 ? (phase.isIdentity ? 1 : 0.8) : 1.0
            )
            // Effect 1 & Default: Offset
            .offset(
                x: selectedEffect == 1 ? (phase.isIdentity ? 0 : -40) : 0,
                y: selectedEffect == 4 ? (phase.isIdentity ? 0 : (phase == .topLeading ? -20 : 20)) : 0
            )
            // Effect 2 & Default: Rotation
            .rotationEffect(
                .init(degrees: selectedEffect == 2 ? (phase.isIdentity ? 0 : (phase == .bottomTrailing ? 8 : -8)) :
                      selectedEffect == 4 ? (phase.isIdentity ? 0 : (phase == .topLeading ? -5 : 5)) : 0)
            )
            // Effect 3: Blur
            .blur(radius: selectedEffect == 3 ? (phase.isIdentity ? 0 : 6) : 0)
            // Global Opacity logic
            .opacity(phase.isIdentity ? 1 : (selectedEffect == 0 ? 0 : 0.5))
    }
    
    func transitionCell(_ card: ScrollCard, horizontal: Bool = false) -> some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(LinearGradient(colors: [card.color, card.color.opacity(0.7)],
                                 startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: horizontal ? 130 : nil, height: horizontal ? 88 : 64)
            .overlay(Text(card.label).font(.system(size: 13, weight: .semibold)).foregroundStyle(.white))
    }

    var infoChip: some View {
        HStack(spacing: 6) {
            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.scrollOrange)
            Text("Scroll to see the transition - views animate as they enter and leave the visible region")
                .font(.system(size: 11)).foregroundStyle(.secondary)
        }
        .padding(8).background(Color.scrollOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ScrollTransitionExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "scrollTransition - iOS 17+")
            Text(".scrollTransition animates views as they enter and exit the visible scroll area. The transition receives the current content view and a ScrollTransitionPhase - apply any visual modifier based on the phase.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".scrollTransition { content, phase in } - fires continuously as the view scrolls in/out of visibility.", color: .scrollOrange)
                StepRow(number: 2, text: "phase.isIdentity - true when fully visible. False when entering/exiting. Use this as the condition.", color: .scrollOrange)
                StepRow(number: 3, text: "phase == .topLeading - entering from top/left. phase == .bottomTrailing - entering from bottom/right.", color: .scrollOrange)
                StepRow(number: 4, text: ".scrollTransition(.animated(.spring())) - custom animation for the transition.", color: .scrollOrange)
                StepRow(number: 5, text: "Combine scaleEffect + opacity + offset for the most polished entrance animations.", color: .scrollOrange)
            }

            CalloutBox(style: .success, title: "The standard entrance pattern", contentBody: "scaleEffect(phase.isIdentity ? 1 : 0.85) + opacity(phase.isIdentity ? 1 : 0) is the clean, subtle entrance effect used throughout system apps. Simple, smooth, not distracting.")

            CodeBlock(code: """
// Standard fade-scale entrance
.scrollTransition { content, phase in
    content
        .scaleEffect(phase.isIdentity ? 1 : 0.85)
        .opacity(phase.isIdentity ? 1 : 0)
}

// Direction-aware slide
.scrollTransition { content, phase in
    content
        .offset(y: phase.isIdentity ? 0 :
                   phase == .topLeading ? -30 : 30)
        .opacity(phase.isIdentity ? 1 : 0.3)
}

// Custom spring animation
.scrollTransition(
    .animated(.spring(response: 0.4, dampingFraction: 0.8))
) { content, phase in
    content.scaleEffect(phase.isIdentity ? 1 : 0.7)
}

// Three phases:
// .topLeading   - entering from top/left
// .identity     - fully visible (isIdentity = true)
// .bottomTrailing - exiting to bottom/right
""")
        }
    }
}
