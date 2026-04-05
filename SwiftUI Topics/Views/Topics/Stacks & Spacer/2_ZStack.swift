//
//
//  2_ZStack.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `05/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: ZStack
struct ZStackVisual: View {
    @State private var selectedDemo = 0
    @State private var zAlignment = 4  // center

    let demos = ["Layering", "Z-order", "Overlay vs ZStack"]
    let alignments: [(name: String, align: Alignment)] = [
        (".topLeading", .topLeading), (".top", .top), (".topTrailing", .topTrailing),
        (".leading", .leading),       (".center", .center), (".trailing", .trailing),
        (".bottomLeading", .bottomLeading), (".bottom", .bottom), (".bottomTrailing", .bottomTrailing),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("ZStack", systemImage: "square.2.layers.3d.fill")
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
                    zDiagram.padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedDemo)
                .animation(.spring(response: 0.3), value: zAlignment)

                // Alignment grid (only shown for demo 0)
                if selectedDemo == 0 {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("ZStack alignment").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 3), spacing: 4) {
                            ForEach(alignments.indices, id: \.self) { i in
                                Button {
                                    withAnimation(.spring(response: 0.25)) { zAlignment = i }
                                } label: {
                                    Text(alignments[i].name)
                                        .font(.system(size: 8, design: .monospaced))
                                        .foregroundStyle(zAlignment == i ? Color.ssPurple : .secondary)
                                        .frame(maxWidth: .infinity).padding(.vertical, 5)
                                        .background(zAlignment == i ? Color.ssPurpleLight : Color(.systemFill))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var zDiagram: some View {
        switch selectedDemo {
        case 0:
            // Layering with alignment
            ZStack(alignment: alignments[zAlignment].align) {
                // Background
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#C4A7F5").opacity(0.4))
                    .frame(width: 180, height: 120)
                // Middle
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#9B67F5").opacity(0.7))
                    .frame(width: 120, height: 80)
                // Top
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.ssPurple)
                    .frame(width: 60, height: 40)
                    .overlay(Text("Top").font(.system(size: 10, weight: .bold)).foregroundStyle(.white))
            }

        case 1:
            // Z-order - later = on top
            HStack(spacing: 20) {
                VStack(spacing: 6) {
                    Text("First written").font(.system(size: 9, weight: .semibold)).foregroundStyle(.secondary)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8).fill(Color.animCoral).frame(width: 60, height: 60)
                        RoundedRectangle(cornerRadius: 8).fill(Color.ssPurple).frame(width: 45, height: 45).offset(x: 10, y: 10)
                        RoundedRectangle(cornerRadius: 8).fill(Color(hex: "#9B67F5")).frame(width: 30, height: 30).offset(x: 20, y: 20)
                    }.frame(width: 80, height: 80)
                    Text("↑ last view\non top").font(.system(size: 8)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("ZStack {").font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                    Text("  Red     // bottom").font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.animCoral)
                    Text("  Purple  // middle").font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.ssPurple)
                    Text("  Light   // top ↑").font(.system(size: 10, design: .monospaced)).foregroundStyle(Color(hex: "#9B67F5"))
                    Text("}").font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                }
            }

        default:
            // .overlay vs ZStack
            HStack(spacing: 16) {
                VStack(spacing: 6) {
                    Text("ZStack").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                    ZStack {
                        Color.ssPurpleLight.frame(width: 90, height: 70).clipShape(RoundedRectangle(cornerRadius: 8))
                        Text("Full\ncanvas").font(.system(size: 9)).foregroundStyle(Color.ssPurple).multilineTextAlignment(.center)
                        Image(systemName: "star.fill").font(.system(size: 14)).foregroundStyle(Color.ssPurple).offset(x: 28, y: -24)
                    }
                    Text("All children\nsize canvas").font(.system(size: 8)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                }

                VStack(spacing: 6) {
                    Text(".overlay").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                    Color.ssPurpleLight.frame(width: 90, height: 70).clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(alignment: .topTrailing) {
                            Image(systemName: "star.fill").font(.system(size: 14)).foregroundStyle(Color.ssPurple)
                                .padding(6)
                        }
                    Text("Sized by\nbase view").font(.system(size: 8)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                }
            }
        }
    }
}

struct ZStackExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "ZStack - layering views")
            Text("ZStack places views on top of each other along the Z-axis (depth). The first view listed is at the bottom, the last is on top. ZStack sizes itself to fit the largest child.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Views are drawn back to front - first in code = furthest back, last = frontmost.", color: .ssPurple)
                StepRow(number: 2, text: "ZStack(alignment: .topTrailing) - all children align to that corner unless they have their own frame.", color: .ssPurple)
                StepRow(number: 3, text: "ZStack sizes to the largest child. Smaller children sit centered (or at alignment) within that space.", color: .ssPurple)
                StepRow(number: 4, text: ".overlay - like ZStack but sized to the base view, not the largest. Use for badges, indicators.", color: .ssPurple)
                StepRow(number: 5, text: ".background - same as .overlay but places the added view behind, not in front.", color: .ssPurple)
            }

            CalloutBox(style: .success, title: "Prefer .overlay over ZStack for badges", contentBody: "When adding a badge or indicator on top of a view, .overlay is cleaner - the layout is driven by the base view's size. ZStack would size to the badge if it were larger.")

            CalloutBox(style: .info, title: "Use Color.clear to claim space", contentBody: "Color.clear inside a ZStack claims space without drawing anything visible. Useful when you want the ZStack to be a specific size regardless of its visible children.")

            CodeBlock(code: """
// Basic layering
ZStack {
    Color.blue           // background
    Image("photo")       // middle
    Text("Caption")      // top
        .padding()
        .background(.black.opacity(0.5))
}

// With alignment
ZStack(alignment: .bottomTrailing) {
    Image("avatar")
    Circle()
        .fill(.green)
        .frame(width: 12, height: 12)
        .overlay(Circle().stroke(.white, lineWidth: 2))
}

// Prefer .overlay for badges
Image("avatar")
    .overlay(alignment: .topTrailing) {
        Circle().fill(.red)
            .frame(width: 16, height: 16)
            .overlay(Text("3").font(.caption2).foregroundStyle(.white))
    }
""")
        }
    }
}
