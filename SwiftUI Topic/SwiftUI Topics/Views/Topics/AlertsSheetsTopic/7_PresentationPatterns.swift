//
//
//  7_PresentationPatterns.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Presentation Patterns
struct PresentationPatternsVisual: View {
    @State private var selectedPattern = 0
    @State private var showBug         = false
    @State private var showFixed       = false
    @State private var outerSheet      = false
    @State private var innerSheet      = false

    let patterns = ["Anchor placement", "Double-present bug", "Nested sheets"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Presentation patterns", systemImage: "arrow.triangle.branch")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.asRed)

                HStack(spacing: 8) {
                    ForEach(patterns.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedPattern = i }
                        } label: {
                            Text(patterns[i])
                                .font(.system(size: 10, weight: selectedPattern == i ? .semibold : .regular))
                                .foregroundStyle(selectedPattern == i ? Color.asRed : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedPattern == i ? Color.asRedLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedPattern {
                case 0:
                    // Anchor placement rules
                    VStack(spacing: 8) {
                        ruleRow(
                            isGood: true,
                            code: "Button { showSheet = true }\n    .sheet(isPresented: $showSheet) { }",
                            desc: "Sheet on the triggering button - correct. Sheet follows the button's lifecycle."
                        )
                        ruleRow(
                            isGood: false,
                            code: "NavigationStack { ... }\n    .sheet(isPresented: $show) { }",
                            desc: "Sheet on NavigationStack - avoid. Modifiers on the stack wrapper don't work correctly."
                        )
                        ruleRow(
                            isGood: true,
                            code: "List { rows }\n    .sheet(isPresented: $show) { }",
                            desc: "Sheet on List content - correct. Stable anchor, reliable presentation."
                        )
                        ruleRow(
                            isGood: false,
                            code: "ForEach(items) { item in\n    row.sheet(isPresented: $show) { }\n}",
                            desc: "Sheet on ForEach row - risky. Each row has its own sheet; only one can present at a time."
                        )
                        ruleRow(
                            isGood: true,
                            code: "List { ForEach(items) { row } }\n    .sheet(item: $selectedItem) { }",
                            desc: "Single sheet on List, driven by item binding - correct pattern for row taps."
                        )
                    }

                case 1:
                    // Double-present bug
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            VStack(spacing: 6) {
                                bugLabel("Bug", color: .animCoral)
                                Text("Two buttons, each with their own .sheet - only one can present at a time. Second button silently fails.")
                                    .font(.system(size: 10)).foregroundStyle(.secondary)
                                VStack(spacing: 6) {
                                    Button("Sheet A") { showBug = true }
                                        .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                                        .frame(maxWidth: .infinity).padding(.vertical, 8)
                                        .background(Color.animCoral).clipShape(RoundedRectangle(cornerRadius: 8))
                                        .buttonStyle(PressableButtonStyle())
                                        .sheet(isPresented: $showBug) {
                                            Text("Sheet A").font(.title2.bold()).padding()
                                                .presentationDetents([.medium])
                                        }
                                    Button("Sheet B") { innerSheet = true }
                                        .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                                        .frame(maxWidth: .infinity).padding(.vertical, 8)
                                        .background(Color.animCoral).clipShape(RoundedRectangle(cornerRadius: 8))
                                        .buttonStyle(PressableButtonStyle())
                                        .sheet(isPresented: $innerSheet) {
                                            Text("Sheet B").font(.title2.bold()).padding()
                                                .presentationDetents([.medium])
                                        }
                                }
                            }
                            .frame(maxWidth: .infinity)

                            VStack(spacing: 6) {
                                bugLabel("Fix ✓", color: .formGreen)
                                Text("One .sheet(item:) on the container. Each button sets the item - only one sheet modifier needed.")
                                    .font(.system(size: 10)).foregroundStyle(.secondary)
                                FixedSheetDemo()
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }

                default:
                    // Nested sheets
                    VStack(spacing: 10) {
                        Text("A sheet can present its own sheet - each sheet is an independent presentation context")
                            .font(.system(size: 11)).foregroundStyle(.secondary)
                        Button {
                            outerSheet = true
                        } label: {
                            Text("Open outer sheet")
                                .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 11)
                                .background(Color.asRed).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressableButtonStyle())
                        .sheet(isPresented: $outerSheet) {
                            VStack(spacing: 16) {
                                Text("Outer sheet").font(.system(size: 18, weight: .bold))
                                Text("This sheet can present its own sheet below").font(.system(size: 12)).foregroundStyle(.secondary)
                                Button("Open inner sheet") { innerSheet = true }
                                    .buttonStyle(.borderedProminent).tint(.asRed)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .presentationDetents([.medium])
                            .sheet(isPresented: $innerSheet) {
                                VStack(spacing: 14) {
                                    Text("Inner sheet").font(.system(size: 18, weight: .bold))
                                    Text("Nested sheet - each is independent").font(.system(size: 12)).foregroundStyle(.secondary)
                                    Button("Close") { innerSheet = false }.buttonStyle(.borderedProminent).tint(.formGreen)
                                }
                                .presentationDetents([.fraction(0.35)])
                            }
                        }
                    }
                }
            }
        }
    }

