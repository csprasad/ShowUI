//
//
//  7_CustomTextFieldStyles.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `10/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Custom TextFieldStyles
struct OutlinedTextFieldStyle: TextFieldStyle {
    var color: Color = .tfOrange
    var isFocused: Bool = false

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isFocused ? color.opacity(0.06) : Color(.systemFill))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isFocused ? color : Color.clear, lineWidth: 2)
            )
            .animation(.spring(response: 0.25), value: isFocused)
    }
}

struct UnderlineTextFieldStyle: TextFieldStyle {
    var color: Color = .tfOrange
    var isFocused: Bool = false

    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack(spacing: 0) {
            configuration
                .padding(.horizontal, 4)
                .padding(.vertical, 10)
            Rectangle()
                .fill(isFocused ? color : Color(.systemGray4))
                .frame(height: isFocused ? 2 : 1)
                .animation(.spring(response: 0.25), value: isFocused)
        }
    }
}

// Shake modifier for error animation
struct ShakeModifier: GeometryEffect {
    var amount: CGFloat = 8
    var shakesPerUnit   = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

// MARK: - LESSON 7: Custom TextField Style
struct CustomTFStyleVisual: View {
    @State private var text1 = ""
    @State private var text2 = ""
    @State private var text3 = ""
    @State private var text4 = ""
    @State private var shakeAmount: CGFloat = 0
    @State private var selectedDemo = 0
    @FocusState private var focus1: Bool
    @FocusState private var focus2: Bool
    @FocusState private var focus3: Bool

    let demos = ["Style gallery", "Animated border", "Shake on error"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Custom TextField style", systemImage: "paintbrush.pointed.fill")
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
                    // Style gallery
                    VStack(spacing: 12) {
                        styleCell("OutlinedStyle") {
                            TextField("Outlined field", text: $text1)
                                .textFieldStyle(OutlinedTextFieldStyle(isFocused: focus1))
                                .focused($focus1)
                        }
                        styleCell("UnderlineStyle") {
                            TextField("Underline field", text: $text2)
                                .textFieldStyle(UnderlineTextFieldStyle(isFocused: focus2))
                                .focused($focus2)
                        }
                        styleCell("Capsule pill") {
                            HStack(spacing: 8) {
                                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                                TextField("Search…", text: $text3)
                                    .textFieldStyle(.plain)
                            }
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .background(Color(.systemFill))
                            .clipShape(Capsule())
                        }
                        styleCell("Inset material") {
                            TextField("Type here", text: $text4)
                                .textFieldStyle(.plain)
                                .padding(.horizontal, 14).padding(.vertical, 10)
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                case 1:
                    // Animated focus border
                    VStack(spacing: 14) {
                        TextField("Focused orange border", text: $text1)
                            .textFieldStyle(OutlinedTextFieldStyle(color: .tfOrange, isFocused: focus1))
                            .focused($focus1)

                        TextField("Focused blue border", text: $text2)
                            .textFieldStyle(OutlinedTextFieldStyle(color: .navBlue, isFocused: focus2))
                            .focused($focus2)

                        TextField("Focused purple border", text: $text3)
                            .textFieldStyle(OutlinedTextFieldStyle(color: .ssPurple, isFocused: focus3))
                            .focused($focus3)

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.tfOrange)
                            Text("Tap each field - the border animates in using @FocusState passed to the style")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.tfOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // Shake on error
                    VStack(spacing: 12) {
                        HStack(spacing: 10) {
                            Image(systemName: "lock.fill").foregroundStyle(Color.tfOrange)
                            TextField("Enter password", text: $text1)
                                .textFieldStyle(.plain)
                        }
                        .padding(.horizontal, 14).padding(.vertical, 11)
                        .background(Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .modifier(ShakeModifier(animatableData: shakeAmount))

                        Button {
                            withAnimation(.default) { shakeAmount += 1 }
                        } label: {
                            Text("Submit wrong password")
                                .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 11)
                                .background(Color.animCoral).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressableButtonStyle())

                        Text("GeometryEffect + sin() creates the horizontal shake animation")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    func styleCell<C: View>(_ name: String, @ViewBuilder content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name).font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
            content()
        }
    }
}

struct CustomTFStyleExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Custom TextFieldStyle")
            Text("Conform to TextFieldStyle to create a reusable style applied with .textFieldStyle(). The style receives the raw TextField and wraps it with any appearance. Pass @FocusState down to animate on focus/blur.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "struct MyStyle: TextFieldStyle { func _body(configuration:) -> some View { configuration … } }", color: .tfOrange)
                StepRow(number: 2, text: "configuration is the TextField itself - wrap it with padding, background, overlay.", color: .tfOrange)
                StepRow(number: 3, text: "Pass isFocused: Bool to the style struct - animate background/border based on it.", color: .tfOrange)
                StepRow(number: 4, text: "ShakeModifier: GeometryEffect uses sin() to oscillate horizontal translation - classic error shake.", color: .tfOrange)
                StepRow(number: 5, text: "Trigger shake: withAnimation(.default) { shakeAmount += 1 } - incrementing triggers the effect.", color: .tfOrange)
            }

            CalloutBox(style: .warning, title: "_body is a private API", contentBody: "TextFieldStyle's _body(configuration:) uses an underscore - it's technically private API. It works reliably but Apple hasn't officially documented the protocol. For production, wrapping in a ViewModifier or View extension is safer and fully supported.")

            CodeBlock(code: """
// TextFieldStyle conformance
struct OutlinedField: TextFieldStyle {
    var isFocused: Bool

    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isFocused ? .blue.opacity(0.05) : Color(.systemFill))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isFocused ? .blue : .clear, lineWidth: 2)
            )
            .animation(.spring(), value: isFocused)
    }
}

// Usage - pass FocusState to the style
@FocusState private var isFocused: Bool

TextField("Email", text: $email)
    .textFieldStyle(OutlinedField(isFocused: isFocused))
    .focused($isFocused)

// Shake on error
struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(
            translationX: 8 * sin(animatableData * .pi * 3), y: 0
        ))
    }
}

@State private var shake: CGFloat = 0
field.modifier(ShakeEffect(animatableData: shake))
Button("Wrong") { withAnimation { shake += 1 } }
""")
        }
    }
}
