//
//
//  16_DrawingGroup.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 16: DrawingGroup & Performance
struct DrawingGroupVisual: View {
    @State private var particleCount = 20
    @State private var useDrawingGroup = false
    @State private var isAnimating = false
    @State private var fps: Double = 0

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("DrawingGroup & performance", systemImage: "cpu.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.animPink)

                // Toggle
                Toggle(isOn: $useDrawingGroup) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("drawingGroup()")
                            .font(.system(size: 13, weight: .semibold))
                        Text(useDrawingGroup ? "Metal rendering — offloads to GPU" : "Standard CPU rendering")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                }
                .tint(Color.animPink)

                // Particle canvas
                ZStack {
                    Color(.secondarySystemBackground)
                    if isAnimating {
                        particleView
                            .drawingGroup(opaque: false, colorMode: useDrawingGroup ? .linear : .nonLinear)
                    } else {
                        Button("Start") { isAnimating = true }
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.animPink)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                if isAnimating {
                    Button("Stop") { isAnimating = false }
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(Color.animPink)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .buttonStyle(PressableButtonStyle())
                }

                // Particle count slider
                HStack(spacing: 10) {
                    Text("Particles")
                        .font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 60, alignment: .leading)
                    Slider(value: Binding(get: { CGFloat(particleCount) }, set: { particleCount = Int($0) }),
                           in: 5...60, step: 5).tint(.animPink)
                    Text("\(particleCount)")
                        .font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 28)
                }

                // What it does
                HStack(spacing: 8) {
                    Image(systemName: useDrawingGroup ? "checkmark.circle.fill" : "info.circle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(useDrawingGroup ? Color.animTeal : Color.animPink)
                    Text(useDrawingGroup
                        ? "Flattened to a Metal texture — better for many overlapping transparent views"
                        : "Each view rendered individually — can drop frames with many blended views")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .animation(.easeInOut(duration: 0.2), value: useDrawingGroup)
            }
        }
    }

    var particleView: some View {
        TimelineView(.animation) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            ZStack {
                ForEach(0..<particleCount, id: \.self) { i in
                    let seed = Double(i) * 137.508
                    let x = sin(seed + t * 0.8) * 120
                    let y = cos(seed * 1.3 + t * 0.6) * 50
                    let scale = CGFloat(0.5 + sin(seed + t * 1.2) * 0.5)
                    let hue = (seed / 360 + t * 0.04).truncatingRemainder(dividingBy: 1)

                    Circle()
                        .fill(Color(hue: hue, saturation: 0.8, brightness: 0.9).opacity(0.7))
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .offset(x: x, y: y)
                }
            }
        }
    }
}

struct DrawingGroupExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "drawingGroup() & performance")
            Text("drawingGroup() flattens a view hierarchy into a single Metal texture before compositing it into the parent. This trades flexibility for speed, as all the views inside are rendered together in one GPU pass instead of individually.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Add .drawingGroup() to a container with many overlapping, transparent, animated views.", color: .animPink)
                StepRow(number: 2, text: "Everything inside is rasterized into one texture, and the GPU compositing replaces per-view CPU blending.", color: .animPink)
                StepRow(number: 3, text: "Best for: particle systems, blurred overlays, many animated shapes with transparency.", color: .animPink)
                StepRow(number: 4, text: "Worst for: views that change layout frequently, as the rasterization cost outweighs the benefit.", color: .animPink)
            }

            CalloutBox(style: .warning, title: "When NOT to use it", contentBody: "drawingGroup forces rasterization at a fixed size. Anything that changes its layout bounds (expanding text, dynamic sizing) will look blurry or be clipped. Only use it for fixed-size animated content.")

            CalloutBox(style: .info, title: "Profile first", contentBody: "Use Instruments → Core Animation to check if you're actually dropping frames. drawingGroup adds memory pressure, so it's best to only apply it when you've confirmed a performance problem, not preemptively.")

            CodeBlock(code: """
// Wrap heavy animation in drawingGroup
ZStack {
    ForEach(particles) { particle in
        Circle()
            .fill(particle.color.opacity(0.6))
            .frame(width: 20)
            .offset(particle.position)
    }
}
.drawingGroup()  // flatten to Metal texture

// Check in Instruments:
// Core Animation → FPS drop → apply drawingGroup
// Core Animation → Memory spike → remove drawingGroup

// Identify render issues in Xcode:
// Debug > View Debugging > Rendering > Color Blended Layers
""")
        }
    }
}
