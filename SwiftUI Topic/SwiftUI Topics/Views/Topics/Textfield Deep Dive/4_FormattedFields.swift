//
//
//  4_FormattedFields.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Formatted Fields
struct FormattedFieldsVisual: View {
    @State private var amount: Double   = 42.5
    @State private var integer: Int     = 1234
    @State private var date: Date       = Date()
    @State private var percentage: Double = 0.75
    @State private var selectedDemo     = 0
    let demos = ["Currency", "Number & %", "Date & custom"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Formatted fields", systemImage: "number.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tfOrange)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 12, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.tfOrange : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.tfOrangeLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Currency
                    VStack(spacing: 10) {
                        formattedRow("USD", icon: "dollarsign.circle.fill") {
                            TextField("Amount", value: $amount, format: .currency(code: "USD"))
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                        }
                        formattedRow("EUR", icon: "eurosign.circle.fill") {
                            TextField("Amount", value: $amount, format: .currency(code: "EUR"))
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                        }
                        formattedRow("GBP", icon: "sterlingsign.circle.fill") {
                            TextField("Amount", value: $amount, format: .currency(code: "GBP"))
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                        }
                        resultChip("amount = \(amount)")
                    }

                case 1:
                    // Number formats
                    VStack(spacing: 10) {
                        formattedRow("Integer", icon: "number") {
                            TextField("Number", value: $integer, format: .number)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                        }
                        formattedRow("Decimal", icon: "plusminus.circle") {
                            TextField("Value", value: $amount, format: .number.precision(.fractionLength(2)))
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                        }
                        formattedRow("Percent", icon: "percent") {
                            TextField("Percent", value: $percentage, format: .percent.precision(.fractionLength(1)))
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                        }
                        formattedRow("Grouped", icon: "3.square") {
                            TextField("Big number", value: $integer, format: .number.grouping(.automatic))
                                .keyboardType(.numberPad)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                        }
                        resultChip("integer = \(integer)  ·  pct = \(String(format: "%.2f", percentage))")
                    }

                default:
                    // Date formats
                    VStack(spacing: 10) {
                        formattedRow("Date only", icon: "calendar") {
                            TextField("Date", value: $date, format: .dateTime.month().day().year())
                                .keyboardType(.default)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                        }
                        formattedRow("Abbreviated", icon: "calendar.badge.clock") {
                            TextField("Date", value: $date, format: Date.FormatStyle(date: .abbreviated, time: .omitted))
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                        }

                        Divider()
                        Text("Custom FormatStyle - hex input ↔ Int")
                            .font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        HStack(spacing: 10) {
                            Image(systemName: "0.square.fill").foregroundStyle(Color.tfOrange)
                            TextField("e.g. FF or 255", value: $integer, format: HexFormatStyle())
                                .keyboardType(.asciiCapable)
                                .textFieldStyle(.plain)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                            Spacer()
                            Text("= \(integer) decimal")
                                .font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 12).padding(.vertical, 10)
                        .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

                        resultChip("date = \(date.formatted(date: .abbreviated, time: .omitted))")
                    }
                }
            }
        }
    }

    func formattedRow<C: View>(_ label: String, icon: String, @ViewBuilder content: () -> C) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(Color.tfOrange).frame(width: 22)
            Text(label).font(.system(size: 13)).frame(width: 72, alignment: .leading)
            content()
        }
        .padding(.horizontal, 12).padding(.vertical, 10)
        .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func resultChip(_ text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "arrow.right.circle.fill").font(.system(size: 12)).foregroundStyle(Color.tfOrange)
            Text(text).font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
        }
        .padding(8).background(Color.tfOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// Custom FormatStyle: hex string ↔ Int
struct HexFormatStyle: ParseableFormatStyle {
    var parseStrategy: HexParseStrategy { HexParseStrategy() }
    func format(_ value: Int) -> String { String(value, radix: 16, uppercase: true) }
}

struct HexParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> Int {
        guard let n = Int(value, radix: 16) else { throw CocoaError(.fileReadCorruptFile) }
        return n
    }
}

struct FormattedFieldsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Formatted TextField")
            Text("TextField(\"Label\", value: $typed, format: .currency(code: \"USD\")) binds to a typed value (Double, Int, Date) and handles formatting and parsing automatically. The field shows formatted text but the binding holds the raw value.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "TextField(\"…\", value: $double, format: .currency(code: \"USD\")) - formatted binding.", color: .tfOrange)
                StepRow(number: 2, text: ".number - parses any numeric string. .number.precision(.fractionLength(2)) - two decimal places.", color: .tfOrange)
                StepRow(number: 3, text: ".percent - user types 0.75 and sees 75%. Or types 75 and you get 0.75.", color: .tfOrange)
                StepRow(number: 4, text: ".dateTime.month().day().year() - builds a date format from components.", color: .tfOrange)
                StepRow(number: 5, text: "ParseableFormatStyle - create completely custom bidirectional formatters for domain types.", color: .tfOrange)
            }

            CalloutBox(style: .success, title: "value: binding is type-safe", contentBody: "With value: $myDouble the field only accepts valid numbers - invalid input reverts to the previous value on dismiss. No manual string-to-Double conversion or validation needed for type parsing.")

            CalloutBox(style: .info, title: "Custom ParseableFormatStyle", contentBody: "Implement ParseableFormatStyle with format(_ value:) and a ParseStrategy for completely custom input - hex numbers, country codes, custom date formats, or any domain type. The field handles display and parsing automatically.")

            CodeBlock(code: """
// Currency
@State private var amount: Double = 0
TextField("Price", value: $amount, format: .currency(code: "USD"))
    .keyboardType(.decimalPad)

// Number with precision
TextField("Weight", value: $kg, format: .number.precision(.fractionLength(1)))

// Percentage
TextField("Rate", value: $rate, format: .percent)
// User sees "75.5%", binding holds 0.755

// Date
TextField("Date", value: $date,
          format: .dateTime.month().day().year())

// Custom ParseableFormatStyle
struct HexStyle: ParseableFormatStyle {
    var parseStrategy: HexParser { HexParser() }
    func format(_ v: Int) -> String { String(v, radix: 16) }
}
struct HexParser: ParseStrategy {
    func parse(_ s: String) throws -> Int {
        guard let n = Int(s, radix: 16) else { throw ParseError() }
        return n
    }
}
TextField("Hex", value: $int, format: HexStyle())
""")
        }
    }
}

