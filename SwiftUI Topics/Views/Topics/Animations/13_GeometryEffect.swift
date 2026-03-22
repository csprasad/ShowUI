//
//
//  13_GeometryEffect.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 13: GeometryEffect
struct GeometryEffectVisual: View {
    @State private var trigger: CGFloat = 0
    @State private var amount: CGFloat = 10
    @State private var selectedEffect = 0

    let effects = ["Wave", "Skew", "Shake", "3D flip"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("GeometryEffect", systemImage: "rotate.3d.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.animAmber)

                // Preview
                ZStack {
                    Color(.secondarySystemBackground)
                    previewView
                }
                .frame(maxWidth: .infinity)
                .frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Trigger
                Button("Trigger") { fire() }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.animAmber)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .buttonStyle(PressableButtonStyle())

                // Intensity slider
                HStack(spacing: 10) {
                    Text("Intensity")
                        .font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 60, alignment: .leading)
                    Slider(value: $amount, in: 2...30, step: 1).tint(.animAmber)
                    Text("\(Int(amount))")
                        .font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 28)
                }

                // Effect selector
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(effects.indices, id: \.self) { i in
                        Button(effects[i]) {
                            withAnimation(.spring(response: 0.3)) { selectedEffect = i; trigger = 0 }
                        }
                        .font(.system(size: 11, weight: selectedEffect == i ? .semibold : .regular))
                        .foregroundStyle(selectedEffect == i ? Color.animAmber : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(selectedEffect == i ? Color(hex: "#FAEEDA") : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
        }
    }

    // Animate trigger 0 > 1 so sin() oscillates through a full cycle,
    // then snap back to 0 so it's ready for the next tap.
    func fire() {
        trigger = 0
        withAnimation(.linear(duration: 0.5)) { trigger = 1 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.52) { trigger = 0 }
    }

    @ViewBuilder
    private var previewView: some View {
        let card = RoundedRectangle(cornerRadius: 16)
            .fill(LinearGradient(colors: [Color.animAmber, Color(hex: "#633806")],
                                 startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 90, height: 90)
            .overlay(Image(systemName: "star.fill")
                .font(.system(size: 28))
                .foregroundStyle(.white.opacity(0.8)))

        switch selectedEffect {
        case 0:
            card.modifier(WaveEffect(amplitude: amount, trigger: trigger))
        case 1:
            card.modifier(SkewEffect(amount: amount, trigger: trigger))
        case 2:
            card.modifier(ShakeEffect(shakes: max(1, Int(amount / 2)), trigger: trigger))
        default:
            card.modifier(FlipEffect(trigger: trigger))
        }
    }
}

// MARK: - Wave GeometryEffect
struct WaveEffect: GeometryEffect {
    var amplitude: CGFloat
    var trigger: CGFloat
    var animatableData: CGFloat {
        get { trigger }
        set { trigger = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let wave = sin(trigger * .pi * 2) * amplitude
        return ProjectionTransform(CGAffineTransform(translationX: 0, y: wave))
    }
}

// MARK: - Skew GeometryEffect
struct SkewEffect: GeometryEffect {
    var amount: CGFloat
    var trigger: CGFloat
    var animatableData: CGFloat {
        get { trigger }
        set { trigger = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let skew = sin(trigger * .pi * 2) * (amount / 100)
        return ProjectionTransform(CGAffineTransform(a: 1, b: 0, c: skew, d: 1, tx: 0, ty: 0))
    }
}

// MARK: - Shake GeometryEffect
struct ShakeEffect: GeometryEffect {
    var shakes: Int
    var trigger: CGFloat
    var animatableData: CGFloat {
        get { trigger }
        set { trigger = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = sin(trigger * .pi * CGFloat(shakes * 2)) * 12
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

// MARK: - Flip GeometryEffect
struct FlipEffect: GeometryEffect {
    var trigger: CGFloat
    var animatableData: CGFloat {
        get { trigger }
        set { trigger = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let angle = trigger * .pi * 2
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        transform = CATransform3DRotate(transform, angle, 0, 1, 0)
        return ProjectionTransform(transform)
    }
}

struct GeometryEffectExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "GeometryEffect")
            Text("GeometryEffect lets you build custom animated transforms that integrate with SwiftUI's animation system. Unlike modifiers, they animate in the render pass — no view rebuilds, just matrix transforms on every frame.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Conform to GeometryEffect and implement effectValue(size:) — return a ProjectionTransform.", color: .animAmber)
                StepRow(number: 2, text: "Expose animatableData — SwiftUI interpolates this and calls effectValue on every frame.", color: .animAmber)
                StepRow(number: 3, text: "Use sin() to create oscillating effects — sin() returns -1 to 1, scale to your amplitude.", color: .animAmber)
                StepRow(number: 4, text: "For 3D effects, use CATransform3D and set m34 for perspective.", color: .animAmber)
            }

            CalloutBox(style: .success, title: "Why not just .offset or .scaleEffect?", contentBody: "GeometryEffect runs during the render pass without triggering view body re-evaluation. This makes complex animated transforms significantly cheaper than driving them from @State.")

            CodeBlock(code: """
struct ShakeEffect: GeometryEffect {
    var shakes: Int
    var trigger: CGFloat  // animate this from 0 → 1

    var animatableData: CGFloat {
        get { trigger }
        set { trigger = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = sin(trigger * .pi * CGFloat(shakes * 2)) * 12
        return ProjectionTransform(
            CGAffineTransform(translationX: translation, y: 0)
        )
    }
}

// Apply it
Text("Wrong password")
    .modifier(ShakeEffect(shakes: 4, trigger: triggerValue))
    .animation(.linear(duration: 0.5), value: triggerValue)
""")
        }
    }
}
