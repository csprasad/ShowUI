//
//
//  4_Alignment.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `05/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Alignment
struct AlignmentGuideVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Stack alignment", "Custom guide", "Alignment in ZStack"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Alignment", systemImage: "align.horizontal.center.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.ssPurple)

                HStack(spacing: 8) {
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
                    alignmentDiagram.padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedDemo)

                let infos = [
                    "VStack alignment controls how children of different widths are positioned horizontally - .leading, .center, or .trailing.",
                    "Custom alignment guides let you align views across different levels of the hierarchy - even views that aren't in the same stack.",
                    "ZStack alignment positions all children at the same anchor point. Individual children can override with .frame(alignment:).",
                ]
                Text(infos[selectedDemo])
                    .font(.system(size: 12)).foregroundStyle(.secondary).lineSpacing(2)
                    .animation(.easeInOut(duration: 0.2), value: selectedDemo)
            }
        }
    }

    @ViewBuilder
    private var alignmentDiagram: some View {
        switch selectedDemo {
        case 0:
            // Stack alignment comparison
            HStack(spacing: 16) {
                ForEach([("leading", HorizontalAlignment.leading),
                         ("center", HorizontalAlignment.center),
                         ("trailing", HorizontalAlignment.trailing)], id: \.0) { name, align in
                    VStack(spacing: 4) {
                        Text(".\(name)").font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.ssPurple)
                        VStack(alignment: align, spacing: 4) {
                            ForEach([60, 100, 80], id: \.self) { w in
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.ssPurple.opacity(0.6))
                                    .frame(width: CGFloat(w) * 0.8, height: 14)
                            }
                        }
                        .frame(width: 85)
                        .padding(6)
                        .background(Color.ssPurpleLight)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }

        case 1:
            // Custom alignment guide
            VStack(spacing: 8) {
                Text("Custom alignment guide aligns across different stacks")
                    .font(.system(size: 10)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                HStack(alignment: .customMidpoint, spacing: 20) {
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4).fill(Color.ssPurple.opacity(0.3)).frame(width: 60, height: 20)
                        RoundedRectangle(cornerRadius: 4).fill(Color.ssPurple).frame(width: 60, height: 20)
                            .alignmentGuide(.customMidpoint) { d in d[VerticalAlignment.center] }
                        RoundedRectangle(cornerRadius: 4).fill(Color.ssPurple.opacity(0.3)).frame(width: 60, height: 20)
                    }
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4).fill(Color(hex: "#9B67F5").opacity(0.3)).frame(width: 80, height: 30)
                        RoundedRectangle(cornerRadius: 4).fill(Color(hex: "#9B67F5")).frame(width: 80, height: 20)
                            .alignmentGuide(.customMidpoint) { d in d[VerticalAlignment.center] }
                    }
                }
                Text("Both highlighted rows aligned on custom guide").font(.system(size: 9)).foregroundStyle(.secondary)
            }

        default:
            // ZStack alignment grid
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 10).fill(Color.ssPurpleLight).frame(width: 160, height: 100)
                Text("ZStack\ncontent").font(.system(size: 11)).foregroundStyle(Color.ssPurple).multilineTextAlignment(.center)
                // Badge using alignment
                Circle().fill(Color.animCoral).frame(width: 24, height: 24)
                    .overlay(Text("3").font(.system(size: 10, weight: .bold)).foregroundStyle(.white))
                    .offset(x: 8, y: -8)
            }
        }
    }
}

extension VerticalAlignment {
    private enum CustomMidpoint: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat { d[VerticalAlignment.center] }
    }
    static let customMidpoint = VerticalAlignment(CustomMidpoint.self)
}

struct AlignmentGuideExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Alignment")
            Text("Alignment in SwiftUI works on two levels: the alignment parameter on a stack positions children on the cross axis, and custom alignment guides let you align views that aren't siblings - across different parts of the hierarchy.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "VStack(alignment: .leading) aligns all children to the left edge of the widest child.", color: .ssPurple)
                StepRow(number: 2, text: "HStack(alignment: .top) aligns all children to the tallest child's top edge.", color: .ssPurple)
                StepRow(number: 3, text: ".alignmentGuide(.leading) { d in d[.trailing] } - makes this view's leading edge align where its trailing edge would normally be.", color: .ssPurple)
                StepRow(number: 4, text: "Custom alignment guides: define a new AlignmentID and use it to align across nested stacks.", color: .ssPurple)
            }

            CalloutBox(style: .info, title: "alignmentGuide for creative layouts", contentBody: ".alignmentGuide lets you shift where a view 'thinks' its alignment edge is, without changing its visual position in isolation. This is how you create overlapping or offset layouts.")

            CodeBlock(code: """
// Basic stack alignment
VStack(alignment: .trailing) {
    Text("Short")
    Text("Much longer text")  // drives the width
    Text("Medium")            // all align to trailing
}

// Custom alignment guide - shift a view
HStack(alignment: .top) {
    Text("Normal")
    Text("Shifted up")
        .alignmentGuide(.top) { d in
            d[.top] - 10    // 10pt above normal top
        }
}

// Cross-stack alignment
extension VerticalAlignment {
    private enum MyGuide: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[VerticalAlignment.center]
        }
    }
    static let myGuide = VerticalAlignment(MyGuide.self)
}

HStack(alignment: .myGuide) {
    ViewA()
        .alignmentGuide(.myGuide) { d in d[.bottom] }
    ViewB()
        .alignmentGuide(.myGuide) { d in d[.center] }
}
""")
        }
    }
}

