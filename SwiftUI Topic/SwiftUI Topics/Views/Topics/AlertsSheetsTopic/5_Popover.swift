//
//
//  5_Popover.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Popover
struct PopoverVisual: View {
    @State private var showBasic         = false
    @State private var showInfo          = false
    @State private var showMenu          = false
    @State private var selectedEdge      = 0
    @State private var lastPicked        = "-"
    @State private var selectedDemo      = 0

    let demos  = ["Basic popover", "Info tip", "Picker popover"]
    let edges  = [("top", Edge.top), ("bottom", Edge.bottom), ("leading", Edge.leading), ("trailing", Edge.trailing)]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Popover", systemImage: "bubble.right.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.asRed)

                // iPad note
                HStack(spacing: 6) {
                    Image(systemName: "ipad").font(.system(size: 12)).foregroundStyle(Color.asRed)
                    Text("On iPad: true floating popover with arrow. On iPhone: full-height sheet (no arrow).")
                        .font(.system(size: 11)).foregroundStyle(.secondary)
                }
                .padding(8).background(Color.asRedLight).clipShape(RoundedRectangle(cornerRadius: 8))

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.asRed : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.asRedLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Basic popover with arrow edge selector
                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Text("Arrow edge:").font(.system(size: 12)).foregroundStyle(.secondary)
                            ForEach(edges.indices, id: \.self) { i in
                                Button {
                                    withAnimation(.spring(response: 0.3)) { selectedEdge = i }
                                } label: {
                                    Text(edges[i].0)
                                        .font(.system(size: 10, weight: selectedEdge == i ? .semibold : .regular))
                                        .foregroundStyle(selectedEdge == i ? Color.asRed : .secondary)
                                        .padding(.horizontal, 8).padding(.vertical, 4)
                                        .background(selectedEdge == i ? Color.asRedLight : Color(.systemFill))
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }

                        Button {
                            showBasic = true
                        } label: {
                            Text("Show popover")
                                .font(.system(size: 14, weight: .semibold)).foregroundStyle(.white)
                                .padding(.horizontal, 20).padding(.vertical, 10)
                                .background(Color.asRed).clipShape(Capsule())
                        }
                        .buttonStyle(PressableButtonStyle())
                        .popover(isPresented: $showBasic, arrowEdge: edges[selectedEdge].1) {
                            VStack(spacing: 12) {
                                Text("Popover content")
                                    .font(.system(size: 15, weight: .semibold))
                                Text("arrowEdge: .\(edges[selectedEdge].0)")
                                    .font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary)
                                Button("Dismiss") { showBasic = false }
                                    .buttonStyle(.borderedProminent).tint(.asRed)
                            }
                            .padding(20)
                            .presentationCompactAdaptation(.none) // iPad-style even on iPhone
                        }
                    }

                case 1:
                    // Info tip popover
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Password strength").font(.system(size: 14, weight: .medium))
                            HStack(spacing: 4) {
                                ForEach(0..<4, id: \.self) { i in
                                    RoundedRectangle(cornerRadius: 2).fill(i < 3 ? Color.formGreen : Color(.systemFill)).frame(height: 4)
                                }
                            }
                        }
                        Button {
                            showInfo = true
                        } label: {
                            Image(systemName: "info.circle.fill").font(.system(size: 18)).foregroundStyle(Color.asRed)
                        }
                        .buttonStyle(PressableButtonStyle())
                        .popover(isPresented: $showInfo, arrowEdge: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Password tips", systemImage: "lock.shield.fill")
                                    .font(.system(size: 13, weight: .semibold)).foregroundStyle(Color.asRed)
                                Text("• At least 12 characters\n• Mix uppercase + numbers\n• Use a unique password")
                                    .font(.system(size: 12)).foregroundStyle(.secondary)
                            }
                            .padding(16)
                            .frame(width: 220)
                            .presentationCompactAdaptation(.popover)
                        }
                    }
                    .padding(12).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 12))

                default:
                    // Menu/picker in popover
                    VStack(spacing: 12) {
                        Button {
                            showMenu = true
                        } label: {
                            HStack(spacing: 8) {
                                Text("Sort by: \(lastPicked == "-" ? "Default" : lastPicked)")
                                    .font(.system(size: 13, weight: .medium))
                                Image(systemName: "chevron.up.chevron.down").font(.system(size: 11)).foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 14).padding(.vertical, 9)
                            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PressableButtonStyle())
                        .popover(isPresented: $showMenu) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Sort by").font(.system(size: 12, weight: .semibold)).foregroundStyle(.secondary)
                                    .padding(.horizontal, 12).padding(.top, 10).padding(.bottom, 4)
                                ForEach(["Name", "Date modified", "Size", "Kind"], id: \.self) { option in
                                    Button {
                                        lastPicked = option
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { showMenu = false }
                                    } label: {
                                        HStack {
                                            Text(option).font(.system(size: 14))
                                            Spacer()
                                            if lastPicked == option {
                                                Image(systemName: "checkmark").font(.system(size: 12, weight: .semibold)).foregroundStyle(Color.asRed)
                                            }
                                        }
                                        .padding(.horizontal, 12).padding(.vertical, 9)
                                    }
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }
                            .frame(width: 200).padding(.bottom, 8)
                            .presentationCompactAdaptation(.popover)
                        }

                        if lastPicked != "-" {
                            Text("Sorted by: \(lastPicked)")
                                .font(.system(size: 12)).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }
}

struct PopoverExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Popover")
            Text(".popover presents a floating callout with an arrow pointing to its source. On iPad it behaves as a true floating popover. On iPhone it presents as a sheet by default - control this with .presentationCompactAdaptation.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".popover(isPresented: $bool) { Content() } - attach to the anchor view (the view the arrow points to).", color: .asRed)
                StepRow(number: 2, text: "arrowEdge: .bottom - the arrow points to the bottom of the anchor. Adjust for correct positioning.", color: .asRed)
                StepRow(number: 3, text: ".presentationCompactAdaptation(.none) - on iPhone, show as a real popover (no sheet behavior).", color: .asRed)
                StepRow(number: 4, text: ".presentationCompactAdaptation(.popover) - forces popover style on compact size classes.", color: .asRed)
                StepRow(number: 5, text: "Give popover content a .frame(width:) to prevent it sizing to the full screen on iPad.", color: .asRed)
            }

            CalloutBox(style: .info, title: "arrowEdge points FROM the popover TO the anchor", contentBody: "arrowEdge: .bottom means the arrow is on the bottom edge of the popover, pointing down toward the anchor button. The popover appears above the button.")

            CalloutBox(style: .success, title: "Use popover for contextual info", contentBody: "Great for tooltip-style explanations, inline pickers, contextual menus tied to a specific element, and compact settings panels on iPad. Avoid for complex flows - use .sheet for those.")

            CodeBlock(code: """
// Basic popover
Button("More info") { showPopover = true }
    .popover(isPresented: $showPopover,
             arrowEdge: .bottom) {      // arrow points down to button
        Text("Helpful info here")
            .padding(16)
            .frame(width: 250)
    }

// Force popover on iPhone too
.popover(isPresented: $show) {
    Content()
        .presentationCompactAdaptation(.popover)
}

// Item-driven popover
.popover(item: $selectedItem) { item in
    ItemDetail(item: item)
        .frame(width: 300, height: 200)
}
""")
        }
    }
}
