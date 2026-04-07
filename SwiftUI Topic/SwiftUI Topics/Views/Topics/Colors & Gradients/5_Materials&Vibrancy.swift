//
//
//  5_Materials&Vibrancy.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Materials & Vibrancy
struct MaterialsVisual: View {
    @State private var selectedMaterial = 0
    @State private var selectedDemo = 0
    let demos = ["Materials", "Blur effect", "Vibrancy"]

    let materials: [(name: String, mat: Material, desc: String)] = [
        (".ultraThinMaterial",  .ultraThinMaterial,  "Most transparent blur"),
        (".thinMaterial",       .thinMaterial,       "Light frosted glass"),
        (".regularMaterial",    .regularMaterial,    "Standard blur"),
        (".thickMaterial",      .thickMaterial,      "Heavier blur"),
        (".ultraThickMaterial", .ultraThickMaterial, "Most opaque blur"),
        (".bar",                .bar,                "Navigation/tab bar style"),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Materials & vibrancy", systemImage: "camera.filters")
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
                    // Material selector + preview
                    VStack(spacing: 8) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(materials.indices, id: \.self) { i in
                                    Button {
                                        withAnimation(.spring(response: 0.3)) { selectedMaterial = i }
                                    } label: {
                                        Text(materials[i].name.replacingOccurrences(of: ".", with: ""))
                                            .font(.system(size: 10, weight: selectedMaterial == i ? .semibold : .regular))
                                            .foregroundStyle(selectedMaterial == i ? Color.cgAmber : .secondary)
                                            .padding(.horizontal, 8).padding(.vertical, 5)
                                            .background(selectedMaterial == i ? Color.cgAmberLight : Color(.systemFill))
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }
                        }

                        // Preview - background + frosted card on top
                        ZStack {
                            // Colorful background
                            LinearGradient(colors: [Color(hex: "#667EEA"), Color(hex: "#F5576C"), Color(hex: "#43E97B")],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)

                            // Frosted card
                            VStack(spacing: 8) {
                                Text(materials[selectedMaterial].name)
                                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                Text(materials[selectedMaterial].desc)
                                    .font(.system(size: 11)).foregroundStyle(.secondary)
                            }
                            .padding(16)
                            .background(materials[selectedMaterial].mat)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .frame(maxWidth: .infinity).frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .animation(.spring(response: 0.35), value: selectedMaterial)
                    }

                case 1:
                    // Blur effect
                    VStack(spacing: 10) {
                        ZStack {
                            LinearGradient(colors: [Color(hex: "#FA709A"), Color(hex: "#FEE140"), Color(hex: "#4FACFE")],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                            // Content underneath
                            VStack(spacing: 4) {
                                Text("Content behind").font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                Text("blur radius: 10").font(.system(size: 10, design: .monospaced)).foregroundStyle(.white.opacity(0.8))
                            }
                        }
                        .frame(maxWidth: .infinity).frame(height: 60).clipShape(RoundedRectangle(cornerRadius: 10))

                        ZStack {
                            LinearGradient(colors: [Color(hex: "#FA709A"), Color(hex: "#FEE140"), Color(hex: "#4FACFE")],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                                .blur(radius: 10)
                            Text(".blur(radius: 10)").font(.system(size: 12, design: .monospaced))
                        }
                        .frame(maxWidth: .infinity).frame(height: 60).clipShape(RoundedRectangle(cornerRadius: 10))

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.cgAmber)
                            Text(".blur() on a view blurs that view's contents. Material blurs the content BEHIND the view.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.cgAmberLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // Vibrancy
                    ZStack {
                        LinearGradient(colors: [Color(hex: "#667EEA"), Color(hex: "#764BA2")],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)

                        VStack(spacing: 12) {
                            HStack(spacing: 16) {
                                VStack(spacing: 4) {
                                    Text("Regular").font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
                                    Text("Text").foregroundStyle(.white).font(.system(size: 15, weight: .bold))
                                    Image(systemName: "star.fill").font(.system(size: 20)).foregroundStyle(.white)
                                }
                                VStack(spacing: 4) {
                                    Text("Material BG").font(.system(size: 11, weight: .semibold))
                                    Text("Text").font(.system(size: 15, weight: .bold))
                                    Image(systemName: "star.fill").font(.system(size: 20))
                                }
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            Text(".foregroundStyle(.white) vs text on .ultraThinMaterial")
                                .font(.system(size: 9)).foregroundStyle(.white.opacity(0.7))
                        }
                    }
                    .frame(maxWidth: .infinity).frame(height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}

struct MaterialsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Materials & vibrancy")
            Text("Materials apply a frosted-glass blur effect - they blur the content behind the view. SwiftUI provides six material levels, from nearly transparent to nearly opaque. Use them for cards, sheets, and overlays that float over content.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".background(.regularMaterial) - the standard frosted glass. Most common material usage.", color: .cgAmber)
                StepRow(number: 2, text: ".ultraThinMaterial - barely visible blur, almost transparent. Good for subtle overlays.", color: .cgAmber)
                StepRow(number: 3, text: ".thickMaterial / .ultraThickMaterial - denser blur, more like a solid background.", color: .cgAmber)
                StepRow(number: 4, text: ".bar - specifically designed to match navigation and tab bar appearances.", color: .cgAmber)
                StepRow(number: 5, text: "Materials only blur content behind them - not a filter on the view itself. Use .blur() to blur the view.", color: .cgAmber)
            }

            CalloutBox(style: .success, title: "Materials work in dark mode", contentBody: "Materials automatically adapt between light and dark mode - lighter in light mode, darker in dark mode. This is another reason to prefer materials over custom semi-transparent backgrounds.")

            CodeBlock(code: """
// Frosted card
VStack { content }
    .padding(16)
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 20))

// Floating toolbar
HStack { buttons }
    .padding(12)
    .background(.ultraThinMaterial)
    .clipShape(Capsule())

// Bottom sheet background
.presentationBackground(.regularMaterial)

// All material levels:
// .ultraThinMaterial   - most see-through
// .thinMaterial
// .regularMaterial     - standard
// .thickMaterial
// .ultraThickMaterial  - most opaque
// .bar                 - navigation bar style

// Blur the view itself (not behind it)
Image("photo")
    .blur(radius: 8)    // blurs the image
    .background(.ultraThinMaterial)  // blurs behind
""")
        }
    }
}

