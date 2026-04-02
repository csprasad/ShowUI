//
//
//  5_invertedMask.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `19/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Inverted Mask
struct InvertedMaskVisual: View {
    @State private var selectedShape = 0
    @State private var showCompositing = true

    let shapes = ["heart.fill", "star.fill", "bolt.fill", "circle.fill"]
    let shapeNames = ["Heart", "Star", "Bolt", "Circle"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Inverted mask (.destinationOut)", systemImage: "minus.circle")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#993C1D"))
                    Spacer()
                }

                // Side by side: normal vs inverted
                HStack(spacing: 10) {
                    // Normal mask
                    VStack(spacing: 6) {
                        ZStack {
                            Color(.secondarySystemBackground)
                            MaskBaseGradient()
                                .mask {
                                    Image(systemName: shapes[selectedShape])
                                        .font(.system(size: 70))
                                }
                        }
                        .frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        Text("Normal mask")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)

                    // Inverted mask
                    VStack(spacing: 6) {
                        ZStack {
                            Color(.secondarySystemBackground)
                            ZStack {
                                MaskBaseGradient()
                                Image(systemName: shapes[selectedShape])
                                    .font(.system(size: 70))
                                    .blendMode(.destinationOut)
                            }
                            .compositingGroup()
                        }
                        .frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        Text(".destinationOut")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .animation(.spring(response: 0.35), value: selectedShape)

                // Shape selector
                HStack(spacing: 8) {
                    ForEach(shapes.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedShape = i }
                        } label: {
                            Image(systemName: shapes[i])
                                .font(.system(size: 18))
                                .foregroundStyle(selectedShape == i ? Color(hex: "#993C1D") : .secondary)
                                .frame(width: 44, height: 44)
                                .background(selectedShape == i ? Color(hex: "#FAECE7") : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                    Spacer()
                }
            }
        }
    }
}

struct InvertedMaskExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Cutting shapes out of content")
            Text("The .destinationOut blend mode erases the destination layer wherever the source layer has pixels. Combined with .compositingGroup(), this punches a hole in your content in the exact shape of the overlay view.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Wrap both layers in a ZStack.", color: Color(hex: "#993C1D"))
                StepRow(number: 2, text: "Apply .blendMode(.destinationOut) to the cutout shape.", color: Color(hex: "#993C1D"))
                StepRow(number: 3, text: "Apply .compositingGroup() to the ZStack, which is critical, without it the blend has no effect.", color: Color(hex: "#993C1D"))
            }

            CalloutBox(style: .danger, title: ".compositingGroup() is required", contentBody: "Without .compositingGroup(), the blend mode operates against the screen background instead of the layer below. Always add it to the parent ZStack.")

            CalloutBox(style: .info, title: "Common use", contentBody: "Notification badges that cut into an avatar, icon overlays with a hole, text cutouts on solid backgrounds.")

            CodeBlock(code: """
ZStack {
    // Content layer
    MaskBaseGradient()

    // Cutout shape - erases content beneath
    Image(systemName: "heart.fill")
        .font(.system(size: 80))
        .blendMode(.destinationOut)
}
.compositingGroup()  // required
""")
        }
    }
}
