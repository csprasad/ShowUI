//
//
//  2_TipViewInlineTips.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import TipKit

#Preview {
    TKInlineTipVisual()
}

// MARK: - LESSON 2: TipView - Inline Tips
struct TKInlineTipVisual: View {
    @State private var selectedDemo   = 0
    @State private var tipVisible1    = true
    @State private var tipVisible2    = true
    @State private var tipVisible3    = true
    @State private var arrowEdge: Edge = .top
    let demos = ["Basic TipView", "Arrow & edges", "Inside layouts"]

    let welcomeTip    = WelcomeTip()
    let searchTip     = SearchTip()
    let favouriteTip  = FavouriteTip()

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("TipView - inline tips", systemImage: "rectangle.badge.plus")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tkAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; tipVisible1 = true; tipVisible2 = true; tipVisible3 = true }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.tkAmber : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.tkAmberLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Basic TipView
                    VStack(spacing: 10) {
                        if tipVisible1 {
                            TipView(welcomeTip)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                                .tipBackground(.tkAmberLight)
                        }

                        Button(tipVisible1 ? "Dismiss tip" : "Show tip again") {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                tipVisible1.toggle()
                            }
                        }
                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(Color.tkAmber).clipShape(RoundedRectangle(cornerRadius: 10))
                        .buttonStyle(PressableButtonStyle())

                        if tipVisible2 {
                            TipView(searchTip, arrowEdge: .bottom)
                                .tipBackground(Color(hex: "#EFF6FF"))
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }

                        codeSnip("TipView(myTip)                     // default arrow: .top\nTipView(myTip, arrowEdge: .bottom) // arrow on bottom edge")
                    }

                case 1:
                    // Arrow edge demo
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Text("arrowEdge:").font(.system(size: 12)).foregroundStyle(.secondary)
                            ForEach([Edge.top, .bottom, .leading, .trailing], id: \.self) { edge in
                                Button(edgeName(edge)) {
                                    withAnimation(.spring(response: 0.3)) { arrowEdge = edge }
                                }
                                .font(.system(size: 11, weight: arrowEdge == edge ? .semibold : .regular))
                                .foregroundStyle(arrowEdge == edge ? .white : .tkAmber)
                                .padding(.horizontal, 10).padding(.vertical, 5)
                                .background(arrowEdge == edge ? Color.tkAmber : Color.tkAmberLight)
                                .clipShape(Capsule())
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                        
                        TipView(favouriteTip, arrowEdge: arrowEdge)
                            .animation(.spring(response: 0.4), value: arrowEdge)

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.tkAmber)
                            Text("arrowEdge determines which edge the arrow points FROM. If nil, no arrow is shown.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tkAmberLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // Inside layouts
                    VStack(spacing: 10) {
                        Text("TipView in a List / VStack flow").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        // Simulate a settings list with tips interspersed
                        VStack(spacing: 0) {
                            settingsRow(icon: "magnifyingglass", label: "Search")
                            if tipVisible2 {
                                TipView(searchTip, arrowEdge: .top)
                                    .padding(.horizontal, 4)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                            Divider().padding(.leading, 50)
                            settingsRow(icon: "heart.fill", label: "Favourites")
                            if tipVisible3 {
                                TipView(favouriteTip, arrowEdge: .top)
                                    .padding(.horizontal, 4)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                            Divider().padding(.leading, 50)
                            settingsRow(icon: "square.and.arrow.up", label: "Share")
                        }
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                        HStack(spacing: 8) {
                            Button("Hide tips") {
                                withAnimation(.spring(response: 0.4)) { tipVisible2 = false; tipVisible3 = false }
                            }.smallTipButton(color: .animCoral)
                            Button("Show tips") {
                                withAnimation(.spring(response: 0.4)) { tipVisible2 = true; tipVisible3 = true }
                            }.smallTipButton(color: .tkAmber)
                        }
                    }
                    .animation(.spring(response: 0.4), value: tipVisible2)
                    .animation(.spring(response: 0.4), value: tipVisible3)
                }
            }
        }
    }

    func edgeName(_ edge: Edge) -> String {
        switch edge { case .top: "top"; case .bottom: "bottom"; case .leading: "leading"; case .trailing: "trailing" }
    }

    func settingsRow(icon: String, label: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 16)).foregroundStyle(Color.tkAmber).frame(width: 30)
            Text(label).font(.system(size: 14))
            Spacer()
            Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(Color(.systemGray3))
        }
        .padding(.horizontal, 14).padding(.vertical, 12)
    }

    func codeSnip(_ text: String) -> some View {
        Text(text).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.tkAmber)
            .padding(8).background(Color.tkAmberLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private extension View {
    func smallTipButton(color: Color) -> some View {
        self.font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 8)
            .background(color).clipShape(RoundedRectangle(cornerRadius: 8))
            .buttonStyle(PressableButtonStyle())
    }

    func tipBackground(_ color: Color) -> some View {
        self.background(color).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct TKInlineTipExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "TipView - inline tip card")
            Text("TipView renders a tip as an inline card in your layout. It adapts its height to content, shows image/title/message/actions, and animates in/out. Use it between content rows or at the top of a screen.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "TipView(myTip) - basic inline card. Appears in the view hierarchy like any other view.", color: .tkAmber)
                StepRow(number: 2, text: "TipView(myTip, arrowEdge: .bottom) - adds an arrow pointing to a specific edge.", color: .tkAmber)
                StepRow(number: 3, text: "arrowEdge: nil - disables the arrow entirely for standalone cards.", color: .tkAmber)
                StepRow(number: 4, text: ".tipBackground(Color) - customise the tip card's background colour.", color: .tkAmber)
                StepRow(number: 5, text: "Wrap in if tip.status == .available { TipView(tip) } for conditional display.", color: .tkAmber)
                StepRow(number: 6, text: ".transition() on the TipView - controls insertion/removal animation.", color: .tkAmber)
            }

            CalloutBox(style: .info, title: "TipView takes space in the layout", contentBody: "Unlike .popoverTip(), TipView is part of the layout flow. When it appears, it pushes other views. If the tip is dismissed, the space collapses. Wrap in a conditional if statement for smooth animated layout changes.")

            CodeBlock(code: """
struct FeatureView: View {
    let tip = SearchTip()

    var body: some View {
        VStack {
            // Show tip only when eligible
            if tip.status == .available {
                TipView(tip, arrowEdge: .bottom)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            searchBarContent
        }
        .animation(.spring(), value: tip.status)
    }
}

// With background colour
TipView(myTip)
    .background(.yellow.opacity(0.1))
    .clipShape(RoundedRectangle(cornerRadius: 12))

// Custom styling
TipView(myTip)
    .tipViewStyle(MyCustomTipViewStyle())
""")
        }
    }
}

