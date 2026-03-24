//
//
//  3_multipleDetents.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Multiple Detents
struct MultipleDetentsVisual: View {
    @State private var showSheet = false
    @State private var selectedDetentBinding = PresentationDetent.medium
    @State private var selectedPreset = 0
 
    let presets: [(name: String, detents: [PresentationDetent], description: String)] = [
        ("Map style",       [.fraction(0.15), .medium, .large],  "Small peek → half → full. Classic maps sheet pattern."),
        ("Content browser", [.medium, .large],                    "Half or full. Standard for content lists."),
        ("Quick actions",   [.fraction(0.35), .large],           "Compact tray or full. Good for action sheets."),
        ("Fixed + expand",  [.height(140), .large],              "Fixed small size that can expand to full."),
    ]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Multiple detents", systemImage: "rectangle.split.3x1.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sheetGreen)
 
                // Preset selector
                VStack(spacing: 6) {
                    ForEach(presets.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedPreset = i }
                        } label: {
                            HStack(spacing: 10) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(presets[i].name)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(selectedPreset == i ? Color.sheetGreen : .primary)
                                    Text(presets[i].description)
                                        .font(.system(size: 11))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                // Mini detent diagram
                                HStack(spacing: 2) {
                                    ForEach(0..<presets[i].detents.count, id: \.self) { j in
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(selectedPreset == i ? Color.sheetGreen : Color(.systemGray4))
                                            .frame(width: 6, height: CGFloat(j + 1) * 8 + 8)
                                    }
                                }
                            }
                            .padding(.horizontal, 12).padding(.vertical, 10)
                            .background(selectedPreset == i ? Color.sheetGreenLight : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
 
                Button {
                    selectedDetentBinding = presets[selectedPreset].detents.first ?? .medium
                    showSheet = true
                } label: {
                    Text("Open & drag to see all detents")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(Color.sheetGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PressableButtonStyle())
                .sheet(isPresented: $showSheet) {
                    MultiDetentSheetContent(
                        detents: presets[selectedPreset].detents,
                        selectedDetent: $selectedDetentBinding
                    )
                }
            }
        }
    }
}
 
struct MultiDetentSheetContent: View {
    let detents: [PresentationDetent]
    @Binding var selectedDetent: PresentationDetent
    @Environment(\.dismiss) var dismiss
 
    var detentName: String {
        switch selectedDetent {
        case .medium: return ".medium"
        case .large:  return ".large"
        default:      return "custom"
        }
    }
 
    var body: some View {
        VStack(spacing: 10) {
            // Drag indicator
            Capsule()
                .fill(Color(.systemFill))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
 
            Image(systemName: detents.count == 2 ? "rectangle.split.2x1.fill" : "rectangle.split.3x1.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color.sheetGreen)
 
            Text("Drag to resize")
                .font(.system(size: 20, weight: .bold))
 
            Text("Current detent: \(detentName)")
                .font(.system(size: 14, design: .monospaced))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16).padding(.vertical, 8)
                .background(Color.sheetGreenLight)
                .clipShape(Capsule())
 
            Text("\(detents.count) detents available: Drag the sheet up or down to snap between them")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
 
            Spacer()
        }
        .presentationDetents(Set(detents), selection: $selectedDetent)
        .presentationDragIndicator(.hidden) // custom indicator above
    }
}

#Preview {
    MultipleDetentsVisual()
}
 
struct MultipleDetentsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Multiple detents")
            Text("Pass multiple detents to let the user drag between defined sizes. The sheet snaps to each detent as the user drags. A selectedDetent binding lets you read or programmatically set the current size.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: ".presentationDetents([.medium, .large]) — two stopping points. User drags between them.", color: .sheetGreen)
                StepRow(number: 2, text: "Pass a Set, not an Array — order doesn't matter, detents are sorted by height automatically.", color: .sheetGreen)
                StepRow(number: 3, text: "selection: $selectedDetent — Binding<PresentationDetent> lets you read the current size or set it programmatically.", color: .sheetGreen)
                StepRow(number: 4, text: "Programmatically change size by assigning to the binding, and the sheet animates to the new detent.", color: .sheetGreen)
            }
 
            CalloutBox(style: .success, title: "The maps pattern", contentBody: "[.fraction(0.15), .medium, .large] — a tiny peek, a half-sheet, and full screen. This is the pattern Apple uses in Maps and it's the most versatile multi-detent setup.")
 
            CalloutBox(style: .info, title: "Programmatic size changes", contentBody: "Assign to the selectedDetent binding from a button inside the sheet to animate it to a different size. e.g. a 'Expand' button that jumps from .medium to .large.")
 
            CodeBlock(code: """
@State private var selectedDetent = PresentationDetent.medium
 
.sheet(isPresented: $show) {
    SheetContent()
        .presentationDetents(
            [.fraction(0.15), .medium, .large],
            selection: $selectedDetent
        )
}
 
// Read current size
Text("Current: \\(selectedDetent == .medium ? "half" : "full")")
 
// Programmatically expand
Button("Expand") {
    withAnimation { selectedDetent = .large }
}
""")
        }
    }
}
 
