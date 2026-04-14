//
//
//  3_popoverTipFloatingTips.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import TipKit



// MARK: - LESSON 3: popoverTip - Floating Tips
struct TKPopoverTipVisual: View {
    @State private var selectedDemo   = 0
    @State private var showPopover1   = false
    @State private var showPopover2   = false
    @State private var showPopover3   = false
    @State private var selectedTab    = 0
    let demos = ["Button anchor", "Toolbar anchor", "Comparison"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("popoverTip - floating tips", systemImage: "arrow.up.message.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tkAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; showPopover1 = false; showPopover2 = false; showPopover3 = false }
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
                    // Button anchors
                    VStack(spacing: 14) {
                        Text("The popover arrow points to the anchored view").font(.system(size: 11)).foregroundStyle(.secondary)

                        // Row of buttons with popovers
                        HStack(spacing: 16) {
                            Spacer()
                            Button {
                                withAnimation { showPopover1.toggle() }
                            } label: {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 22)).foregroundStyle(showPopover1 ? Color.animCoral : .secondary)
                                    .frame(width: 44, height: 44)
                                    .background(Color(.systemFill))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(PressableButtonStyle())
                            .popover(isPresented: $showPopover1) {
                                simulatedPopoverTip(tip: FavouriteTip(), onDismiss: { showPopover1 = false })
                            }

                            Button {
                                withAnimation { showPopover2.toggle() }
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 20)).foregroundStyle(showPopover2 ? Color.tkAmber : .secondary)
                                    .frame(width: 44, height: 44)
                                    .background(Color(.systemFill))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(PressableButtonStyle())
                            .popover(isPresented: $showPopover2) {
                                simulatedPopoverTip(tip: ShareTip(), onDismiss: { showPopover2 = false })
                            }

                            Button {
                                withAnimation { showPopover3.toggle() }
                            } label: {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 20)).foregroundStyle(showPopover3 ? Color.tkGold : .secondary)
                                    .frame(width: 44, height: 44)
                                    .background(Color(.systemFill))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(PressableButtonStyle())
                            .popover(isPresented: $showPopover3) {
                                simulatedPopoverTip(tip: ProFeatureTip(), onDismiss: { showPopover3 = false })
                            }
                            Spacer()
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.tkAmber)
                            Text("Tap the icons to see popover tips. In real code use .popoverTip(tip) - simulated here with .popover().")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tkAmberLight).clipShape(RoundedRectangle(cornerRadius: 8))

                        codeSnip(".popoverTip(myTip)\n// or with arrow edge:\n.popoverTip(myTip, arrowEdge: .top)\n// dismiss on action:\n.popoverTip(myTip) { action in\n    if action.id == \"done\" { tip.invalidate(reason: .actionPerformed) }\n}")
                    }

                case 1:
                    // Toolbar usage
                    VStack(spacing: 10) {
                        NavigationStack {
                            List {
                                ForEach(1...4, id: \.self) { i in
                                    HStack(spacing: 10) {
                                        Image(systemName: "doc.fill").foregroundStyle(Color.tkAmber)
                                        Text("Document \(i)").font(.system(size: 13))
                                    }
                                }
                            }
                            .navigationTitle("Files")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        withAnimation { showPopover1.toggle() }
                                    } label: {
                                        Image(systemName: "plus")
                                    }
                                    .popover(isPresented: $showPopover1) {
                                        simulatedPopoverTip(tip: WelcomeTip(), onDismiss: { showPopover1 = false })
                                    }
                                }
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button {
                                        withAnimation { showPopover2.toggle() }
                                    } label: {
                                        Image(systemName: "magnifyingglass")
                                    }
                                    .popover(isPresented: $showPopover2) {
                                        simulatedPopoverTip(tip: SearchTip(), onDismiss: { showPopover2 = false })
                                    }
                                }
                            }
                        }
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemFill), lineWidth: 0.5))

                        codeSnip("// In toolbar:\nToolbarItem(placement: .navigationBarTrailing) {\n    Button(\"Add\") { }\n        .popoverTip(addTip)  // arrow points to the button\n}")
                    }

                default:
                    // TipView vs popoverTip comparison
                    VStack(spacing: 8) {
                        comparisonRow(
                            icon1: "rectangle.badge.plus",     title1: "TipView",
                            icon2: "arrow.up.message.fill",    title2: ".popoverTip",
                            rows: [
                                ("Layout", "Takes space in layout flow", "Floats above content - no layout impact"),
                                ("Best for", "Feature intro cards, onboarding", "Specific UI elements (buttons, icons)"),
                                ("Arrow", "Points from the card edge", "Points to the anchored view"),
                                ("Dismiss", "User taps × in top corner", "User taps outside or × in popover"),
                                ("Placement", "Between views in a VStack/List", "Attached via .popoverTip() modifier"),
                            ]
                        )
                    }
                }
            }
        }
    }

    func simulatedPopoverTip(tip: any Tip, onDismiss: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                tip.image?.font(.system(size: 24)).foregroundStyle(Color.tkAmber)
                VStack(alignment: .leading, spacing: 4) {
                    tip.title.font(.system(size: 13, weight: .semibold))
                    tip.message?.font(.system(size: 11)).foregroundStyle(.secondary)
                }
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Color(.systemGray3)).font(.system(size: 16))
                }.buttonStyle(PressableButtonStyle())
            }
        }
        .padding(14)
        .frame(width: 260)
        .presentationCompactAdaptation(.popover)
    }

    func codeSnip(_ text: String) -> some View {
        Text(text).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.tkAmber)
            .padding(7).background(Color.tkAmberLight).clipShape(RoundedRectangle(cornerRadius: 7))
    }

    func comparisonRow(icon1: String, title1: String, icon2: String, title2: String, rows: [(String, String, String)]) -> some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                Label(title1, systemImage: icon1).font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.tkAmber).frame(maxWidth: .infinity)
                Label(title2, systemImage: icon2).font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.navBlue).frame(maxWidth: .infinity)
            }
            Divider()
            ForEach(rows, id: \.0) { row in
                HStack(alignment: .top, spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(row.0).font(.system(size: 9, weight: .semibold)).foregroundStyle(.secondary)
                        Text(row.1).font(.system(size: 10)).foregroundStyle(Color.tkAmber)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    VStack(alignment: .leading, spacing: 2) {
                        Text(row.0).font(.system(size: 9, weight: .semibold)).foregroundStyle(.secondary)
                        Text(row.2).font(.system(size: 10)).foregroundStyle(Color.navBlue)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(6).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
    }
}

struct TKPopoverTipExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: ".popoverTip() - floating tip")
            Text(".popoverTip() attaches a floating tip popover to any view. The arrow automatically points to the anchored view. Unlike TipView, it doesn't affect layout. Ideal for toolbar buttons, action icons, and specific UI elements.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".popoverTip(myTip) - attach to any view. Appears when the tip becomes eligible.", color: .tkAmber)
                StepRow(number: 2, text: ".popoverTip(myTip, arrowEdge: .bottom) - control which edge the arrow appears on.", color: .tkAmber)
                StepRow(number: 3, text: "Dismiss callback: .popoverTip(tip) { action in } - handle action button taps.", color: .tkAmber)
                StepRow(number: 4, text: "Works on any view: buttons, images, toolbar items, list rows.", color: .tkAmber)
                StepRow(number: 5, text: "Only one popover tip appears at a time - TipKit queues them.", color: .tkAmber)
            }

            CodeBlock(code: """
// Basic popover tip
Button("Share") { shareAction() }
    .popoverTip(ShareTip())

// With arrow edge
Image(systemName: "star.fill")
    .popoverTip(FavouriteTip(), arrowEdge: .bottom)

// Handle action callbacks
Button("Search") { }
    .popoverTip(SearchTip()) { action in
        switch action.id {
        case "learn-more":
            showLearnMore = true
        default:
            break
        }
        // Tip auto-invalidates after action
    }

// Toolbar tip
.toolbar {
    ToolbarItem(placement: .navigationBarTrailing) {
        Button("+", action: add)
            .popoverTip(AddItemTip(), arrowEdge: .top)
    }
}
""")
        }
    }
}
