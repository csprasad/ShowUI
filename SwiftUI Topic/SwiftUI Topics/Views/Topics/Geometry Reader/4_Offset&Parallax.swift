//
//
//  4_Offset&Parallax.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Offset & Parallax
struct OffsetParallaxVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Parallax header", "Sticky offset", "Scale on scroll"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Offset & parallax", systemImage: "square.3.layers.3d.down.forward")
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
                    // Parallax header - 2 layers scroll at different speeds
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            // Hero with parallax
                            GeometryReader { geo in
                                let minY = geo.frame(in: .named("scroll")).minY
                                let offset = minY > 0 ? minY : 0
                                let scale  = minY > 0 ? 1 + minY / 300 : 1

                                ZStack(alignment: .bottom) {
                                    // Background layer - moves slower (parallax)
                                    LinearGradient(colors: [Color.geoGreen, Color(hex: "#4ADE80")],
                                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                                        .frame(maxWidth: .infinity)
                                        .offset(y: -offset * 0.4)
                                        .scaleEffect(scale)
                                    // Foreground text
                                    VStack(spacing: 4) {
                                        Text("Parallax Header").font(.system(size: 18, weight: .bold)).foregroundStyle(.white)
                                        Text("Scroll to see parallax").font(.system(size: 12)).foregroundStyle(.white.opacity(0.8))
                                    }
                                    .padding(.bottom, 20)
                                    .offset(y: -offset * 0.2)
                                }
                            }
                            .frame(height: 130)

                            // Content rows
                            VStack(spacing: 8) {
                                ForEach(0..<6) { i in
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.geoGreen.opacity(0.1 + Double(i) * 0.05))
                                        .frame(maxWidth: .infinity).frame(height: 44)
                                        .overlay(Text("Row \(i + 1)").font(.system(size: 12)).foregroundStyle(Color.geoGreen))
                                }
                            }
                            .padding(.horizontal, 4).padding(.top, 10)
                        }
                    }
                    .coordinateSpace(name: "scroll")
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                case 1:
                    // Sticky title - appears as scroll happens
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            GeometryReader { geo in
                                let y = geo.frame(in: .named("stickyScroll")).minY
                                let progress = (-y / 80).clamped(to: 0...1)

                                ZStack(alignment: .bottom) {
                                    LinearGradient(colors: [Color(hex: "#15803D"), Color.geoGreen],
                                                   startPoint: .top, endPoint: .bottom)
                                        .frame(maxWidth: .infinity)
                                    VStack(spacing: 4) {
                                        Text("Pull down / scroll up")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundStyle(.white.opacity(1 - progress))
                                        Text("to reveal sticky header above")
                                            .font(.system(size: 11))
                                            .foregroundStyle(.white.opacity(0.7 - progress * 0.7))
                                    }
                                    .padding(.bottom, 16)
                                }
                            }
                            .frame(height: 100)

                            VStack(spacing: 8) {
                                ForEach(0..<8) { i in
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemFill))
                                        .frame(maxWidth: .infinity).frame(height: 44)
                                        .overlay(Text("Content row \(i + 1)").font(.system(size: 12)).foregroundStyle(.secondary))
                                }
                            }
                            .padding(.horizontal, 4).padding(.top, 8)
                        }
                    }
                    .coordinateSpace(name: "stickyScroll")
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                default:
                    // Scale cells by distance from scroll centre
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<8) { i in
                                GeometryReader { geo in
                                    let frame = geo.frame(in: .named("hScroll"))
                                    let midX  = frame.midX
                                    let containerMid: CGFloat = 160
                                    let dist  = abs(midX - containerMid)
                                    let scale = max(0.75, 1 - dist / 400)
                                    let opacity = max(0.5, 1 - dist / 300)

                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(gridCellColors[i % gridCellColors.count])
                                        .scaleEffect(scale)
                                        .opacity(opacity)
                                        .overlay(Text("Card \(i+1)").font(.system(size: 13, weight: .bold)).foregroundStyle(.white))
                                }
                                .frame(width: 110, height: 80)
                            }
                        }
                        .padding(.horizontal, 20).padding(.vertical, 20)
                    }
                    .coordinateSpace(name: "hScroll")
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .background(Color(.secondarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 14)))
                }

                HStack(spacing: 6) {
                    Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.geoGreen)
                    Text(["Scroll the content to see the background layer move at a different speed.", "Scroll up - the gradient hero fades as text approaches the top.", "Scroll horizontally - cards scale down as they move away from centre."][selectedDemo])
                        .font(.system(size: 11)).foregroundStyle(.secondary)
                }
                .padding(8).background(Color.geoGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

extension CGFloat {
    func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}

struct OffsetParallaxExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Offset & parallax with GeometryReader")
            Text("Reading a view's position inside a named coordinate space (usually a scroll view) gives a live offset value as the user scrolls. Apply this offset at different multipliers to different layers to create parallax depth.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Name the ScrollView: .coordinateSpace(name: \"scroll\") on the ScrollView.", color: .geoGreen)
                StepRow(number: 2, text: "Read position: geo.frame(in: .named(\"scroll\")).minY - 0 at top, positive as user pulls down.", color: .geoGreen)
                StepRow(number: 3, text: "Background offset: .offset(y: -scrollY * 0.4) - moves at 40% of scroll speed = parallax.", color: .geoGreen)
                StepRow(number: 4, text: "Clamp the value: max(0, minY) - prevents the effect inverting when scrolled up.", color: .geoGreen)
                StepRow(number: 5, text: "Scale on scroll: scaleEffect(1 + max(0, minY) / 300) - zoom in when pulling down.", color: .geoGreen)
            }

            CalloutBox(style: .success, title: "iOS 17: use .visualEffect instead", contentBody: ".visualEffect { content, proxy in } is the modern iOS 17 replacement for GeometryReader parallax inside scroll views. It's more efficient - doesn't affect layout - and the proxy directly gives scroll-relative position.")

            CodeBlock(code: """
ScrollView {
    VStack(spacing: 0) {
        // Parallax hero
        GeometryReader { geo in
            let y = geo.frame(in: .named("scroll")).minY
            let scrollOffset = max(0, y)   // clamp at 0

            ZStack {
                // Background - moves slower
                backgroundImage
                    .offset(y: -scrollOffset * 0.4)
                    .scaleEffect(1 + scrollOffset / 300)

                // Text - moves at normal speed
                heroText
                    .offset(y: -scrollOffset * 0.1)
            }
        }
        .frame(height: 260)

        // Normal content
        contentRows
    }
}
.coordinateSpace(name: "scroll")
""")
        }
    }
}

