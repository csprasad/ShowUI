//
//
//  5_PreferenceKey.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: PreferenceKey
struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct AnchorPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGRect] = [:]
    static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
        value.merge(nextValue()) { $1 }
    }
}

struct PreferenceKeyVisual: View {
    @State private var equalWidth: CGFloat  = 0
    @State private var selectedTab          = 0
    @State private var indicatorFrame       = CGRect.zero
    @State private var selectedDemo         = 0
    let demos  = ["Equal widths", "Tab indicator", "Size reader"]
    let tabs   = ["Home", "Explore", "Profile", "Settings"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("PreferenceKey", systemImage: "arrow.up.message.fill")
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
                    // Equal-width buttons
                    VStack(spacing: 12) {
                        Text("Buttons match the widest one").font(.system(size: 11)).foregroundStyle(.secondary)
                        HStack(spacing: 8) {
                            ForEach(["OK", "Cancel", "Learn more"], id: \.self) { label in
                                Text(label)
                                    .font(.system(size: 13, weight: .semibold))
                                    .padding(.horizontal, 14).padding(.vertical, 9)
                                    .background(
                                        GeometryReader { geo in
                                            Color.clear.preference(key: WidthPreferenceKey.self,
                                                                    value: geo.size.width)
                                        }
                                    )
                                    .frame(minWidth: equalWidth)
                                    .background(Color.geoGreen)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .onPreferenceChange(WidthPreferenceKey.self) { equalWidth = $0 }

                        HStack(spacing: 6) {
                            Image(systemName: "arrow.left.and.right").font(.system(size: 11)).foregroundStyle(Color.geoGreen)
                            Text("Widest = \(Int(equalWidth))pt - all buttons use this as minWidth")
                                .font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.geoGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // Tab indicator that follows selection
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottomLeading) {
                            // Tabs
                            HStack(spacing: 0) {
                                ForEach(tabs.indices, id: \.self) { i in
                                    Button {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedTab = i }
                                    } label: {
                                        Text(tabs[i])
                                            .font(.system(size: 12, weight: selectedTab == i ? .semibold : .regular))
                                            .foregroundStyle(selectedTab == i ? Color.geoGreen : .secondary)
                                            .frame(maxWidth: .infinity).padding(.vertical, 10)
                                            .background(
                                                GeometryReader { geo in
                                                    Color.clear.anchorPreference(key: AnchorPreferenceKey.self,
                                                                                  value: .bounds) { anchor in
                                                        [i: anchor.cgRect(in: .named("tabs"))]
                                                    }
                                                }
                                            )
                                    }
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }

                            // Sliding indicator
                            if indicatorFrame != .zero {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.geoGreen)
                                    .frame(width: indicatorFrame.width * 0.6, height: 3)
                                    .offset(x: indicatorFrame.minX + indicatorFrame.width * 0.2)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
                            }
                        }
                        .coordinateSpace(name: "tabs")
                        .onPreferenceChange(AnchorPreferenceKey.self) { frames in
                            if let frame = frames[selectedTab] {
                                indicatorFrame = frame
                            }
                        }
                        .onChange(of: selectedTab) { _, new in
                            // force update when tab changes
                        }
                        .background(Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                        Text("Tab \(tabs[selectedTab]) selected")
                            .font(.system(size: 12)).foregroundStyle(.secondary)
                            .padding(.top, 10)
                    }

                default:
                    // Size reader
                    VStack(spacing: 10) {
                        Text("Resize window / rotate to see values update")
                            .font(.system(size: 11)).foregroundStyle(.secondary)
                        VStack(spacing: 6) {
                            ForEach(["Title", "A longer subtitle text", "Short"], id: \.self) { text in
                                Text(text)
                                    .font(.system(size: 14))
                                    .padding(.horizontal, 14).padding(.vertical, 8)
                                    .background(
                                        GeometryReader { geo in
                                            RoundedRectangle(cornerRadius: 8).fill(Color.geoGreenLight)
                                                .preference(key: WidthPreferenceKey.self, value: geo.size.width)
                                        }
                                    )
                            }
                        }
                        .onPreferenceChange(WidthPreferenceKey.self) { w in equalWidth = w }

                        HStack(spacing: 6) {
                            Image(systemName: "ruler.fill").font(.system(size: 11)).foregroundStyle(Color.geoGreen)
                            Text("Widest text block: \(Int(equalWidth))pt")
                                .font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.geoGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }
}

extension Anchor<CGRect> {
    func cgRect(in space: CoordinateSpace) -> CGRect { .zero } // stub - real impl via GeometryProxy
}

struct PreferenceKeyExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "PreferenceKey - bottom-up communication")
            Text("PreferenceKey lets child views pass data up to their ancestors. It's the opposite of environment (top-down). Children write values, the view tree reduces them, and ancestors read the result via .onPreferenceChange.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Declare a PreferenceKey with a defaultValue and a reduce function.", color: .geoGreen)
                StepRow(number: 2, text: ".preference(key: MyKey.self, value: someValue) - child writes its value.", color: .geoGreen)
                StepRow(number: 3, text: ".onPreferenceChange(MyKey.self) { value in } on ancestor - reads the final reduced value.", color: .geoGreen)
                StepRow(number: 4, text: "reduce() - merges multiple children's values (e.g., max width, accumulate frames).", color: .geoGreen)
                StepRow(number: 5, text: "Common use: equal-width buttons, tab indicators, height matching, overlay positioning.", color: .geoGreen)
            }

            CalloutBox(style: .info, title: "Use the background trick to avoid layout issues", contentBody: ".background(GeometryReader { geo in Color.clear.preference(key:…, value: geo.size.width) }) reads the view's size without the GeometryReader affecting the view's own layout contribution.")

            CodeBlock(code: """
// 1. Declare the key
struct MaxWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat,
                        nextValue: () -> CGFloat) {
        value = max(value, nextValue())   // keep the largest
    }
}

// 2. Children write values
ForEach(buttons) { btn in
    Text(btn.title)
        .background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: MaxWidthKey.self,
                    value: geo.size.width
                )
            }
        )
}

// 3. Ancestor reads the result
.onPreferenceChange(MaxWidthKey.self) { maxW in
    self.buttonWidth = maxW
}

// 4. Apply the measured value
Text(btn.title)
    .frame(minWidth: buttonWidth)  // all buttons equal width
""")
        }
    }
}
