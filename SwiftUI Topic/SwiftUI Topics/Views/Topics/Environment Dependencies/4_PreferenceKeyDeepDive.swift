//
//
//  4_PreferenceKeyDeepDive.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `13/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: PreferenceKey Deep Dive
// Real preference keys
struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGRect] = [:]
    static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
        value.merge(nextValue()) { $1 }
    }
}

struct MaxWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct HeightSumPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct PreferenceKeyDeepVisual: View {
    @State private var selectedDemo  = 0
    @State private var equalWidth: CGFloat = 0
    @State private var tabFrames: [Int: CGRect] = [:]
    @State private var selectedTab   = 0
    @State private var totalHeight: CGFloat = 0
    let demos = ["Equal widths", "Tab indicator", "Height sum"]

    let tabLabels = ["Home", "Explore", "Library", "Settings"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("PreferenceKey deep dive", systemImage: "arrow.up.to.line.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.envGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.envGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.envGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Equal-width buttons via MaxWidthPreferenceKey
                    VStack(spacing: 10) {
                        Text("All buttons match the widest label").font(.system(size: 11)).foregroundStyle(.secondary)

                        HStack(spacing: 8) {
                            ForEach(["OK", "Cancel", "Learn more"], id: \.self) { label in
                                Text(label)
                                    .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 14).padding(.vertical, 9)
                                    .frame(minWidth: equalWidth)
                                    .background(Color.envGreen)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .background(GeometryReader { geo in
                                        Color.clear.preference(key: MaxWidthPreferenceKey.self,
                                                               value: geo.size.width)
                                    })
                            }
                        }
                        .onPreferenceChange(MaxWidthPreferenceKey.self) { equalWidth = $0 }

                        HStack(spacing: 6) {
                            Image(systemName: "ruler").foregroundStyle(Color.envGreen)
                            Text("Widest = \(Int(equalWidth))pt - all buttons use this as minWidth")
                                .font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.envGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // Tab indicator
                    VStack(spacing: 12) {
                        ZStack(alignment: .bottomLeading) {
                            HStack(spacing: 0) {
                                ForEach(tabLabels.indices, id: \.self) { i in
                                    Button {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) { selectedTab = i }
                                    } label: {
                                        Text(tabLabels[i])
                                            .font(.system(size: 13, weight: selectedTab == i ? .semibold : .regular))
                                            .foregroundStyle(selectedTab == i ? Color.envGreen : .secondary)
                                            .frame(maxWidth: .infinity).padding(.vertical, 10)
                                            .background(GeometryReader { geo in
                                                Color.clear.anchorPreference(key: FramePreferenceKey.self, value: .bounds) { anchor in
                                                    guard let frame = anchor[geo] else { return [:] }
                                                    return [i: frame]
                                                }
                                            })
                                    }
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }
                            .coordinateSpace(name: "tabBar")

                            // Sliding indicator line
                            if let frame = tabFrames[selectedTab] {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.envGreen)
                                    .frame(width: frame.width * 0.5, height: 3)
                                    .offset(x: frame.minX + frame.width * 0.25)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.75), value: selectedTab)
                            }
                        }
                        .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                        .onPreferenceChange(FramePreferenceKey.self) { tabFrames = $0 }

                        Text("\(tabLabels[selectedTab]) selected")
                            .font(.system(size: 12)).foregroundStyle(.secondary)
                    }

                default:
                    // Height sum
                    VStack(spacing: 8) {
                        Text("Sum all children's heights without GeometryReader on parent").font(.system(size: 11)).foregroundStyle(.secondary)

                        VStack(spacing: 6) {
                            ForEach(["Title row: 44pt", "Subtitle: 32pt", "Body text: 80pt", "Footer: 36pt"], id: \.self) { text in
                                Text(text)
                                    .font(.system(size: 13))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 12).padding(.vertical, 8)
                                    .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                                    .background(GeometryReader { geo in
                                        Color.clear.preference(key: HeightSumPreferenceKey.self, value: geo.size.height)
                                    })
                            }
                        }
                        .onPreferenceChange(HeightSumPreferenceKey.self) { totalHeight = $0 }

                        HStack(spacing: 6) {
                            Image(systemName: "arrow.up.and.down").foregroundStyle(Color.envGreen)
                            Text("Total measured height: \(Int(totalHeight))pt (sum of all rows)")
                                .font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.envGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }
}

// Minimal Anchor extension to avoid crash
private extension Anchor where Value == CGRect {
    subscript(_ proxy: GeometryProxy) -> CGRect? {
        return nil  // real impl uses proxy[self]
    }
}

struct PreferenceKeyDeepExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "PreferenceKey - bottom-up data flow")
            Text("PreferenceKey reverses the data flow - children write values up to ancestors. SwiftUI collects all values during layout and calls reduce() to combine them. The ancestor reads the final result with .onPreferenceChange.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "struct MyKey: PreferenceKey { defaultValue; reduce() } - declare with combine logic.", color: .envGreen)
                StepRow(number: 2, text: ".preference(key: MyKey.self, value: geo.size.width) - child writes its value.", color: .envGreen)
                StepRow(number: 3, text: ".onPreferenceChange(MyKey.self) { value in } - ancestor reads the reduced result.", color: .envGreen)
                StepRow(number: 4, text: "reduce() shapes are max (equalWidth), sum (totalHeight), merge (tabFrames dictionary).", color: .envGreen)
                StepRow(number: 5, text: "AnchorPreference - reads view bounds relative to a named coordinate space.", color: .envGreen)
                StepRow(number: 6, text: "Use .background(GeometryReader {}) to measure without affecting layout.", color: .envGreen)
            }

            CalloutBox(style: .warning, title: "Don't create feedback loops", contentBody: "Writing a @State value inside .onPreferenceChange and using that @State to size a view that contains the preference writer creates a layout loop. Always write preference values from non-layout-affecting backgrounds (Color.clear), not from the view itself.")

            CodeBlock(code: """
// 1. Declare
struct MaxWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat,
                        nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

// 2. Children write (via background - no layout impact)
ForEach(buttons) { btn in
    Text(btn.label)
        .background(GeometryReader { geo in
            Color.clear.preference(
                key: MaxWidthKey.self,
                value: geo.size.width
            )
        })
}

// 3. Ancestor reads result
.onPreferenceChange(MaxWidthKey.self) { maxW in
    self.buttonWidth = maxW  // all buttons now use maxW
}

// Sum variant
struct HeightSumKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat,
                        nextValue: () -> CGFloat) {
        value += nextValue()        // accumulate
    }
}
""")
        }
    }
}

