//
//
//  6_visualEffect.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: visualEffect
struct VisualEffectVisual: View {
    @State private var selectedEffect = 0
    let effects = ["Parallax", "Scale", "Opacity fade", "Rotation", "3D tilt"]
    let cards   = ScrollCard.samples(8)

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("visualEffect", systemImage: "wand.and.rays")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.scrollOrange)

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

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(cards) { card in
                            ZStack {
                                // Background layer for parallax
                                if selectedEffect == 0 {
                                    LinearGradient(colors: [card.color.opacity(0.3), card.color.opacity(0.1)],
                                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                                        .frame(width: 180, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 18))
                                        .visualEffect { content, proxy in
                                            let x = proxy.frame(in: .scrollView).midX
                                            let containerMid = proxy.bounds(of: .scrollView)?.midX ?? 0
                                            let offset = (x - containerMid) * 0.3
                                            return content.offset(x: offset)
                                        }
                                }
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(card.color)
                                    .frame(width: 160, height: 100)
                                    .overlay(
                                        VStack(spacing: 4) {
                                            Text(card.label).font(.system(size: 16, weight: .bold)).foregroundStyle(.white)
                                            Text(effects[selectedEffect]).font(.system(size: 9, design: .monospaced)).foregroundStyle(.white.opacity(0.7))
                                        }
                                    )
                                    .visualEffect { [selectedEffect] content, proxy in
                                        applyVisualEffect(content, proxy: proxy, selectedEffect: selectedEffect)
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 20).padding(.vertical, 12)
                }
                .frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .background(Color(.secondarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 16)))

                HStack(spacing: 6) {
                    Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.scrollOrange)
                    Text("Scroll the cards - .visualEffect gives each cell access to its own geometry proxy")
                        .font(.system(size: 11)).foregroundStyle(.secondary)
                }
                .padding(8).background(Color.scrollOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    nonisolated private func applyVisualEffect(_ content: EmptyVisualEffect, proxy: GeometryProxy, selectedEffect: Int) -> some VisualEffect {
        let frame          = proxy.frame(in: .scrollView)
        let containerW     = proxy.bounds(of: .scrollView)?.width ?? 400
        let centerX        = frame.midX
        let containerMidX  = containerW / 2
        let distance       = centerX - containerMidX
        let normalized     = distance / containerW   // -0.5 to 0.5
        
        return content
            // Scale logic
            .scaleEffect(
                selectedEffect == 1 ? max(0.7, 1 - abs(normalized) * 0.3) :
                selectedEffect == 4 ? (1 - abs(normalized) * 0.15) : 1.0
            )
            // Opacity logic
            .opacity(
                selectedEffect == 2 ? max(0.2, 1 - abs(normalized) * 0.8) : 1.0
            )
            // 2D Rotation
            .rotationEffect(
                .init(degrees: selectedEffect == 3 ? (normalized * 12) : 0)
            )
            // 3D Rotation (Case 4 / Default)
            .rotation3DEffect(
                .init(degrees: selectedEffect == 4 ? (normalized * 20) : 0),
                axis: (x: 0, y: 1, z: 0)
            )
    }
}

struct VisualEffectExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "visualEffect - iOS 17+")
            Text(".visualEffect gives each cell in a scroll view access to a GeometryProxy relative to the scroll container. This lets you apply per-cell effects based on each cell's position in the scroll view - parallax, scale, 3D tilt.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".visualEffect { content, proxy in } - the proxy gives the cell's frame in the scroll coordinate space.", color: .scrollOrange)
                StepRow(number: 2, text: "proxy.frame(in: .scrollView) - the cell's frame relative to the scroll view bounds.", color: .scrollOrange)
                StepRow(number: 3, text: "proxy.bounds(of: .scrollView) - the scroll view's total bounds.", color: .scrollOrange)
                StepRow(number: 4, text: "Normalize position: (cell.midX - container.midX) / container.width gives -0.5 to 0.5.", color: .scrollOrange)
                StepRow(number: 5, text: "Unlike GeometryReader, visualEffect doesn't affect layout - it only changes visual rendering.", color: .scrollOrange)
            }

            CalloutBox(style: .success, title: "visualEffect doesn't break layout", contentBody: "Unlike GeometryReader which can affect layout, .visualEffect is purely visual - it modifies rendering without changing the view's layout contribution. Safe to use on grid and list cells.")

            CodeBlock(code: """
// Scale + opacity by scroll position
.visualEffect { content, proxy in
    let frame = proxy.frame(in: .scrollView)
    let containerMid = proxy.bounds(of: .scrollView)?.midX ?? 0
    let distance = abs(frame.midX - containerMid)
    let normalized = distance / (proxy.bounds(of: .scrollView)?.width ?? 400)

    return content
        .scaleEffect(1 - normalized * 0.2)
        .opacity(1 - normalized * 0.5)
}

// 3D card tilt
.visualEffect { content, proxy in
    let x = proxy.frame(in: .scrollView).midX
    let mid = proxy.bounds(of: .scrollView)?.midX ?? 0
    let angle = ((x - mid) / (proxy.bounds(of: .scrollView)?.width ?? 400)) * 30

    return content
        .rotation3DEffect(.degrees(angle), axis: (0, 1, 0))
}

// Parallax background
.visualEffect { content, proxy in
    let x = proxy.frame(in: .scrollView).midX
    let mid = proxy.bounds(of: .scrollView)?.midX ?? 0
    return content.offset(x: (x - mid) * -0.3)
}
""")
        }
    }
}
