//
//
//  2_Spring.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Spring Animations
struct SpringVisual: View {
    @State private var isOn = false
    @State private var selectedPreset = 0
    @State private var duration: CGFloat = 0.5
    @State private var bounce: CGFloat = 0.3

    struct SpringPreset {
        let name: String
        let anim: Animation
        let description: String
    }

    let presets: [SpringPreset] = [
        SpringPreset(name: "smooth",    anim: .smooth,           description: "No bounce - gentle, professional"),
        SpringPreset(name: "snappy",    anim: .snappy,           description: "Fast with slight bounce"),
        SpringPreset(name: "bouncy",    anim: .bouncy,           description: "Pronounced overshoot and settle"),
        SpringPreset(name: "interactive", anim: .interactiveSpring(), description: "Follows finger - low response time"),
    ]

    var customSpring: Animation {
        .spring(duration: duration, bounce: bounce)
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Spring animations", systemImage: "waveform.path.ecg")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.animTeal)

                // Animated ball that bounces
                ZStack {
                    Color(.secondarySystemBackground)
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.animTeal, Color(hex: "#085041")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                        .offset(x: isOn ? 80 : -80)
                        .shadow(color: Color.animTeal.opacity(0.3), radius: 8, y: 4)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Trigger
                Button {
                    withAnimation(
                        selectedPreset < presets.count
                            ? presets[selectedPreset].anim
                            : customSpring
                    ) { isOn.toggle() }
                } label: {
                    Text(isOn ? "Return" : "Launch")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.animTeal)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PressableButtonStyle())

                // Preset chips
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(presets.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedPreset = i }
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(".\(presets[i].name)")
                                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                    .foregroundStyle(selectedPreset == i ? Color.animTeal : .primary)
                                Text(presets[i].description)
                                    .font(.system(size: 10))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .background(selectedPreset == i ? Color(hex: "#E1F5EE") : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedPreset == i ? Color.animTeal.opacity(0.4) : Color.clear, lineWidth: 1)
                            )
                        }
                        .buttonStyle(PressableButtonStyle())
                    }

                    // Custom spring
                    Button {
                        withAnimation(.spring(response: 0.3)) { selectedPreset = presets.count }
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(".spring()")
                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                .foregroundStyle(selectedPreset == presets.count ? Color.animTeal : .primary)
                            Text("Custom parameters")
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(selectedPreset == presets.count ? Color(hex: "#E1F5EE") : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedPreset == presets.count ? Color.animTeal.opacity(0.4) : Color.clear, lineWidth: 1)
                        )
                    }
                    .buttonStyle(PressableButtonStyle())
                }

                // Custom spring sliders
                if selectedPreset == presets.count {
                    VStack(spacing: 8) {
                        HStack(spacing: 10) {
                            Text("Duration")
                                .font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 60, alignment: .leading)
                            Slider(value: $duration, in: 0.1...2.0, step: 0.1).tint(.animTeal)
                            Text("\(duration, specifier: "%.1f")s")
                                .font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 36)
                        }
                        HStack(spacing: 10) {
                            Text("Bounce")
                                .font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 60, alignment: .leading)
                            Slider(value: $bounce, in: 0.0...1.0, step: 0.05).tint(.animTeal)
                            Text("\(bounce, specifier: "%.2f")")
                                .font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 36)
                        }
                    }
                    .padding(10)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}

struct SpringExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Spring animations")
            Text("Springs model real physics, like a mass on a spring that overshoots and oscillates before settling. They feel natural because they mimic how physical objects actually move. iOS uses springs everywhere internally.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".smooth - no bounce. Use for UI elements that should feel calm and professional.", color: .animTeal)
                StepRow(number: 2, text: ".snappy - quick with a tiny overshoot. Great for interactive responses.", color: .animTeal)
                StepRow(number: 3, text: ".bouncy - visible overshoot and settle. Use sparingly for delight moments.", color: .animTeal)
                StepRow(number: 4, text: ".spring(duration:bounce:) - tune directly. duration is settle time, bounce from 0 (none) to 1 (very springy).", color: .animTeal)
            }

            CalloutBox(style: .success, title: "Default to springs", contentBody: "Apple's own HIG recommends springs for most animations. They handle interruption gracefully if you tap mid-animation, a spring continues naturally from wherever it was.")

            CalloutBox(style: .info, title: "bounce parameter", contentBody: "0.0 = critically damped (no overshoot). 0.3 = light bounce. 1.0 = very springy. Values above 1 are allowed but rarely useful.")

            CodeBlock(code: """
// Semantic presets - use these first
.smooth          // calm, no bounce
.snappy          // quick, minimal bounce
.bouncy          // playful overshoot
.interactiveSpring() // follows finger

// Custom spring
.spring(duration: 0.5, bounce: 0.3)

// Old API (still valid)
.spring(response: 0.4, dampingFraction: 0.7)
""")
        }
    }
}
