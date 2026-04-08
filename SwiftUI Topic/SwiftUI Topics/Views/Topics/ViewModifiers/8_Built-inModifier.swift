//
//
//  8_Built-inModifier.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `08/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Built-in Modifier Deep Dive
struct BuiltInModifierVisual: View {
    @State private var selectedModifier = 0
    @State private var shadowRadius: CGFloat = 8
    @State private var shadowX: CGFloat = 0
    @State private var shadowY: CGFloat = 4
    @State private var overlayAlignment = 4 // center
    @State private var showOverlay = true

    let modifiers = ["shadow", "overlay", "background", "clipShape", "contentShape"]
    let alignments: [(String, Alignment)] = [
        (".topLeading", .topLeading), (".top", .top), (".topTrailing", .topTrailing),
        (".leading", .leading),       (".center", .center), (".trailing", .trailing),
        (".bottomLeading", .bottomLeading), (".bottom", .bottom), (".bottomTrailing", .bottomTrailing),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Built-in modifier deep dive", systemImage: "square.on.square.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.vmGreen)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(modifiers.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedModifier = i }
                            } label: {
                                Text(".\(modifiers[i])")
                                    .font(.system(size: 10, weight: selectedModifier == i ? .semibold : .regular, design: .monospaced))
                                    .foregroundStyle(selectedModifier == i ? Color.vmGreen : .secondary)
                                    .padding(.horizontal, 10).padding(.vertical, 6)
                                    .background(selectedModifier == i ? Color.vmGreenLight : Color(.systemFill))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }

                ZStack {
                    Color(.secondarySystemBackground)
                    modifierDemo.padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.35), value: selectedModifier)
                .animation(.easeInOut(duration: 0.1), value: shadowRadius)
                .animation(.easeInOut(duration: 0.1), value: shadowX)
                .animation(.easeInOut(duration: 0.1), value: shadowY)
                .animation(.spring(response: 0.3), value: overlayAlignment)
                .animation(.spring(response: 0.3), value: showOverlay)
            }
        }
    }

    @ViewBuilder
    private var modifierDemo: some View {
        switch selectedModifier {
        case 0:
            // shadow deep dive
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .frame(width: 120, height: 70)
                    .shadow(color: Color.vmGreen.opacity(0.35), radius: shadowRadius, x: shadowX, y: shadowY)
                    .overlay(Text("Shadow").font(.system(size: 12)).foregroundStyle(.secondary))

                VStack(spacing: 5) {
                    sliderRow("radius", value: $shadowRadius, range: 0...30)
                    sliderRow("x", value: $shadowX, range: -20...20)
                    sliderRow("y", value: $shadowY, range: -20...20)
                }
            }

        case 1:
            // overlay alignment grid
            VStack(spacing: 10) {
                ZStack {
                    GradientPlaceholder(index: 3)
                        .frame(width: 120, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(alignment: alignments[overlayAlignment].1) {
                            if showOverlay {
                                Text("Overlay")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 6).padding(.vertical, 3)
                                    .background(Color.vmGreen)
                                    .clipShape(Capsule())
                                    .padding(4)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                }

                HStack(spacing: 4) {
                    Button { withAnimation { showOverlay.toggle() } } label: {
                        Text(showOverlay ? "Hide" : "Show")
                            .font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.vmGreen)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Color.vmGreenLight).clipShape(Capsule())
                    }.buttonStyle(PressableButtonStyle())
                    Text("Alignment:").font(.system(size: 10)).foregroundStyle(.secondary)
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 3), spacing: 3) {
                    ForEach(alignments.indices, id: \.self) { i in
                        Button { withAnimation { overlayAlignment = i } } label: {
                            Text(alignments[i].0.replacingOccurrences(of: ".", with: ""))
                                .font(.system(size: 7, design: .monospaced))
                                .foregroundStyle(overlayAlignment == i ? .white : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 4)
                                .background(overlayAlignment == i ? Color.vmGreen : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }.buttonStyle(PressableButtonStyle())
                    }
                }
            }

        case 2:
            // background
            VStack(spacing: 10) {
                HStack(spacing: 14) {
                    VStack(spacing: 4) {
                        Text("Color").font(.system(size: 11)).foregroundStyle(.secondary)
                        Text("Bg").font(.system(size: 14, weight: .bold))
                            .padding(10).background(Color.vmGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    VStack(spacing: 4) {
                        Text("Gradient").font(.system(size: 11)).foregroundStyle(.secondary)
                        Text("Bg").font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
                            .padding(10)
                            .background(LinearGradient(colors: [.vmGreen, Color(hex: "#4ADE80")], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    VStack(spacing: 4) {
                        Text("Material").font(.system(size: 11)).foregroundStyle(.secondary)
                        Text("Bg").font(.system(size: 14, weight: .bold))
                            .padding(10).background(.regularMaterial).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    VStack(spacing: 4) {
                        Text("Shape").font(.system(size: 11)).foregroundStyle(.secondary)
                        Text("Bg").font(.system(size: 14, weight: .bold))
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.vmGreenLight).stroke(Color.vmGreen, lineWidth: 1.5))
                    }
                }
                Text(".background accepts Color, Gradient, Material, or any ShapeStyle")
                    .font(.system(size: 9)).foregroundStyle(.secondary).multilineTextAlignment(.center)
            }

        case 3:
            // clipShape
            HStack(spacing: 14) {
                ForEach([
                    ("Circle", AnyShape(Circle())),
                    ("Capsule", AnyShape(Capsule())),
                    ("Rect r:20", AnyShape(RoundedRectangle(cornerRadius: 20))),
                    ("Custom", AnyShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 4, bottomTrailingRadius: 20, topTrailingRadius: 4))),
                ], id: \.0) { name, shape in
                    VStack(spacing: 5) {
                        GradientPlaceholder(index: 2).frame(width: 56, height: 56).clipShape(shape)
                        Text(name).font(.system(size: 8)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                    }
                }
            }

        default:
            // contentShape
            VStack(spacing: 12) {
                Text(".contentShape defines the tappable/hittable area").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                HStack(spacing: 20) {
                    VStack(spacing: 6) {
                        HStack(spacing: 10) {
                            Image(systemName: "star").font(.system(size: 20)).foregroundStyle(Color.vmGreen)
                            Spacer().frame(width: 20)
                            Text("Title").font(.system(size: 13))
                        }
                        .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                        .onTapGesture { }
                        Text("No contentShape\nonly icons/text tap").font(.system(size: 8)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                    }
                    VStack(spacing: 6) {
                        HStack(spacing: 10) {
                            Image(systemName: "star").font(.system(size: 20)).foregroundStyle(Color.vmGreen)
                            Spacer().frame(width: 20)
                            Text("Title").font(.system(size: 13))
                        }
                        .padding(10).background(Color.vmGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                        .contentShape(Rectangle())
                        .onTapGesture { }
                        Text(".contentShape(Rectangle())\nfull row tappable ✓").font(.system(size: 8)).foregroundStyle(Color.vmGreen).multilineTextAlignment(.center)
                    }
                }
            }
        }
    }

    func sliderRow(_ label: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>) -> some View {
        HStack(spacing: 8) {
            Text(label).font(.system(size: 10)).foregroundStyle(.secondary).frame(width: 36)
            Slider(value: value, in: range).tint(.vmGreen)
            Text(String(format: "%.0f", value.wrappedValue))
                .font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.vmGreen).frame(width: 24)
        }
    }
}

struct BuiltInModifierExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Built-in modifiers in depth")
            Text("The most commonly used built-in modifiers each have important subtleties. shadow, overlay, background, clipShape, and contentShape are all more powerful and nuanced than they first appear.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".shadow(color:radius:x:y:) - color defaults to black at 33% opacity. Shadow is on the outside of clipShape.", color: .vmGreen)
                StepRow(number: 2, text: ".overlay(alignment:) { view } - places a view on top. alignment controls where. Applied after clipShape follows the shape.", color: .vmGreen)
                StepRow(number: 3, text: ".background accepts Color, Gradient, Material, or any ShapeStyle - even a custom Shape with fill+stroke.", color: .vmGreen)
                StepRow(number: 4, text: ".clipShape(shape, style:) - any Shape works. .continuous on RoundedRectangle for smooth iOS-style corners.", color: .vmGreen)
                StepRow(number: 5, text: ".contentShape(shape) - defines the interaction area. Critical for HStack rows where gaps would otherwise be non-tappable.", color: .vmGreen)
            }

            CalloutBox(style: .warning, title: "contentShape is required for HStack tap targets", contentBody: "HStack { Image(); Spacer(); Text() }.onTapGesture - only the Image and Text are tappable. The Spacer gap in the middle is not. Add .contentShape(Rectangle()) to make the entire row tappable.")

            CodeBlock(code: """
// shadow - after clipShape
view
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

// overlay - badge pattern
Image("avatar")
    .clipShape(Circle())
    .overlay(alignment: .bottomTrailing) {
        StatusBadge()
    }

// background - with shape style
Text("Badge")
    .padding(8)
    .background(
        RoundedRectangle(cornerRadius: 8)
            .fill(.blue.opacity(0.1))
            .stroke(.blue.opacity(0.3), lineWidth: 1)
    )

// clipShape - continuous corners
.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

// contentShape - full row tap
HStack {
    icon; Spacer(); Text("Label")
}
.contentShape(Rectangle())   // whole HStack tappable
.onTapGesture { select() }
""")
        }
    }
}

