//
//
//  6_EnvironmentModifiers.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `08/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Environment Modifiers
struct EnvironmentModifierVisual: View {
    @State private var fontSize: CGFloat = 14
    @State private var textColor: Color = .vmGreen
    @State private var colorSchemeForced: ColorScheme = .light
    @State private var selectedDemo = 0

    let demos = ["Font propagation", "ForegroundStyle", "Force dark mode"]

    let colors: [(Color, String)] = [(.vmGreen, "green"), (.navBlue, "blue"), (.ssPurple, "purple"), (.animCoral, "coral")]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Environment modifiers", systemImage: "leaf.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.vmGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 10, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.vmGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.vmGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Font propagation
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Text("size:").font(.system(size: 11)).foregroundStyle(.secondary).frame(width: 30)
                            Slider(value: $fontSize, in: 10...22, step: 1).tint(.vmGreen)
                            Text("\(Int(fontSize))pt").font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.vmGreen).frame(width: 28)
                        }

                        // Container with .font - propagates to all children
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Parent sets .font - propagates down")
                                .font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 8) {
                                    Text("Title").fontWeight(.bold)
                                    Text("(bold override)")
                                        .font(.system(size: 10)).foregroundStyle(.secondary) // override
                                }
                                Text("Subtitle - inherits parent font size")
                                Text("Body text - also inherits")
                                HStack(spacing: 6) {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("SF Symbol + Text - both scale together")
                                }
                            }
                            .font(.system(size: fontSize))  // single modifier propagates to all
                            .foregroundStyle(Color.vmGreen)
                            .padding(10).background(Color.vmGreenLight).clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .animation(.easeInOut(duration: 0.1), value: fontSize)
                    }

                case 1:
                    // foregroundStyle propagation
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Text("color:").font(.system(size: 11)).foregroundStyle(.secondary)
                            ForEach(colors.indices, id: \.self) { i in
                                Button { withAnimation { textColor = colors[i].0 } } label: {
                                    Circle().fill(colors[i].0).frame(width: 24, height: 24)
                                        .overlay(Circle().stroke(.white, lineWidth: textColor == colors[i].0 ? 2 : 0))
                                }.buttonStyle(PressableButtonStyle())
                            }
                            Spacer()
                        }

                        // foregroundStyle set on container → propagates
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 10) {
                                Image(systemName: "star.fill")
                                Text("Featured")
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                            }
                            Text("One .foregroundStyle on the HStack tints all children - text, icons, everything")
                                .font(.system(size: 11)).opacity(0.7)
                        }
                        .foregroundStyle(textColor)  // propagates to all children
                        .padding(12).background(textColor.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))
                        .animation(.spring(response: 0.3), value: textColor.description)
                    }

                default:
                    // Force dark mode
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            ForEach([("Light", ColorScheme.light), ("Dark", ColorScheme.dark)], id: \.0) { label, cs in
                                Button { withAnimation(.spring(response: 0.3)) { colorSchemeForced = cs } } label: {
                                    Text(label)
                                        .font(.system(size: 12, weight: colorSchemeForced == cs ? .semibold : .regular))
                                        .foregroundStyle(colorSchemeForced == cs ? .white : .secondary)
                                        .frame(maxWidth: .infinity).padding(.vertical, 8)
                                        .background(colorSchemeForced == cs ? Color.vmGreen : Color(.systemFill))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }

                        // The forced-scheme view
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Card title").font(.system(size: 14, weight: .semibold))
                                Spacer()
                                Image(systemName: "ellipsis.circle").foregroundStyle(.secondary)
                            }
                            Text("This card adapts using system colors - apply .environment(\\.colorScheme) to force it.")
                                .font(.system(size: 12)).foregroundStyle(.secondary)
                        }
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .environment(\.colorScheme, colorSchemeForced)
                        .animation(.easeInOut(duration: 0.3), value: colorSchemeForced)
                    }
                }
            }
        }
    }
}

struct EnvironmentModifierExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Environment modifiers")
            Text("Some modifiers propagate through the entire view hierarchy - they're called environment modifiers. Set them once on a parent and all descendants inherit the value unless they override it with their own.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".font() on a VStack sets the default font for every Text inside - unless a child overrides it.", color: .vmGreen)
                StepRow(number: 2, text: ".foregroundStyle() propagates to all children - icons, text, shapes all get the same color.", color: .vmGreen)
                StepRow(number: 3, text: ".environment(\\.colorScheme, .dark) forces dark mode on the entire subtree.", color: .vmGreen)
                StepRow(number: 4, text: "Child overrides parent: a Text with its own .font() ignores the parent's .font().", color: .vmGreen)
                StepRow(number: 5, text: "Regular modifiers (.padding, .background) don't propagate - they only affect the one view.", color: .vmGreen)
            }

            CalloutBox(style: .success, title: "One .font() instead of many", contentBody: "Instead of setting the same font on 5 Text views, set it once on their container VStack. Each Text still overrides with its own weight or size if needed - the parent just provides the default.")

            CalloutBox(style: .info, title: "Environment vs regular modifiers", contentBody: "Environment modifiers: .font(), .foregroundStyle(), .environment(), .tint(), .disabled(). Regular (non-propagating) modifiers: .padding(), .background(), .opacity(), .frame(). Knowing which is which prevents unexpected cascading.")

            CodeBlock(code: """
// Environment modifier - propagates to all children
VStack {
    Text("Title").fontWeight(.bold)     // overrides weight
    Text("Body")                        // inherits size
    Label("Icon", systemImage: "star")  // icon also inherits
}
.font(.system(size: 15))    // set once, all children inherit

// foregroundStyle propagates
HStack {
    Image(systemName: "star")  // tinted blue
    Text("Featured")           // tinted blue
    Spacer()
    Text("→")                 // tinted blue
}
.foregroundStyle(.blue)

// Force dark mode on subtree
CardView()
    .environment(\\.colorScheme, .dark)

// Disable entire subtree
FormSection()
    .disabled(isLoading)   // all controls inside are disabled
""")
        }
    }
}
