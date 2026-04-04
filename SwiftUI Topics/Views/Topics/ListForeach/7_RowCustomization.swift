//
//
//  7_RowCustomization.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Row Customization
struct RowCustomizationVisual: View {
    @State private var selectedStyle = 0
    let styles = ["Default", "No separator", "Custom bg", "Full width", "Custom inset"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Row customization", systemImage: "paintbrush.pointed.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.lfBlue)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(styles.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedStyle = i }
                            } label: {
                                Text(styles[i])
                                    .font(.system(size: 11, weight: selectedStyle == i ? .semibold : .regular))
                                    .foregroundStyle(selectedStyle == i ? Color.lfBlue : .secondary)
                                    .padding(.horizontal, 10).padding(.vertical, 6)
                                    .background(selectedStyle == i ? Color.lfBlueLight : Color(.systemFill))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }

                // Live demo
                listDemo
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .animation(.spring(response: 0.35), value: selectedStyle)

                // Code for current style
                let codes = [
                    "// Default — system separators and insets",
                    ".listRowSeparator(.hidden)\n// Hides the row separator line",
                    ".listRowBackground(Color.lfBlueLight)\n// Custom row background color",
                    ".listRowInsets(EdgeInsets())\n// Removes default side insets → full width",
                    ".listRowInsets(EdgeInsets(top:8, leading:20, bottom:8, trailing:20))\n// Custom padding",
                ]
                Text(codes[selectedStyle])
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(Color.lfBlue)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.lfBlueLight)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .animation(.easeInOut(duration: 0.15), value: selectedStyle)
            }
        }
    }

    @ViewBuilder
    private var listDemo: some View {
        let items = LFContact.samples.prefix(4)

        switch selectedStyle {
        case 1:
            // No separators
            List(Array(items)) { contact in
                contactRow(contact, color: .lfBlue)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)

        case 2:
            // Custom background
            List(Array(items)) { contact in
                contactRow(contact, color: .lfBlue)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.lfBlueLight)
                            .padding(.horizontal, 8).padding(.vertical, 2)
                    )
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)

        case 3:
            // Full width — no insets
            List(Array(items)) { contact in
                HStack(spacing: 12) {
                    Rectangle().fill(contact.name.hashValue % 2 == 0 ? Color.lfBlue : Color.animTeal)
                        .frame(width: 4)
                    Text(contact.name).font(.system(size: 14))
                    Spacer()
                }
                .frame(height: 44)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)

        case 4:
            // Custom inset
            List(Array(items)) { contact in
                contactRow(contact, color: .lfBlue)
                    .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
            }
            .listStyle(.plain)

        default:
            // Default
            List(Array(items)) { contact in
                contactRow(contact, color: .lfBlue)
            }
            .listStyle(.plain)
        }
    }

    func contactRow(_ contact: LFContact, color: Color) -> some View {
        HStack(spacing: 12) {
            Circle().fill(color).frame(width: 30, height: 30)
                .overlay(Text(contact.initial).font(.system(size: 12, weight: .semibold)).foregroundStyle(.white))
            VStack(alignment: .leading, spacing: 1) {
                Text(contact.name).font(.system(size: 13, weight: .medium))
                Text(contact.role).font(.system(size: 11)).foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}

struct RowCustomizationExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Customizing list rows")
            Text("SwiftUI provides modifiers to control every aspect of row appearance — separators, background, insets, and tint. These are applied per-row on the content view inside the List, not on the List itself.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".listRowSeparator(.hidden) — hides the separator line below a row. .visible forces it on.", color: .lfBlue)
                StepRow(number: 2, text: ".listRowSeparatorTint(color) — changes the separator color for a specific row.", color: .lfBlue)
                StepRow(number: 3, text: ".listRowBackground(view) — replaces the default white row background with any view.", color: .lfBlue)
                StepRow(number: 4, text: ".listRowInsets(EdgeInsets()) — sets custom padding. EdgeInsets() removes all insets for full-width rows.", color: .lfBlue)
                StepRow(number: 5, text: ".listItemTint(color) — tints interactive controls (toggles, disclosure indicators) inside the row.", color: .lfBlue)
            }

            CalloutBox(style: .info, title: "Apply to the row content, not the List", contentBody: "All .listRow* modifiers must be applied to the view inside the List/ForEach — not to the List container. They configure how the List wraps that specific row.")

            CalloutBox(style: .success, title: "Combining modifiers", contentBody: ".listRowSeparator(.hidden) + .listRowBackground(Color.clear) + .listRowInsets(EdgeInsets()) gives you a completely blank canvas for fully custom rows while keeping List's lazy rendering.")

            CodeBlock(code: """
List(items) { item in
    CustomRowView(item: item)
        .listRowSeparator(.hidden)          // no line
        .listRowBackground(Color.blue.opacity(0.1))  // tinted bg
        .listRowInsets(EdgeInsets(          // custom padding
            top: 8, leading: 16,
            bottom: 8, trailing: 16
        ))
        .listRowSeparatorTint(.blue)        // colored separator
}

// Full-width custom row (no side insets)
HStack {
    ColorBar()
    RowContent()
}
.listRowInsets(EdgeInsets())   // zero insets
.listRowSeparator(.hidden)

// Tint controls inside row
Toggle("Enable", isOn: $isEnabled)
    .listItemTint(.purple)     // toggle tint
""")
        }
    }
}
