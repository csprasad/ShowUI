//
//  Masking.swift
//  SwiftUI Topics
//
//  Created by codeAlligator on 28/01/26.
//

import SwiftUI
// MARK: - Masking Showcase View

struct MaskingView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                MaskDemo(title: "1. Normal Mask (.mask)") {
                    NormalMask()
                }
                
                MaskDemo(title: "2. Blend Mode Mask (.destinationOut)") {
                    BlendModeMask()
                }

                MaskDemo(title: "3. Inverted Mask (Luminance -> Alpha)") {
                    InvertedTrueMask()
                }

                MaskDemo(title: "4. Gradient Mask") {
                    GradientMask()
                }
            }
            .padding()
        }
    }
}

// MARK: - Demo Wrapper

struct MaskDemo<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            content
                .frame(height: 220)
                .cornerRadius(16)
                .shadow(radius: 8)
        }
    }
}

// MARK: - Normal Mask

struct NormalMask: View {
    var body: some View {
        Image("sequoia")
            .resizable()
            .scaledToFill()
            .mask {
                Image(systemName: "heart.fill")
                    .font(.system(size: 180))
            }
    }
}

// MARK: - Blend Mode Mask (Compositing)

struct BlendModeMask: View {
    var body: some View {
        ZStack {
            Image("sequoia")
                .resizable()
                .scaledToFill()

            Image(systemName: "heart.fill")
                .font(.system(size: 180))
                .blendMode(.destinationOut)
        }
        .compositingGroup()
    }
}

// MARK: - Inverted Mask (TRUE mask)

struct InvertedTrueMask: View {
    var body: some View {
        Image("sequoia")
            .resizable()
            .scaledToFill()
            .mask {
                ZStack {
                    Color.white

                    Image(systemName: "heart.fill")
                        .font(.system(size: 160))
                        .foregroundColor(.black)
                        .padding(.top, 40)
                }
                .luminanceToAlpha()
            }
    }
}

// MARK: - Gradient Mask

struct GradientMask: View {
    var body: some View {
        Image("sequoia")
            .resizable()
            .scaledToFill()
            .mask {
                LinearGradient(
                    colors: [
                        .black,
                        .black,
                        .white,
                        .white
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
            }
    }
}
