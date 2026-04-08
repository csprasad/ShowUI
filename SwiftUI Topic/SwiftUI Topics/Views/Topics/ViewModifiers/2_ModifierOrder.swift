//
//
//  2_ModifierOrder.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `08/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Modifier Order
struct ModifierOrderVisual: View {
    @State private var selectedComparison = 0
    let comparisons = ["padding → background", "background → padding", "clip → shadow", "shadow → clip"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Modifier order", systemImage: "list.number")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.vmGreen)

                // Comparison selector
                VStack(spacing: 6) {
                    let cols = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
                    LazyVGrid(columns: cols, spacing: 8) {
                        ForEach(comparisons.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedComparison = i }
                            } label: {
                                Text(comparisons[i])
                                    .font(.system(size: 10, weight: selectedComparison == i ? .semibold : .regular, design: .monospaced))
                                    .foregroundStyle(selectedComparison == i ? Color.vmGreen : .secondary)
                                    .frame(maxWidth: .infinity).padding(.vertical, 8)
                                    .background(selectedComparison == i ? Color.vmGreenLight : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .multilineTextAlignment(.center)
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }

                // Side by side result
                ZStack {
                    Color(.secondarySystemBackground)
                    HStack(spacing: 0) {
                        comparisonSide(index: selectedComparison, isFirst: true)
                        Divider()
                        comparisonSide(index: selectedComparison, isFirst: false)
                    }
                    .padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.35), value: selectedComparison)
            }
        }
    }

    @ViewBuilder
    func comparisonSide(index: Int, isFirst: Bool) -> some View {
        VStack(spacing: 10) {
            // Label
            Text(isFirst ? "First" : "Reversed")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.secondary)

            // Visual result
            Group {
                switch (index, isFirst) {
                case (0, true):  // padding → background
                    Text("Label")
                        .font(.system(size: 13, weight: .semibold))
                        .padding(14)
                        .background(Color.vmGreenLight)
                case (0, false): // background → padding
                    Text("Label")
                        .font(.system(size: 13, weight: .semibold))
                        .background(Color.vmGreenLight)
                        .padding(14)
                case (1, true):  // clip → shadow
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.vmGreenLight)
                        .frame(width: 80, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.vmGreen.opacity(0.3), radius: 8, y: 4)
                case (1, false): // shadow → clip
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.vmGreenLight)
                        .frame(width: 80, height: 50)
                        .shadow(color: Color.vmGreen.opacity(0.3), radius: 8, y: 4)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                case (2, true):  // clip → shadow (circle)
                    Circle()
                        .fill(LinearGradient(colors: [Color.vmGreen, Color(hex: "#4ADE80")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .shadow(color: Color.vmGreen.opacity(0.4), radius: 8, y: 4)
                case (2, false): // shadow → clip (circle)
                    Circle()
                        .fill(LinearGradient(colors: [Color.vmGreen, Color(hex: "#4ADE80")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 60, height: 60)
                        .shadow(color: Color.vmGreen.opacity(0.4), radius: 8, y: 4)
                        .clipShape(Circle())
                default:         // border cases
                    Text("Same").font(.system(size: 12)).foregroundStyle(.secondary)
                }
            }

            // Code snippet
            VStack(alignment: .leading, spacing: 2) {
                codeLines(for: index, isFirst: isFirst)
            }
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    func codeLines(for index: Int, isFirst: Bool) -> some View {
        switch (index, isFirst) {
        case (0, true):
            codeLine(".padding(14)")
            codeLine(".background(.light)")
        case (0, false):
            codeLine(".background(.light)")
            codeLine(".padding(14)")
        case (1, true):
            codeLine(".clipShape(...)")
            codeLine(".shadow(...)")
        case (1, false):
            codeLine(".shadow(...)")
            codeLine(".clipShape(...) ←clips shadow!")
        case (2, true):
            codeLine(".clipShape(Circle())")
            codeLine(".shadow(...) ← visible")
        default:
            codeLine(".shadow(...)")
            codeLine(".clipShape(...) ← cuts shadow!")
        }
    }

    func codeLine(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 8, design: .monospaced))
            .foregroundStyle(Color.vmGreen)
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(Color.vmGreenLight)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

struct ModifierOrderExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Why order matters")
            Text("Modifier order is one of the most common sources of confusion in SwiftUI. Because each modifier wraps the view in a new container, the order completely changes the visual and layout result.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".padding().background() - padding is inside the background. The colored area includes the padding space.", color: .vmGreen)
                StepRow(number: 2, text: ".background().padding() - background only covers the text. The padding is outside the colored area.", color: .vmGreen)
                StepRow(number: 3, text: ".clipShape().shadow() - shadow is applied to the clipped result. Shadow is visible.", color: .vmGreen)
                StepRow(number: 4, text: ".shadow().clipShape() - shadow is drawn first, then clipped off. Shadow disappears.", color: .vmGreen)
                StepRow(number: 5, text: ".overlay() after .clipShape() - overlay respects the clip boundary. Before - overlay gets clipped too.", color: .vmGreen)
            }

            CalloutBox(style: .danger, title: "The shadow + clipShape trap", contentBody: "The most common order mistake: applying .shadow() before .clipShape() makes the shadow invisible - it gets clipped. Always: .clipShape() first, then .shadow(). The shadow goes on the outside of the clipped shape.")

            CalloutBox(style: .info, title: "Mental model: read bottom to top", contentBody: "When reasoning about modifier order, read from the inside out. The innermost modifier (closest to the view) is applied first. The outermost modifier (last in the chain) wraps everything else.")

            CodeBlock(code: """
// ✓ Padding inside background
Text("Card")
    .padding(16)         // space inside blue area
    .background(.blue)   // blue covers text + padding

// ✗ Padding outside background
Text("Card")
    .background(.blue)   // blue only behind text
    .padding(16)         // clear space around blue

// ✓ Shadow visible (after clip)
Image("photo")
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .shadow(radius: 8)   // shadows the clipped shape

// ✗ Shadow clipped off
Image("photo")
    .shadow(radius: 8)   // shadow drawn here...
    .clipShape(...)      // ...then clipped away!

// ✓ Overlay after clip (follows shape)
view
    .clipShape(Circle())
    .overlay(Circle().stroke(.white, lineWidth: 2))
""")
        }
    }
}
