//
//
//  5_Frame.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `05/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Frame
struct FrameVisual: View {
    @State private var selectedDemo = 0
    @State private var fixedWidth: CGFloat = 120
    @State private var fixedHeight: CGFloat = 60

    let demos = ["Fixed size", "max: .infinity", "min/ideal/max", "Aspect ratio"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Frame", systemImage: "rectangle.dashed")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.ssPurple)

                let cols = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
                LazyVGrid(columns: cols, spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
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
                    frameDiagram.padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedDemo)
                .animation(.easeInOut(duration: 0.15), value: fixedWidth)
                .animation(.easeInOut(duration: 0.15), value: fixedHeight)

                // Sliders for fixed size demo
                if selectedDemo == 0 {
                    HStack(spacing: 10) {
                        Text("W").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 12)
                        Slider(value: $fixedWidth, in: 40...200, step: 4).tint(.ssPurple)
                        Text("\(Int(fixedWidth))pt").font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 40)
                    }
                    HStack(spacing: 10) {
                        Text("H").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 12)
                        Slider(value: $fixedHeight, in: 30...120, step: 4).tint(.ssPurple)
                        Text("\(Int(fixedHeight))pt").font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 40)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var frameDiagram: some View {
        switch selectedDemo {
        case 0:
            // Fixed size
            VStack(spacing: 6) {
                Text(".frame(width: \(Int(fixedWidth)), height: \(Int(fixedHeight)))")
                    .font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.ssPurple)
                ZStack {
                    RoundedRectangle(cornerRadius: 6).stroke(Color.ssPurple.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4]))
                        .frame(width: fixedWidth, height: fixedHeight)
                    Text("Fixed frame").font(.system(size: 10)).foregroundStyle(Color.ssPurple)
                }
            }

        case 1:
            // maxWidth: .infinity
            VStack(spacing: 8) {
                Text(".frame(maxWidth: .infinity)")
                    .font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.ssPurple)
                HStack(spacing: 0) {
                    Image(systemName: "arrow.left").font(.system(size: 10)).foregroundStyle(Color.ssPurple)
                    RoundedRectangle(cornerRadius: 6).fill(Color.ssPurple.opacity(0.2))
                        .frame(height: 36)
                        .overlay(Text("Fills available width").font(.system(size: 10)).foregroundStyle(Color.ssPurple))
                    Image(systemName: "arrow.right").font(.system(size: 10)).foregroundStyle(Color.ssPurple)
                }
                Text(".frame(maxHeight: .infinity) fills height the same way")
                    .font(.system(size: 9)).foregroundStyle(.secondary)
            }

        case 2:
            // min/ideal/max
            HStack(spacing: 12) {
                VStack(spacing: 4) {
                    Text("Compressed").font(.system(size: 8, weight: .semibold)).foregroundStyle(.secondary)
                    RoundedRectangle(cornerRadius: 4).fill(Color.ssPurple)
                        .frame(width: 50, height: 30)
                        .overlay(Text("min").font(.system(size: 8)).foregroundStyle(.white))
                }
                VStack(spacing: 4) {
                    Text("Ideal (default)").font(.system(size: 8, weight: .semibold)).foregroundStyle(.secondary)
                    RoundedRectangle(cornerRadius: 4).fill(Color(hex: "#9B67F5"))
                        .frame(width: 80, height: 30)
                        .overlay(Text("ideal").font(.system(size: 8)).foregroundStyle(.white))
                }
                VStack(spacing: 4) {
                    Text("Expanded").font(.system(size: 8, weight: .semibold)).foregroundStyle(.secondary)
                    RoundedRectangle(cornerRadius: 4).fill(Color(hex: "#C4A7F5"))
                        .frame(width: 110, height: 30)
                        .overlay(Text("max").font(.system(size: 8)).foregroundStyle(.white))
                }
            }

        default:
            // Aspect ratio
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("1:1").font(.system(size: 9)).foregroundStyle(.secondary)
                    RoundedRectangle(cornerRadius: 6).fill(Color.ssPurple.opacity(0.7))
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 60)
                }
                VStack(spacing: 4) {
                    Text("16:9").font(.system(size: 9)).foregroundStyle(.secondary)
                    RoundedRectangle(cornerRadius: 6).fill(Color(hex: "#9B67F5").opacity(0.7))
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(width: 90)
                }
                VStack(spacing: 4) {
                    Text("4:3").font(.system(size: 9)).foregroundStyle(.secondary)
                    RoundedRectangle(cornerRadius: 6).fill(Color(hex: "#C4A7F5").opacity(0.7))
                        .aspectRatio(4/3, contentMode: .fit)
                        .frame(width: 70)
                }
            }
        }
    }
}

struct FrameExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Frame - controlling size")
            Text(".frame() is one of the most important layout modifiers. It tells SwiftUI the size you want the view to be - fixed, minimum, maximum, or a combination. It creates a transparent wrapper that negotiates space with the parent.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".frame(width: 100, height: 50) - fixed size. The view is always exactly this size.", color: .ssPurple)
                StepRow(number: 2, text: ".frame(maxWidth: .infinity) - expand to fill all available width. The most common pattern for full-width buttons and cards.", color: .ssPurple)
                StepRow(number: 3, text: ".frame(minWidth: 44, minHeight: 44) - enforce a minimum tap target without fixing the size.", color: .ssPurple)
                StepRow(number: 4, text: ".frame(width: n, alignment: .leading) - size to n, then position content at .leading inside that frame.", color: .ssPurple)
                StepRow(number: 5, text: ".aspectRatio(16/9, contentMode: .fit) - maintain proportions. .fit stays within bounds, .fill covers bounds.", color: .ssPurple)
            }

            CalloutBox(style: .info, title: "Frame is a wrapper, not a constraint", contentBody: ".frame() creates an invisible wrapper around the view. The content inside can still be smaller or larger - it's positioned within the frame according to the alignment. Use .clipped() if you want to prevent overflow.")

            CalloutBox(style: .success, title: "maxWidth: .infinity is your friend", contentBody: "The most useful frame modifier: .frame(maxWidth: .infinity) makes a view fill its parent's width. Apply it to buttons, cards, and any container you want full-width. Combine with .padding(.horizontal) for insets.")

            CodeBlock(code: """
// Fixed size
Image("logo")
    .frame(width: 44, height: 44)

// Full width button
Button("Continue") { }
    .frame(maxWidth: .infinity)
    .padding()
    .background(.blue)
    .clipShape(Capsule())

// Min tap target
Button { } label: {
    Image(systemName: "plus")
}
.frame(minWidth: 44, minHeight: 44)

// Aspect ratio
Image("photo")
    .resizable()
    .aspectRatio(16/9, contentMode: .fit)

// Frame with alignment
Text("Short")
    .frame(width: 200, alignment: .trailing)
// Text is right-aligned inside 200pt frame
""")
        }
    }
}
