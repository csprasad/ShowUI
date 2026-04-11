//
//
//  1_TextFieldBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: TextField Basics
struct TFBasicsVisual: View {
    @State private var simple   = ""
    @State private var bio      = ""
    @State private var search   = ""
    @State private var selectedDemo = 0
    let demos = ["Variants", "Axis & limits", "Label styles"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("TextField basics", systemImage: "text.cursor")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.tfOrange)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
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
                    // Variant gallery
                    VStack(spacing: 10) {
                        fieldRow("Rounded border") {
                            TextField("Type something…", text: $simple)
                                .textFieldStyle(.roundedBorder)
                        }
                        fieldRow("Plain (no style)") {
                            HStack {
                                TextField("Plain field", text: $simple)
                                    .textFieldStyle(.plain)
                                Divider().frame(height: 20)
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(simple.isEmpty ? .secondary : Color.tfOrange)
                                    .onTapGesture { simple = "" }
                            }
                            .padding(.horizontal, 12).padding(.vertical, 9)
                            .background(Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        fieldRow("With icon") {
                            HStack(spacing: 8) {
                                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                                TextField("Search", text: $search)
                                    .textFieldStyle(.plain)
                                if !search.isEmpty {
                                    Button { search = "" } label: {
                                        Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                                    }
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }
                            .padding(.horizontal, 12).padding(.vertical, 9)
                            .background(Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }

                case 1:
                    // axis + lineLimit
                    VStack(spacing: 10) {
                        fieldRow("axis: .vertical") {
                            TextField("Tell us about yourself…", text: $bio, axis: .vertical)
                                .lineLimit(2...6)
                                .padding(10)
                                .background(Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.tfOrange)
                            Text("\(bio.count) chars · grows 2–6 lines")
                                .font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tfOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))

                        fieldRow("lineLimit: 1 (truncates)") {
                            TextField("Long text gets truncated here on one line only", text: $simple)
                                .lineLimit(1)
                                .textFieldStyle(.roundedBorder)
                        }
                    }

                default:
                    // Label styles
                    VStack(spacing: 10) {
                        // In-line label
                        LabeledContent("Username") {
                            TextField("alice_dev", text: $simple).textFieldStyle(.plain).multilineTextAlignment(.trailing)
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

                        // Floating label approach (custom)
                        ZStack(alignment: .leading) {
                            Text("Email address")
                                .font(.system(size: simple.isEmpty ? 14 : 11))
                                .foregroundStyle(simple.isEmpty ? .secondary : Color.tfOrange)
                                .offset(y: simple.isEmpty ? 0 : -16)
                                .animation(.spring(response: 0.25), value: simple.isEmpty)
                            TextField("", text: $simple)
                                .textFieldStyle(.plain)
                                .padding(.top, simple.isEmpty ? 0 : 10)
                                .animation(.spring(response: 0.25), value: simple.isEmpty)
                        }
                        .padding(.horizontal, 14).padding(.top, 16).padding(.bottom, 10)
                        .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(simple.isEmpty ? Color.clear : Color.tfOrange, lineWidth: 1.5))
                    }
                }
            }
        }
    }

    func fieldRow<C: View>(_ label: String, @ViewBuilder content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
            content()
        }
    }
}

struct TFBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "TextField - the fundamentals")
            Text("TextField binds directly to a String and renders an editable text input. The label acts as a placeholder. Four built-in styles handle most cases; use .plain for fully custom backgrounds and wrapping in your own container.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "TextField(\"Placeholder\", text: $string) - title is the placeholder, text is the binding.", color: .tfOrange)
                StepRow(number: 2, text: ".textFieldStyle(.roundedBorder / .plain) - roundedBorder adds system border; plain leaves styling to you.", color: .tfOrange)
                StepRow(number: 3, text: "TextField(\"…\", text: $x, axis: .vertical) + .lineLimit(2...6) - multiline that grows.", color: .tfOrange)
                StepRow(number: 4, text: ".lineLimit(n) - single-line truncation. .lineLimit(min...max) - multiline range.", color: .tfOrange)
                StepRow(number: 5, text: ".multilineTextAlignment(.trailing) - right-aligns text. Good for form value cells.", color: .tfOrange)
                StepRow(number: 6, text: "Use LabeledContent for the system key-value row layout inside Form.", color: .tfOrange)
            }

            CalloutBox(style: .info, title: "Floating label pattern", contentBody: "SwiftUI doesn't provide a floating label field natively. Build it with ZStack, animating the label's font size and y-offset based on whether the field is empty. Combine with .animation(.spring()) for smooth transition.")

            CodeBlock(code: """
// Basic
TextField("Full name", text: $name)
    .textFieldStyle(.roundedBorder)

// Multiline - grows with content
TextField("Notes", text: $notes, axis: .vertical)
    .lineLimit(3...8)
    .padding(12)
    .background(Color(.systemFill))
    .clipShape(RoundedRectangle(cornerRadius: 10))

// Clear button pattern
HStack {
    TextField("Search", text: $query)
    if !query.isEmpty {
        Button { query = "" } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.secondary)
        }
    }
}

// Aligned value in Form row
LabeledContent("Email") {
    TextField("", text: $email)
        .multilineTextAlignment(.trailing)
}
""")
        }
    }
}
