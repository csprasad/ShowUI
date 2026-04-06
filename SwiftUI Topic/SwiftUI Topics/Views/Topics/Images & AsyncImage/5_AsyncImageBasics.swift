//
//
//  5_AsyncImageBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: AsyncImage Basics
struct AsyncImageBasicsVisual: View {
    @State private var selectedState = 0
    @State private var simulatedProgress = 0.0
    @State private var isLoading = false

    let states = ["Loading", "Success", "Failure", "With placeholder"]
    let sampleURLs = [
        "https://picsum.photos/seed/showui1/300/200",
        "https://picsum.photos/seed/showui2/300/200",
        "https://picsum.photos/seed/showui3/300/200",
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("AsyncImage basics", systemImage: "icloud.and.arrow.down.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.imgIndigo)

                // State selector
                let cols = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
                LazyVGrid(columns: cols, spacing: 8) {
                    ForEach(states.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedState = i }
                        } label: {
                            Text(states[i])
                                .font(.system(size: 11, weight: selectedState == i ? .semibold : .regular))
                                .foregroundStyle(selectedState == i ? Color.imgIndigo : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedState == i ? Color.imgIndigoLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Simulated async image states
                ZStack {
                    Color(.secondarySystemBackground)
                    simulatedState.padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedState)

                // Real AsyncImage demo
                VStack(alignment: .leading, spacing: 8) {
                    Text("Live AsyncImage - tap to reload")
                        .font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                    HStack(spacing: 10) {
                        ForEach(sampleURLs.indices, id: \.self) { i in
                            AsyncImage(url: URL(string: sampleURLs[i])) { phase in
                                switch phase {
                                case .empty:
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemFill))
                                        .overlay(ProgressView().tint(.imgIndigo))
                                case .success(let image):
                                    image.resizable().scaledToFill()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                case .failure:
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: "#FCEBEB"))
                                        .overlay(Image(systemName: "wifi.exclamationmark").foregroundStyle(Color.animCoral))
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 70, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Spacer()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var simulatedState: some View {
        switch selectedState {
        case 0:
            // Loading state
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemFill))
                        .frame(width: 180, height: 100)
                    VStack(spacing: 8) {
                        ProgressView().tint(.imgIndigo).scaleEffect(1.2)
                        Text("Loading image...").font(.system(size: 12)).foregroundStyle(.secondary)
                    }
                }
                Text("AsyncImage shows ProgressView by default while loading")
                    .font(.system(size: 10)).foregroundStyle(.secondary).multilineTextAlignment(.center)
            }

        case 1:
            // Success state
            VStack(spacing: 10) {
                GradientPlaceholder(index: 2)
                    .frame(width: 180, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.formGreen)
                            Text("Loaded").foregroundStyle(Color.formGreen).font(.system(size: 11))
                        }
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(.regularMaterial)
                        .clipShape(Capsule())
                        .padding(8),
                        alignment: .bottomTrailing
                    )
                Text("phase.success(image) - use image.resizable()...")
                    .font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
            }

        case 2:
            // Failure state
            VStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#FCEBEB"))
                    .frame(width: 180, height: 100)
                    .overlay(
                        VStack(spacing: 6) {
                            Image(systemName: "wifi.exclamationmark")
                                .font(.system(size: 28)).foregroundStyle(Color.animCoral)
                            Text("Failed to load").font(.system(size: 12)).foregroundStyle(Color.animCoral)
                        }
                    )
                Text("phase.failure - show retry button or fallback")
                    .font(.system(size: 10)).foregroundStyle(.secondary)
            }

        default:
            // Placeholder pattern
            VStack(spacing: 10) {
                ZStack {
                    GradientPlaceholder(index: 0)
                        .frame(width: 180, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .opacity(0.3)
                    VStack(spacing: 4) {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 28)).foregroundStyle(Color.imgIndigo.opacity(0.5))
                        Text("Placeholder while loading").font(.system(size: 11)).foregroundStyle(.secondary)
                    }
                }
                Text("Show a styled placeholder that matches the loaded image size")
                    .font(.system(size: 10)).foregroundStyle(.secondary).multilineTextAlignment(.center)
            }
        }
    }
}

struct AsyncImageBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "AsyncImage")
            Text("AsyncImage loads an image from a URL asynchronously. It handles the network request, caching, and state management automatically. For basic use, pass a URL and SwiftUI handles the rest.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "AsyncImage(url: url) - simplest form. Shows a ProgressView while loading, the image when done.", color: .imgIndigo)
                StepRow(number: 2, text: "AsyncImage(url:) { image } placeholder: { } - provide a custom placeholder view.", color: .imgIndigo)
                StepRow(number: 3, text: "AsyncImage(url:) { phase in } - full phase-based control with .empty, .success, .failure.", color: .imgIndigo)
                StepRow(number: 4, text: "transaction: Transaction(animation: .easeIn) - animate the image appearing.", color: .imgIndigo)
            }

            CalloutBox(style: .info, title: "AsyncImage uses URLSession under the hood", contentBody: "AsyncImage uses URLSession for fetching and NSURLCache for caching. The cache is shared with URLSession's default cache. For custom cache policies or cache sizes, use a custom URLSession.")

            CalloutBox(style: .warning, title: "AsyncImage doesn't persist cache across launches", contentBody: "NSURLCache is an in-memory + disk cache but doesn't persist between cold app launches by default. For aggressive image caching, use a dedicated image caching library like Kingfisher or Nuke.")

            CodeBlock(code: """
// Simplest - auto ProgressView placeholder
AsyncImage(url: URL(string: imageURL))
    .frame(width: 200, height: 150)
    .clipShape(RoundedRectangle(cornerRadius: 12))

// Custom placeholder
AsyncImage(url: url) { image in
    image
        .resizable()
        .scaledToFill()
} placeholder: {
    Color.gray.opacity(0.3)   // shimmer or gradient
}
.frame(width: 200, height: 150)
.clipShape(RoundedRectangle(cornerRadius: 12))

// With transition animation
AsyncImage(url: url, transaction: Transaction(animation: .easeIn)) { phase in
    if let image = phase.image {
        image.resizable().scaledToFill()
    } else {
        placeholderView
    }
}
""")
        }
    }
}
