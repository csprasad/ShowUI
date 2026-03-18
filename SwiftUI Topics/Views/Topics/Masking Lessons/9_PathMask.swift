//
//
//  9_PathMask.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `19/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 9: Path Mask
struct PathMaskVisual: View {
    @State private var selectedPath = 0
    let pathNames = ["Arrow", "Star", "Wave", "Diamond"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Path mask", systemImage: "pencil.and.outline")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#993C1D"))

                // Live preview
                GeometryReader { geo in
                    ZStack {
                        Color(.secondarySystemBackground)
                        MaskBaseGradient()
                            .mask {
                                pathView(for: selectedPath, size: geo.size)
                                    .frame(width: geo.size.width, height: geo.size.height)
                            }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .frame(height: 150)
                .animation(.spring(response: 0.4), value: selectedPath)

                // Path selector
                HStack(spacing: 8) {
                    ForEach(pathNames.indices, id: \.self) { i in
                        Button(pathNames[i]) {
                            withAnimation(.spring(response: 0.3)) { selectedPath = i }
                        }
                        .font(.system(size: 12, weight: selectedPath == i ? .semibold : .regular))
                        .foregroundStyle(selectedPath == i ? Color(hex: "#993C1D") : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(selectedPath == i ? Color(hex: "#FAECE7") : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(selectedPath == i ? Color(hex: "#993C1D").opacity(0.3) : Color.clear, lineWidth: 1))
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
        }
    }

    @ViewBuilder
    func pathView(for index: Int, size: CGSize) -> some View {
        let w = size.width, h = size.height
        switch index {
        case 0: // Arrow
            Path { path in
                path.move(to: CGPoint(x: w*0.1, y: h*0.4))
                path.addLine(to: CGPoint(x: w*0.55, y: h*0.4))
                path.addLine(to: CGPoint(x: w*0.55, y: h*0.2))
                path.addLine(to: CGPoint(x: w*0.9, y: h*0.5))
                path.addLine(to: CGPoint(x: w*0.55, y: h*0.8))
                path.addLine(to: CGPoint(x: w*0.55, y: h*0.6))
                path.addLine(to: CGPoint(x: w*0.1, y: h*0.6))
                path.closeSubpath()
            }.fill(Color.white)

        case 1: // Star
            Path { path in
                let cx = w/2, cy = h/2
                let outer: CGFloat = min(w,h)*0.42
                let inner: CGFloat = outer * 0.4
                for i in 0..<10 {
                    let angle = CGFloat(i) * .pi / 5 - .pi/2
                    let r = i % 2 == 0 ? outer : inner
                    let x = cx + r * cos(angle)
                    let y = cy + r * sin(angle)
                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                    else { path.addLine(to: CGPoint(x: x, y: y)) }
                }
                path.closeSubpath()
            }.fill(Color.white)

        case 2: // Wave band
            Path { path in
                let step = w / 8
                path.move(to: CGPoint(x: 0, y: h*0.3))
                for i in 0...8 {
                    let x = CGFloat(i) * step
                    let y = h*0.3 + (i % 2 == 0 ? -h*0.12 : h*0.12)
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                path.addLine(to: CGPoint(x: w, y: h*0.7))
                for i in stride(from: 8, through: 0, by: -1) {
                    let x = CGFloat(i) * step
                    let y = h*0.7 + (i % 2 == 0 ? h*0.12 : -h*0.12)
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                path.closeSubpath()
            }.fill(Color.white)

        default: // Diamond
            Path { path in
                path.move(to: CGPoint(x: w/2, y: h*0.08))
                path.addLine(to: CGPoint(x: w*0.88, y: h/2))
                path.addLine(to: CGPoint(x: w/2, y: h*0.92))
                path.addLine(to: CGPoint(x: w*0.12, y: h/2))
                path.closeSubpath()
            }.fill(Color.white)
        }
    }
}

struct PathMaskExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Custom path masks")
            Text("When built-in shapes aren't enough, use a custom Path or a Shape conforming type as your mask. Paths give you pixel-precise control over the mask boundary, while Shapes let you use more complex shapes like arrows, stars, waves, any geometry.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Create a Path by plotting points with move(to:) and addLine(to:).", color: Color(hex: "#993C1D"))
                StepRow(number: 2, text: "Fill the path with Color.white, so the filled area becomes visible in the mask.", color: Color(hex: "#993C1D"))
                StepRow(number: 3, text: "For reusable shapes, conform a struct to Shape and implement path(in:).", color: Color(hex: "#993C1D"))
                StepRow(number: 4, text: "Use GeometryReader to make the path scale to any view size.", color: Color(hex: "#993C1D"))
            }

            CalloutBox(style: .info, title: "Shape protocol", contentBody: "Conforming to Shape is cleaner than using Path directly, because you get automatic animation support and can use the shape with both .clipShape() and .mask().")

            CodeBlock(code: """
// Custom Shape conformance
struct StarShape: Shape {
    let points: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cx = rect.midX, cy = rect.midY
        let outer = min(rect.width, rect.height) / 2
        let inner = outer * 0.4
        for i in 0..<(points * 2) {
            let angle = CGFloat(i) * .pi / CGFloat(points) - .pi / 2
            let r = i % 2 == 0 ? outer : inner
            let pt = CGPoint(x: cx + r * cos(angle), y: cy + r * sin(angle))
            i == 0 ? path.move(to: pt) : path.addLine(to: pt)
        }
        path.closeSubpath()
        return path
    }
}

// Use it as a mask
content
    .mask { StarShape(points: 5) }

// Or as a clip shape
content
    .clipShape(StarShape(points: 6))
""")
        }
    }
}
