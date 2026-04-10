//
//
//  4_dragIndicator.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Drag Indicator
struct DragIndicatorVisual: View {
    @State private var showSheet = false
    @State private var showIndicator = true
    @State private var selectedScenario = 0
 
    let scenarios = [
        (name: "Show",   desc: "Scrollable or resizable content - user needs to know they can drag"),
        (name: "Hide",   desc: "Fixed-height sheet with no drag - indicator would be misleading"),
        (name: "Auto",   desc: "SwiftUI decides based on detents - shown when multiple detents exist"),
    ]
 
    var indicator: Visibility {
        switch selectedScenario {
        case 0: return .visible
        case 1: return .hidden
        default: return .automatic
        }
    }
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Drag indicator", systemImage: "minus.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sheetGreen)
 
                // Visual mock of indicator
                ZStack {
                    Color(.secondarySystemBackground)
                    VStack(spacing: 12) {
                        // Mock sheet with/without indicator
                        VStack(spacing: 0) {
                            // Sheet top
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(.systemBackground))
                                .frame(maxWidth: .infinity)
                                .frame(height: 80)
                                .shadow(color: .black.opacity(0.1), radius: 10, y: -2)
                                .overlay(alignment: .top) {
                                    VStack(spacing: 6) {
                                        if selectedScenario != 1 {
                                            Capsule()
                                                .fill(Color(.systemGray4))
                                                .frame(width: 36, height: 5)
                                                .padding(.top, 8)
                                                .transition(.opacity.combined(with: .scale))
                                        } else {
                                            Capsule()
                                                .fill(Color.clear)
                                                .frame(width: 36, height: 5)
                                                .padding(.top, 8)
                                        }
                                        Text(selectedScenario == 1 ? "No indicator" : "Drag me")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(.secondary)
                                    }
                                }
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.35), value: selectedScenario)
 
                // Scenario selector
                VStack(spacing: 6) {
                    ForEach(scenarios.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedScenario = i }
                        } label: {
                            HStack(spacing: 10) {
                                Text(".\(scenarios[i].name.lowercased())")
                                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                    .foregroundStyle(selectedScenario == i ? Color.sheetGreen : .primary)
                                    .frame(width: 64, alignment: .leading)
                                Text(scenarios[i].desc)
                                    .font(.system(size: 11))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                                Spacer()
                            }
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(selectedScenario == i ? Color.sheetGreenLight : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
 
                Button {
                    showSheet = true
                } label: {
                    Text("Open sheet")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(Color.sheetGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PressableButtonStyle())
                .sheet(isPresented: $showSheet) {
                    MockSheetContent(title: "Drag indicator: .\(scenarios[selectedScenario].name.lowercased())")
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(indicator)
                }
            }
        }
    }
}
 
struct DragIndicatorExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Drag indicator")
            Text("The drag indicator is the small pill-shaped handle at the top of a sheet. It signals to users that the sheet is draggable. Whether to show it depends entirely on context, not every sheet should have one.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: ".presentationDragIndicator(.visible) - always show. Use when the sheet has multiple detents or scrollable content.", color: .sheetGreen)
                StepRow(number: 2, text: ".presentationDragIndicator(.hidden) - never show. Use for fixed-height non-draggable sheets.", color: .sheetGreen)
                StepRow(number: 3, text: ".presentationDragIndicator(.automatic) - SwiftUI decides. Shows when multiple detents exist, hides for single detent.", color: .sheetGreen)
            }
 
            CalloutBox(style: .info, title: "When to show", contentBody: "Show the indicator when the sheet is resizable (multiple detents) or when it contains a ScrollView. The indicator tells users they can interact with the sheet's height, and don't show it if they can't.")
 
            CalloutBox(style: .warning, title: "The indicator doesn't prevent dismissal", contentBody: "Hiding the indicator doesn't lock the sheet. Users can still swipe down to dismiss. To prevent dismissal, use .interactiveDismissDisabled() covered in Lesson 8.")
 
            CodeBlock(code: """
// Always show
.sheet(isPresented: $show) {
    Content()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
}
 
// Always hide
.sheet(isPresented: $show) {
    Content()
        .presentationDetents([.height(200)])
        .presentationDragIndicator(.hidden)
}
 
// Let SwiftUI decide (default)
.presentationDragIndicator(.automatic)
""")
        }
    }
}
