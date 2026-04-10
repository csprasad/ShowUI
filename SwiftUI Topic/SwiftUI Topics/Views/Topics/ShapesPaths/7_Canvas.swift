//
//
//  7_ Canvas.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Canvas
struct CanvasVisual: View {
    @State private var selectedDemo  = 0
    @State private var pointCount    = 60
    @State private var animating     = false
    @State private var phase: Double = 0
    let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()

    let demos = ["Scatter plot", "Waveform", "Particle grid"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Canvas", systemImage: "paintpalette.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.spBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedDemo = i; animating = false
                            }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.spBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.spBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Controls
                switch selectedDemo {
                case 0:
                    sliderRow("points", value: Binding(get: { CGFloat(pointCount) }, set: { pointCount = Int($0) }), range: 10...120, step: 5)
                case 1:
                    HStack(spacing: 8) {
                        sliderRow("points", value: Binding(get: { CGFloat(pointCount) }, set: { pointCount = Int($0) }), range: 20...200, step: 10)
                        animateButton
                    }
                default:
                    animateButton
                }

                // Canvas
                Canvas { ctx, size in
                    switch selectedDemo {
                    case 0: drawScatter(ctx: ctx, size: size)
                    case 1: drawWaveform(ctx: ctx, size: size)
                    default: drawParticleGrid(ctx: ctx, size: size)
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 160)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .onReceive(timer) { _ in if animating { phase += 0.06 } }
                .animation(.easeInOut(duration: 0.15), value: pointCount)
            }
        }
    }

    // MARK: Drawing functions

    func drawScatter(ctx: GraphicsContext, size: CGSize) {
        let seed: UInt64 = 42
        var rng = SeedableRNG(seed: seed)
        let colors: [Color] = [.spBlue, Color(hex: "#0891B2"), Color(hex: "#0E7490"), Color(hex: "#BAE6FD")]

        for i in 0..<pointCount {
            let x = CGFloat(rng.next()) * size.width
            let y = CGFloat(rng.next()) * size.height
            let r = CGFloat(rng.next()) * 8 + 3
            let colorIdx = i % colors.count
            var circle = Path()
            circle.addEllipse(in: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(circle, with: .color(colors[colorIdx].opacity(0.7)))
        }
    }

    func drawWaveform(ctx: GraphicsContext, size: CGSize) {
        let midY = size.height / 2
        var path = Path()
        path.move(to: CGPoint(x: 0, y: midY))

        for i in 0..<pointCount {
            let x = CGFloat(i) / CGFloat(pointCount - 1) * size.width
            let y = midY - sin((CGFloat(i) / CGFloat(pointCount)) * .pi * 4 + phase) * (size.height * 0.3)
            path.addLine(to: CGPoint(x: x, y: y))
        }

        ctx.stroke(path, with: .linearGradient(
            Gradient(colors: [Color.spBlue, Color(hex: "#0891B2"), Color(hex: "#BAE6FD")]),
            startPoint: .zero, endPoint: CGPoint(x: size.width, y: 0)
        ), lineWidth: 3)

        // Draw dots at peaks
        for i in stride(from: 0, to: pointCount, by: pointCount / 8) {
            let x  = CGFloat(i) / CGFloat(pointCount - 1) * size.width
            let y  = midY - sin((CGFloat(i) / CGFloat(pointCount)) * .pi * 4 + phase) * (size.height * 0.3)
            var dot = Path()
            dot.addEllipse(in: CGRect(x: x - 4, y: y - 4, width: 8, height: 8))
            ctx.fill(dot, with: .color(.spBlue))
        }
    }

    func drawParticleGrid(ctx: GraphicsContext, size: CGSize) {
        let cols = 12, rows = 8
        let cw = size.width / CGFloat(cols)
        let rh = size.height / CGFloat(rows)

        for row in 0..<rows {
            for col in 0..<cols {
                let cx     = CGFloat(col) * cw + cw / 2
                let cy     = CGFloat(row) * rh + rh / 2
                let dist   = hypot(cx - size.width / 2, cy - size.height / 2)
                let offset = sin(dist / 30 - phase) * 6
                let r      = 3 + abs(sin((dist / 40) + phase)) * 5
                let opacity = 0.4 + abs(sin((dist / 50) + phase)) * 0.6

                var dot = Path()
                dot.addEllipse(in: CGRect(x: cx - r + offset, y: cy - r, width: r * 2, height: r * 2))

                let t = (dist / (size.width * 0.7)).clamped(to: 0...1)
                let color = Color(hue: 0.55 + t * 0.1, saturation: 0.8, brightness: 0.9)
                ctx.fill(dot, with: .color(color.opacity(animating ? opacity : 0.6)))
            }
        }
    }

    var animateButton: some View {
        Button {
            withAnimation(.spring(response: 0.3)) { animating.toggle() }
        } label: {
            Text(animating ? "Pause" : "Animate")
                .font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(animating ? Color.animCoral : Color.spBlue)
                .clipShape(Capsule())
        }
        .buttonStyle(PressableButtonStyle())
    }

    func sliderRow(_ label: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>, step: CGFloat = 1) -> some View {
        HStack(spacing: 6) {
            Text(label).font(.system(size: 10)).foregroundStyle(.secondary).frame(width: 36)
            Slider(value: value, in: range, step: step).tint(.spBlue)
            Text("\(Int(value.wrappedValue))").font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.spBlue).frame(width: 28)
        }
    }
}

