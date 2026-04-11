//
//
//  1_AnimationTypes.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: Animation Types
struct AnimTypesVisual: View {
    @State private var triggered   = false
    @State private var selected    = 0
    @State private var showAll     = false

    struct AnimConfig: Identifiable {
        let id = UUID()
        let name: String
        let anim: Animation
        let color: Color
    }

    let configs: [AnimConfig] = [
        AnimConfig(name: ".spring()", anim: .spring(), color: Color(hex: "#D97706")),
        AnimConfig(name: ".spring(bounce: 0.5)", anim: .spring(bounce: 0.5), color: Color(hex: "#C2410C")),
        AnimConfig(name: ".bouncy", anim: .bouncy, color: Color(hex: "#7C3AED")),
        AnimConfig(name: ".easeInOut(1.0)", anim: .easeInOut(duration: 1.0), color: Color(hex: "#0F766E")),
        AnimConfig(name: ".easeIn(0.8)", anim: .easeIn(duration: 0.8), color: Color(hex: "#1D4ED8")),
        AnimConfig(name: ".easeOut(0.8)", anim: .easeOut(duration: 0.8), color: Color(hex: "#0891B2")),
        AnimConfig(name: ".linear(0.8)", anim: .linear(duration: 0.8), color: Color(hex: "#4D7C0F")),
        AnimConfig(name: ".smooth", anim: .smooth, color: Color(hex: "#BE123C")),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Animation types", systemImage: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.anAmber)

                // All-at-once vs single
                HStack(spacing: 8) {
                    Toggle("Compare all", isOn: $showAll.animation(.spring(response: 0.3))).tint(.anAmber)
                        .font(.system(size: 13))

                    if !showAll {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(configs.indices, id: \.self) { i in
                                    Button {
                                        withAnimation(.spring(response: 0.25)) { selected = i }
                                    } label: {
                                        Text(String(configs[i].name.prefix(12)))
                                            .font(.system(size: 9, weight: selected == i ? .semibold : .regular, design: .monospaced))
                                            .foregroundStyle(selected == i ? .white : .secondary)
                                            .padding(.horizontal, 8).padding(.vertical, 5)
                                            .background(selected == i ? configs[i].color : Color(.systemFill))
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }
                        }
                    }
                }

                // Animation playground
                ZStack {
                    Color(.secondarySystemBackground)

                    if showAll {
                        // Side-by-side race
                        VStack(spacing: 0) {
                            ForEach(configs) { cfg in
                                HStack(spacing: 8) {
                                    Text(cfg.name)
                                        .font(.system(size: 8, design: .monospaced))
                                        .foregroundStyle(.secondary)
                                        .frame(width: 120, alignment: .leading)
                                    GeometryReader { geo in
                                        Circle()
                                            .fill(cfg.color)
                                            .frame(width: 14, height: 14)
                                            .offset(x: triggered ? geo.size.width - 18 : 0)
                                            .animation(cfg.anim, value: triggered)
                                    }
                                    .frame(height: 14)
                                }
                                .padding(.horizontal, 10).padding(.vertical, 3)
                            }
                        }
                        .padding(.vertical, 8)
                    } else {
                        // Single animated block
                        let cfg = configs[selected]
                        VStack(spacing: 10) {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(cfg.color)
                                .frame(width: 60, height: 60)
                                .rotation3DEffect(.degrees(triggered ? 180 : 0), axis: (0, 1, 0))
                                .offset(x: triggered ? 80 : -80)
                                .animation(cfg.anim, value: triggered)

                            Text(cfg.name)
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                .foregroundStyle(cfg.color)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: showAll ? 220 : 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.3), value: showAll)

                // Trigger button
                Button {
                    triggered.toggle()
                } label: {
                    Text(triggered ? "← Reset" : "Animate →")
                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(Color.anAmber).clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
    }
}

struct AnimTypesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Animation curves")
            Text("SwiftUI provides spring-based and timing-based animations. Springs simulate physics and overshoot naturally - preferred for UI elements. Timing curves (ease, linear) give precise duration control for content transitions.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".spring() - default spring. Good for most UI movement. Automatically tunes response and damping.", color: .anAmber)
                StepRow(number: 2, text: ".spring(duration: 0.4, bounce: 0.2) - explicit spring. bounce: 0 = no overshoot, 1 = very bouncy.", color: .anAmber)
                StepRow(number: 3, text: ".bouncy - preset bouncy spring. Equivalent to spring with moderate bounce.", color: .anAmber)
                StepRow(number: 4, text: ".smooth - smooth spring with no overshoot. Great for content layout changes.", color: .anAmber)
                StepRow(number: 5, text: ".easeInOut(duration:) - starts slow, speeds up, slows down. Smooth and natural.", color: .anAmber)
                StepRow(number: 6, text: ".linear(duration:) - constant speed. Use for continuous animations like rotation.", color: .anAmber)
            }

            CalloutBox(style: .success, title: "Prefer springs for UI", contentBody: "Springs feel more natural than timing curves because they simulate physics. .spring() with its default parameters works well for almost everything. Only reach for easeInOut when you need exact duration control.")

            CodeBlock(code: """
// Springs
.spring()                          // default - great starting point
.spring(duration: 0.5)            // control duration
.spring(response: 0.4, dampingFraction: 0.7)  // classic spring API
.spring(bounce: 0.3)              // 0=none, 1=very bouncy
.bouncy                            // preset bouncy spring
.smooth                            // preset no-overshoot spring
.snappy                            // preset responsive spring

// Timing curves
.easeInOut(duration: 0.4)
.easeIn(duration: 0.3)
.easeOut(duration: 0.3)
.linear(duration: 0.5)
.interpolatingSpring(stiffness: 200, damping: 20)

// Delay and repeat
.spring().delay(0.2)
.easeInOut(duration: 0.5).repeatForever(autoreverses: true)
.linear(duration: 1).repeatCount(3)
""")
        }
    }
}
