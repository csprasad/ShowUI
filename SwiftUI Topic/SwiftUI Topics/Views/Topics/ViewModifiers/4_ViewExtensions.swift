//
//
//  4_ViewExtensions.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `08/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: View Extensions
extension View {
    func cardStyle(color: Color = .vmGreen, radius: CGFloat = 14) -> some View {
        modifier(CardModifier(color: color, radius: radius))
    }

    func badge(_ text: String, color: Color = .red) -> some View {
        modifier(BadgeModifier(text: text, color: color))
    }

    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }

    func pressable() -> some View {
        modifier(PressableModifier())
    }
}

struct PressableModifier: ViewModifier {
    @GestureState private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.94 : 1.0)
            .brightness(isPressed ? -0.05 : 0)
            .animation(.spring(response: 0.25, dampingFraction: 0.65), value: isPressed)
            .gesture(DragGesture(minimumDistance: 0).updating($isPressed) { _, s, _ in s = true })
    }
}

struct ViewExtensionVisual: View {
    @State private var selectedDemo = 0
    let demos = [".cardStyle()", ".badge()", ".shimmer()", ".pressable()"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("View extensions", systemImage: "puzzlepiece.extension.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.vmGreen)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(demos.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                            } label: {
                                Text(demos[i])
                                    .font(.system(size: 10, weight: selectedDemo == i ? .semibold : .regular, design: .monospaced))
                                    .foregroundStyle(selectedDemo == i ? Color.vmGreen : .secondary)
                                    .padding(.horizontal, 10).padding(.vertical, 6)
                                    .background(selectedDemo == i ? Color.vmGreenLight : Color(.systemFill))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }

                ZStack {
                    Color(.secondarySystemBackground)
                    extensionDemo.padding(16)
                }
                .frame(maxWidth: .infinity).frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.35), value: selectedDemo)
            }
        }
    }

    @ViewBuilder
    private var extensionDemo: some View {
        switch selectedDemo {
        case 0:
            // cardStyle()
            HStack(spacing: 10) {
                Text("Default").font(.system(size: 13)).foregroundStyle(Color.vmGreen).cardStyle()
                Text("Blue").font(.system(size: 13)).foregroundStyle(Color.navBlue).cardStyle(color: .navBlue)
                Text("r=24").font(.system(size: 13)).foregroundStyle(Color.ssPurple).cardStyle(color: .ssPurple, radius: 24)
            }
        case 1:
            // badge()
            HStack(spacing: 24) {
                Image(systemName: "bell.fill").font(.system(size: 32)).foregroundStyle(Color.vmGreen)
                    .frame(width: 56, height: 56).background(Color.vmGreenLight).clipShape(RoundedRectangle(cornerRadius: 14))
                    .badge("5")
                Text("Messages").font(.system(size: 14, weight: .semibold))
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background(Color(.systemBackground)).clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                    .badge("NEW", color: .vmGreen)
            }
        case 2:
            // shimmer()
            VStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { i in
                    HStack(spacing: 10) {
                        Circle().fill(Color(.systemFill)).frame(width: 32, height: 32)
                        RoundedRectangle(cornerRadius: 4).fill(Color(.systemFill)).frame(maxWidth: .infinity).frame(height: 12)
                    }
                }
            }
            .shimmer()
        default:
            // pressable()
            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    ForEach(["Tap me", "Or me", "Me too"], id: \.self) { label in
                        Text(label)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .background(Color.vmGreen)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .pressable()
                    }
                }
                Text(".pressable() - scale + brightness on press").font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }
    }
}

struct ViewExtensionExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "View extensions - ergonomic API")
            Text("Wrapping ViewModifier in a View extension gives you a clean .myStyle() call syntax instead of .modifier(MyStyle()). This is exactly how SwiftUI's own modifiers work - .padding(), .background(), .foregroundStyle() are all just extension methods.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "extension View { func myModifier() -> some View { modifier(MyModifier()) } } - one line per extension.", color: .vmGreen)
                StepRow(number: 2, text: "Add parameters to both the extension and the ViewModifier struct for customizable modifiers.", color: .vmGreen)
                StepRow(number: 3, text: "Default parameter values make modifiers easy to use for the common case while allowing customization.", color: .vmGreen)
                StepRow(number: 4, text: "Group related modifiers in an extension in their own file - keeps your codebase organized.", color: .vmGreen)
            }

            CalloutBox(style: .success, title: "This is how SwiftUI itself works", contentBody: "Text.bold(), View.padding(), View.foregroundStyle() - all of these are View extension methods returning modified views. Your custom modifiers are first-class citizens alongside the built-in ones.")

            CodeBlock(code: """
// Define modifier
struct PrimaryButton: ViewModifier {
    var isLoading: Bool

    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isLoading ? Color.gray : Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// Extension for clean API
extension View {
    func primaryButton(isLoading: Bool = false) -> some View {
        modifier(PrimaryButton(isLoading: isLoading))
    }
}

// Usage - reads like SwiftUI built-ins
Button("Continue") { }
    .primaryButton()

Button("Please wait") { }
    .primaryButton(isLoading: true)
""")
        }
    }
}
