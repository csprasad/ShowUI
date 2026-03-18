//
//
//  3_ClipShapes.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `19/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Clip Shapes
struct ClipShapeVisual: View {
    @State private var selectedIndex = 0

    struct ClipOption {
        let name: String
        let code: String
        let shape: AnyShape
    }

    let options: [ClipOption] = [
        ClipOption(name: "Circle",    code: ".clipShape(Circle())",             shape: AnyShape(Circle())),
        ClipOption(name: "Capsule",   code: ".clipShape(Capsule())",         shape: AnyShape(Capsule())),
        ClipOption(name: "RoundedRect",code: ".clipShape(RoundedRectangle(cornerRadius: 24))", shape: AnyShape(RoundedRectangle(cornerRadius: 24))),
        ClipOption(name: "Ellipse",   code: ".clipShape(Ellipse())",         shape: AnyShape(Ellipse())),
        ClipOption(name: "Rectangle", code: ".clipShape(Rectangle())",       shape: AnyShape(Rectangle())),
        ClipOption(name: "ButtonBorder", code: ".clipShape(ContainerRelativeShape())", shape: AnyShape(ContainerRelativeShape())),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Clip shapes", systemImage: "circle.rectangle.filled.pattern.diagonalline")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#993C1D"))

                // Live preview
                MaskBaseGradient()
                    .frame(maxWidth: .infinity)
                    .frame(height: 140)
                    .clipShape(options[selectedIndex].shape)
                    .animation(.spring(response: 0.4), value: selectedIndex)

                // Code label
                Text(options[selectedIndex].code)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(Color(hex: "#993C1D"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(hex: "#FAECE7"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .animation(.easeInOut(duration: 0.15), value: selectedIndex)

                // Shape selector
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(options.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedIndex = i }
                        } label: {
                            Text(options[i].name)
                                .font(.system(size: 11, weight: selectedIndex == i ? .semibold : .regular))
                                .foregroundStyle(selectedIndex == i ? Color(hex: "#993C1D") : .secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(selectedIndex == i ? Color(hex: "#FAECE7") : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(selectedIndex == i ? Color(hex: "#993C1D").opacity(0.3) : Color.clear, lineWidth: 1))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
        }
    }
}

struct ClipShapeExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Clip shapes vs masking")
            Text(".clipShape() is SwiftUI's fast path for shape clipping. Unlike .mask(), it only accepts Shape types, but it's simpler, more performant, and handles hit testing correctly.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Built-in shapes: Circle, Capsule, Ellipse, Rectangle, RoundedRectangle.", color: Color(hex: "#993C1D"))
                StepRow(number: 2, text: "Also clips hit testing, so taps outside the shape don't register.", color: Color(hex: "#993C1D"))
                StepRow(number: 3, text: "For soft edges or gradient masks, use .mask() instead.", color: Color(hex: "#993C1D"))
            }

            CalloutBox(style: .info, title: "contentShape vs clipShape", contentBody: ".contentShape() defines the hit-test area without changing the visual clip. Use it when you want a larger tap target than the visible shape.")

            CalloutBox(style: .success, title: "Use clipShape for performance", contentBody: "clipShape is optimised by the render engine. For simple shapes it's always faster than an equivalent .mask().")

            CodeBlock(code: """
// Simple circle crop — common for avatars
Image("avatar")
    .resizable()
    .frame(width: 60, height: 60)
    .clipShape(Circle())

// Rounded card
VStack { ... }
    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

// Pill button shape
Button("Action") { }
    .clipShape(Capsule())
""")
        }
    }
}

