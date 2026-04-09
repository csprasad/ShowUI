//
//
//  1_Built-inShapes.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: Built-in Shapes
struct BuiltInShapesVisual: View {
    @State private var cornerRadius: CGFloat = 16
    @State private var topLeading: CGFloat   = 20
    @State private var topTrailing: CGFloat  = 4
    @State private var bottomLeading: CGFloat = 4
    @State private var bottomTrailing: CGFloat = 20
    @State private var selectedDemo           = 0

    let demos = ["All shapes", "RoundedRect", "UnevenRounded"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Built-in shapes", systemImage: "square.on.circle")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.spBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.spBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.spBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // All shapes grid
                    let shapes: [(String, AnyView)] = [
                        ("Rectangle",         AnyView(Rectangle().fill(Color.spBlue))),
                        ("RoundedRect",        AnyView(RoundedRectangle(cornerRadius: 12).fill(Color(hex: "#0891B2")))),
                        ("Circle",             AnyView(Circle().fill(Color(hex: "#0E7490")))),
                        ("Ellipse",            AnyView(Ellipse().fill(Color(hex: "#155E75")))),
                        ("Capsule",            AnyView(Capsule().fill(Color(hex: "#164E63")))),
                        ("ContStyle",          AnyView(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.spBlue.opacity(0.7)))),
                    ]
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                        ForEach(shapes, id: \.0) { name, shape in
                            VStack(spacing: 5) {
                                shape.frame(height: 44)
                                Text(name)
                                    .font(.system(size: 9, design: .monospaced))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1).minimumScaleFactor(0.7)
                            }
                        }
                    }

                case 1:
                    // RoundedRectangle corner radius
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Text("radius:").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 44)
                            Slider(value: $cornerRadius, in: 0...60, step: 2).tint(Color.spBlue)
                            Text("\(Int(cornerRadius))").font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.spBlue).frame(width: 24)
                        }
                        HStack(spacing: 12) {
                            VStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
                                    .fill(Color.spBlue).frame(height: 60)
                                Text(".circular").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                            }
                            VStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                    .fill(Color(hex: "#0891B2")).frame(height: 60)
                                Text(".continuous").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                            }
                        }
                        .animation(.easeInOut(duration: 0.1), value: cornerRadius)
                        Text("continuous = squircle (Apple-style). circular = standard CSS border-radius.")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }

                default:
                    // UnevenRoundedRectangle
                    VStack(spacing: 10) {
                        UnevenRoundedRectangle(
                            topLeadingRadius: topLeading,
                            bottomLeadingRadius: bottomLeading,
                            bottomTrailingRadius: bottomTrailing,
                            topTrailingRadius: topTrailing,
                            style: .continuous
                        )
                        .fill(LinearGradient(colors: [Color.spBlue, Color(hex: "#0891B2")],
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 80)
                        .animation(.easeInOut(duration: 0.1), value: topLeading)
                        .animation(.easeInOut(duration: 0.1), value: topTrailing)
                        .animation(.easeInOut(duration: 0.1), value: bottomLeading)
                        .animation(.easeInOut(duration: 0.1), value: bottomTrailing)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 2), spacing: 6) {
                            cornerSlider("topLeading",    value: $topLeading)
                            cornerSlider("topTrailing",   value: $topTrailing)
                            cornerSlider("bottomLeading", value: $bottomLeading)
                            cornerSlider("bottomTrailing",value: $bottomTrailing)
                        }
                    }
                }
            }
        }
    }

    func cornerSlider(_ name: String, value: Binding<CGFloat>) -> some View {
        VStack(spacing: 6) {
            HStack {
                Text(".\(name.prefix(10)):").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary).frame(width: 72, alignment: .leading)
                Text("\(Int(value.wrappedValue))").font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.spBlue).frame(width: 20)
            }.padding(.top, 10)
            Slider(value: value, in: 0...40, step: 2).tint(.spBlue).padding(10)
        }.background(Color.spBlueLight).cornerRadius(10)
    }
}

struct BuiltInShapesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Built-in shapes")
            Text("SwiftUI provides six built-in shapes. Each conforms to the Shape protocol - they can be used as fills, strokes, clip shapes, and backgrounds interchangeably. All respond to the frame they're placed in.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Rectangle - fills its entire frame. The simplest shape and the basis for many UIs.", color: .spBlue)
                StepRow(number: 2, text: "RoundedRectangle(cornerRadius:style:) - .continuous gives squircle corners (Apple standard). .circular gives standard rounded corners.", color: .spBlue)
                StepRow(number: 3, text: "Circle - always a circle, sized to the smaller of width or height.", color: .spBlue)
                StepRow(number: 4, text: "Ellipse - oval that fills the entire frame regardless of aspect ratio.", color: .spBlue)
                StepRow(number: 5, text: "Capsule - rectangle with fully rounded ends. Great for pills, tags and buttons.", color: .spBlue)
                StepRow(number: 6, text: "UnevenRoundedRectangle - iOS 16+. Independent radius per corner for asymmetric shapes.", color: .spBlue)
            }

            CalloutBox(style: .success, title: ".continuous is the Apple standard", contentBody: "RoundedRectangle(cornerRadius: n, style: .continuous) matches the squircle look used throughout iOS - app icons, cards, buttons. Prefer it over .circular for a native-feeling UI.")

            CodeBlock(code: """
Rectangle().fill(.blue)
Circle().fill(.red)
Ellipse().fill(.green)
Capsule().fill(.orange)

RoundedRectangle(cornerRadius: 16, style: .continuous)
    .fill(.purple)

// iOS 16+
UnevenRoundedRectangle(
    topLeadingRadius: 20,
    bottomLeadingRadius: 4,
    bottomTrailingRadius: 20,
    topTrailingRadius: 4,
    style: .continuous
)
.fill(.blue)

// Shapes work as clipShape too
Image("photo")
    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
""")
        }
    }
}
