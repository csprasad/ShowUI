//
//
//  5_backgroundInteraction.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Background Interaction
struct BackgroundInteractionVisual: View {
    @State private var showSheet = false
    @State private var selectedMode = 0
    @State private var counter = 0
 
    let modes = [
        (name: "disabled",    desc: "Default - background is dimmed and non-interactive"),
        (name: "enabled",     desc: "Background stays interactive - ap the visible area around the sheet"),
        (name: "upThrough",   desc: "Interactive up to a specific detent, disabled above it"),
    ]
    
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Background interaction", systemImage: "rectangle.and.hand.point.up.left.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.sheetGreen)
                    Spacer()
                    Text("iOS 16.4+")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.sheetGreen)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.sheetGreenLight)
                        .clipShape(Capsule())
                }
 
                // Mode selector
                VStack(spacing: 6) {
                    ForEach(modes.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedMode = i }
                        } label: {
                            HStack(spacing: 10) {
                                Text(".\(modes[i].name)")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                    .foregroundStyle(selectedMode == i ? Color.sheetGreen : .primary)
                                    .frame(width: 90, alignment: .leading)
                                Text(modes[i].desc)
                                    .font(.system(size: 11))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                                Spacer()
                            }
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(selectedMode == i ? Color.sheetGreenLight : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
 
                // Counter button - interactive behind sheet in enabled mode
                HStack(spacing: 10) {
                    Button {
                        withAnimation { counter += 1 }
                    } label: {
                        HStack(spacing: 8) {
                            Text("Background taps: \(counter)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.sheetGreen)
                            Spacer()
                            Image(systemName: "hand.tap.fill")
                                .foregroundStyle(Color.sheetGreen)
                        }
                        .padding(.horizontal, 14).padding(.vertical, 11)
                        .background(Color.sheetGreenLight)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(PressableButtonStyle())
                }
 
                Button {
                    showSheet = true
                } label: {
                    Text("Open sheet - then tap background button")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(Color.sheetGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PressableButtonStyle())
                .sheet(isPresented: $showSheet) {
                    backgroundInteractionSheet
                }
            }
        }
    }
 
    @ViewBuilder
    private var backgroundInteractionSheet: some View {
        VStack(spacing: 12) {
            Capsule()
                .fill(Color(.systemFill))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
            Text("Sheet is open")
                .font(.system(size: 17, weight: .semibold))
            Text(selectedMode == 0
                 ? "Background is dimmed, you can't tap it"
                 : "Try tapping the green button behind this sheet")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Text("Background taps so far: \(counter)")
                .font(.system(size: 14, weight: .semibold, design: .monospaced))
                .foregroundStyle(Color.sheetGreen)
            Spacer()
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .presentationBackgroundInteraction(
            selectedMode == 0 ? .disabled :
            selectedMode == 1 ? .enabled :
            .enabled(upThrough: .fraction(0.5))
        )
    }
}

struct BackgroundInteractionExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Background interaction - iOS 16.4+")
            Text("By default, a sheet dims and blocks the background. presentationBackgroundInteraction lets the background remain tappable while the sheet is open, enabling map-style UIs where a sheet and a map coexist.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: ".disabled - default. Background is dimmed and non-interactive.", color: .sheetGreen)
                StepRow(number: 2, text: ".enabled - background stays fully interactive. Sheet acts as a non-blocking overlay.", color: .sheetGreen)
                StepRow(number: 3, text: ".enabled(upThrough: .medium) - interactive when sheet is at or below .medium, blocked when expanded.", color: .sheetGreen)
            }
 
            CalloutBox(style: .success, title: "The Maps pattern in your app", contentBody: "Use .enabled(upThrough: .medium) with a map or content view behind the sheet. At the small detent, the user can interact with the map. When they expand the sheet, the background becomes blocked, just like in the Maps app. This is the recommended pattern for building map-style UIs in SwiftUI, as it mirrors exactly how Apple Maps works.")
 
            CalloutBox(style: .warning, title: "Remove the dim when enabling interaction", contentBody: "When background interaction is enabled, also use .presentationBackground(.clear) or a custom background, to remove the dim. This is especially important when using .enabled(upThrough: .medium), as the default dim looks odd if users can interact through it.")
 
            CodeBlock(code: """
// Fully interactive background
.sheet(isPresented: $show) {
    SheetContent()
        .presentationDetents([.fraction(0.3), .large])
        .presentationBackgroundInteraction(.enabled)
}
 
// Interactive only at smaller detent
.presentationBackgroundInteraction(
    .enabled(upThrough: .medium)
)
 
// Default - blocked
.presentationBackgroundInteraction(.disabled)
""")
        }
    }
}
