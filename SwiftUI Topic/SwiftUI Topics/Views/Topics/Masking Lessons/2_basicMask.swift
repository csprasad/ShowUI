//
//
//  2_basicMask.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `19/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Basic Mask
struct BasicMaskVisual: View {
    @State private var selectedShape = 0
    let shapes = ["heart.fill", "star.fill", "moon.fill", "bolt.fill", "leaf.fill", "flame.fill"]
    let shapeNames = ["Heart", "Star", "Moon", "Bolt", "Leaf", "Flame"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Basic mask - .mask()", systemImage: "heart.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#993C1D"))

                // Live preview
                ZStack {
                    MaskBaseGradient()
                        .mask {
                            Image(systemName: shapes[selectedShape])
                                .font(.system(size: 120))
                        }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.35), value: selectedShape)

                // Shape selector
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 6)
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(shapes.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedShape = i }
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: shapes[i])
                                    .font(.system(size: 20))
                                    .foregroundStyle(selectedShape == i ? Color(hex: "#993C1D") : .secondary)
                                    .frame(width: 40, height: 40)
                                    .background(selectedShape == i ? Color(hex: "#FAECE7") : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text(shapeNames[i])
                                    .font(.system(size: 9))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
        }
    }
}

struct BasicMaskExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Using .mask()")
            Text("The .mask() modifier takes any SwiftUI view as its mask. The mask view's opacity determines what shows through a solid white shape reveals everything, a transparent area hides everything.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Apply .mask { } to the content you want to clip.", color: Color(hex: "#993C1D"))
                StepRow(number: 2, text: "Inside the mask, use any view, including SF Symbols, Text, Shape, Image.", color: Color(hex: "#993C1D"))
                StepRow(number: 3, text: "The mask is centered on the content by default.", color: Color(hex: "#993C1D"))
            }

            CalloutBox(style: .success, title: "Any view works as a mask", contentBody: "Text, SF Symbols, custom Shapes, Images, ZStacks, and anything you can draw in SwiftUI can be a mask.")

            CalloutBox(style: .warning, title: "Color doesn't matter, Opacity does", contentBody: "A red circle and a white circle produce identical masks. What matters is the alpha channel, not the color. Use black for hidden, white for visible.")

            CodeBlock(code: """
// SF Symbol as mask
MaskBaseGradient()
    .mask {
        Image(systemName: "heart.fill")
            .font(.system(size: 120))
    }

// Text as mask
Color.blue
    .mask {
        Text("Swift")
            .font(.system(size: 64, weight: .black))
    }
""")
        }
    }
}
