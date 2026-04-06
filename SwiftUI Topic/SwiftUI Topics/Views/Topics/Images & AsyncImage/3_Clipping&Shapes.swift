//
//
//  3_Clipping&Shapes.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Clipping & Shapes
struct ClippingVisual: View {
    @State private var selectedDemo = 0
    @State private var cornerRadius: CGFloat = 16
    let demos = ["Standard shapes", "Custom angles", "Borders & rings", "Corner\nradius"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Clipping & shapes", systemImage: "seal.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.imgIndigo)

                // The Segmented Control (Fixed indices)
                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            // Unified spring for all transitions
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.imgIndigo : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.imgIndigoLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // The Visual Container
                ZStack {
                    Color(.secondarySystemBackground)
                    clippingDemo.padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                
                // Radius Slider (Now Case 3)
                if selectedDemo == 3 {
                    VStack(spacing: 12) {
                        HStack(spacing: 10) {
                            Text("radius").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 40)
                            Slider(value: $cornerRadius, in: 0...60, step: 2).tint(.imgIndigo)
                            Text("\(Int(cornerRadius))pt").font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 36)
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity)) // slider reveal
                }
            }
        }
    }

    @ViewBuilder
    private var clippingDemo: some View {
        switch selectedDemo {
        case 0:
            //Standard shapes
            HStack(alignment: .top, spacing: 16) {
                let size: CGFloat = 68
                
                // Circle
                VisualColumn(title: "Circle") {
                    GradientPlaceholder(index: 0).frame(width: size, height: size).clipShape(Circle())
                }
                
                // Capsule (Width > Height)
                VisualColumn(title: "Capsule") {
                    GradientPlaceholder(index: 1).frame(width: size * 1.3, height: size * 0.8).clipShape(Capsule())
                }
                
                // App Icon (Squircle)
                VisualColumn(title: "Rounded Rect\n(Icon)") {
                    GradientPlaceholder(index: 2).frame(width: size, height: size).clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            .frame(maxWidth: .infinity)

        case 1:
            HStack(spacing: 30) {
                // Chat Bubble
                VStack(spacing: 12) {
                    Text("SwiftUI is Fire!")
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 16).padding(.vertical, 10)
                        .background(Color.imgIndigo)
                        .foregroundStyle(.white)
                        .clipShape(.rect(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 4, topTrailingRadius: 20))
                    Text("Chat UI").font(.system(size: 10)).foregroundStyle(.secondary)
                }
                
                // Ticket Cutout
                VStack(spacing: 12) {
                    GradientPlaceholder(index: 4)
                        .frame(width: 100, height: 60)
                        .clipShape(TicketShape())
                        .overlay(
                            Circle().fill(Color(.secondarySystemBackground))
                                .frame(width: 14, height: 14)
                                .offset(x: 50) // Halfway cut
                        )
                    Text("Ticket Stub").font(.system(size: 10)).foregroundStyle(.secondary)
                }
            }

        case 2:
            // Borders & rings
            HStack(alignment: .center, spacing: 28) {
                let size: CGFloat = 72
                
                // Glass Ring
                VStack(spacing: 12) {
                    ZStack {
                        GradientPlaceholder(index: 0)
                            .frame(width: size, height: size)
                            .clipShape(Circle())
                        
                        // Specular Border
                        Circle()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [.white.opacity(0.9), .white.opacity(0.1), .white.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                            .frame(width: size, height: size)
                    }
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                    Text("Specular Ring").font(.system(size: 9, weight: .bold)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                }
                
                // Floating Ring (Orbital Effect)
                VStack(spacing: 12) {
                    ZStack {
                        GradientPlaceholder(index: 1)
                            .frame(width: size, height: size)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 1)) // Subtle inner edge
                        
                        // The Orbital Ring
                        Circle()
                            .stroke(
                                LinearGradient(colors: [Color.imgIndigo, Color.imgIndigo.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing),
                                lineWidth: 3
                            )
                            .frame(width: size + 8, height: size + 8)
                    }
                    .shadow(color: Color.imgIndigo.opacity(0.2), radius: 12, y: 6)
                    Text("Floating Ring").font(.system(size: 9, weight: .bold)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                }
                
                // Frosted Card Border
                VStack(spacing: 12) {
                    ZStack {
                        GradientPlaceholder(index: 2)
                            .frame(width: size, height: size - 22)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        
                        // Glass Overlay with Inner Glow
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [.animCoral.opacity(0.7), .clear, .animCoral.opacity(0.5)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                    }
                    .shadow(color: .black.opacity(0.15), radius: 15, y: 8)
                    Text("Frosted Edge").font(.system(size: 9, weight: .bold)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
        default:
            // Adjustable corner radius
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    GradientPlaceholder(index: 2).frame(width: 100, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(".clipShape(RoundedRectangle(")
                            .font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                        Text("    cornerRadius: \(Int(cornerRadius)),")
                            .font(.system(size: 10, design: .monospaced)).foregroundStyle(Color.imgIndigo).bold()
                        Text("    style: .continuous")
                            .font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                        Text("))")
                            .font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                    }
                }
                Text(cornerRadius == 0 ? "No rounding" : cornerRadius >= 50 ? "Pill / circle shape" : "Rounded rectangle")
                    .font(.system(size: 11)).foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Internal Visual Helper
private struct VisualColumn<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 10) {
            content
            Text(title).font(.system(size: 9)).foregroundStyle(.secondary).multilineTextAlignment(.center).lineLimit(2)
        }
    }
}

// MARK: - Custom Shape
struct TicketShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let cutoutRadius: CGFloat = 12
        
        path.move(to: CGPoint(x: cutoutRadius, y: 0))
        path.addLine(to: CGPoint(x: width - cutoutRadius, y: 0))
        path.addArc(center: CGPoint(x: width, y: 0), radius: cutoutRadius, startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
        path.addLine(to: CGPoint(x: width, y: height - cutoutRadius))
        path.addArc(center: CGPoint(x: width, y: height), radius: cutoutRadius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: true)
        path.addLine(to: CGPoint(x: cutoutRadius, y: height))
        path.addArc(center: CGPoint(x: 0, y: height), radius: cutoutRadius, startAngle: .degrees(0), endAngle: .degrees(270), clockwise: true)
        path.addLine(to: CGPoint(x: 0, y: cutoutRadius))
        path.addArc(center: CGPoint(x: 0, y: 0), radius: cutoutRadius, startAngle: .degrees(90), endAngle: .degrees(0), clockwise: true)
        path.closeSubpath()
        
        return path
    }
}
struct ClippingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Clipping & shapes")
            Text(".clipShape() masks an image to any Shape. Pair with .overlay() to add borders on top of the clipped result - always overlay after clipping so the border follows the shape edge.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".clipShape(Circle()) - circular clip. Classic for avatars.", color: .imgIndigo)
                StepRow(number: 2, text: ".clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous)) - smooth rounded corners.", color: .imgIndigo)
                StepRow(number: 3, text: ".overlay(Circle().stroke(.white, lineWidth: 3)) - white border on top of clip. Overlay is applied after clipShape.", color: .imgIndigo)
                StepRow(number: 4, text: "Gradient ring: .stroke(LinearGradient(...), lineWidth: 3) - apply gradient to the stroke.", color: .imgIndigo)
                StepRow(number: 5, text: ".shadow() after clipShape gives a shadow following the clip shape's outline.", color: .imgIndigo)
            }

            CalloutBox(style: .warning, title: "Overlay order - after clipShape", contentBody: "Put .overlay() AFTER .clipShape(). If you overlay first, the overlay gets clipped too. The border/ring should always sit on top of the clipped image, following its shape outline.")

            CodeBlock(code: """
// Circular avatar
Image("avatar")
    .resizable()
    .scaledToFill()
    .frame(width: 60, height: 60)
    .clipShape(Circle())
    .overlay(Circle().stroke(.white, lineWidth: 3))
    .shadow(radius: 4)

// Gradient ring
.overlay(
    Circle().stroke(
        LinearGradient(
            colors: [.purple, .blue, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        lineWidth: 3
    )
)

// Story-style ring with gap
.overlay(
    Circle()
        .stroke(Color.accentColor, lineWidth: 3)
        .padding(2)  // gap between image and ring
)

// Continuous rounded rect
.clipShape(
    RoundedRectangle(cornerRadius: 20, style: .continuous)
)
""")
        }
    }
}