    func ruleRow(isGood: Bool, code: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: isGood ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 14))
                .foregroundStyle(isGood ? Color.formGreen : Color.animCoral)
                .padding(.top, 1)
            VStack(alignment: .leading, spacing: 3) {
                Text(code).font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(isGood ? Color.formGreen : Color.animCoral)
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }
        .padding(8)
        .background(isGood ? Color(hex: "#E1F5EE") : Color(hex: "#FCEBEB"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func bugLabel(_ text: String, color: Color) -> some View {
        Text(text).font(.system(size: 10, weight: .bold)).foregroundStyle(.white)
            .padding(.horizontal, 8).padding(.vertical, 3).background(color).clipShape(Capsule())
    }
}

struct FixedSheetDemo: View {
    @State private var activeSheet: String? = nil
    var body: some View {
        VStack(spacing: 6) {
            Button("Sheet A") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { activeSheet = "A" }
            }
            .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 8)
            .background(Color.formGreen).clipShape(RoundedRectangle(cornerRadius: 8))
            .buttonStyle(PressableButtonStyle())
            Button("Sheet B") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { activeSheet = "B" }
            }
            .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 8)
            .background(Color.formGreen).clipShape(RoundedRectangle(cornerRadius: 8))
            .buttonStyle(PressableButtonStyle())
        }
        .sheet(item: $activeSheet) { sheet in
            Text("Sheet \(sheet)").font(.title2.bold()).padding()
                .presentationDetents([.medium])
        }
    }
}

struct PresentationPatternsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Presentation patterns & pitfalls")
            Text("Where you attach .sheet, .alert, and .popover matters. SwiftUI presentations are owned by the view they're attached to - if that view disappears, the presentation is dismissed. Following the right patterns prevents subtle bugs.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "One sheet per view - attach only one .sheet modifier per view. Two on the same view means only one can present.", color: .asRed)
                StepRow(number: 2, text: "For multiple sheets from one container, use .sheet(item:) with an enum or optional to switch between content.", color: .asRed)
                StepRow(number: 3, text: "Don't put .sheet on NavigationStack or List - put it on the content view inside.", color: .asRed)
                StepRow(number: 4, text: "ForEach rows - attach one .sheet on the List/VStack with an item binding, not one per row.", color: .asRed)
                StepRow(number: 5, text: "Nested sheets work - a sheet's content can present its own sheet. Each is independent.", color: .asRed)
            }

            CalloutBox(style: .danger, title: "Two .sheet modifiers on the same view", contentBody: "Attaching two .sheet modifiers to the same view silently breaks - only the first one works. Use a single .sheet(item:) with an enum to present different content based on the selected item.")

            CodeBlock(code: """
// ✗ Two sheets - only first works
view
    .sheet(isPresented: $showA) { SheetA() }
    .sheet(isPresented: $showB) { SheetB() }  // ignored!

// ✓ One sheet with enum item
enum ActiveSheet: Identifiable {
    case profile, settings, help
    var id: Self { self }
}
@State private var activeSheet: ActiveSheet?

view.sheet(item: $activeSheet) { sheet in
    switch sheet {
    case .profile:  ProfileSheet()
    case .settings: SettingsSheet()
    case .help:     HelpSheet()
    }
}

Button("Profile")  { activeSheet = .profile }
Button("Settings") { activeSheet = .settings }
""")
        }
    }
}
