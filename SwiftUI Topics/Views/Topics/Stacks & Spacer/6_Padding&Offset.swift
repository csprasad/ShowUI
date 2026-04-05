//
//
//  6_Padding&Offset.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `05/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Padding & Offset
struct PaddingOffsetVisual: View {
    @State private var paddingAmount: CGFloat = 16
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    @State private var selectedDemo = 0

    let demos = ["Padding", "Offset", "Difference"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Padding & offset", systemImage: "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.ssPurple)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 12, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.ssPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.ssPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                ZStack {
                    Color(.secondarySystemBackground)
                    demoDiagram.padding(8)
                }
                .frame(maxWidth: .infinity).frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedDemo)
                .animation(.easeInOut(duration: 0.1), value: paddingAmount)
                .animation(.spring(response: 0.3), value: offsetX)
                .animation(.spring(response: 0.3), value: offsetY)

                // Controls
                switch selectedDemo {
                case 0:
                    HStack(spacing: 10) {
                        Text("padding").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 50)
                        Slider(value: $paddingAmount, in: 0...32, step: 2).tint(.ssPurple)
                        Text("\(Int(paddingAmount))pt").font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 32)
                    }
                case 1:
                    VStack(spacing: 6) {
                        HStack(spacing: 10) {
                            Text("X").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 12)
                            Slider(value: $offsetX, in: -40...40, step: 4).tint(.ssPurple)
                            Text("\(Int(offsetX))pt").font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 40)
                        }
                        HStack(spacing: 10) {
                            Text("Y").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 12)
                            Slider(value: $offsetY, in: -40...40, step: 4).tint(.ssPurple)
                            Text("\(Int(offsetY))pt").font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 40)
                        }
                    }
                default: EmptyView()
                }
            }
        }
    }

    @ViewBuilder
    private var demoDiagram: some View {
        switch selectedDemo {
        case 0:
            // Padding - affects layout space
            ZStack(alignment: .topLeading) {
                // Original position indicator
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.ssPurple.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [3]))
                    .frame(width: 80 + paddingAmount * 2, height: 36 + paddingAmount * 2)
                    .frame(maxWidth: .infinity)

                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.ssPurple)
                    .frame(width: 80, height: 36)
                    .padding(paddingAmount)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Text(".padding(\(Int(paddingAmount)))")
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundStyle(.white)
                    )
            }

        case 1:
            // Offset - doesn't affect layout
            VStack(spacing: 4) {
                ZStack {
                    // Ghost showing original layout space
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.ssPurple.opacity(0.25), style: StrokeStyle(lineWidth: 1, dash: [3]))
                        .frame(width: 100, height: 40)
                    // Moved view
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.ssPurple)
                        .frame(width: 100, height: 40)
                        .overlay(Text("Offset view").font(.system(size: 10)).foregroundStyle(.white))
                        .offset(x: offsetX, y: offsetY)
                }
                Text("Dashed = original layout space (unchanged)")
                    .font(.system(size: 8)).foregroundStyle(.secondary)
            }

        default:
            // Difference
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("padding").font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.ssPurple)
                    VStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 12)
                        RoundedRectangle(cornerRadius: 4).fill(Color.ssPurple).frame(height: 20).padding(.horizontal, 8)
                        RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 12)
                    }
                    .frame(width: 100)
                    Text("Takes up MORE\nlayout space").font(.system(size: 8)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                }
                VStack(spacing: 4) {
                    Text("offset").font(.system(size: 10, weight: .semibold)).foregroundStyle(Color(hex: "#9B67F5"))
                    ZStack {
                        VStack(spacing: 2) {
                            RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 12)
                            RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "#9B67F5").opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [2])).frame(height: 20)
                            RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 12)
                        }
                        .frame(width: 100)
                        RoundedRectangle(cornerRadius: 4).fill(Color(hex: "#9B67F5")).frame(width: 84, height: 20).offset(x: 10, y: -8)
                    }
                    Text("Layout space\nUNCHANGED").font(.system(size: 8)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                }
            }
        }
    }
}

struct PaddingOffsetExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Padding vs offset")
            Text("Padding and offset both move content visually, but they work completely differently. Padding adds space and affects layout - other views move to accommodate it. Offset moves the rendered view without changing its layout footprint.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".padding(16) adds 16pt of space on all sides. The view takes up 32pt more space than without padding.", color: .ssPurple)
                StepRow(number: 2, text: ".padding(.horizontal, 16) - specific sides. Also: .top, .bottom, .leading, .trailing, .vertical.", color: .ssPurple)
                StepRow(number: 3, text: ".offset(x: 10, y: -5) moves the rendered view without changing the layout space it occupies.", color: .ssPurple)
                StepRow(number: 4, text: "Offset is ideal for animation - animate offset to slide a view in/out without disturbing surrounding layout.", color: .ssPurple)
            }

            CalloutBox(style: .warning, title: "offset doesn't change tap area", contentBody: "When you offset a view 20pt to the right, its tap area stays at the original position. If you need the tap area to move too, use .padding or change the actual position in a stack instead.")

            CalloutBox(style: .info, title: "Padding order matters", contentBody: ".background() then .padding() - padding is outside the background. .padding() then .background() - background extends into the padding area. The order changes the visual result.")

            CodeBlock(code: """
// Padding - affects layout space
Text("Hello")
    .padding(16)          // 16pt all sides
    .padding(.horizontal, 20)  // only left/right
    .padding(.top, 8)     // only top

// Background inside padding
Text("Card")
    .padding(16)
    .background(.blue)    // background includes padding area

// Background outside padding
Text("Card")
    .background(.blue)    // background is tight
    .padding(16)          // space outside background

// Offset - doesn't affect layout
Image(systemName: "star")
    .offset(x: 4, y: -2)   // nudge position only

// Animate with offset - other views unaffected
Image(systemName: "arrow.right")
    .offset(x: isExpanded ? 8 : 0)
    .animation(.spring(), value: isExpanded)
""")
        }
    }
}

