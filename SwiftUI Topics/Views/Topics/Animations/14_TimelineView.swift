//
//
//  14_TimelineView.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 14: TimelineView
struct TimelineViewVisual: View {
    @State private var isRunning = false
    @State private var selectedDemo = 0
    let demos = ["Clock", "Particles", "Wave"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("TimelineView", systemImage: "clock.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.animPurple)
                    Spacer()
                    Button(isRunning ? "Pause" : "Play") {
                        isRunning.toggle()
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.animPurple)
                    .padding(.horizontal, 14).padding(.vertical, 6)
                    .background(Color(hex: "#EEEDFE"))
                    .clipShape(Capsule())
                    .buttonStyle(PressableButtonStyle())
                }

                // Demo selector
                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button(demos[i]) {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        }
                        .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                        .foregroundStyle(selectedDemo == i ? Color.animPurple : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(selectedDemo == i ? Color(hex: "#EEEDFE") : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Demo area
                ZStack {
                    Color(.secondarySystemBackground)
                    if isRunning {
                        switch selectedDemo {
                        case 0: clockDemo
                        case 1: particleDemo
                        default: waveDemo
                        }
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.secondary)
                            Text("Tap Play to start")
                                .font(.system(size: 13))
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.easeInOut(duration: 0.3), value: isRunning)
            }
        }
    }

    // MARK: - Clock demo
    var clockDemo: some View {
        TimelineView(.animation(paused: !isRunning)) { context in
            let date = context.date
            let calendar = Calendar.current
            let seconds = CGFloat(calendar.component(.second, from: date))
            let minutes = CGFloat(calendar.component(.minute, from: date))
            let hours   = CGFloat(calendar.component(.hour, from: date) % 12)
            let secondAngle = seconds / 60 * 360
            let minuteAngle = (minutes + seconds / 60) / 60 * 360
            let hourAngle   = (hours + minutes / 60) / 12 * 360

            ZStack {
                Circle().stroke(Color(.systemFill), lineWidth: 2).frame(width: 100, height: 100)
                // Hour hand
                Capsule().fill(Color.animPurple).frame(width: 4, height: 28)
                    .offset(y: -14).rotationEffect(.degrees(hourAngle))
                // Minute hand
                Capsule().fill(Color.animPurple.opacity(0.7)).frame(width: 2.5, height: 38)
                    .offset(y: -19).rotationEffect(.degrees(minuteAngle))
                // Second hand
                Capsule().fill(Color.animCoral).frame(width: 1.5, height: 44)
                    .offset(y: -22).rotationEffect(.degrees(secondAngle))
                Circle().fill(Color.animPurple).frame(width: 6, height: 6)
            }
        }
    }

    // MARK: - Particle demo
    var particleDemo: some View {
        TimelineView(.animation(minimumInterval: 1/30, paused: !isRunning)) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            Canvas { ctx, size in
                for i in 0..<20 {
                    let seed = Double(i) * 137.508
                    let x = (sin(seed + t * 0.7) * 0.5 + 0.5) * size.width
                    let y = (cos(seed * 1.3 + t * 0.5) * 0.5 + 0.5) * size.height
                    let radius = CGFloat(4 + sin(seed * 2.1 + t) * 3)
                    let opacity = 0.4 + sin(seed * 1.7 + t * 1.3) * 0.3
                    let hue = (seed / 360 + t * 0.05).truncatingRemainder(dividingBy: 1)
                    ctx.fill(
                        Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius*2, height: radius*2)),
                        with: .color(Color(hue: hue, saturation: 0.8, brightness: 0.9).opacity(opacity))
                    )
                }
            }
        }
    }

    // MARK: - Wave demo
    var waveDemo: some View {
        TimelineView(.animation(minimumInterval: 1/60, paused: !isRunning)) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            Canvas { ctx, size in
                let w = size.width, h = size.height
                for waveIndex in 0..<3 {
                    let offset = Double(waveIndex) * .pi * 0.6
                    let colors: [Color] = [Color.animPurple, Color.animTeal, Color.animCoral]
                    var path = Path()
                    path.move(to: CGPoint(x: 0, y: h/2))
                    for x in stride(from: 0, through: w, by: 2) {
                        let y = h/2 + sin(Double(x) / 40 + t * 2 + offset) * 25
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    ctx.stroke(path, with: .color(colors[waveIndex].opacity(0.7)),
                               style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                }
            }
        }
    }
}

struct TimelineViewExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "TimelineView")
            Text("TimelineView drives its content from a clock not from state changes. It redraws on a schedule, making it perfect for real-time animations, clocks, particle systems, and anything that needs to animate continuously without user interaction.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".animation — updates as fast as the display allows (60/120fps). Use for smooth animations.", color: .animPurple)
                StepRow(number: 2, text: ".animation(minimumInterval:) — cap the update rate. 1/30 saves battery for less critical animation.", color: .animPurple)
                StepRow(number: 3, text: ".periodic(from:by:) — fire at fixed intervals. Good for clocks, timers.", color: .animPurple)
                StepRow(number: 4, text: "context.date — the current time. Use it to drive all animation values for frame-perfect sync.", color: .animPurple)
                StepRow(number: 5, text: "Pair with Canvas for high-performance drawing — no view recycling overhead.", color: .animPurple)
            }

            CalloutBox(style: .warning, title: "paused parameter", contentBody: "Always use paused: !isRunning to stop the timeline when not needed. A running TimelineView with .animation schedule consumes CPU/GPU every frame even when off-screen.")

            CalloutBox(style: .info, title: "timeIntervalSinceReferenceDate", contentBody: "Use Date().timeIntervalSinceReferenceDate as your t value. Feed it into sin() and cos() to get smooth oscillating values, which is the foundation of most continuous animations.")

            CodeBlock(code: """
// 60fps animation timeline
TimelineView(.animation) { context in
    let t = context.date.timeIntervalSinceReferenceDate
    Circle()
        .offset(x: sin(t * 2) * 50, y: cos(t * 1.5) * 30)
}

// With Canvas for performance
TimelineView(.animation(minimumInterval: 1/60)) { context in
    let t = context.date.timeIntervalSinceReferenceDate
    Canvas { ctx, size in
        // Draw particles, waves, etc using t
    }
}

// Periodic — fires every second
TimelineView(.periodic(from: .now, by: 1.0)) { context in
    Text(context.date, style: .time)
}
""")
        }
    }
}
