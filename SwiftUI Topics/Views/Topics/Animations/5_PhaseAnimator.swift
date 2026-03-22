//
//
//  5_PhaseAnimator.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Phase Animator
struct PhaseAnimatorVisual: View {
    @State private var trigger = 0
    @State private var selectedEffect = 0
    @State private var isAutoPlaying = false

    let effects = ["Bounce", "Appear", "Shake", "Pulse"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("PhaseAnimator", systemImage: "arrow.trianglehead.2.clockwise.rotate.90")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.animPurple)
                    Spacer()
                    Text("iOS 17+")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.animPurple)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color(hex: "#EEEDFE"))
                        .clipShape(Capsule())
                }

                // The animated subject
                ZStack {
                    Color(.secondarySystemBackground)

                    switch selectedEffect {
                    case 0: bounceEffect
                    case 1: appearEffect
                    case 2: shakeEffect
                    default: pulseEffect
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Trigger button
                Button("Trigger animation") {
                    trigger += 1
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.animPurple)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .buttonStyle(PressableButtonStyle())

                // Effect selector
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(effects.indices, id: \.self) { i in
                        Button(effects[i]) {
                            withAnimation(.spring(response: 0.3)) { selectedEffect = i }
                            trigger = 0
                        }
                        .font(.system(size: 11, weight: selectedEffect == i ? .semibold : .regular))
                        .foregroundStyle(selectedEffect == i ? Color.animPurple : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(selectedEffect == i ? Color(hex: "#EEEDFE") : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                CalloutBox(style: .info, title: "PhaseAnimator cycles through states", contentBody: "Each phase plays in sequence when triggered. Unlike withAnimation, you don't manually chain — SwiftUI handles the sequencing.")
            }
        }
    }

    // MARK: - Effect views using PhaseAnimator

    var bounceEffect: some View {
        PhaseAnimator([0, 1, 2], trigger: trigger) { phase in
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.animPurple)
                .frame(width: 60, height: 60)
                .scaleEffect(phase == 1 ? 1.4 : phase == 2 ? 0.9 : 1.0)
                .offset(y: phase == 1 ? -30 : 0)
        } animation: { phase in
            phase == 1 ? .spring(duration: 0.3, bounce: 0.3) : .spring(duration: 0.4, bounce: 0.6)
        }
    }

    var appearEffect: some View {
        PhaseAnimator([false, true], trigger: trigger) { isVisible in
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(colors: [Color.animPurple, Color(hex: "#3C3489")],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 80, height: 80)
                .scaleEffect(isVisible ? 1 : 0.1)
                .opacity(isVisible ? 1 : 0)
                .rotation3DEffect(.degrees(isVisible ? 0 : 180), axis: (x: 0, y: 1, z: 0))
        } animation: { _ in .spring(duration: 0.6, bounce: 0.4) }
    }

    var shakeEffect: some View {
        PhaseAnimator([0, -12, 12, -8, 8, -4, 4, 0], trigger: trigger) { offset in
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "#993C1D"))
                .frame(width: 70, height: 70)
                .overlay(
                    Image(systemName: "bell.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.white)
                )
                .offset(x: offset)
        } animation: { _ in .linear(duration: 0.08) }
    }

    var pulseEffect: some View {
        PhaseAnimator([1.0, 1.25, 1.0], trigger: trigger) { scale in
            Circle()
                .fill(Color.animTeal.opacity(0.3))
                .frame(width: 80, height: 80)
                .overlay(
                    Circle()
                        .fill(Color.animTeal)
                        .frame(width: 40, height: 40)
                )
                .scaleEffect(scale)
        } animation: { _ in .easeInOut(duration: 0.4) }
    }
}

struct PhaseAnimatorExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "PhaseAnimator — iOS 17+")
            Text("PhaseAnimator cycles through an array of phases automatically when triggered. Each phase transition can use a different animation. SwiftUI handles the sequencing, so no DispatchQueue.asyncAfter chains needed.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Define an array of phases — any Equatable type (Bool, Int, enum).", color: .animPurple)
                StepRow(number: 2, text: "Use the current phase value to set your view's properties.", color: .animPurple)
                StepRow(number: 3, text: "The animation closure returns a different Animation per phase transition.", color: .animPurple)
                StepRow(number: 4, text: "Change trigger to start the cycle. It plays through all phases then stops.", color: .animPurple)
            }

            CalloutBox(style: .success, title: "Great for multi-step effects", contentBody: "Bounce, shake, heartbeat, shimmer any effect with multiple stages. Replaces async chains and nested withAnimation calls.")

            CodeBlock(code: """
// Bounce effect — 3 phases
PhaseAnimator([0, 1, 2], trigger: didTap) { phase in
    Circle()
        .scaleEffect(phase == 1 ? 1.4 : phase == 2 ? 0.9 : 1.0)
        .offset(y: phase == 1 ? -30 : 0)
} animation: { phase in
    phase == 1
        ? .spring(duration: 0.3, bounce: 0.2)
        : .spring(duration: 0.4, bounce: 0.6)
}

// Trigger it
Button("Bounce") { didTap += 1 }
""")
        }
    }
}
