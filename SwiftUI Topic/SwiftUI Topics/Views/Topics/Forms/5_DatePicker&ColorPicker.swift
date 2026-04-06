//
//
//  5_DatePicker&ColorPicker.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: DatePicker & ColorPicker
struct DateColorPickerVisual: View {
    @State private var selectedDate = Date()
    @State private var birthDate = Calendar.current.date(from: DateComponents(year: 1990, month: 6, day: 15)) ?? Date()
    @State private var meetingTime = Date()
    @State private var accentColor = Color.formGreen
    @State private var bgColor = Color.formGreenLight
    @State private var selectedDemo = 0

    let demos = ["DatePicker styles", "Date + Time", "ColorPicker"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("DatePicker & ColorPicker", systemImage: "calendar.badge.clock")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.formGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.formGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.formGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    VStack(spacing: 10) {
                        // Compact (default)
                        controlRow(label: ".compact") {
                            DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .tint(.formGreen)
                        }
                        // Graphical
                        VStack(alignment: .leading, spacing: 6) {
                            Text(".graphical - inline calendar")
                                .font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            DatePicker("", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .tint(.formGreen)
                                .labelsHidden()
                                .frame(maxHeight: 280)
                        }
                        .padding(10).background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                    }

                case 1:
                    VStack(spacing: 10) {
                        // Date only
                        controlRow(label: "Date only") {
                            DatePicker("Meeting date", selection: $meetingTime, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .tint(.formGreen)
                        }
                        // Time only
                        controlRow(label: "Time only") {
                            DatePicker("Meeting time", selection: $meetingTime, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.compact)
                                .tint(.formGreen)
                        }
                        // Both
                        controlRow(label: "Date + Time") {
                            DatePicker("When", selection: $meetingTime)
                                .datePickerStyle(.compact)
                                .tint(.formGreen)
                        }
                        // Range constraint
                        controlRow(label: "Future only") {
                            DatePicker("From", selection: $meetingTime, in: Date()...)
                                .datePickerStyle(.compact)
                                .tint(.formGreen)
                        }
                        // Summary
                        HStack(spacing: 6) {
                            Image(systemName: "calendar.badge.clock").foregroundStyle(Color.formGreen).font(.system(size: 12))
                            Text(meetingTime.formatted(date: .abbreviated, time: .shortened))
                                .font(.system(size: 12)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.formGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    VStack(spacing: 12) {
                        // Single color
                        controlRow(label: "Accent color") {
                            ColorPicker("Pick color", selection: $accentColor)
                        }
                        controlRow(label: "No opacity") {
                            ColorPicker("Background", selection: $bgColor, supportsOpacity: false)
                        }

                        // Live preview
                        RoundedRectangle(cornerRadius: 12)
                            .fill(bgColor)
                            .frame(height: 60)
                            .overlay(
                                Text("Live preview")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(accentColor)
                            )
                            .animation(.easeInOut(duration: 0.2), value: accentColor.description)
                            .animation(.easeInOut(duration: 0.2), value: bgColor.description)
                    }
                }
            }
        }
    }

    func controlRow<C: View>(label: String, @ViewBuilder content: () -> C) -> some View {
        HStack {
            Text(label).font(.system(size: 13)).foregroundStyle(.secondary).frame(width: 90, alignment: .leading)
            Spacer()
            content()
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

struct DateColorPickerExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "DatePicker & ColorPicker")
            Text("DatePicker provides a system date/time selector in several visual styles. ColorPicker opens the system color wheel. Both integrate with Form beautifully and require minimal setup.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".datePickerStyle(.compact) - row with tappable date/time buttons. Default in Form.", color: .formGreen)
                StepRow(number: 2, text: ".datePickerStyle(.graphical) - inline calendar grid. Best for full date selection.", color: .formGreen)
                StepRow(number: 3, text: ".datePickerStyle(.wheel) - spinning drum. Classic iOS look.", color: .formGreen)
                StepRow(number: 4, text: "displayedComponents: .date / .hourAndMinute / both - controls what the picker shows.", color: .formGreen)
                StepRow(number: 5, text: "in: Date()... - future only. in: ...Date() - past only. in: rangeStart...rangeEnd - specific range.", color: .formGreen)
                StepRow(number: 6, text: "ColorPicker(supportsOpacity: false) - removes alpha channel from the picker.", color: .formGreen)
            }

            CalloutBox(style: .info, title: "Format displayed dates", contentBody: "Use Date.formatted() to show selected values in your own UI. The .abbreviated style gives '6 Jun 2024', .complete gives the full localized date. Always use the system formatter rather than DateFormatter manually.")

            CodeBlock(code: """
// Basic date picker
@State private var date = Date()

DatePicker("Birthday", selection: $date,
           in: ...Date(),
           displayedComponents: .date)
    .datePickerStyle(.compact)
    .tint(.blue)

// Time only
DatePicker("Meeting time", selection: $time,
           displayedComponents: .hourAndMinute)

// Inline calendar
DatePicker("", selection: $date)
    .datePickerStyle(.graphical)
    .labelsHidden()

// Color picker
@State private var color = Color.blue

ColorPicker("Theme color", selection: $color)
ColorPicker("Background", selection: $bg,
            supportsOpacity: false)

// Display formatted date
Text(date.formatted(date: .abbreviated, time: .omitted))
Text(date.formatted(.dateTime.month().day().year()))
""")
        }
    }
}
