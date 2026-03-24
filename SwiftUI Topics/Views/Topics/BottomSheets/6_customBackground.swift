//
//
//  6_customBackground.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Custom Background
struct CustomBackgroundVisual: View {
    @State private var showSheet = false
    @State private var selectedBackground = 0
 
    struct BGOption {
        let name: String
        let preview: Color
        let description: String
    }
 
    let options: [BGOption] = [
        BGOption(name: ".regularMaterial",  preview: Color(.systemBackground).opacity(0.8), description: "Frosted glass — standard blur"),
        BGOption(name: ".thickMaterial",    preview: Color(.systemBackground).opacity(0.95), description: "Heavier blur — more opaque"),
        BGOption(name: ".ultraThinMaterial",preview: Color(.systemBackground).opacity(0.5), description: "Light blur — very translucent"),
        BGOption(name: "Color.sheetGreen",  preview: Color.sheetGreenLight, description: "Solid color background"),
        BGOption(name: ".clear",            preview: Color.clear, description: "Transparent — see through"),
    ]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                headerLabel
                optionsListView
                triggerButton
            }
        }
    }

    // MARK: - Sub-components

    private var headerLabel: some View {
        Label("Custom background", systemImage: "paintpalette.fill")
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Color.sheetGreen)
    }

    private var optionsListView: some View {
        VStack(spacing: 6) {
            ForEach(options.indices, id: \.self) { i in
                optionRow(index: i)
            }
        }
    }

    private func optionRow(index i: Int) -> some View {
        let option = options[i] // Localize the lookup to help the compiler
        let isSelected = selectedBackground == i

        return Button {
            withAnimation(.spring(response: 0.3)) { selectedBackground = i }
        } label: {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(option.preview)
                    .frame(width: 28, height: 28)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(.systemFill), lineWidth: 1))
 
                VStack(alignment: .leading, spacing: 1) {
                    Text(option.name)
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundStyle(isSelected ? Color.sheetGreen : .primary)
                    Text(option.description)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.sheetGreen)
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(isSelected ? Color.sheetGreenLight : Color(.systemFill))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(PressableButtonStyle())
    }

    private var triggerButton: some View {
        Button {
            showSheet = true
        } label: {
            Text("Open sheet with selected background")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(Color.sheetGreen)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PressableButtonStyle())
        .sheet(isPresented: $showSheet) {
            customBackgroundSheet
        }
    }
 
    @ViewBuilder
    private var customBackgroundSheet: some View {
        let currentOption = options[selectedBackground]
        
        VStack(spacing: 16) {
            Capsule()
                .fill(Color(.systemFill))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
            Image(systemName: "paintpalette.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color.sheetGreen)
            Text(currentOption.name)
                .font(.system(size: 17, weight: .semibold))
            Text(currentOption.description)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
            Spacer()
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(24)
        .modifier(BackgroundModifier(index: selectedBackground))
    }
}
struct BackgroundModifier: ViewModifier {
    let index: Int
 
    func body(content: Content) -> some View {
        switch index {
        case 0: content.presentationBackground(.regularMaterial)
        case 1: content.presentationBackground(.thickMaterial)
        case 2: content.presentationBackground(.ultraThinMaterial)
        case 3: content.presentationBackground(Color.sheetGreenLight)
        default: content.presentationBackground(.clear)
        }
    }
}
 
struct CustomBackgroundExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Custom sheet background")
            Text("presentationBackground controls what fills the sheet's surface. You can use materials (blurs), solid colors, gradients, or even clear. presentationCornerRadius adjusts the top corner rounding.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: ".presentationBackground(.regularMaterial) — frosted glass blur. Standard iOS look.", color: .sheetGreen)
                StepRow(number: 2, text: ".presentationBackground(Color.blue) — solid color. Good for branded sheets.", color: .sheetGreen)
                StepRow(number: 3, text: ".presentationBackground(.clear) — fully transparent. Combine with custom views for floating card effects.", color: .sheetGreen)
                StepRow(number: 4, text: ".presentationCornerRadius(32) — increase the top corner radius. Default is around 10pt.", color: .sheetGreen)
            }
 
            CalloutBox(style: .info, title: "Material blurs the content behind the sheet", contentBody: "Material backgrounds work best with background interaction disabled (default). If you enable background interaction with a material background, the blur may look odd, as the material will bleed into the background. Try use a semi-transparent color instead.")
 
            CalloutBox(style: .success, title: "Large corner radius for modern feel", contentBody: ".presentationCornerRadius(32) with a white or light background gives sheets the modern iOS Maps look. Combine with .presentationDragIndicator(.visible) for the complete effect.")
 
            CodeBlock(code: """
.sheet(isPresented: $show) {
    SheetContent()
        // Background material
        .presentationBackground(.regularMaterial)
        // Or solid color
        .presentationBackground(Color(.systemBackground))
        // Or gradient
        .presentationBackground {
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .top, endPoint: .bottom
            )
        }
        // Corner radius
        .presentationCornerRadius(32)
}
""")
        }
    }
}
