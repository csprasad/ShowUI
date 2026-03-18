//
//
//  6_Luminance.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `19/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Luminance to Alpha
struct LuminanceMaskVisual: View {
    @State private var brightness: CGFloat = 0.5
    @State private var showInverted = false

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("luminanceToAlpha()", systemImage: "sun.max.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#993C1D"))
                    Spacer()
                    Toggle("Invert", isOn: $showInverted)
                        .labelsHidden()
                        .tint(Color(hex: "#993C1D"))
                }

                // Side by side: the mask source vs result
                HStack(spacing: 10) {
                    VStack(spacing: 6) {
                        ZStack {
                            Color.black
                            VStack(spacing: 0) {
                                Rectangle().fill(Color.white).frame(maxWidth: .infinity).frame(height: 50)
                                Rectangle().fill(Color(white: 0.6)).frame(maxWidth: .infinity).frame(height: 25)
                                Rectangle().fill(Color(white: 0.3)).frame(maxWidth: .infinity).frame(height: 25)
                            }
                        }
                        .frame(height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        Text("Luminance source")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }

                    Image(systemName: "arrow.right")
                        .foregroundStyle(.secondary)

                    VStack(spacing: 6) {
                        ZStack {
                            // Checkerboard to show transparency
                            Canvas { ctx, size in
                                let t: CGFloat = 8
                                for r in 0...Int(size.height / t) {
                                    for c in 0...Int(size.width / t) {
                                        ctx.fill(Path(CGRect(x: CGFloat(c)*t, y: CGFloat(r)*t, width: t, height: t)),
                                                 with: .color((r+c)%2==0 ? Color(.systemGray5) : Color(.systemGray4)))
                                    }
                                }
                            }

                            MaskBaseGradient()
                                .mask {
                                    ZStack {
                                        if showInverted { Color.white }
                                        VStack(spacing: 0) {
                                            Rectangle().fill(showInverted ? Color.black : Color.white).frame(maxWidth: .infinity).frame(height: 50)
                                            Rectangle().fill(showInverted ? Color(white: 0.4) : Color(white: 0.6)).frame(maxWidth: .infinity).frame(height: 25)
                                            Rectangle().fill(showInverted ? Color(white: 0.7) : Color(white: 0.3)).frame(maxWidth: .infinity).frame(height: 25)
                                        }
                                    }
                                    .luminanceToAlpha()
                                }
                        }
                        .frame(height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        Text(showInverted ? "Inverted result" : "Result")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                }
                .animation(.spring(response: 0.35), value: showInverted)

                CalloutBox(style: .info, title: "White = visible, Black = transparent", contentBody: "luminanceToAlpha() converts brightness directly to alpha. Toggle 'Invert' above to flip which areas show through.")
            }
        }
    }
}

struct LuminanceMaskExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "luminanceToAlpha()")
            Text("luminanceToAlpha() converts a view's brightness directly into its alpha channel. Bright (white) areas become fully opaque, dark (black) areas become fully transparent. It's the key to building true inverted masks.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Build a mask view using white (visible) and black (hidden) areas.", color: Color(hex: "#993C1D"))
                StepRow(number: 2, text: "Apply .luminanceToAlpha() to convert brightness to transparency.", color: Color(hex: "#993C1D"))
                StepRow(number: 3, text: "Use this as your .mask{ }, now black areas hide content and white reveals it.", color: Color(hex: "#993C1D"))
                StepRow(number: 4, text: "For an inverted mask: wrap in Color.white and make the shape black, content shows everywhere except the shape.", color: Color(hex: "#993C1D"))
            }

            CalloutBox(style: .success, title: "True inverted mask", contentBody: "Wrap your shape in a ZStack with Color.white background, color the shape black, then apply .luminanceToAlpha(). Result: content visible everywhere except inside the shape.")

            CodeBlock(code: """
// True inverted mask — visible everywhere except the shape
content
    .mask {
        ZStack {
            Color.white          // visible everywhere

            Image(systemName: "heart.fill")
                .font(.system(size: 120))
                .foregroundColor(.black)  // hidden inside heart
        }
        .luminanceToAlpha()
    }
""")
        }
    }
}
