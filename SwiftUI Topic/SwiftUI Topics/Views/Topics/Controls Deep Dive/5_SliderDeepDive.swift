//
//
//  5_SliderDeepDive.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Slider Deep Dive
struct SliderDeepDiveVisual: View {
    @State private var value: Double    = 50
    @State private var stepped: Double  = 25
    @State private var editing          = false
    @State private var selectedDemo     = 0
    let demos = ["Anatomy", "Step & range", "Editing state"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Slider deep dive", systemImage: "slider.horizontal.3")
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
                    // Annotated anatomy
                    VStack(spacing: 14) {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Current value").font(.system(size: 11)).foregroundStyle(.secondary)
                                Spacer()
                                Text(String(format: "%.1f", value))
                                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                                    .foregroundStyle(Color.cdPurple)
                                    .contentTransition(.numericText())
                                    .animation(.spring(duration: 0.2), value: value)
                            }

                            HStack(spacing: 12) {
                                Image(systemName: "speaker.fill")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)

                                Slider(value: $value, in: 0...100)
                                    .tint(.cdPurple)

                                Image(systemName: "speaker.wave.3.fill")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.cdPurple)
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Volume Control")
                        }
                        .padding(12).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 12))

                        // Parts callouts
                        VStack(spacing: 6) {
                            callout("Slider(value: $x, in: 0...100)", detail: "binding + closed range")
                            callout("minimumValueLabel:", detail: "view on the left end")
                            callout("maximumValueLabel:", detail: "view on the right end")
                            callout(".tint(color)", detail: "track + thumb fill color")
                        }

                        // Various tints
                        VStack(spacing: 8) {
                            ForEach([(Color.cdPurple, "cdPurple"), (.formGreen, "green"), (.animCoral, "coral"), (.animAmber, "amber")], id: \.1) { color, name in
                                HStack(spacing: 10) {
                                    Text(".\(name)").font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary).frame(width: 68)
                                    Slider(value: .constant(value), in: 0...100).tint(color)
                                }
                            }
                        }
                        .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                        .animation(.easeInOut(duration: 0.05), value: value)
                    }

                case 1:
                    // Step and range
                    VStack(spacing: 12) {
                        stepRow("step: 1",   value: $stepped, range: 0...100, step: 1,  format: "%.0f")
                        stepRow("step: 5",   value: $stepped, range: 0...100, step: 5,  format: "%.0f")
                        stepRow("step: 0.1", value: $stepped, range: 0...1,   step: 0.1, format: "%.1f")
                        stepRow("step: 25",  value: $stepped, range: 0...100, step: 25, format: "%.0f")

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.cdPurple)
                            Text("Each slider jumps to discrete values. step: 25 creates 5 snap positions.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.cdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // onEditingChanged
                    VStack(spacing: 12) {
                        Slider(value: $value, in: 0...100) { isEditing in
                            withAnimation(.spring(response: 0.25)) { editing = isEditing }
                        }
                        .tint(editing ? .cdPurple : .secondary)
                        .animation(.easeInOut(duration: 0.1), value: value)

                        // Live preview that changes while dragging
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(LinearGradient(
                                    colors: [Color.cdPurple.opacity(0.3 + value / 200), Color.cdViolet.opacity(0.5 + value / 200)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(maxWidth: .infinity).frame(height: 80)
                                .animation(.easeInOut(duration: 0.05), value: value)

                            VStack(spacing: 4) {
                                Text(String(format: "%.0f%%", value))
                                    .font(.system(size: 24, weight: .bold)).foregroundStyle(.white)
                                    .contentTransition(.numericText()).animation(.spring(duration: 0.15), value: Int(value))
                                Text(editing ? "Dragging…" : "Release to commit")
                                    .font(.system(size: 11)).foregroundStyle(.white.opacity(0.8))
                            }
                        }

                        callout("onEditingChanged: { isEditing in }", detail: "true while dragging, false on release")
                    }
                }
            }
        }
    }

    func callout(_ code: String, detail: String) -> some View {
        HStack(spacing: 8) {
            Text(code).font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.cdPurple)
            Spacer()
            Text(detail).font(.system(size: 10)).foregroundStyle(.secondary)
        }
        .padding(6).background(Color.cdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 6))
    }

    func stepRow(_ label: String, value: Binding<Double>, range: ClosedRange<Double>, step: Double, format: String) -> some View {
        HStack(spacing: 10) {
            Text(label).font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary).frame(width: 64)
            Slider(value: value, in: range, step: step).tint(.cdPurple)
            Text(String(format: format, value.wrappedValue))
                .font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.cdPurple).frame(width: 32)
        }
    }
}

struct SliderDeepDiveExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Slider - anatomy and control")
            Text("Slider maps a continuous or stepped Double to a drag control. The minimumValueLabel/maximumValueLabel closures add contextual views at each end. onEditingChanged fires when dragging starts and stops.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Slider(value: $x, in: min...max) - basic. Slider(value:in:step:) - discrete snapping.", color: .cdPurple)
                StepRow(number: 2, text: "minimumValueLabel: { } / maximumValueLabel: { } - contextual icons or text at ends.", color: .cdPurple)
                StepRow(number: 3, text: ".tint(color) - changes filled track and thumb color.", color: .cdPurple)
                StepRow(number: 4, text: "onEditingChanged: { isEditing in } - true while user drags, false on release. Use to defer expensive work.", color: .cdPurple)
                StepRow(number: 5, text: "step: - discrete positions. step: 1 gives integer values; step: 0.5 gives halves.", color: .cdPurple)
            }

            CalloutBox(style: .success, title: "Defer expensive work with onEditingChanged", contentBody: "Don't run network calls or heavy computation every time the slider value changes. Use onEditingChanged and only apply the value when isEditing becomes false - when the user releases the thumb.")

            CodeBlock(code: """
// Full anatomy
Slider(value: $volume, in: 0...100, step: 1) {
    Text("Volume")                // accessibility label
} minimumValueLabel: {
    Image(systemName: "speaker.fill")
} maximumValueLabel: {
    Image(systemName: "speaker.wave.3.fill")
} onEditingChanged: { isEditing in
    if !isEditing {
        applyVolume(volume)        // defer work to release
    }
}
.tint(.blue)

// Continuous - no step
Slider(value: $opacity, in: 0...1)

// Discrete - snaps to integers
Slider(value: $fontSize, in: 10...32, step: 1)

// Negative range
Slider(value: $brightness, in: -1...1)
""")
        }
    }
}
