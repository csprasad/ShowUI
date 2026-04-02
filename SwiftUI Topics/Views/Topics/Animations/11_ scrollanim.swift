//
//
//  11_ scrollanim.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 11: Scroll Animations

struct ScrollAnimVisual: View {
    @State private var selectedEffect = 0
    let effects = ["scrollTransition", "visualEffect", "Parallax"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("Scroll animations", systemImage: "scroll.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.animTeal)
                    Spacer()
                    Text("iOS 17+")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.animTeal)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color(hex: "#E1F5EE"))
                        .clipShape(Capsule())
                }

                // Effect selector
                HStack(spacing: 8) {
                    ForEach(effects.indices, id: \.self) { i in
                        Button(effects[i]) {
                            withAnimation(.spring(response: 0.3)) { selectedEffect = i }
                        }
                        .font(.system(size: 11, weight: selectedEffect == i ? .semibold : .regular))
                        .foregroundStyle(selectedEffect == i ? Color.animTeal : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(selectedEffect == i ? Color(hex: "#E1F5EE") : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Scroll demo
                switch selectedEffect {
                case 0: scrollTransitionDemo
                case 1: visualEffectDemo
                default: parallaxDemo
                }

                Text("Scroll inside the area above to see the effect")
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    // MARK: scrollTransition
    var scrollTransitionDemo: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(0..<8, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [Color.animTeal, Color(hex: "#085041")],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .overlay(
                            Text("Item \(i + 1)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white)
                        )
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.3)
                                .scaleEffect(phase.isIdentity ? 1 : 0.85)
                                .offset(x: phase == .topLeading ? -30 : phase == .bottomTrailing ? 30 : 0)
                        }
                }
            }
            .padding(.horizontal, 4)
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: visualEffect
    var visualEffectDemo: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<6, id: \.self) { i in
                    let colors: [Color] = [.animPurple, .animTeal, .animCoral, .animAmber, .animBlue, .animPink]
                    RoundedRectangle(cornerRadius: 16)
                        .fill(colors[i % colors.count])
                        .frame(width: 100, height: 140)
                        .overlay(
                            Text("\(i + 1)")
                                .font(.system(size: 28, weight: .black))
                                .foregroundStyle(.white.opacity(0.6))
                        )
                        .visualEffect { content, proxy in
                            let frame = proxy.frame(in: .scrollView(axis: .horizontal))
                            let distance = abs(frame.midX - proxy.size.width / 2)
                            let scale = max(0.75, 1 - distance / 400)
                            let opacity = max(0.4, 1 - distance / 300)
                            return content
                                .scaleEffect(scale)
                                .opacity(opacity)
                        }
                }
            }
            .padding(.horizontal, 16)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: Parallax
    var parallaxDemo: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(0..<4, id: \.self) { i in
                    let colors: [[Color]] = [
                        [Color(hex: "#B5D4F4"), Color(hex: "#CECBF6")],
                        [Color(hex: "#9FE1CB"), Color(hex: "#B5D4F4")],
                        [Color(hex: "#FAC775"), Color(hex: "#F5C4B3")],
                        [Color(hex: "#CECBF6"), Color(hex: "#9FE1CB")],
                    ]
                    ZStack {
                        LinearGradient(colors: colors[i], startPoint: .topLeading, endPoint: .bottomTrailing)
                        GeometryReader { geo in
                            let offset = geo.frame(in: .scrollView(axis: .vertical)).minY
                            Text("Section \(i + 1)")
                                .font(.system(size: 22, weight: .black))
                                .foregroundStyle(.white.opacity(0.8))
                                .offset(y: offset * 0.4)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(height: 90)
                }
            }
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ScrollAnimExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Scroll animations - iOS 17+")
            Text("iOS 17 introduced first-class scroll animation APIs that let views react to their position in a scroll view. Previously this required GeometryReader hacks - now it's declarative and performant.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".scrollTransition - apply effects as items enter and leave the visible area. phase.isIdentity is true when fully visible.", color: .animTeal)
                StepRow(number: 2, text: ".visualEffect - access the view's geometry relative to the scroll view and apply transforms, opacity, blur.", color: .animTeal)
                StepRow(number: 3, text: "Parallax - use GeometryReader inside the item to read scroll offset and offset content at a reduced rate.", color: .animTeal)
                StepRow(number: 4, text: ".scrollTargetBehavior(.viewAligned) - snap scroll to individual items, like a pager.", color: .animTeal)
            }

            CalloutBox(style: .success, title: "scrollTransition phases", contentBody: "Phase has three states: .topLeading (item entering from top/leading), .identity (fully visible), .bottomTrailing (item leaving toward bottom/trailing). Drive all your effects from these three states.")

            CalloutBox(style: .warning, title: "Performance note", contentBody: "visualEffect runs on every scroll frame. Keep the closure lightweight, transforms and opacity are fine. Avoid layout changes or heavy computation inside it.")

            CodeBlock(code: """
// scrollTransition - fade and scale items as they scroll
ForEach(items) { item in
    CardView(item: item)
        .scrollTransition { content, phase in
            content
                .opacity(phase.isIdentity ? 1 : 0.4)
                .scaleEffect(phase.isIdentity ? 1 : 0.88)
                .blur(radius: phase.isIdentity ? 0 : 4)
        }
}

// visualEffect - geometry-based effects
CardView()
    .visualEffect { content, proxy in
        let frame = proxy.frame(in: .scrollView(axis: .horizontal))
        let distance = abs(frame.midX - proxy.size.width / 2)
        return content.scaleEffect(max(0.7, 1 - distance / 400))
    }

// Parallax background
GeometryReader { geo in
    let offset = geo.frame(in: .scrollView(axis: .vertical)).minY
    Image("bg")
        .offset(y: offset * 0.4)  // moves slower than scroll
}
""")
        }
    }
}
