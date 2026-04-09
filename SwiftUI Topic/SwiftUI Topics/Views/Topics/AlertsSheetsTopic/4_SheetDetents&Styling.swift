//
//
//  4_SheetDetents&Styling.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Sheet Detents & Styling
struct SheetDetentsVisual: View {
    @State private var showSheet         = false
    @State private var selectedDetent    = PresentationDetent.medium
    @State private var selectedDentOption = 0
    @State private var showIndicator     = true
    @State private var bgMaterial        = 0
    @State private var cornerRadius: CGFloat = 20
    @State private var allowInteraction  = false
    @State private var selectedDemo      = 0

    let demos = ["Detents", "Appearance", "Interaction"]

    let detentOptions: [(name: String, desc: String, detent: PresentationDetent)] = [
        (".medium",        "Half screen",       .medium),
        (".large",         "Full screen",        .large),
        (".height(200)",   "Fixed 200pt",        .height(200)),
        (".fraction(0.4)", "40% of screen",      .fraction(0.4)),
    ]

    let materials = ["default bg", ".regularMaterial", ".thinMaterial", "Color.asRedLight"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Sheet detents & styling", systemImage: "arrow.up.and.down.square.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.asRed)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 12, weight: selectedDemo == i ? .semibold : .regular))
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
                    // Detent picker + height visualisation
                    VStack(spacing: 12) {
                        VStack(spacing: 6) {
                            ForEach(detentOptions.indices, id: \.self) { i in
                                Button {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedDentOption = i
                                        selectedDetent = detentOptions[i].detent
                                    }
                                } label: {
                                    HStack(spacing: 10) {
                                        Text(detentOptions[i].name)
                                            .font(.system(size: 11, weight: selectedDentOption == i ? .semibold : .regular, design: .monospaced))
                                            .foregroundStyle(selectedDentOption == i ? Color.asRed : .primary)
                                        Text(detentOptions[i].desc)
                                            .font(.system(size: 11)).foregroundStyle(.secondary)
                                        Spacer()
                                        if selectedDentOption == i {
                                            Image(systemName: "checkmark").font(.system(size: 10, weight: .bold)).foregroundStyle(Color.asRed)
                                        }
                                    }
                                    .padding(.horizontal, 12).padding(.vertical, 8)
                                    .background(selectedDentOption == i ? Color.asRedLight : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 9))
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }

                        // Visual height bar
                        GeometryReader { geo in
                            ZStack(alignment: .bottom) {
                                RoundedRectangle(cornerRadius: 10).stroke(Color(.systemFill), lineWidth: 1)
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.asRed.opacity(0.15))
                                    .frame(height: geo.size.height * heightFraction(selectedDentOption))
                                    .animation(.spring(response: 0.4), value: selectedDentOption)
                            }
                        }
                        .frame(height: 50)

                        Button {
                            showSheet = true
                        } label: {
                            Text("Open sheet with \(detentOptions[selectedDentOption].name)")
                                .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 11)
                                .background(Color.asRed).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressableButtonStyle())
                        .sheet(isPresented: $showSheet) {
                            sheetContent
                                .presentationDetents([selectedDetent])
                                .presentationDragIndicator(showIndicator ? .visible : .hidden)
                        }
                    }

                case 1:
                    // Appearance
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Toggle("Drag indicator", isOn: $showIndicator).tint(.asRed).font(.system(size: 12))
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Background").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            HStack(spacing: 6) {
                                ForEach(materials.indices, id: \.self) { i in
                                    Button {
                                        withAnimation(.spring(response: 0.3)) { bgMaterial = i }
                                    } label: {
                                        Text(["default", ".regular", ".thin", "color"][i])
                                            .font(.system(size: 9, weight: bgMaterial == i ? .semibold : .regular))
                                            .foregroundStyle(bgMaterial == i ? Color.asRed : .secondary)
                                            .padding(.horizontal, 6).padding(.vertical, 4)
                                            .background(bgMaterial == i ? Color.asRedLight : Color(.systemFill))
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }
                        }
                        HStack(spacing: 8) {
                            Text("Corner radius").font(.system(size: 11)).foregroundStyle(.secondary).frame(width: 80)
                            Slider(value: $cornerRadius, in: 0...40, step: 2).tint(.asRed)
                            Text("\(Int(cornerRadius))").font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.asRed).frame(width: 24)
                        }
                        Button {
                            showSheet = true
                        } label: {
                            Text("Open styled sheet")
                                .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 11)
                                .background(Color.asRed).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressableButtonStyle())
                        .sheet(isPresented: $showSheet) {
                            sheetContent
                                .presentationDetents([.medium])
                                .presentationDragIndicator(showIndicator ? .visible : .hidden)
                                .presentationCornerRadius(cornerRadius)
                                .modifier(SheetBgModifier(index: bgMaterial))
                        }
                    }

                default:
                    // Background interaction
                    VStack(spacing: 10) {
                        Toggle("Background interaction", isOn: $allowInteraction).tint(.asRed).font(.system(size: 12))
                        Text(allowInteraction
                             ? "Sheet is open but you can still tap the counter below"
                             : "Default: background dimmed and non-interactive")
                            .font(.system(size: 11)).foregroundStyle(.secondary)

                        Button {
                            showSheet = true
                        } label: {
                            Text("Open sheet")
                                .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 11)
                                .background(Color.asRed).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressableButtonStyle())
                        .sheet(isPresented: $showSheet) {
                            sheetContent
                                .presentationDetents([.fraction(0.35)])
                                .presentationBackgroundInteraction(allowInteraction ? .enabled : .disabled)
                                .presentationDragIndicator(.visible)
                        }
                    }
                }
            }
        }
    }

    var sheetContent: some View {
        VStack(spacing: 14) {
            Image(systemName: "rectangle.bottomhalf.inset.filled").font(.system(size: 40)).foregroundStyle(Color.asRed)
            Text("Sheet content").font(.system(size: 18, weight: .bold))
            Text("Swipe or tap Done to dismiss").font(.system(size: 12)).foregroundStyle(.secondary)
            Button("Done") { showSheet = false }.buttonStyle(.borderedProminent).tint(.asRed)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func heightFraction(_ idx: Int) -> CGFloat {
        switch idx {
        case 0: return 0.5
        case 1: return 0.95
        case 2: return 0.25
        case 3: return 0.4
        default: return 0.5
        }
    }
}

struct SheetBgModifier: ViewModifier {
    let index: Int
    func body(content: Content) -> some View {
        switch index {
        case 1: content.presentationBackground(.regularMaterial)
        case 2: content.presentationBackground(.thinMaterial)
        case 3: content.presentationBackground(Color.asRedLight)
        default: content
        }
    }
}

struct SheetDetentsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Sheet detents & styling")
            Text("Detents define the resting heights for a sheet. Styling modifiers control the background, corner radius, drag indicator, and background interaction. All go inside the sheet's content closure, not on the triggering view.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".presentationDetents([.medium, .large]) - allows drag between two heights.", color: .asRed)
                StepRow(number: 2, text: ".presentationDragIndicator(.visible / .hidden) - show or hide the pill handle.", color: .asRed)
                StepRow(number: 3, text: ".presentationBackground(.regularMaterial) - frosted glass background.", color: .asRed)
                StepRow(number: 4, text: ".presentationCornerRadius(32) - customize the top corner radius.", color: .asRed)
                StepRow(number: 5, text: ".presentationBackgroundInteraction(.enabled) - allow tapping through to content behind.", color: .asRed)
                StepRow(number: 6, text: ".interactiveDismissDisabled(true) - prevent swipe-to-dismiss. Always provide a close button.", color: .asRed)
            }

            CalloutBox(style: .info, title: "All presentation modifiers go inside the sheet", contentBody: ".presentationDetents, .presentationBackground, .presentationCornerRadius - all applied on the content view inside the sheet closure, not on the trigger button or the .sheet modifier itself.")

            CodeBlock(code: """
.sheet(isPresented: $show) {
    SheetContent()
        // Height
        .presentationDetents([.medium, .large])
        // Or specific sizes
        .presentationDetents([.height(300), .fraction(0.7)])

        // Visual
        .presentationDragIndicator(.visible)
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(28)

        // Behavior
        .presentationBackgroundInteraction(
            .enabled(upThrough: .medium)
        )
        .interactiveDismissDisabled(isFormDirty)
}
""")
        }
    }
}

