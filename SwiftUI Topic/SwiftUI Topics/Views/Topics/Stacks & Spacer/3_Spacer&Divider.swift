//
//
//  3_Spacer&Divider.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `05/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Spacer & Divider

struct SpacerDividerVisual: View {
    @State private var selectedDemo = 0
    @State private var minLength: CGFloat = 0
    @State private var showMinLength = false

    let demos = ["Spacer in HStack", "Spacer in VStack", "Fixed space", "Dividers"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Spacer & Divider", systemImage: "arrow.left.and.right")
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
                    demoDiagram.padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedDemo)

                // Info
                let infos = [
                    "Spacer() pushes A to the left edge and B to the right - fills all available horizontal space between them.",
                    "Spacer() in a VStack pushes views to top and bottom - fills remaining vertical space.",
                    "Spacer(minLength: 20) guarantees at least 20pt of space. Fixed space uses .frame(width:) or fixed Spacer.",
                    "Divider() draws a horizontal line. Inside HStack it draws vertical. Add .frame, .foregroundStyle to customize.",
                ]
                Text(infos[selectedDemo])
                    .font(.system(size: 12)).foregroundStyle(.secondary).lineSpacing(2)
                    .animation(.easeInOut(duration: 0.2), value: selectedDemo)
            }
        }
    }

    @ViewBuilder
    private var demoDiagram: some View {
        switch selectedDemo {
        case 0:
            // Spacer in HStack
            HStack {
                LayoutBlock(label: "A", color: .ssPurple, height: 40)
                // Spacer annotation
                ZStack {
                    Rectangle().fill(Color.ssPurple.opacity(0.15)).frame(height: 2)
                    Text("Spacer()").font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.ssPurple)
                        .padding(.horizontal, 4).background(Color(.secondarySystemBackground))
                }
                LayoutBlock(label: "B", color: Color(hex: "#9B67F5"), height: 40)
            }
            .padding(.horizontal, 8)

        case 1:
            // Spacer in VStack
            VStack {
                LayoutBlock(label: "Top", color: .ssPurple, width: 160, height: 32)
                ZStack {
                    Rectangle().fill(Color.ssPurple.opacity(0.15)).frame(width: 2)
                    Text("Spacer()").font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.ssPurple)
                        .padding(.vertical, 2).background(Color(.secondarySystemBackground))
                }
                LayoutBlock(label: "Bottom", color: Color(hex: "#9B67F5"), width: 160, height: 32)
            }

        case 2:
            // Fixed space
            VStack(spacing: 10) {
                HStack(spacing: 0) {
                    LayoutBlock(label: "A", color: .ssPurple, height: 36)
                    Spacer(minLength: 40)
                    LayoutBlock(label: "B", color: Color(hex: "#9B67F5"), height: 36)
                }
                .overlay(
                    HStack {
                        Spacer().frame(minWidth: 40)
                        Text("minLength: 40").font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.ssPurple)
                        Spacer()
                    }
                )

                HStack(spacing: 0) {
                    LayoutBlock(label: "A", color: .ssPurple, height: 36)
                    Color.clear.frame(width: 24)  // fixed gap
                    LayoutBlock(label: "B", color: Color(hex: "#9B67F5"), height: 36)
                    Text("  ← 24pt fixed").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                }
            }

        default:
            // Dividers
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Text("Section A").font(.system(size: 12, weight: .semibold))
                    Spacer()
                }
                .padding(.bottom, 6)
                Divider()
                HStack(spacing: 12) {
                    Text("Item 1").font(.system(size: 12))
                    Divider().frame(height: 16)  // vertical in HStack
                    Text("Item 2").font(.system(size: 12))
                    Divider().frame(height: 16)
                    Text("Item 3").font(.system(size: 12))
                }
                .padding(.vertical, 8)
                Divider().overlay(Color.ssPurple.opacity(0.4))  // tinted
                Text("Section B").font(.system(size: 12, weight: .semibold))
                    .padding(.top, 6)
            }
        }
    }
}

struct SpacerDividerExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Spacer & Divider")
            Text("Spacer is a flexible view that expands to fill all available space in a stack. It's the primary tool for pushing views apart or to edges. Divider draws a thin line - horizontal in VStack, vertical in HStack.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Spacer() in an HStack pushes views to opposite edges - the most common layout pattern.", color: .ssPurple)
                StepRow(number: 2, text: "Spacer(minLength: n) guarantees at least n points of space even when compressed.", color: .ssPurple)
                StepRow(number: 3, text: "Multiple Spacers divide remaining space equally - two Spacers = each gets half.", color: .ssPurple)
                StepRow(number: 4, text: "For fixed gaps, use .padding() or Color.clear.frame(width:) - not Spacer.", color: .ssPurple)
                StepRow(number: 5, text: "Divider() in HStack draws vertically. In VStack draws horizontally.", color: .ssPurple)
            }

            CalloutBox(style: .info, title: "Spacer has no visual appearance", contentBody: "Spacer() is invisible - it's purely a layout tool. If you want a visible gap with a specific color, use Color.clear.frame(width: n) or a Rectangle with your desired color.")

            CalloutBox(style: .warning, title: "Spacer in a stack without a frame", contentBody: "A Spacer in a VStack that has no explicit height will try to expand the VStack to fill all available space. This is often what you want (full-height screen) but can cause unexpected behavior inside a ScrollView or List.")

            CodeBlock(code: """
// Push views apart
HStack {
    Text("Left")
    Spacer()
    Text("Right")
}

// Push to bottom
VStack {
    Text("Top content")
    Spacer()
    Button("Bottom action") { }
}

// Multiple spacers - equal division
HStack {
    Spacer()
    Text("Centered")
    Spacer()
}

// Fixed gap - not Spacer
HStack(spacing: 0) {
    Icon()
    Color.clear.frame(width: 12)  // fixed 12pt gap
    Text("Label")
}

// Divider
VStack {
    Text("Above")
    Divider()
    Text("Below")
}

// Colored divider
Divider()
    .overlay(Color.blue)
    .frame(height: 2)
""")
        }
    }
}