// Minimal seeded RNG for deterministic scatter
struct SeedableRNG {
    var state: UInt64
    init(seed: UInt64) { state = seed }
    mutating func next() -> Double {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return Double((state >> 33) & 0x7FFFFFFF) / Double(0x7FFFFFFF)
    }
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

struct CanvasExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Canvas - imperative drawing")
            Text("Canvas provides a high-performance 2D drawing surface using Swift's imperative drawing API. Unlike Shape (which produces a SwiftUI view), Canvas draws directly to a bitmap - ideal for particle systems, charts, and anything with hundreds of elements.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Canvas { ctx, size in } - the closure receives a GraphicsContext and CGSize every frame.", color: .spBlue)
                StepRow(number: 2, text: "ctx.fill(path, with: .color(.blue)) - fill a Path with a color or gradient.", color: .spBlue)
                StepRow(number: 3, text: "ctx.stroke(path, with:, lineWidth:) - stroke a path.", color: .spBlue)
                StepRow(number: 4, text: "ctx.draw(symbol, at:) - draw resolved SwiftUI symbols (Image, Text) at a point.", color: .spBlue)
                StepRow(number: 5, text: "Canvas redraws every time a dependency changes - use @State wisely to avoid unnecessary redraws.", color: .spBlue)
                StepRow(number: 6, text: "ctx.withCGContext { } - escape hatch to CGContext for CoreGraphics APIs.", color: .spBlue)
            }

            CalloutBox(style: .success, title: "Canvas vs Shape", contentBody: "Use Shape when you want a single reusable, animatable path that behaves like a SwiftUI view. Use Canvas for complex scenes - particles, charts, games - where drawing hundreds of elements per frame is needed.")

            CalloutBox(style: .info, title: "Drawing symbols in Canvas", contentBody: "Canvas can draw SwiftUI views as symbols: let image = ctx.resolve(Image(systemName: \"star.fill\")); ctx.draw(image, at: point). This lets you place SF Symbols, Text, or custom views precisely in the canvas.")

            CodeBlock(code: """
Canvas { context, size in
    // Fill circles
    for point in points {
        var circle = Path()
        circle.addEllipse(in: CGRect(
            x: point.x - 5, y: point.y - 5,
            width: 10, height: 10
        ))
        context.fill(circle, with: .color(.blue))
    }

    // Stroke a path
    context.stroke(linePath,
                   with: .color(.red),
                   lineWidth: 2)

    // Gradient stroke
    context.stroke(wavePath, with: .linearGradient(
        Gradient(colors: [.blue, .cyan]),
        startPoint: .zero,
        endPoint: CGPoint(x: size.width, y: 0)
    ), lineWidth: 3)

    // Draw SF Symbol
    let sym = context.resolve(Image(systemName: "star.fill"))
    context.draw(sym, at: CGPoint(x: 100, y: 100))
}
.frame(width: 300, height: 200)
""")
        }
    }
}
