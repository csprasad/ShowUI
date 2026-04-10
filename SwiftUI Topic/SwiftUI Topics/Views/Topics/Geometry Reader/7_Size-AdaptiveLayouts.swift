//
//
//  7_Size-AdaptiveLayouts.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

#Preview {
    AdaptiveLayoutVisual()
}

// MARK: - LESSON 7: Size-Adaptive Layouts
struct AdaptiveLayoutVisual: View {
    @State private var containerWidth: CGFloat = 260
    @State private var selectedDemo           = 0
    let demos = ["HStack ↔ VStack", "Column count", "Text wrap"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Size-adaptive layouts", systemImage: "rectangle.3.group.fill")
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

                // Width slider - simulates narrow/wide container
                HStack(spacing: 8) {
                    Text("width:").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 36)
                    Slider(value: $containerWidth, in: 120...340, step: 4).tint(.geoGreen)
                    Text("\(Int(containerWidth))pt").font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.geoGreen).frame(width: 36)
                }

                // Container that mimics the given width
                ZStack(alignment: .leading) {
                    Color(.secondarySystemBackground)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                    adaptiveContent
                        .frame(width: containerWidth)
                        .padding(12)
                        .background(Color(.systemBackground).clipShape(RoundedRectangle(cornerRadius: 12)))
                        .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
                        .padding(10)
                        .animation(.spring(response: 0.4), value: containerWidth)
                }
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }

    @ViewBuilder
    var adaptiveContent: some View {
        switch selectedDemo {
        case 0:
            // HStack on wide, VStack on narrow
            let isWide = containerWidth > 200
            if isWide {
                HStack(spacing: 10) {
                    profileIcon
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Alice Chen").font(.system(size: 13, weight: .semibold))
                        Text("iOS Engineer").font(.system(size: 11)).foregroundStyle(.secondary)
                    }
                    Spacer()
                    followButton
                }
                .transition(.opacity.combined(with: .move(edge: .trailing)))
            } else {
                VStack(spacing: 8) {
                    profileIcon
                    Text("Alice Chen").font(.system(size: 13, weight: .semibold))
                    Text("iOS Engineer").font(.system(size: 11)).foregroundStyle(.secondary)
                    followButton
                }
                .transition(.opacity.combined(with: .move(edge: .leading)))
            }

        case 1:
            // Column count based on width
            let cols = containerWidth > 250 ? 4 : containerWidth > 180 ? 3 : 2
            VStack(alignment: .leading, spacing: 4) {
                Text("\(cols) cols").font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.geoGreen)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: cols), spacing: 4) {
                    ForEach(0..<8, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 6)
                            .fill(gridCellColors[i % gridCellColors.count])
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
                .animation(.spring(response: 0.4), value: cols)
            }

        default:
            // Text size adaptive
            let isWide = containerWidth > 200
            VStack(alignment: .leading, spacing: 4) {
                Text("Dynamic text")
                    .font(.system(size: isWide ? 16 : 13, weight: .bold))
                    .foregroundStyle(Color.geoGreen)
                Text("Available width determines whether we show a short blurb or a longer explanation here.")
                    .font(.system(size: isWide ? 12 : 10))
                    .foregroundStyle(.secondary)
                    .lineLimit(isWide ? nil : 2)
                    .animation(.spring(response: 0.3), value: isWide)
            }
        }
    }

    var profileIcon: some View {
        Circle().fill(Color.geoGreen)
            .frame(width: 36, height: 36)
            .overlay(Text("AC").font(.system(size: 13, weight: .bold)).foregroundStyle(.white))
    }

    var followButton: some View {
        Text("Follow")
            .font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
            .padding(.horizontal, 14).padding(.vertical, 6)
            .background(Color.geoGreen).clipShape(Capsule())
    }
}

struct AdaptiveLayoutExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Size-adaptive layouts")
            Text("Reading the available width with GeometryReader lets you switch between different layout configurations - HStack vs VStack, column counts, font sizes, content density. The layout responds to its container rather than fixed screen sizes.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Read width: GeometryReader { geo in let isWide = geo.size.width > 300 }", color: .geoGreen)
                StepRow(number: 2, text: "if isWide { HStack } else { VStack } - structural switch based on available space.", color: .geoGreen)
                StepRow(number: 3, text: "Column count: let cols = width > 500 ? 4 : width > 300 ? 3 : 2", color: .geoGreen)
                StepRow(number: 4, text: "ViewThatFits { HStack { } VStack { } } - iOS 16 lets SwiftUI pick whichever fits.", color: .geoGreen)
                StepRow(number: 5, text: "@Environment(\\.horizontalSizeClass) - compact vs regular. Useful for iPad split-view decisions.", color: .geoGreen)
            }

            CalloutBox(style: .success, title: "ViewThatFits - no GeometryReader needed", contentBody: "ViewThatFits { HStack { children } VStack { children } } automatically tries each layout and picks the first one that fits without truncation. For simple HStack/VStack switching, it's cleaner than a GeometryReader with breakpoints.")

            CodeBlock(code: """
// GeometryReader breakpoint approach
GeometryReader { geo in
    let isWide = geo.size.width > 400

    if isWide {
        HStack { content }
    } else {
        VStack { content }
    }
}

// ViewThatFits - iOS 16+ (cleaner)
ViewThatFits {
    HStack { icon; labels; button }   // try first
    VStack { icon; labels; button }   // fallback
}

// Dynamic column count
GeometryReader { geo in
    let cols = geo.size.width > 600 ? 4
             : geo.size.width > 400 ? 3
             : 2
    LazyVGrid(columns: Array(
        repeating: GridItem(.flexible()),
        count: cols
    )) {
        ForEach(items) { CellView($0) }
    }
}

// Environment size class
@Environment(\\.horizontalSizeClass) var hSize
if hSize == .regular {
    twoColumnLayout
} else {
    singleColumnLayout
}
""")
        }
    }
}
