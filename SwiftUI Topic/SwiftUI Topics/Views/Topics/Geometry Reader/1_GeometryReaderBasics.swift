//
//
//  1_GeometryReaderBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: GeometryReader Basics
struct GeoBasicsVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Size readout", "Layout quirks", "When to use"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("GeometryReader basics", systemImage: "arrow.up.left.and.arrow.down.right")
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
                    // Live size readout
                    GeometryReader { geo in
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.geoGreenLight)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.geoGreen.opacity(0.3), lineWidth: 1.5))

                            VStack(spacing: 10) {
                                Text("GeometryReader reports:").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                                HStack(spacing: 20) {
                                    geoStat("width",  value: geo.size.width)
                                    geoStat("height", value: geo.size.height)
                                }
                                HStack(spacing: 20) {
                                    geoStat("minX", value: geo.frame(in: .local).minX)
                                    geoStat("minY", value: geo.frame(in: .local).minY)
                                }
                                // Show proportional bar
                                GeometryReader { inner in
                                    HStack(spacing: 0) {
                                        Rectangle().fill(Color.geoGreen)
                                            .frame(width: inner.size.width * 0.4)
                                        Rectangle().fill(Color.geoGreen.opacity(0.3))
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .overlay(Text("40% = \(Int(inner.size.width * 0.4))pt").font(.system(size: 10)).foregroundStyle(.white.opacity(0.9)))
                                }
                                .frame(height: 24)
                            }
                            .padding(16)
                        }
                    }
                    .frame(height: 160)

                case 1:
                    // Layout quirks diagram
                    VStack(spacing: 8) {
                        quirkRow(icon: "exclamationmark.triangle.fill", color: .animAmber,
                                 title: "Fills max available space",
                                 desc: "Unlike most views, GeometryReader expands to fill all proposed space - even if the content is smaller.")
                        quirkRow(icon: "exclamationmark.triangle.fill", color: .animAmber,
                                 title: "Top-left origin",
                                 desc: "Content inside GeometryReader is positioned from the top-left by default - not centered. Add .frame(maxWidth:.infinity, maxHeight:.infinity) to center.")
                        quirkRow(icon: "checkmark.circle.fill", color: .geoGreen,
                                 title: "Use overlay/background trick",
                                 desc: "GeometryReader { geo in Color.clear.preference(key:..., value: geo.size) } in background avoids the expansion side-effect.")
                        quirkRow(icon: "checkmark.circle.fill", color: .geoGreen,
                                 title: "Use .frame() after if needed",
                                 desc: "Place GeometryReader inside a .frame(height:) to constrain its expansion.")
                    }

                default:
                    // When to use / not use
                    VStack(alignment: .leading, spacing: 8) {
                        useRow(good: true,  text: "Square cells: .aspectRatio(1) is better - no GeoReader needed.")
                        useRow(good: false, text: "Every cell in a LazyVGrid - creates a layout pass per cell, slow.")
                        useRow(good: true,  text: "Reading parent width to make a proportional layout decision.")
                        useRow(good: true,  text: "Canvas drawing that needs exact pixel dimensions.")
                        useRow(good: false, text: "Centering content - use .frame(maxWidth:.infinity) instead.")
                        useRow(good: true,  text: "Parallax scroll effects needing position in scroll container.")
                        useRow(good: false, text: "When .frame() or .containerRelativeFrame() would suffice.")
                    }
                }
            }
        }
    }

    func geoStat(_ label: String, value: CGFloat) -> some View {
        VStack(spacing: 2) {
            Text(String(format: "%.1f", value))
                .font(.system(size: 18, weight: .bold, design: .monospaced)).foregroundStyle(Color.geoGreen)
            Text(label).font(.system(size: 10)).foregroundStyle(.secondary)
        }
    }

    func quirkRow(icon: String, color: Color, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon).font(.system(size: 13)).foregroundStyle(color).padding(.top, 1)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 12, weight: .semibold))
                Text(desc).font(.system(size: 11)).foregroundStyle(.secondary)
            }
        }
        .padding(8)
        .background(color.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func useRow(good: Bool, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: good ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 12))
                .foregroundStyle(good ? Color.geoGreen : Color.animCoral)
            Text(text).font(.system(size: 11)).foregroundStyle(.secondary)
        }
    }
}

struct GeoBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "GeometryReader")
            Text("GeometryReader is a container view that provides its content with a GeometryProxy - giving access to the view's size and frame in multiple coordinate spaces. It's powerful but has important layout side effects to understand.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "GeometryReader { geo in } - geo is a GeometryProxy. Available inside the closure.", color: .geoGreen)
                StepRow(number: 2, text: "geo.size.width / geo.size.height - the available space offered to the GeometryReader.", color: .geoGreen)
                StepRow(number: 3, text: "geo.frame(in: .local) - the view's own coordinate space. geo.frame(in: .global) - screen coordinates.", color: .geoGreen)
                StepRow(number: 4, text: "GeometryReader expands to fill ALL proposed space - unlike most views. Plan for this.", color: .geoGreen)
                StepRow(number: 5, text: "Content inside is top-left aligned by default. Use .frame(maxWidth:.infinity) to stretch or ZStack to center.", color: .geoGreen)
            }

            CalloutBox(style: .warning, title: "The background trick", contentBody: ".background(GeometryReader { geo in Color.clear.preference(key:…, value: geo.size) }) reads size without affecting the layout of the view it's attached to. The view sizes normally and the GeometryReader reads whatever space was given.")

            CodeBlock(code: """
// Basic usage
GeometryReader { geo in
    let w = geo.size.width
    let h = geo.size.height

    VStack {
        Text("\\(Int(w)) × \\(Int(h))")
        Rectangle()
            .fill(.blue)
            .frame(width: w * 0.6, height: 10)
    }
}
.frame(height: 80)   // constrain expansion

// Background trick - no layout side effects
Color.blue
    .background(
        GeometryReader { geo in
            Color.clear
                .preference(key: SizeKey.self, value: geo.size)
        }
    )
    .onPreferenceChange(SizeKey.self) { size in
        containerSize = size
    }
""")
        }
    }
}
