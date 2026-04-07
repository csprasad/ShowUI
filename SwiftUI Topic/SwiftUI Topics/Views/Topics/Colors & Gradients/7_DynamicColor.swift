//
//
//  7_DynamicColor.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Dynamic Color
struct DynamicColorVisual: View {
    @Environment(\.colorScheme) var scheme
    @State private var selectedDemo = 0
    @State private var forcedScheme: ColorScheme = .light

    let demos = ["Auto adapt", "Color scheme", "UIColor bridge"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Dynamic color", systemImage: "circle.lefthalf.filled")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cgAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.cgAmber : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.cgAmberLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Adaptive color side by side
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            adaptiveCard("Light mode", scheme: .light)
                            adaptiveCard("Dark mode", scheme: .dark)
                        }
                        .frame(maxWidth: .infinity)
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.cgAmber)
                            Text("System colors flip automatically. Your device is in \(scheme == .dark ? "dark" : "light") mode right now.")
                                .font(.system(size: 11)).foregroundStyle(Color.cgAmber)
                        }
                        .padding(8).background(Color.cgAmberLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // Color scheme environment
                    VStack(alignment: .leading, spacing: 10) {
                        // Force light/dark preview
                        HStack(spacing: 8) {
                            Button {
                                withAnimation(.spring(response: 0.3)) { forcedScheme = .light }
                            } label: {
                                Label("Light", systemImage: "sun.max.fill")
                                    .font(.system(size: 12, weight: forcedScheme == .light ? .semibold : .regular))
                                    .foregroundStyle(forcedScheme == .light ? Color.cgAmber : .secondary)
                                    .frame(maxWidth: .infinity).padding(.vertical, 7)
                                    .background(forcedScheme == .light ? Color.cgAmberLight : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(PressableButtonStyle())

                            Button {
                                withAnimation(.spring(response: 0.3)) { forcedScheme = .dark }
                            } label: {
                                Label("Dark", systemImage: "moon.fill")
                                    .font(.system(size: 12, weight: forcedScheme == .dark ? .semibold : .regular))
                                    .foregroundStyle(forcedScheme == .dark ? Color.white : .secondary)
                                    .frame(maxWidth: .infinity).padding(.vertical, 7)
                                    .background(forcedScheme == .dark ? Color(hex: "#1C1C1E") : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(PressableButtonStyle())
                        }

                        // Forced preview card
                        ZStack {
                            (forcedScheme == .dark ? Color(hex: "#1C1C1E") : Color.white)
                            VStack(spacing: 8) {
                                HStack(spacing: 10) {
                                    Circle().fill(Color(.systemBlue)).frame(width: 36, height: 36)
                                        .overlay(Image(systemName: "person.fill").font(.system(size: 16)).foregroundStyle(.white))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Alice Chen").font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(forcedScheme == .dark ? .white : .primary)
                                        Text("iOS Engineer").font(.system(size: 12))
                                            .foregroundStyle(forcedScheme == .dark ? Color(white: 0.6) : Color.secondary)
                                    }
                                    Spacer()
                                }
                                Divider()
                                HStack(spacing: 8) {
                                    Image(systemName: "envelope.fill").foregroundStyle(.blue)
                                    Text("Message").font(.system(size: 13))
                                        .foregroundStyle(forcedScheme == .dark ? .white : .primary)
                                    Spacer()
                                    Image(systemName: "chevron.right").font(.system(size: 11))
                                        .foregroundStyle(forcedScheme == .dark ? Color(white: 0.4) : Color.secondary)
                                }
                            }
                            .padding(12)
                        }
                        .frame(maxWidth: .infinity).frame(height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: .black.opacity(forcedScheme == .dark ? 0 : 0.08), radius: 8)
                        .environment(\.colorScheme, forcedScheme)
                        .animation(.spring(response: 0.35), value: forcedScheme)
                    }

                default:
                    // UIColor bridge
                    VStack(alignment: .leading, spacing: 8) {
                        uiColorRow("Color(.systemBackground)", Color(.systemBackground))
                        uiColorRow("Color(.secondarySystemBackground)", Color(.secondarySystemBackground))
                        uiColorRow("Color(.tertiarySystemBackground)", Color(.tertiarySystemBackground))
                        uiColorRow("Color(.label)", Color(.label))
                        uiColorRow("Color(.secondaryLabel)", Color(.secondaryLabel))
                        uiColorRow("Color(UIColor.systemIndigo)", Color(UIColor.systemIndigo))
                    }
                }
            }
        }
    }

    func adaptiveCard(_ label: String, scheme: ColorScheme) -> some View {
        let isDark = scheme == .dark
        return VStack(spacing: 8) {
            Text(label).font(.system(size: 14, weight: .semibold))
                .foregroundStyle(isDark ? .white : .primary)
            Divider()
            VStack(alignment: .leading, spacing: 6) {
                colorSwatch(isDark ? .white : Color(.label), name: ".primary")
                colorSwatch(isDark ? Color(white: 0.6) : Color(.secondaryLabel), name: ".secondary")
                colorSwatch(isDark ? Color(hex: "#1C1C1E") : .white, name: "systemBg", outlined: true)
                colorSwatch(isDark ? Color(hex: "#2C2C2E") : Color(.secondarySystemBackground), name: "secondaryBg")
            }.frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(isDark ? Color(hex: "#1C1C1E") : .white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.07), radius: 6)
        .environment(\.colorScheme, scheme)
    }

    func colorSwatch(_ color: Color, name: String, outlined: Bool = false) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 4).fill(color).frame(width: 30, height: 22)
                .overlay(outlined ? AnyView(RoundedRectangle(cornerRadius: 4).stroke(Color(.systemFill), lineWidth: 1)) : AnyView(EmptyView()))
            Text(name).font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
        }
    }

    func uiColorRow(_ name: String, _ color: Color) -> some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 6).fill(color).frame(width: 28, height: 28)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(.systemFill), lineWidth: 1))
            Text(name).font(.system(size: 9, design: .monospaced)).foregroundStyle(.primary).lineLimit(1).minimumScaleFactor(0.7)
        }
        .padding(6).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct DynamicColorExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Dynamic color & dark mode")
            Text("SwiftUI's color system adapts to the current appearance automatically. Semantic colors like .primary and Color(.systemBackground) flip between light and dark values - your UI adapts with zero extra code.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@Environment(\\.colorScheme) var scheme - reads .light or .dark. Use to provide different values per mode.", color: .cgAmber)
                StepRow(number: 2, text: ".environment(\\.colorScheme, .dark) - forces a view tree into dark mode. Great for previews.", color: .cgAmber)
                StepRow(number: 3, text: "Color(.systemBackground) via UIColor - access the full palette of adaptive UIColor system colors.", color: .cgAmber)
                StepRow(number: 4, text: "Asset catalog colors with light/dark variants - define exact hex values that adapt to appearance.", color: .cgAmber)
                StepRow(number: 5, text: "Color(light: .white, dark: Color(hex: \"#1C1C1E\")) - inline adaptive color init (via custom extension).", color: .cgAmber)
            }

            CalloutBox(style: .warning, title: "Avoid hardcoded colors in UI", contentBody: "Color(hex: \"#FFFFFF\") is always white - invisible in dark mode if used as text. For any UI element, use Color(.label) instead of .black, Color(.systemBackground) instead of .white.")

            CodeBlock(code: """
// Read current scheme
@Environment(\\.colorScheme) var scheme

var textColor: Color {
    scheme == .dark ? .white : Color(.label)
}

// Force dark mode preview
struct MyView: View { ... }

#Preview {
    MyView()
        .environment(\\.colorScheme, .dark)
}

// UIColor bridge - full adaptive palette
Color(.systemBackground)           // white/near-black
Color(.secondarySystemBackground)  // card background
Color(.label)                      // text - black/white
Color(.secondaryLabel)             // secondary text
Color(.systemFill)                 // fill color

// Asset catalog color
Color("BrandPrimary")  // defined in Assets.xcassets
                       // with light + dark variants

// Conditional color (custom extension)
extension Color {
    init(light: Color, dark: Color) {
        self = Color(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(dark) : UIColor(light)
        })
    }
}
""")
        }
    }
}
