//
//
//  3_ProportionalSizing.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Proportional Sizing
struct ProportionalSizingVisual: View {
    @State private var splitRatio: CGFloat  = 0.6
    @State private var selectedDemo         = 0
    @State private var cardCount            = 3
    let demos = ["Split layout", "Dynamic grid", "Aspect fill"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Proportional sizing", systemImage: "square.resize")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.geoGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.geoGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.geoGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Split layout
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Text("split:").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 32)
                            Slider(value: $splitRatio, in: 0.2...0.8).tint(.geoGreen)
                            Text("\(Int(splitRatio * 100))%").font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.geoGreen).frame(width: 36)
                        }
                        GeometryReader { geo in
                            HStack(spacing: 6) {
                                // Left panel - proportional width
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.geoGreen)
                                    .frame(width: geo.size.width * splitRatio)
                                    .overlay(
                                        VStack(spacing: 2) {
                                            Text("\(Int(splitRatio * 100))%")
                                                .font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
                                            Text("\(Int(geo.size.width * splitRatio))pt")
                                                .font(.system(size: 10, design: .monospaced)).foregroundStyle(.white.opacity(0.8))
                                        }
                                    )
                                // Right panel
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.geoGreen.opacity(0.3))
                                    .frame(width: geo.size.width * (1 - splitRatio) - 6)
                                    .overlay(
                                        VStack(spacing: 2) {
                                            Text("\(Int((1 - splitRatio) * 100))%")
                                                .font(.system(size: 14, weight: .bold)).foregroundStyle(Color.geoGreen)
                                            Text("\(Int(geo.size.width * (1 - splitRatio) - 6))pt")
                                                .font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.geoGreen.opacity(0.7))
                                        }
                                    )
                            }
                        }
                        .frame(height: 80)
                        .animation(.spring(response: 0.3), value: splitRatio)
                    }

                case 1:
                    // Dynamic grid from available width
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Text("cards:").font(.system(size: 12)).foregroundStyle(.secondary)
                            ForEach([2, 3, 4, 5], id: \.self) { n in
                                Button("\(n)") { withAnimation(.spring(response: 0.3)) { cardCount = n } }
                                    .font(.system(size: 12, weight: cardCount == n ? .semibold : .regular))
                                    .foregroundStyle(cardCount == n ? .white : .secondary)
                                    .frame(width: 28, height: 28)
                                    .background(cardCount == n ? Color.geoGreen : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .buttonStyle(PressableButtonStyle())
                            }
                        }
                        GeometryReader { geo in
                            let spacing: CGFloat = 6
                            let cardW = (geo.size.width - spacing * CGFloat(cardCount - 1)) / CGFloat(cardCount)
                            HStack(spacing: spacing) {
                                ForEach(0..<cardCount, id: \.self) { i in
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(gridCellColors[i % gridCellColors.count])
                                        .frame(width: cardW, height: 70)
                                        .overlay(
                                            VStack(spacing: 2) {
                                                Text("\(Int(cardW))pt")
                                                    .font(.system(size: 10, weight: .bold, design: .monospaced)).foregroundStyle(.white)
                                            }
                                        )
                                }
                            }
                        }
                        .frame(height: 80)
                        .animation(.spring(response: 0.4), value: cardCount)
                    }

                default:
                    // Aspect fill hero using available width
                    GeometryReader { geo in
                        let w = geo.size.width
                        let h = w * 9 / 16  // 16:9 aspect ratio
                        VStack(spacing: 8) {
                            ZStack {
                                LinearGradient(colors: [Color.geoGreen, Color(hex: "#4ADE80")],
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .frame(width: w, height: h)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                VStack(spacing: 4) {
                                    Text("16 : 9")
                                        .font(.system(size: 18, weight: .bold)).foregroundStyle(.white)
                                    Text("\(Int(w)) × \(Int(h))pt")
                                        .font(.system(size: 12, design: .monospaced)).foregroundStyle(.white.opacity(0.8))
                                }
                            }
                            Text("Width drives height: h = w × 9/16")
                                .font(.system(size: 10)).foregroundStyle(.secondary)
                        }
                    }
                    .frame(height: 160)
                }
            }
        }
    }
}

struct ProportionalSizingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Proportional sizing")
            Text("GeometryReader's primary use case: measuring available space so child views can size themselves as a fraction of it. This enables truly responsive layouts that adapt to any screen width.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "geo.size.width * 0.6 - 60% of available width. Scales with screen size automatically.", color: .geoGreen)
                StepRow(number: 2, text: "Card width = (available - gaps) / count - calculates exact card width for any column count.", color: .geoGreen)
                StepRow(number: 3, text: "Fixed aspect ratios: height = width * (9/16) - width from geo, height derived.", color: .geoGreen)
                StepRow(number: 4, text: "Compare geo.size.width to switch layouts - HStack on wide, VStack on narrow.", color: .geoGreen)
            }

            CalloutBox(style: .info, title: "containerRelativeFrame is often simpler", contentBody: "For simple proportional sizing, .containerRelativeFrame(.horizontal, count: 3, span: 1, spacing: 8) in iOS 17+ replaces most GeometryReader-for-sizing patterns. Consider it first before reaching for GeometryReader.")

            CodeBlock(code: """
// Proportional width
GeometryReader { geo in
    HStack {
        // Left 60%
        Rectangle()
            .frame(width: geo.size.width * 0.6)
        // Right 40%
        Rectangle()
            .frame(width: geo.size.width * 0.4)
    }
}

// Equal-width cards with exact sizing
GeometryReader { geo in
    let n = 3
    let spacing: CGFloat = 8
    let cardW = (geo.size.width - spacing * CGFloat(n - 1)) / CGFloat(n)
    HStack(spacing: spacing) {
        ForEach(0..<n) { _ in
            CardView().frame(width: cardW)
        }
    }
}

// Fixed aspect ratio hero
GeometryReader { geo in
    Image("hero")
        .resizable().scaledToFill()
        .frame(width: geo.size.width,
               height: geo.size.width * 9/16)
        .clipped()
}
.frame(height: /* computed */ 0)  // need known height
""")
        }
    }
}
