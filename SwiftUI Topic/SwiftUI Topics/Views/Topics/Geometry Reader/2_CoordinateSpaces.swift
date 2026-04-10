//
//
//  2_CoordinateSpaces.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Coordinate Spaces
struct CoordSpacesVisual: View {
    @State private var selectedSpace = 0
    @State private var tapPoint: CGPoint = .zero
    @State private var showTap = false
    let spaces = ["local", "global", "named"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Coordinate spaces", systemImage: "mappin.and.ellipse")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.geoGreen)

                HStack(spacing: 8) {
                    ForEach(spaces.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedSpace = i }
                        } label: {
                            Text(".\(spaces[i])")
                                .font(.system(size: 11, weight: selectedSpace == i ? .semibold : .regular, design: .monospaced))
                                .foregroundStyle(selectedSpace == i ? Color.geoGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedSpace == i ? Color.geoGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedSpace {
                case 0:
                    // Local coords
                    GeometryReader { geo in
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.geoGreenLight)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.geoGreen.opacity(0.3)))
                            VStack(alignment: .leading, spacing: 6) {
                                Text(".local - origin at top-left of THIS view")
                                    .font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.geoGreen)
                                Text("minX: \(Int(geo.frame(in: .local).minX))  minY: \(Int(geo.frame(in: .local).minY))")
                                    .font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                                Text("width: \(Int(geo.frame(in: .local).width))  height: \(Int(geo.frame(in: .local).height))")
                                    .font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                                Text("→ .local minX/minY is always 0,0")
                                    .font(.system(size: 10)).foregroundStyle(Color.geoGreen.opacity(0.7))
                            }
                            .padding(14)

                            // Origin dot
                            Circle().fill(Color.geoGreen).frame(width: 8, height: 8)
                            Text("(0,0)").font(.system(size: 8)).foregroundStyle(Color.geoGreen)
                                .offset(x: 10, y: 2)
                        }
                    }
                    .frame(height: 120)

                case 1:
                    // Global coords
                    GeometryReader { geo in
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemFill))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.geoGreen.opacity(0.3)))
                            VStack(alignment: .leading, spacing: 6) {
                                Text(".global - origin at top-left of SCREEN")
                                    .font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.geoGreen)
                                Text("minX: \(Int(geo.frame(in: .global).minX))")
                                    .font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                                Text("minY: \(Int(geo.frame(in: .global).minY))")
                                    .font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                                Text("→ position of this card from screen top-left")
                                    .font(.system(size: 10)).foregroundStyle(Color.geoGreen.opacity(0.7))
                            }
                            .padding(14)
                        }
                    }
                    .frame(height: 110)

                default:
                    // Named coordinate space
                    VStack(spacing: 10) {
                        GeometryReader { outer in
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.geoGreenLight)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.geoGreen.opacity(0.3)))

                                Text("Named space: \"container\"")
                                    .font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.geoGreen)
                                    .padding(10)

                                // Inner view reading its frame in the named space
                                GeometryReader { inner in
                                    let frame = inner.frame(in: .named("container"))
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.geoGreen.opacity(0.2))
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.geoGreen, lineWidth: 1.5))
                                        VStack(spacing: 2) {
                                            Text("In \"container\":")
                                                .font(.system(size: 9, weight: .semibold)).foregroundStyle(Color.geoGreen)
                                            Text("x:\(Int(frame.minX)) y:\(Int(frame.minY))")
                                                .font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                                        }
                                    }
                                }
                                .padding(50)
                            }
                        }
                        .coordinateSpace(name: "container")
                        .frame(height: 130)

                        Text("Named space lets a child read its frame relative to any ancestor")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

struct CoordSpacesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Coordinate spaces")
            Text("geo.frame(in:) returns a CGRect describing the view's position and size in a given coordinate system. Three options: .local (view's own origin), .global (screen origin), or a .named space you define on an ancestor.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "geo.frame(in: .local) - always (0, 0, width, height). The view relative to itself.", color: .geoGreen)
                StepRow(number: 2, text: "geo.frame(in: .global) - position on screen. Changes as the view scrolls or moves.", color: .geoGreen)
                StepRow(number: 3, text: "geo.frame(in: .named(\"scroll\")) - position relative to an ancestor named with .coordinateSpace(name:).", color: .geoGreen)
                StepRow(number: 4, text: ".coordinateSpace(name: \"container\") on a parent view - lets children reference it as .named(\"container\").", color: .geoGreen)
                StepRow(number: 5, text: "Named spaces are key for scroll offset detection - read the content's minY in the scroll's coordinate space.", color: .geoGreen)
            }

            CalloutBox(style: .success, title: "Named spaces for scroll offset", contentBody: ".coordinateSpace(name: \"scroll\") on the ScrollView, then GeometryReader { geo in Color.clear.preference(key:…, value: geo.frame(in: .named(\"scroll\")).minY) } inside gives the scroll offset without UIKit.")

            CodeBlock(code: """
GeometryReader { geo in
    // Local - view's own coord system, always (0,0)
    let localFrame = geo.frame(in: .local)

    // Global - screen coordinates
    let screenFrame = geo.frame(in: .global)
    let screenX = screenFrame.minX
    let screenY = screenFrame.minY

    // Named - relative to ancestor
    let relativeFrame = geo.frame(in: .named("container"))
}

// Define a named space on an ancestor
ScrollView {
    content
}
.coordinateSpace(name: "scroll")

// Inside content - read position in scroll
GeometryReader { geo in
    Color.clear.preference(
        key: OffsetKey.self,
        value: geo.frame(in: .named("scroll")).minY
    )
}
""")
        }
    }
}

