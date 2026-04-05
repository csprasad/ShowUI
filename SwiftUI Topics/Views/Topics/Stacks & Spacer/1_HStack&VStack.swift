//
//
//  1_HStack&VStack.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `05/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Shared block view
struct LayoutBlock: View {
    let label: String
    var color: Color = .ssPurple
    var width: CGFloat? = nil
    var height: CGFloat? = 44

    var body: some View {
        Text(label)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: width, height: height)
            .frame(minWidth: 32)
            .padding(.horizontal, width == nil ? 10 : 0)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - LESSON 1: HStack & VStack

struct HVStackVisual: View {
    @State private var axis = 0          // 0=H, 1=V
    @State private var spacing: CGFloat = 8
    @State private var alignment = 0     // varies by axis

    let hAlignments: [(name: String, align: VerticalAlignment)] = [
        (".top", .top), (".center", .center), (".bottom", .bottom), (".firstTextBaseline", .firstTextBaseline)
    ]
    let vAlignments: [(name: String, align: HorizontalAlignment)] = [
        (".leading", .leading), (".center", .center), (".trailing", .trailing)
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("HStack & VStack", systemImage: "rectangle.split.3x1.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.ssPurple)

                // Axis toggle
                HStack(spacing: 8) {
                    axisButton("HStack", icon: "arrow.left.and.right", selected: axis == 0) { axis = 0; alignment = 0 }
                    axisButton("VStack", icon: "arrow.up.and.down", selected: axis == 1) { axis = 1; alignment = 0 }
                }

                // Live preview
                ZStack {
                    Color(.secondarySystemBackground)
                    if axis == 0 {
                        HStack(alignment: hAlignments[min(alignment, hAlignments.count-1)].align, spacing: spacing) {
                            LayoutBlock(label: "A", color: .ssPurple, height: 36)
                            LayoutBlock(label: "B", color: Color(hex: "#9B67F5"), height: 56)
                            LayoutBlock(label: "C", color: Color(hex: "#C4A7F5"), height: 44)
                        }
                    } else {
                        VStack(alignment: vAlignments[min(alignment, vAlignments.count-1)].align, spacing: spacing) {
                            LayoutBlock(label: "Short", color: .ssPurple, width: 80, height: 36)
                            LayoutBlock(label: "Medium width", color: Color(hex: "#9B67F5"), width: 140, height: 36)
                            LayoutBlock(label: "Wide block view", color: Color(hex: "#C4A7F5"), width: 180, height: 36)
                        }
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: axis)
                .animation(.spring(response: 0.3), value: alignment)
                .animation(.easeInOut(duration: 0.15), value: spacing)

                // Spacing slider
                HStack(spacing: 10) {
                    Text("spacing").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 52)
                    Slider(value: $spacing, in: 0...32, step: 2).tint(.ssPurple)
                    Text("\(Int(spacing))pt").font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 32)
                }

                // Alignment picker
                VStack(alignment: .leading, spacing: 6) {
                    Text("alignment").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            let options = axis == 0 ? hAlignments.map(\.name) : vAlignments.map(\.name)
                            ForEach(options.indices, id: \.self) { i in
                                Button {
                                    withAnimation(.spring(response: 0.3)) { alignment = i }
                                } label: {
                                    Text(options[i])
                                        .font(.system(size: 10, weight: alignment == i ? .semibold : .regular, design: .monospaced))
                                        .foregroundStyle(alignment == i ? Color.ssPurple : .secondary)
                                        .padding(.horizontal, 8).padding(.vertical, 5)
                                        .background(alignment == i ? Color.ssPurpleLight : Color(.systemFill))
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                    }
                }
            }
        }
    }

    func axisButton(_ title: String, icon: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 12))
                Text(title).font(.system(size: 13, weight: selected ? .semibold : .regular))
            }
            .foregroundStyle(selected ? Color.ssPurple : .secondary)
            .frame(maxWidth: .infinity).padding(.vertical, 9)
            .background(selected ? Color.ssPurpleLight : Color(.systemFill))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(PressableButtonStyle())
    }
}

struct HVStackExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "HStack & VStack")
            Text("HStack arranges views horizontally, VStack vertically. Both take a spacing parameter for gap between items and an alignment parameter for how items line up on the cross-axis.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "HStack(alignment: .top, spacing: 8) - items aligned at their tops, 8pt between each.", color: .ssPurple)
                StepRow(number: 2, text: "VStack(alignment: .leading, spacing: 12) - items left-aligned, 12pt between each.", color: .ssPurple)
                StepRow(number: 3, text: "Default spacing is nil - SwiftUI uses the platform standard (8pt on iOS). Pass 0 for no gap.", color: .ssPurple)
                StepRow(number: 4, text: "Alignment on HStack controls vertical alignment (.top, .center, .bottom, .firstTextBaseline).", color: .ssPurple)
                StepRow(number: 5, text: "Alignment on VStack controls horizontal alignment (.leading, .center, .trailing).", color: .ssPurple)
            }

            CalloutBox(style: .info, title: "Stacks are greedy by default", contentBody: "A VStack takes as much height as its tallest child needs. An HStack takes as much width as all children need combined. Use .frame() or Spacer to control how much space they claim.")

            CalloutBox(style: .success, title: "Nest freely", contentBody: "Nest HStack inside VStack and vice versa for complex layouts. SwiftUI's layout engine handles arbitrary nesting efficiently - don't hesitate to nest 4 or 5 levels deep for the right result.")

            CodeBlock(code: """
// Horizontal stack
HStack(alignment: .center, spacing: 12) {
    Image(systemName: "star.fill")
    Text("Featured")
    Spacer()
    Text("4.9")
}

// Vertical stack
VStack(alignment: .leading, spacing: 8) {
    Text("Title").font(.headline)
    Text("Subtitle").font(.subheadline)
        .foregroundStyle(.secondary)
}

// Nested
HStack(spacing: 16) {
    Image("avatar")
    VStack(alignment: .leading) {
        Text("Name").fontWeight(.semibold)
        Text("Role").foregroundStyle(.secondary)
    }
    Spacer()
    Button("Follow") { }
}
""")
        }
    }
}

