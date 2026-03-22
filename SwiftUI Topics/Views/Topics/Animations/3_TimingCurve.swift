//
//
//  3_TimingCurve.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Timing Curves
struct TimingCurveVisual: View {
    @State private var isOn = false
    @State private var selected = 0

    struct CurveOption {
        let name: String
        let code: String
        let anim: Animation
        let description: String
        let curvePoints: (CGPoint, CGPoint) // bezier control points
    }

    let options: [CurveOption] = [
        CurveOption(name: "linear",     code: ".linear",              anim: .linear(duration: 1.0),            description: "Constant speed throughout",       curvePoints: (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))),
        CurveOption(name: "easeIn",     code: ".easeIn",              anim: .easeIn(duration: 1.0),             description: "Starts slow, ends fast",          curvePoints: (CGPoint(x: 0.42, y: 0), CGPoint(x: 1.0, y: 1.0))),
        CurveOption(name: "easeOut",    code: ".easeOut",             anim: .easeOut(duration: 1.0),            description: "Starts fast, decelerates to stop", curvePoints: (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.58, y: 1.0))),
        CurveOption(name: "easeInOut",  code: ".easeInOut",           anim: .easeInOut(duration: 1.0),          description: "Slow start and end, fast middle",  curvePoints: (CGPoint(x: 0.42, y: 0), CGPoint(x: 0.58, y: 1.0))),
        CurveOption(name: "custom",     code: ".timingCurve(0.2,0.8,0.9,0.1)", anim: .timingCurve(0.2, 0.8, 0.9, 0.1, duration: 1.0), description: "Custom bezier — dramatic snap", curvePoints: (CGPoint(x: 0.2, y: 0.8), CGPoint(x: 0.9, y: 0.1))),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {
                Label("Timing curves", systemImage: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.animAmber)

                HStack(spacing: 12) {
                    // Curve diagram
                    curveDiagram(for: options[selected])
                        .frame(width: 90, height: 90)

                    VStack(alignment: .leading, spacing: 6) {
                        // Moving dot
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color(.systemFill))
                                .frame(height: 6)
                            Circle()
                                .fill(Color.animAmber)
                                .frame(width: 22, height: 22)
                                .offset(x: isOn ? 160 : 0)
                                .animation(options[selected].anim, value: isOn)
                                .shadow(color: Color.animAmber.opacity(0.4), radius: 4)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)

                        Text(options[selected].description)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)

                        Text(options[selected].code)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(Color.animAmber)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "#FAEEDA"))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }

                Button(isOn ? "Reset" : "Play") {
                    if isOn {
                        isOn = false
                    } else {
                        withAnimation(options[selected].anim) { isOn = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                            withAnimation { isOn = false }
                        }
                    }
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.animAmber)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .buttonStyle(PressableButtonStyle())

                // Curve selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(options.indices, id: \.self) { i in
                            Button(options[i].name) {
                                withAnimation(.spring(response: 0.3)) {
                                    selected = i
                                    isOn = false
                                }
                            }
                            .font(.system(size: 11, weight: selected == i ? .semibold : .regular, design: .monospaced))
                            .foregroundStyle(selected == i ? Color.animAmber : .secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(selected == i ? Color(hex: "#FAEEDA") : Color(.systemFill))
                            .clipShape(Capsule())
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }
            }
        }
    }

    func curveDiagram(for option: CurveOption) -> some View {
        Canvas { ctx, size in
            let w = size.width, h = size.height
            let pad: CGFloat = 8

            // Grid
            ctx.stroke(Path(CGRect(x: pad, y: pad, width: w - pad*2, height: h - pad*2)),
                       with: .color(Color(.systemFill)), lineWidth: 1)

            // Diagonal guide
            var guide = Path()
            guide.move(to: CGPoint(x: pad, y: h - pad))
            guide.addLine(to: CGPoint(x: w - pad, y: pad))
            ctx.stroke(guide, with: .color(Color(.systemGray5)), style: StrokeStyle(lineWidth: 0.5, dash: [3,3]))

            // Bezier curve
            let p0 = CGPoint(x: pad, y: h - pad)
            let p3 = CGPoint(x: w - pad, y: pad)
            let cp1 = CGPoint(
                x: pad + option.curvePoints.0.x * (w - pad*2),
                y: h - pad - option.curvePoints.0.y * (h - pad*2)
            )
            let cp2 = CGPoint(
                x: pad + option.curvePoints.1.x * (w - pad*2),
                y: h - pad - option.curvePoints.1.y * (h - pad*2)
            )

            var curve = Path()
            curve.move(to: p0)
            curve.addCurve(to: p3, control1: cp1, control2: cp2)
            ctx.stroke(curve, with: .color(Color.animAmber), style: StrokeStyle(lineWidth: 2, lineCap: .round))

            // Control points
            ctx.fill(Path(ellipseIn: CGRect(x: cp1.x-3, y: cp1.y-3, width: 6, height: 6)), with: .color(Color.animAmber.opacity(0.5)))
            ctx.fill(Path(ellipseIn: CGRect(x: cp2.x-3, y: cp2.y-3, width: 6, height: 6)), with: .color(Color.animAmber.opacity(0.5)))
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct TimingCurveExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Timing curves")
            Text("A timing curve is a bezier function that maps elapsed time (x-axis) to animation progress (y-axis). A straight diagonal line is linear. Curves above the line move faster early, curves below move faster late.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".linear — constant speed. Use for looping animations like spinners.", color: .animAmber)
                StepRow(number: 2, text: ".easeIn — accelerates. Use for things leaving the screen.", color: .animAmber)
                StepRow(number: 3, text: ".easeOut — decelerates. Use for things arriving on screen.", color: .animAmber)
                StepRow(number: 4, text: ".easeInOut — slow start and end. The default — feels most natural.", color: .animAmber)
                StepRow(number: 5, text: ".timingCurve(x1,y1,x2,y2) — full bezier control. Match any custom curve.", color: .animAmber)
            }

            CalloutBox(style: .info, title: "Rule of thumb", contentBody: "easeOut for things entering, easeIn for things leaving, easeInOut for things changing in place. Spring covers most other cases.")

            CodeBlock(code: """
.linear(duration: 0.4)
.easeIn(duration: 0.3)
.easeOut(duration: 0.4)
.easeInOut(duration: 0.5)

// Custom bezier — matches CSS cubic-bezier()
.timingCurve(0.2, 0.8, 0.9, 0.1, duration: 0.6)
""")
        }
    }
}
