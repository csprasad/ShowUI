//
//
//  6_GradientFill.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Gradient as Fill
struct GradientFillVisual: View {
    @State private var selectedDemo = 0
    @State private var animating = false

    let demos = ["Shapes", "Text fill", "Stroke", "Background"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Gradient as fill", systemImage: "paintbrush.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cgAmber)

                let cols = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
                LazyVGrid(columns: cols, spacing: 8) {
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

                ZStack {
                    Color(.secondarySystemBackground)
                    gradientFillDemo.padding(16)
                }
                .frame(maxWidth: .infinity).frame(height: 170)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedDemo)
            }
        }
    }

    @ViewBuilder
    private var gradientFillDemo: some View {
        let grad1 = LinearGradient(colors: [Color(hex: "#667EEA"), Color(hex: "#764BA2")], startPoint: .topLeading, endPoint: .bottomTrailing)
        let grad2 = LinearGradient(colors: [Color(hex: "#F093FB"), Color(hex: "#F5576C")], startPoint: .leading, endPoint: .trailing)
        let grad3 = AngularGradient(colors: [.red,.orange,.yellow,.green,.blue,.purple,.red], center: .center)

        switch selectedDemo {
        case 0:
            // Gradient on shapes
            HStack(spacing: 14) {
                VStack(spacing: 6) {
                    Circle().fill(grad1).frame(width: 64, height: 64)
                    Text("Circle").font(.system(size: 9)).foregroundStyle(.secondary)
                }
                VStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 14).fill(grad2).frame(width: 64, height: 64)
                    Text("RoundedRect").font(.system(size: 9)).foregroundStyle(.secondary)
                }
                VStack(spacing: 6) {
                    Capsule().fill(grad3).frame(width: 64, height: 36)
                    Text("Capsule").font(.system(size: 9)).foregroundStyle(.secondary)
                }
                VStack(spacing: 6) {
                    // Custom star shape with gradient
                    ZStack {
                        RadialGradient(colors: [Color(hex: "#FEE140"), Color(hex: "#FA709A")], center: .center, startRadius: 0, endRadius: 36)
                            .frame(width: 64, height: 64)
                            .mask(Image(systemName: "star.fill").font(.system(size: 52)))
                    }
                    Text("Symbol\nmask").font(.system(size: 9)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                }
            }

        case 1:
            // Text fill with gradient
            VStack(spacing: 14) {
                Text("Gradient")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(grad1)
                Text("Text Fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(colors: [Color(hex: "#F5576C"), Color(hex: "#FEE140")], startPoint: .leading, endPoint: .trailing)
                    )
                Text("Multi-color")
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundStyle(grad3)
            }

        case 2:
            // Gradient stroke
            VStack(spacing: 14) {
                Circle()
                    .strokeBorder(grad1, lineWidth: 4)
                    .frame(width: 80, height: 80)
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(grad2, lineWidth: 3)
                    .frame(width: 160, height: 44)
                    .overlay(Text("Gradient stroke").font(.system(size: 12, weight: .semibold)).foregroundStyle(grad2))
            }

        default:
            // View background
            VStack(spacing: 12) {
                HStack(spacing: 10) {
                    Text("Card 1").font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background(grad1).clipShape(RoundedRectangle(cornerRadius: 12))
                    Text("Card 2").font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background(grad2).clipShape(RoundedRectangle(cornerRadius: 12))
                }
                // Shorthand .gradient
                HStack(spacing: 10) {
                    ForEach([Color.blue, Color.purple, Color.red], id: \.self) { c in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(c.gradient)
                            .frame(height: 44)
                            .overlay(Text(".gradient").font(.system(size: 9, design: .monospaced)).foregroundStyle(.white.opacity(0.8)))
                    }
                }
            }
        }
    }
}

struct GradientFillExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Gradient as ShapeStyle")
            Text("In SwiftUI, any gradient can be used anywhere a ShapeStyle is accepted - as a fill for shapes, foreground for text, stroke for outlines, or background for views. Gradients conform to ShapeStyle directly.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".fill(gradient) - fills any Shape with a gradient: Circle, RoundedRectangle, custom paths.", color: .cgAmber)
                StepRow(number: 2, text: ".foregroundStyle(gradient) - applies gradient to text, SF Symbols, or any foreground-colored view.", color: .cgAmber)
                StepRow(number: 3, text: ".strokeBorder(gradient, lineWidth:) - gradient outline on a shape.", color: .cgAmber)
                StepRow(number: 4, text: ".background(gradient) - gradient as view background. Fills the full view bounds.", color: .cgAmber)
                StepRow(number: 5, text: "Color.blue.gradient - convenience property for a soft gradient derived from any Color.", color: .cgAmber)
            }

            CalloutBox(style: .success, title: "Gradient text in one line", contentBody: "Text(\"Hello\").foregroundStyle(LinearGradient(...)) applies a gradient directly to the text. No masking or ZStack needed - SwiftUI handles it natively.")

            CodeBlock(code: """
let gradient = LinearGradient(
    colors: [.purple, .blue],
    startPoint: .leading,
    endPoint: .trailing
)

// Fill a shape
Circle().fill(gradient)
RoundedRectangle(cornerRadius: 12).fill(gradient)

// Gradient text
Text("Hello")
    .font(.largeTitle.bold())
    .foregroundStyle(gradient)

// Gradient stroke
Circle()
    .strokeBorder(gradient, lineWidth: 3)

// View background
VStack { content }
    .background(gradient)

// Shorthand gradient from any Color
Rectangle().fill(Color.blue.gradient)
Text("Label").foregroundStyle(Color.red.gradient)
""")
        }
    }
}

