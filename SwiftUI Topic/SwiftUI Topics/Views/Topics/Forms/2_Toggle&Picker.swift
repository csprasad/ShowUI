//
//
//  2_Toggle&Picker.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Toggle & Picker
struct TogglePickerVisual: View {
    @State private var toggleA = true
    @State private var toggleB = false
    @State private var pickerStyle = 0
    @State private var selectedFruit = "Apple"
    @State private var selectedDay = 1

    let fruits = ["Apple", "Banana", "Cherry", "Dragonfruit", "Elderberry"]
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    let pickerStyles = ["menu", "segmented", "wheel", "inline"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Toggle & Picker", systemImage: "switch.2")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.formGreen)

                // Toggles
                VStack(spacing: 0) {
                    sectionHeader("Toggle")
                    toggleRow("Notifications", isOn: $toggleA, icon: "bell.fill")
                    Divider().padding(.leading, 46)
                    toggleRow("Auto-update", isOn: $toggleB, icon: "arrow.clockwise")
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                // Picker styles
                VStack(alignment: .leading, spacing: 8) {
                    sectionHeader("Picker styles")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(pickerStyles.indices, id: \.self) { i in
                                Button {
                                    withAnimation(.spring(response: 0.3)) { pickerStyle = i }
                                } label: {
                                    Text(".\(pickerStyles[i])")
                                        .font(.system(size: 10, weight: pickerStyle == i ? .semibold : .regular, design: .monospaced))
                                        .foregroundStyle(pickerStyle == i ? Color.formGreen : .secondary)
                                        .padding(.horizontal, 8).padding(.vertical, 5)
                                        .background(pickerStyle == i ? Color.formGreenLight : Color(.systemFill))
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                    }

                    pickerDemo
                        .padding(12)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                        .animation(.spring(response: 0.35), value: pickerStyle)
                }
            }
        }
    }

    @ViewBuilder
    private var pickerDemo: some View {
        switch pickerStyle {
        case 0:
            HStack {
                Text("Fruit").font(.system(size: 14))
                Spacer()
                Picker("", selection: $selectedFruit) {
                    ForEach(fruits, id: \.self) { Text($0) }
                }.pickerStyle(.menu).tint(.formGreen)
            }
        case 1:
            VStack(alignment: .leading, spacing: 6) {
                Text("Day").font(.system(size: 12)).foregroundStyle(.secondary)
                Picker("Day", selection: $selectedDay) {
                    ForEach(days.indices, id: \.self) { i in
                        Text(days[i]).tag(i)
                    }
                }.pickerStyle(.segmented)
            }
        case 2:
            HStack {
                Picker("Fruit", selection: $selectedFruit) {
                    ForEach(fruits, id: \.self) { Text($0) }
                }
                .pickerStyle(.wheel)
                .frame(height: 80)
                .clipped()
            }
        default:
            Picker("Fruit", selection: $selectedFruit) {
                ForEach(fruits, id: \.self) { Text($0) }
            }
            .pickerStyle(.inline)
            .frame(height: 110)
        }
    }

    func toggleRow(_ title: String, isOn: Binding<Bool>, icon: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8).fill(Color.formGreen).frame(width: 30, height: 30)
                Image(systemName: icon).font(.system(size: 14)).foregroundStyle(.white)
            }
            Text(title).font(.system(size: 14))
            Spacer()
            Toggle("", isOn: isOn).labelsHidden().tint(.formGreen)
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
    }

    func sectionHeader(_ text: String) -> some View {
        Text(text).font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
    }
}

struct TogglePickerExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Toggle & Picker")
            Text("Toggle and Picker are the two most-used controls in settings UIs. Toggle handles boolean state. Picker handles selecting one value from a set and supports multiple visual styles.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Toggle(\"Label\", isOn: $bool) - renders a UISwitch. Tint with .tint(color).", color: .formGreen)
                StepRow(number: 2, text: ".pickerStyle(.menu) - compact dropdown. Default outside Form.", color: .formGreen)
                StepRow(number: 3, text: ".pickerStyle(.segmented) - horizontal segments. Best for 2-5 short options.", color: .formGreen)
                StepRow(number: 4, text: ".pickerStyle(.wheel) - spinning drum. Good for many numeric or ordered options.", color: .formGreen)
                StepRow(number: 5, text: ".pickerStyle(.inline) - shows all options inline. Best inside Form sections.", color: .formGreen)
                StepRow(number: 6, text: ".pickerStyle(.navigationLink) - pushes a selection screen. Default inside Form on iOS.", color: .formGreen)
            }

            CalloutBox(style: .info, title: "Picker selection must match tag type", contentBody: "The selection binding type must match the .tag() values exactly. String selection with Int tags will silently fail. Use the same type throughout or use Hashable enum cases.")

            CalloutBox(style: .success, title: "Toggle in Form gets a row automatically", contentBody: "Inside a Form, Toggle renders as a full row - label on the left, switch on the right - without any extra layout code. This is one of the biggest benefits of using Form.")

            CodeBlock(code: """
// Toggle
@State private var isEnabled = false

Toggle("Dark mode", isOn: $isEnabled)
    .tint(.purple)   // switch tint color

// Toggle with icon (inside Form)
Toggle(isOn: $notifications) {
    Label("Notifications", systemImage: "bell.fill")
}

// Picker - various styles
@State private var selected = "Option A"

Picker("Theme", selection: $selected) {
    Text("Option A").tag("Option A")
    Text("Option B").tag("Option B")
}
.pickerStyle(.menu)        // dropdown
.pickerStyle(.segmented)   // segments
.pickerStyle(.inline)      // all visible

// Enum-backed picker
enum Theme: String, CaseIterable {
    case light, dark, system
}
@State private var theme: Theme = .system

Picker("Theme", selection: $theme) {
    ForEach(Theme.allCases, id: \\.self) {
        Text($0.rawValue.capitalized)
    }
}
""")
        }
    }
}

