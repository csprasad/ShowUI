//
//
//  3_CustomPath.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Custom Path
struct CustomPathVisual: View {
    @State private var selectedDemo = 0
    @State private var sides: Int   = 5
    @State private var innerRatio: CGFloat = 0.4
    @State private var waveFreq: CGFloat   = 3
    @State private var waveAmp: CGFloat    = 20

    let demos = ["Polygon", "Star", "Wave"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Custom Path", systemImage: "scribble.variable")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.spBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 12, weight: selectedDemo == i ? .semibold : .regular))
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
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Text("sides:").font(.system(size: 12)).foregroundStyle(.secondary)
                            ForEach([3, 4, 5, 6, 7, 8], id: \.self) { n in
                                Button("\(n)") {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { sides = n }
                                }
                                .font(.system(size: 12, weight: sides == n ? .semibold : .regular))
                                .foregroundStyle(sides == n ? .white : .secondary)
                                .frame(width: 30, height: 30)
                                .background(sides == n ? Color.spBlue : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                        ZStack {
                            Color(.secondarySystemBackground)
                            PolygonPath(sides: sides)
                                .fill(LinearGradient(colors: [Color.spBlue, Color(hex: "#0891B2")],
                                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 120, height: 120)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: sides)
                        }
                        .frame(maxWidth: .infinity).frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                case 1:
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            sliderRow("points", value: Binding(get: { CGFloat(sides) }, set: { sides = Int($0) }), range: 4...12, step: 1)
                            sliderRow("inner r", value: $innerRatio, range: 0.2...0.7, step: 0.05, format: "%.2f")
                        }
                        ZStack {
                            Color(.secondarySystemBackground)
                            StarPath(points: sides, innerRatio: innerRatio)
                                .fill(LinearGradient(colors: [Color(hex: "#FBBF24"), Color(hex: "#F59E0B")],
                                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 120, height: 120)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: sides)
                                .animation(.easeInOut(duration: 0.15), value: innerRatio)
                        }
                        .frame(maxWidth: .infinity).frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                default:
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            sliderRow("freq", value: $waveFreq, range: 1...8, step: 0.5)
                            sliderRow("amp",  value: $waveAmp,  range: 5...40, step: 1)
                        }
                        ZStack {
                            Color(.secondarySystemBackground)
                            WavePath(frequency: waveFreq, amplitude: waveAmp)
                                .fill(LinearGradient(colors: [Color.spBlue.opacity(0.3), Color.spBlue],
                                                     startPoint: .top, endPoint: .bottom))
                                .frame(maxWidth: .infinity).frame(height: 150)
                        }
                        .frame(maxWidth: .infinity).frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .animation(.easeInOut(duration: 0.1), value: waveFreq)
                        .animation(.easeInOut(duration: 0.1), value: waveAmp)
                    }
                }

                // Code preview
                codePreview
            }
        }
    }

    @ViewBuilder
    var codePreview: some View {
        let snippets = [
            "Path { path in\n  path.move(to: firstPoint)\n  for point in points { path.addLine(to: point) }\n  path.closeSubpath()\n}",
            "// Outer + inner radius points\nPath { path in\n  for i in 0..<(sides*2) {\n    let r = i.isMultiple(of:2) ? outer : inner\n    ...\n  }\n}",
            "Path { path in\n  path.move(to: CGPoint(x:0, y:mid))\n  for x in stride(from:0, to:w, by:2) {\n    let y = mid + sin(x/w * freq * .pi*2) * amp\n    path.addLine(to: CGPoint(x:x, y:y))\n  }\n}",
        ]
        Text(snippets[selectedDemo])
            .font(.system(size: 9, design: .monospaced))
            .foregroundStyle(Color.spBlue)
            .padding(8).background(Color.spBlueLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func sliderRow(_ label: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>, step: CGFloat = 1, format: String = "%.0f") -> some View {
        HStack(spacing: 6) {
            Text(label).font(.system(size: 10)).foregroundStyle(.secondary).frame(width: 36)
            Slider(value: value, in: range, step: step).tint(.spBlue)
            Text(String(format: format, value.wrappedValue)).font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.spBlue).frame(width: 28)
        }
    }
}

// MARK: Path shapes

struct PolygonPath: Shape {
    var sides: Int
    var animatableData: Double {
        get { Double(sides) }
        set { sides = Int(newValue) }
    }
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) / 2 * 0.9
        var path = Path()
        for i in 0..<sides {
            let angle = (Double(i) / Double(sides)) * 2 * .pi - .pi / 2
            let x = center.x + r * cos(angle)
            let y = center.y + r * sin(angle)
            let pt = CGPoint(x: x, y: y)
            if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
        }
        path.closeSubpath()
        return path
    }
}

struct StarPath: Shape {
    var points: Int
    var innerRatio: CGFloat
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerR = min(rect.width, rect.height) / 2 * 0.9
        let innerR = outerR * innerRatio
        let total  = points * 2
        var path   = Path()
        for i in 0..<total {
            let angle  = (Double(i) / Double(total)) * 2 * .pi - .pi / 2
            let r = i.isMultiple(of: 2) ? outerR : innerR
            let x = center.x + r * cos(angle)
            let y = center.y + r * sin(angle)
            let pt = CGPoint(x: x, y: y)
            if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
        }
        path.closeSubpath()
        return path
    }
}

struct WavePath: Shape {
    var frequency: CGFloat
    var amplitude: CGFloat
    func path(in rect: CGRect) -> Path {
        let mid  = rect.midY
        var path = Path()
        path.move(to: CGPoint(x: 0, y: mid))
        stride(from: 0, through: rect.width, by: 2).forEach { x in
            let y = mid - sin((x / rect.width) * frequency * .pi * 2) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

struct CustomPathExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Custom Path")
            Text("Path gives you direct control over drawing - draw lines, curves, arcs, and subpaths using familiar CGPoint coordinates. A Path is a sequence of drawing commands that SwiftUI converts into a rendered shape.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "path.move(to:) - lift the pen and move to a point without drawing.", color: .spBlue)
                StepRow(number: 2, text: "path.addLine(to:) - draw a straight line from the current point.", color: .spBlue)
                StepRow(number: 3, text: "path.addCurve(to:control1:control2:) - cubic Bézier curve.", color: .spBlue)
                StepRow(number: 4, text: "path.addArc(center:radius:startAngle:endAngle:clockwise:) - arc segment.", color: .spBlue)
                StepRow(number: 5, text: "path.closeSubpath() - draws a line back to the start of the current subpath.", color: .spBlue)
                StepRow(number: 6, text: "Path { p in } initializer - build path with builder closure for clean syntax.", color: .spBlue)
            }

            CalloutBox(style: .info, title: "CGRect coordinates", contentBody: "Path commands use CGPoint in the shape's coordinate space. The rect parameter in path(in rect:) gives you the bounds - use rect.width, rect.midX etc. to draw shapes that scale with any frame size.")

            CodeBlock(code: """
// Simple triangle
Path { path in
    path.move(to: CGPoint(x: rect.midX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.closeSubpath()
}

// Bézier curve
Path { path in
    path.move(to: startPoint)
    path.addCurve(
        to: endPoint,
        control1: CGPoint(x: midX, y: minY),
        control2: CGPoint(x: midX, y: maxY)
    )
}

// Arc (for progress rings)
Path { path in
    path.addArc(
        center: CGPoint(x: midX, y: midY),
        radius: 50,
        startAngle: .degrees(-90),
        endAngle: .degrees(270 * progress - 90),
        clockwise: false
    )
}
""")
        }
    }
}
