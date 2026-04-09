//
//
//  6_Trim&Draw-on.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Trim & Draw-on
struct TrimVisual: View {
    @State private var progress: CGFloat  = 0.7
    @State private var startAngle: Double = -90
    @State private var isAnimating        = false
    @State private var selectedDemo       = 0
    @State private var drawProgress: CGFloat = 0

    let demos = ["Progress ring", "Draw-on path", "Dashboard"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Trim & draw-on effect", systemImage: "circle.dotted")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.spBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedDemo = i
                                drawProgress = 0
                                isAnimating  = false
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

                switch selectedDemo {
                case 0:
                    // Progress ring
                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Text("progress").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 60)
                            Slider(value: $progress, in: 0...1).tint(.spBlue)
                            Text("\(Int(progress * 100))%").font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.spBlue).frame(width: 36)
                        }
                        ZStack {
                            // Track
                            Circle()
                                .stroke(Color.spBlue.opacity(0.15), lineWidth: 12)
                                .frame(width: 120, height: 120)
                            // Progress
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(Color.spBlue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(-90))
                                .animation(.spring(response: 0.4), value: progress)
                            // Label
                            VStack(spacing: 2) {
                                Text("\(Int(progress * 100))")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.spBlue)
                                    .contentTransition(.numericText())
                                    .animation(.spring(duration: 0.3), value: Int(progress * 100))
                                Text("%").font(.system(size: 12)).foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }

                case 1:
                    // Draw-on animation
                    VStack(spacing: 12) {
                        ZStack {
                            Color(.secondarySystemBackground)
                            PolygonPath(sides: 6)
                                .trim(from: 0, to: drawProgress)
                                .stroke(Color.spBlue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .frame(width: 110, height: 110)
                                .rotationEffect(.degrees(-90))
                        }
                        .frame(maxWidth: .infinity).frame(height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                        Button {
                            var transaction = Transaction()
                            transaction.disablesAnimations = true
                            withTransaction(transaction) {
                                drawProgress = 0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                withAnimation(.easeInOut(duration: 1.5)) {
                                    drawProgress = 1
                                }
                            }
                        } label: {
                            Text("Animate draw-on")
                                .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 10)
                                .background(Color.spBlue).clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }

                default:
                    // Dashboard with multiple rings
                    VStack(spacing: 24) {
                        ZStack {
                            let rings = [
                                (color: Color.spBlue, r: 90.0),
                                (color: Color(hex: "#0891B2"), r: 70.0),
                                (color: Color(hex: "#0E7490"), r: 50.0)
                            ]
                            
                            ForEach(0..<rings.count, id: \.self) { i in
                                let ring = rings[i]
                                
                                ZStack {
                                    Circle()
                                        .stroke(ring.color.opacity(0.15), lineWidth: 10)
                                    Circle()
                                        .trim(from: 0, to: progress)
                                        .stroke(ring.color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                        .rotationEffect(.degrees(-90))
                                }
                                .frame(width: ring.r * 2, height: ring.r * 2)
                                .animation(.spring(response: 0.5).delay(Double(i) * 0.1), value: progress)
                            }
                        }
                        .frame(height: 200)

                        // Slider
                        HStack {
                            Text("fill:").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 24)
                            Slider(value: $progress).tint(.spBlue)
                            Text("\(Int(progress * 100))%").font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.spBlue)
                        }
                    }
                }
            }
        }
    }
}

struct TrimExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: ".trim - partial shape rendering")
            Text(".trim(from:to:) draws only a portion of a shape's path. The from and to values are 0 to 1, representing the fraction along the path. Combined with animation, it creates draw-on effects and progress indicators.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".trim(from: 0, to: progress) - draw from 0% to progress%. Progress ring: trim a stroked Circle.", color: .spBlue)
                StepRow(number: 2, text: ".rotationEffect(.degrees(-90)) - rotate so the arc starts at 12 o'clock instead of 3 o'clock.", color: .spBlue)
                StepRow(number: 3, text: "StrokeStyle(lineCap: .round) - rounded ends on the progress arc for a polished look.", color: .spBlue)
                StepRow(number: 4, text: "Draw-on: start drawProgress at 0, animate to 1. Any path can have the draw-on effect.", color: .spBlue)
                StepRow(number: 5, text: ".trim on any Shape: Circle, Rectangle, custom Path - anything with a path.", color: .spBlue)
            }

            CalloutBox(style: .success, title: "The progress ring pattern", contentBody: "Circle() track + Circle().trim(from:0, to:progress) foreground + .rotationEffect(-.degrees(90)) is the standard iOS progress ring. Use .stroke with .lineCap: .round for the polished Apple Watch look.")

            CodeBlock(code: """
// Progress ring
ZStack {
    // Track
    Circle()
        .stroke(.gray.opacity(0.2), lineWidth: 12)

    // Progress
    Circle()
        .trim(from: 0, to: progress)   // 0...1
        .stroke(.blue, style: StrokeStyle(
            lineWidth: 12,
            lineCap: .round   // rounded ends
        ))
        .rotationEffect(.degrees(-90))  // start at top
        .animation(.spring(), value: progress)
}
.frame(width: 120, height: 120)

// Draw-on any path
MyPath()
    .trim(from: 0, to: drawProgress)
    .stroke(.blue, lineWidth: 2)
    .onAppear {
        withAnimation(.easeInOut(duration: 2)) {
            drawProgress = 1
        }
    }
""")
        }
    }
}

