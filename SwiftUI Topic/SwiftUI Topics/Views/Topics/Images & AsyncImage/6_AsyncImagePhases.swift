//
//
//  6_AsyncImagePhases.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: AsyncImage Phases
struct AsyncImagePhasesVisual: View {
    @State private var selectedURL = 0
    @State private var refreshID = UUID()

    // Mix of valid URLs and one broken URL to show failure
    let urls = [
        "https://picsum.photos/seed/p1/400/300",
        "https://picsum.photos/seed/p2/400/300",
        "https://broken.invalid/image.jpg",
        "https://picsum.photos/seed/p4/400/300",
    ]
    let labels = ["Image 1", "Image 2", "Broken URL", "Image 4"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("AsyncImage phases", systemImage: "square.stack.3d.forward.dottedline.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.imgIndigo)

                // URL selector
                HStack(spacing: 6) {
                    ForEach(urls.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedURL = i; refreshID = UUID() }
                        } label: {
                            Text(labels[i])
                                .font(.system(size: 10, weight: selectedURL == i ? .semibold : .regular))
                                .foregroundStyle(selectedURL == i ? (i == 2 ? Color.animCoral : Color.imgIndigo) : .secondary)
                                .padding(.horizontal, 8).padding(.vertical, 5)
                                .background(selectedURL == i ? (i == 2 ? Color(hex: "#FCEBEB") : Color.imgIndigoLight) : Color(.systemFill))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // AsyncImage with full phase handling
                AsyncImage(
                    url: URL(string: urls[selectedURL]),
                    transaction: Transaction(animation: .spring(response: 0.5))
                ) { phase in
                    phaseView(phase)
                }
                .id(refreshID)
                .frame(maxWidth: .infinity).frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Phase diagram
                HStack(spacing: 6) {
                    ForEach([
                        ("empty", ".empty\nloading", Color.imgIndigo),
                        ("✓", ".success\nimage ready", Color.formGreen),
                        ("✗", ".failure\nload failed", Color.animCoral),
                    ], id: \.0) { icon, label, color in
                        HStack(spacing: 5) {
                            Text(icon).font(.system(size: 12, weight: .bold)).foregroundStyle(color)
                            Text(label).font(.system(size: 9)).foregroundStyle(.secondary).multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(6)
                        .background(color.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
        }
    }

    @ViewBuilder
    func phaseView(_ phase: AsyncImagePhase) -> some View {
        switch phase {
        case .empty:
            ZStack {
                Color(.systemFill)
                VStack(spacing: 10) {
                    ProgressView().tint(.imgIndigo).scaleEffect(1.3)
                    Text(".empty - loading").font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                }
            }

        case .success(let image):
            ZStack(alignment: .bottomLeading) {
                image.resizable().scaledToFill()
                Label(".success", systemImage: "checkmark.circle.fill")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(.regularMaterial)
                    .clipShape(Capsule())
                    .padding(8)
            }
            .transition(.opacity.combined(with: .scale(scale: 0.95)))

        case .failure:
            ZStack {
                Color(hex: "#FCEBEB")
                VStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 36)).foregroundStyle(Color.animCoral)
                    Text(".failure").font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.animCoral)
                    Button {
                        refreshID = UUID()
                    } label: {
                        Label("Retry", systemImage: "arrow.clockwise")
                            .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                            .padding(.horizontal, 14).padding(.vertical, 6)
                            .background(Color.animCoral)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(PressableButtonStyle())
                }
            }

        @unknown default:
            Color(.systemFill)
        }
    }
}

struct AsyncImagePhasesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "AsyncImagePhase")
            Text("The phase-based AsyncImage gives you full control. The closure receives an AsyncImagePhase enum - .empty (loading), .success(image), or .failure(error). Build custom loading, success, and error UIs for each state.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".empty - image is loading. Show a placeholder, shimmer, or ProgressView.", color: .imgIndigo)
                StepRow(number: 2, text: ".success(let image) - image loaded. Apply .resizable(), .scaledToFill() etc to the image.", color: .imgIndigo)
                StepRow(number: 3, text: ".failure(let error) - load failed. Show error message, retry button, or fallback image.", color: .imgIndigo)
                StepRow(number: 4, text: "phase.image - convenient optional that returns the image if successful, nil otherwise.", color: .imgIndigo)
                StepRow(number: 5, text: "transaction: - animate the transition between phases. Use .spring() for a nice fade-scale.", color: .imgIndigo)
            }

            CalloutBox(style: .success, title: "Retry with .id()", contentBody: "To retry a failed AsyncImage, change its .id() - SwiftUI destroys and recreates the view, triggering a new load attempt. Store a UUID in @State and regenerate it on retry.")

            CalloutBox(style: .info, title: "Shimmer placeholder", contentBody: "In the .empty phase, show a gradient animated from left to right over the placeholder shape - this is the standard 'shimmer' loading pattern. Combine with @State and .onAppear animation.")

            CodeBlock(code: """
AsyncImage(
    url: URL(string: imageURLString),
    transaction: Transaction(animation: .spring())
) { phase in
    switch phase {
    case .empty:
        // Loading - shimmer or progress
        ZStack {
            Color.gray.opacity(0.2)
            ProgressView()
        }

    case .success(let image):
        // Loaded
        image
            .resizable()
            .scaledToFill()
            .transition(.opacity)

    case .failure:
        // Error
        VStack {
            Image(systemName: "wifi.exclamationmark")
            Button("Retry") { retryID = UUID() }
        }

    @unknown default:
        EmptyView()
    }
}
.id(retryID)   // change to force reload
.frame(width: 200, height: 150)
.clipShape(RoundedRectangle(cornerRadius: 12))
""")
        }
    }
}

