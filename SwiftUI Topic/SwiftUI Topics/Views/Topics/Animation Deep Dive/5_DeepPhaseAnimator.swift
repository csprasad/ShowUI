//
//
//  5_PhaseAnimator.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: PhaseAnimator
enum PulsePhase: CaseIterable { case idle, big, small }
enum HeartPhase: CaseIterable { case normal, big, superBig, settle }
enum OrbitPhase: CaseIterable { case pos0, pos1, pos2, pos3 }

struct DeepPhaseAnimatorVisual: View {
    @State private var trigger      = 0
    @State private var selectedDemo = 0
    let demos = ["Pulse loop", "Heart beat", "Orbit"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("PhaseAnimator", systemImage: "repeat.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.anAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; trigger = 0 }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 12, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.anAmber : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.anAmberLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                ZStack {
                    Color(.secondarySystemBackground)

                    switch selectedDemo {
                    case 0:
                        // Continuous pulse loop
                        PhaseAnimator(PulsePhase.allCases) { phase in
                            ZStack {
                                Circle()
                                    .fill(Color.anAmber.opacity(0.15))
                                    .frame(width: phase == .big ? 100 : 60, height: phase == .big ? 100 : 60)
                                Circle()
                                    .fill(Color.anAmber.opacity(0.3))
                                    .frame(width: phase == .big ? 70 : 45, height: phase == .big ? 70 : 45)
                                Circle()
                                    .fill(Color.anAmber)
                                    .frame(width: phase == .small ? 20 : 30, height: phase == .small ? 20 : 30)
                            }
                        } animation: { phase in
                            switch phase {
                            case .idle:  .easeInOut(duration: 0.8)
                            case .big:   .spring(duration: 0.4, bounce: 0.3)
                            case .small: .easeIn(duration: 0.3)
                            }
                        }

                    case 1:
                        // Heart beat - triggered
                        PhaseAnimator(HeartPhase.allCases, trigger: trigger) { phase in
                            Image(systemName: "heart.fill")
                                .font(.system(size: phase == .superBig ? 70 : phase == .big ? 55 : 44))
                                .foregroundStyle(
                                    phase == .superBig ?
                                    LinearGradient(colors: [.animCoral, Color(hex: "#FF6B6B")], startPoint: .top, endPoint: .bottom) :
                                    LinearGradient(colors: [.animCoral, .animCoral], startPoint: .top, endPoint: .bottom)
                                )
                                .shadow(color: Color.animCoral.opacity(phase == .superBig ? 0.5 : 0), radius: 20)
                                .scaleEffect(phase == .settle ? 0.95 : 1)
                        } animation: { phase in
                            switch phase {
                            case .normal:   .spring(duration: 0.2)
                            case .big:      .spring(duration: 0.15, bounce: 0.5)
                            case .superBig: .spring(duration: 0.2, bounce: 0.3)
                            case .settle:   .spring(duration: 0.4, bounce: 0.2)
                            }
                        }

                    default:
                        // Orbiting dot
                        PhaseAnimator(OrbitPhase.allCases) { phase in
                            let positions: [OrbitPhase: CGPoint] = [
                                .pos0: CGPoint(x: 0, y: -50),
                                .pos1: CGPoint(x: 50, y: 0),
                                .pos2: CGPoint(x: 0, y: 50),
                                .pos3: CGPoint(x: -50, y: 0),
                            ]
                            ZStack {
                                Circle().stroke(Color.anAmber.opacity(0.2), lineWidth: 1).frame(width: 100, height: 100)
                                Circle().fill(Color.anAmber).frame(width: 12, height: 12)
                                    .offset(x: positions[phase]?.x ?? 0, y: positions[phase]?.y ?? 0)
                                Circle().fill(Color.anAmberMid).frame(width: 20, height: 20)
                            }
                        } animation: { _ in .linear(duration: 0.4) }
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Trigger button for heart
                if selectedDemo == 1 {
                    Button {
                        trigger += 1
                    } label: {
                        Label("Trigger heartbeat", systemImage: "heart.fill")
                            .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(Color.animCoral).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(PressableButtonStyle())
                } else {
                    HStack(spacing: 6) {
                        Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.anAmber)
                        Text("PhaseAnimator loops through all phases automatically - no trigger needed.")
                            .font(.system(size: 11)).foregroundStyle(.secondary)
                    }
                    .padding(8).background(Color.anAmberLight).clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
}

struct DeepPhaseAnimatorExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "PhaseAnimator - iOS 17+")
            Text("PhaseAnimator cycles through an array of phases, applying a different animation for each transition. Without a trigger it loops continuously - ideal for loading indicators and idle animations. With a trigger it runs once per trigger change.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "PhaseAnimator(Phase.allCases) { phase in } animation: { phase in } - looping.", color: .anAmber)
                StepRow(number: 2, text: "PhaseAnimator(phases, trigger: count) { } animation: { } - runs once per trigger increment.", color: .anAmber)
                StepRow(number: 3, text: "The animation: closure returns a different Animation for each phase transition.", color: .anAmber)
                StepRow(number: 4, text: "Use enums for phases - CaseIterable for automatic allCases array.", color: .anAmber)
                StepRow(number: 5, text: "Properties are read from the current phase - switch phase {} inside the content closure.", color: .anAmber)
            }

            CalloutBox(style: .success, title: "PhaseAnimator for multi-step effects", contentBody: "Use PhaseAnimator when a KeyframeAnimator would require explicit duration math. Phases are declarative - each phase defines a state, the animation: closure defines how to get there. Great for icon effects, loading states, and attention-grabbing loops.")

            CodeBlock(code: """
// Looping idle animation
enum PulsePhase: CaseIterable { case small, big }

PhaseAnimator(PulsePhase.allCases) { phase in
    Circle()
        .fill(.orange)
        .frame(width: phase == .big ? 80 : 40,
               height: phase == .big ? 80 : 40)
} animation: { phase in
    switch phase {
    case .small: .easeIn(duration: 0.4)
    case .big:   .spring(bounce: 0.3)
    }
}

// Triggered - play once per tap
@State private var likeTrigger = 0

PhaseAnimator(LikePhase.allCases, trigger: likeTrigger) { phase in
    Image(systemName: phase == .liked ? "heart.fill" : "heart")
        .foregroundStyle(phase == .liked ? .red : .gray)
        .scaleEffect(phase == .pop ? 1.4 : 1)
} animation: { phase in
    switch phase {
    case .liked: .spring(bounce: 0.5)
    case .pop:   .spring(duration: 0.15)
    case .settle: .spring(duration: 0.3)
    }
}

Button("Like") { likeTrigger += 1 }
""")
        }
    }
}
