//
//
//  1_ToggleDeepDive.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Custom ToggleStyle
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button { configuration.isOn.toggle() } label: {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .strokeBorder(configuration.isOn ? Color.cdPurple : Color(.systemGray3), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if configuration.isOn {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.cdPurple)
                            .frame(width: 22, height: 22)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isOn)
                configuration.label
            }
        }
        .buttonStyle(PressableButtonStyle())
    }
}

struct RadioToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button { configuration.isOn.toggle() } label: {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .strokeBorder(configuration.isOn ? Color.cdPurple : Color(.systemGray3), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if configuration.isOn {
                        Circle().fill(Color.cdPurple).frame(width: 12, height: 12)
                    }
                }
                .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isOn)
                configuration.label
            }
        }
        .buttonStyle(PressableButtonStyle())
    }
}

struct IconToggleStyle: ToggleStyle {
    let onIcon: String
    let offIcon: String
    let onColor: Color
    let offColor: Color

    func makeBody(configuration: Configuration) -> some View {
        Button { configuration.isOn.toggle() } label: {
            Image(systemName: configuration.isOn ? onIcon : offIcon)
                .font(.system(size: 20))
                .foregroundStyle(configuration.isOn ? onColor : offColor)
                .frame(width: 44, height: 44)
                .background(configuration.isOn ? onColor.opacity(0.1) : Color(.systemFill))
                .clipShape(Circle())
                .scaleEffect(configuration.isOn ? 1.0 : 0.9)
                .animation(.spring(response: 0.3, dampingFraction: 0.65), value: configuration.isOn)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

// MARK: - LESSON 1: Toggle Deep Dive

struct ToggleDeepDiveVisual: View {
    @State private var sw1 = true
    @State private var sw2 = false
    @State private var sw3 = true
    @State private var sw4 = false
    @State private var sw5 = true
    @State private var sw6 = false
    @State private var selectedDemo = 0

    let demos = ["System styles", "Custom styles", "Label variants"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Toggle deep dive", systemImage: "switch.2")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cdPurple)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.cdPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.cdPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // System toggle styles
                    VStack(spacing: 0) {
                        toggleRow("Default switch", isOn: $sw1, tint: .cdPurple)
                        divider()
                        toggleRow("Blue tint", isOn: $sw2, tint: .blue)
                        divider()
                        toggleRow("Green tint", isOn: $sw3, tint: .formGreen)
                        divider()
                        toggleRow("Red tint", isOn: $sw4, tint: .animCoral)
                        divider()
                        // Button style
                        HStack {
                            Text("Button style").font(.system(size: 14))
                            Spacer()
                           // Toggle("", isOn: $sw5).toggleStyle(.button).tint(.cdPurple).labelsHidden()//.toggleStyle(.button)
                            
                            Toggle(isOn: $sw5) {
                                Image(systemName: "power")
                                    .font(.system(size: 16, weight: .black))
                            }
                            .toggleStyle(.button)
                            .tint(.cdPurple)
                            .clipShape(Rectangle())
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                    }
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                case 1:
                    // Custom styles
                    VStack(alignment: .leading, spacing: 12) {
                        // Checkbox
                        VStack(spacing: 6) {
                            Text("CheckboxToggleStyle").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            VStack(alignment: .leading, spacing: 8) {
                                Toggle("Agree to terms", isOn: $sw1).toggleStyle(CheckboxToggleStyle()).font(.system(size: 13))
                                Toggle("Subscribe to newsletter", isOn: $sw2).toggleStyle(CheckboxToggleStyle()).font(.system(size: 13))
                                Toggle("Remember me", isOn: $sw3).toggleStyle(CheckboxToggleStyle()).font(.system(size: 13))
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            .padding().background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        // Radio
                        VStack(alignment: .leading, spacing: 6) {
                            Text("RadioToggleStyle").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            HStack(spacing: 16) {
                                Toggle("Option A", isOn: $sw4).toggleStyle(RadioToggleStyle()).font(.system(size: 13))
                                Toggle("Option B", isOn: $sw5).toggleStyle(RadioToggleStyle()).font(.system(size: 13))
                                Toggle("Option C", isOn: $sw6).toggleStyle(RadioToggleStyle()).font(.system(size: 13))
                            }.frame(maxWidth: .infinity)
                            .padding().background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        // Icon
                        VStack(alignment: .leading, spacing: 6) {
                            Text("IconToggleStyle").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            HStack(spacing: 16) {
                                Toggle("", isOn: $sw1).toggleStyle(IconToggleStyle(onIcon: "heart.fill", offIcon: "heart", onColor: .animCoral, offColor: .secondary)).labelsHidden()
                                Toggle("", isOn: $sw2).toggleStyle(IconToggleStyle(onIcon: "star.fill", offIcon: "star", onColor: .animAmber, offColor: .secondary)).labelsHidden()
                                Toggle("", isOn: $sw3).toggleStyle(IconToggleStyle(onIcon: "bookmark.fill", offIcon: "bookmark", onColor: .cdPurple, offColor: .secondary)).labelsHidden()
                                Toggle("", isOn: $sw4).toggleStyle(IconToggleStyle(onIcon: "bell.fill", offIcon: "bell.slash.fill", onColor: .cdPurple, offColor: .animCoral)).labelsHidden()
                            }.frame(maxWidth: .infinity)
                            .padding(12).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }


                default:
                    // Label variants
                    VStack(spacing: 0) {
                        // Simple text label
                        toggleRow("Text-only label", isOn: $sw1, tint: .cdPurple)
                        divider()
                        // Label with icon
                        HStack {
                            Label("Wi-Fi", systemImage: "wifi").font(.system(size: 14))
                            Spacer()
                            Toggle("", isOn: $sw2).tint(.cdPurple).labelsHidden()
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        divider()
                        // Custom label view
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Custom label").font(.system(size: 14))
                                Text("With a subtitle underneath").font(.system(size: 11)).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Toggle("", isOn: $sw3).tint(.cdPurple).labelsHidden()
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        divider()
                        // isOn binding trick - derived
                        HStack {
                            Text("All on (\(sw1 && sw2 && sw3 ? "✓" : "…"))")
                                .font(.system(size: 14))
                            Spacer()
                            Toggle("", isOn: Binding(
                                get: { sw1 && sw2 && sw3 },
                                set: { all in sw1 = all; sw2 = all; sw3 = all }
                            ))
                            .tint(.cdPurple).labelsHidden()
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                    }
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                }
            }
        }
    }

    func toggleRow(_ label: String, isOn: Binding<Bool>, tint: Color) -> some View {
        HStack {
            Text(label).font(.system(size: 14))
            Spacer()
            Toggle("", isOn: isOn).tint(tint).labelsHidden()
        }
        .padding(.horizontal, 14).padding(.vertical, 10)
    }

    func divider() -> some View {
        Divider().padding(.leading, 14)
    }
}

struct ToggleDeepDiveExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Toggle - styles and customisation")
            Text("Toggle binds to a Bool and renders a switch by default. Change its appearance entirely with ToggleStyle - create checkboxes, radio buttons, icon toggles, or any interactive two-state component.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Toggle(\"Label\", isOn: $bool) - default iOS switch. .tint(color) changes the on-state color.", color: .cdPurple)
                StepRow(number: 2, text: ".toggleStyle(.button) - renders as a button that highlights when on. Great for toolbar toggles.", color: .cdPurple)
                StepRow(number: 3, text: ".labelsHidden() - hides the label text; the toggle stands alone.", color: .cdPurple)
                StepRow(number: 4, text: "ToggleStyle protocol - makeBody(configuration:) gives you configuration.isOn and configuration.label.", color: .cdPurple)
                StepRow(number: 5, text: "Derived binding: Binding(get: { a && b }, set: { v in a = v; b = v }) - 'select all' pattern.", color: .cdPurple)
            }

            CalloutBox(style: .success, title: "ToggleStyle for custom controls", contentBody: "Conform to ToggleStyle to build checkboxes, radio buttons, or icon-based two-state buttons. configuration.isOn gives the current state; toggle it with configuration.isOn.toggle(). configuration.label renders the label in any layout you choose.")

            CodeBlock(code: """
// Basic toggle
Toggle("Dark mode", isOn: $isDark)
    .tint(.indigo)

// Button style toggle
Toggle("Bold", isOn: $isBold)
    .toggleStyle(.button)

// Custom checkbox style
struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button { configuration.isOn.toggle() } label: {
            HStack {
                Image(systemName: configuration.isOn
                    ? "checkmark.square.fill" : "square")
                    .foregroundStyle(configuration.isOn ? .blue : .gray)
                configuration.label
            }
        }
        .buttonStyle(.plain)
    }
}

Toggle("Accept terms", isOn: $accepted)
    .toggleStyle(CheckboxStyle())

// Derived "select all" binding
Toggle("All", isOn: Binding(
    get: { items.allSatisfy(\\.isSelected) },
    set: { v in items.indices.forEach { items[$0].isSelected = v } }
))
""")
        }
    }
}
