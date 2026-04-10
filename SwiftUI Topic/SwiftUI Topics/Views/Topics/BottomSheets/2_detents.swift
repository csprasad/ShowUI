//
//
//  2_detents.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

//TODO: - Error were here in main file

// MARK: - LESSON 2: Detents
struct DetentsVisual: View {
    @State private var showSheet = false
    @State private var selectedDetent: String = "medium"
 
    let detentOptions: [(name: String, label: String, detent: PresentationDetent)] = [
        ("medium",   ".medium - half screen",         .medium),
        ("large",    ".large - full screen",           .large),
        ("height200","height(200) - fixed 200pt",      .height(200)),
        ("frac035",  "fraction(0.35) - 35% screen",   .fraction(0.35)),
        ("frac075",  "fraction(0.75) - 75% screen",   .fraction(0.75)),
    ]
 
    var currentDetent: PresentationDetent {
        detentOptions.first { $0.name == selectedDetent }?.detent ?? .medium
    }
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                headerView
                diagramView
                optionsListView
                actionButtonView
            }
        }
    }

    // MARK: - Extracted Subviews
    
    private var headerView: some View {
        Label("Detents", systemImage: "arrow.up.and.down.square.fill")
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Color.sheetGreen)
    }

    private var diagramView: some View {
        GeometryReader { geo in
            let fraction = detentFraction(selectedDetent)
            let currentLabel = detentOptions.first { $0.name == selectedDetent }?.label ?? ""
            
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemFill), lineWidth: 1.5)
 
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.sheetGreen.opacity(0.15))
                    .frame(height: geo.size.height * fraction)
                    .overlay(alignment: .top) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.sheetGreen.opacity(0.3))
                            .frame(height: 3)
                    }
                
                Text(currentLabel)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(Color.sheetGreen)
                    .padding(.bottom, geo.size.height * fraction + 6)
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedDetent)
        }
        .frame(height: 120)
    }

    private var optionsListView: some View {
        VStack(spacing: 6) {
            ForEach(detentOptions, id: \.name) { option in
                detentButton(for: option)
            }
        }
    }

    private func detentButton(for option: (name: String, label: String, detent: PresentationDetent)) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedDetent = option.name
            }
        } label: {
            HStack {
                Text(option.label)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(selectedDetent == option.name ? Color.sheetGreen : .primary)
                Spacer()
                if selectedDetent == option.name {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.sheetGreen)
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(selectedDetent == option.name ? Color.sheetGreenLight : Color(.systemFill))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(PressableButtonStyle())
    }

    private var actionButtonView: some View {
        Button {
            showSheet = true
        } label: {
            Text("Open sheet with selected detent")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(Color.sheetGreen)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PressableButtonStyle())
        .sheet(isPresented: $showSheet) {
            let label = detentOptions.first { $0.name == selectedDetent }?.label ?? ""
            MockSheetContent(title: label)
                .presentationDetents([currentDetent])
                .presentationDragIndicator(.visible)
        }
    }
 
    // MARK: - Logic Helpers
    
    func detentFraction(_ name: String) -> CGFloat {
        switch name {
        case "medium":   return 0.50
        case "large":    return 0.95
        case "height200":return 0.30
        case "frac035":  return 0.35
        case "frac075":  return 0.75
        default:         return 0.50
        }
    }
}

struct DetentsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Presentation detents")
            Text("A detent defines a resting height for a sheet. Without detents, sheets are full-screen by default. Adding .presentationDetents() gives the sheet specific stopping points as the user drags.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: ".medium - half the screen height. The most common detent for quick actions.", color: .sheetGreen)
                StepRow(number: 2, text: ".large - full screen height. The default when no detents are specified.", color: .sheetGreen)
                StepRow(number: 3, text: ".height(200) - fixed pixel height. Use for sheets with fixed content.", color: .sheetGreen)
                StepRow(number: 4, text: ".fraction(0.35) - percentage of screen height. Adapts to all screen sizes.", color: .sheetGreen)
                StepRow(number: 5, text: "Custom - conform to CustomPresentationDetent to compute height from context (font size, screen dimensions).", color: .sheetGreen)
            }
 
            CalloutBox(style: .success, title: "fraction over height", contentBody: ".fraction is almost always better than .height for production apps, because it adapts to different iPhone screen sizes, Dynamic Type sizes, and landscape orientation automatically.")
 
            CalloutBox(style: .info, title: "iOS 16+ required", contentBody: ".presentationDetents was introduced in iOS 16. For iOS 15 support, use third-party solutions or a custom sheet implementation with DragGesture.")
 
            CodeBlock(code: """
// Single detent
.sheet(isPresented: $show) {
    ContentView()
        .presentationDetents([.medium])
}
 
// Multiple detents - user can drag between them
.presentationDetents([.medium, .large])
 
// Fixed height
.presentationDetents([.height(300)])
 
// Fraction of screen
.presentationDetents([.fraction(0.4)])
 
// Custom detent
struct SmallDetent: CustomPresentationDetent {
    static func height(in context: Context) -> CGFloat? {
        context.maxDetentValue * 0.3
    }
}
.presentationDetents([.custom(SmallDetent.self)])
""")
        }
    }
}
