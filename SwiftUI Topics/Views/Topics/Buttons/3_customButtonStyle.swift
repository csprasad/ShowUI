//
//
//  3_customButtonStyle.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Custom Button Style
struct CustomStyleVisual: View {
    @State private var selectedStyle = 0
    @State private var tapCount = 0

    let styleNames = ["Scale", "Lift", "Pill", "Neon", "Ghost"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Custom button styles", systemImage: "slider.horizontal.3")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.btnPurple)

                // Style selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(styleNames.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedStyle = i }
                            } label: {
                                Text(styleNames[i])
                                    .font(.system(size: 12, weight: selectedStyle == i ? .semibold : .regular))
                                    .foregroundStyle(selectedStyle == i ? Color.btnPurple : .secondary)
                                    .padding(.horizontal, 12).padding(.vertical, 6)
                                    .background(selectedStyle == i ? Color.btnPurpleLight : Color(.systemFill))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }

                // Live preview
                ZStack {
                    Color(.secondarySystemBackground)
                    previewButton
                }
                .frame(maxWidth: .infinity).frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedStyle)

                // Tap count
                HStack(spacing: 6) {
                    Image(systemName: "hand.tap")
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                    Text("Tapped \(tapCount) times")
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                    Spacer()
                    Button("Reset") { tapCount = 0 }
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                        .buttonStyle(PressableButtonStyle())
                }
            }
        }
    }

    @ViewBuilder
    private var previewButton: some View {
        switch selectedStyle {
        case 0:
            Button { tapCount += 1 } label: {
                Text("Scale press")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28).padding(.vertical, 14)
                    .background(Color.btnPurple)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(ScaleButtonStyle())

        case 1:
            Button { tapCount += 1 } label: {
                Text("Lift press")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28).padding(.vertical, 14)
                    .background(Color.animTeal)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Color.animTeal.opacity(0.5), radius: 10, y: 4)
            }
            .buttonStyle(LiftButtonStyle())

        case 2:
            Button { tapCount += 1 } label: {
                Text("Pill button")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32).padding(.vertical, 14)
                    .background(
                        LinearGradient(colors: [Color(hex: "#9B67F5"), Color.btnPurple],
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color.btnPurple.opacity(0.4), radius: 12, y: 6)
            }
            .buttonStyle(ScaleButtonStyle())

        case 3:
            Button { tapCount += 1 } label: {
                Text("Neon")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(hex: "#00FF88"))
                    .padding(.horizontal, 28).padding(.vertical, 14)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "#00FF88"), lineWidth: 1.5)
                    )
                    .shadow(color: Color(hex: "#00FF88").opacity(0.5), radius: 12)
            }
            .buttonStyle(ScaleButtonStyle())

        default:
            Button { tapCount += 1 } label: {
                Text("Ghost button")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.btnPurple)
                    .padding(.horizontal, 28).padding(.vertical, 14)
                    .background(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.btnPurple, lineWidth: 1.5)
                    )
            }
            .buttonStyle(GhostButtonStyle())
        }
    }
}

// MARK: - Custom Styles

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct LiftButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .offset(y: configuration.isPressed ? 2 : 0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct GhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct CustomStyleExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Building custom button styles")
            Text("A custom ButtonStyle gets access to the label AND the pressed state via configuration. This is how you build reusable interaction styles, like scale, lift, opacity, color shifts, and more that any button in your app can adopt.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Conform to ButtonStyle and implement makeBody(configuration:).", color: .btnPurple)
                StepRow(number: 2, text: "configuration.label is the button's content - apply modifiers to it.", color: .btnPurple)
                StepRow(number: 3, text: "configuration.isPressed is a Bool - true while the user's finger is down.", color: .btnPurple)
                StepRow(number: 4, text: "Add .contentShape(Rectangle()) to ensure the full frame is tappable, not just the visible content.", color: .btnPurple)
                StepRow(number: 5, text: "Animate using .animation(_:value: configuration.isPressed) for smooth press feedback.", color: .btnPurple)
            }

            CalloutBox(style: .success, title: "isPressed gives you press-in and press-out", contentBody: "SwiftUI calls makeBody every time isPressed changes, so you get two calls: once when the finger touches down, once when it lifts. Drive your animation from this single Bool.")

            CalloutBox(style: .info, title: "PrimitiveButtonStyle for full control", contentBody: "ButtonStyle automatically handles the tap gesture. PrimitiveButtonStyle gives you trigger() to fire the action manually, use it when you need to delay the action, add a long press first, or intercept the tap entirely.")

            CodeBlock(code: """
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(
                .spring(response: 0.25, dampingFraction: 0.6),
                value: configuration.isPressed
            )
    }
}

// Usage
Button { doSomething() } label: {
    Text("Press me")
        .padding()
        .background(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 12))
}
.buttonStyle(ScaleButtonStyle())

// Or apply to many buttons at once
VStack {
    Button("Save") { }
    Button("Share") { }
}
.buttonStyle(ScaleButtonStyle())
""")
        }
    }
}
