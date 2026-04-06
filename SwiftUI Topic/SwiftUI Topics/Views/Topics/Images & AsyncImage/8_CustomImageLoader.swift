//
//
//  8_CustomImageLoader.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Custom Image Loader
// Simple cache actor
actor ImageCache {
    static let shared = ImageCache()
    private var cache: [URL: Image] = [:]

    func image(for url: URL) -> Image? { cache[url] }
    func store(_ image: Image, for url: URL) { cache[url] = image }
}

@Observable
class ImageLoader {
    var image: Image?
    var isLoading = false
    var error: Error?
    var loadCount = 0

    func load(url: URL) async {
        // Check cache first
        if let cached = await ImageCache.shared.image(for: url) {
            image = cached
            loadCount += 1
            return
        }
        isLoading = true
        error = nil
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            guard let uiImage = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }
            let swiftUIImage = Image(uiImage: uiImage)
            await ImageCache.shared.store(swiftUIImage, for: url)
            image = swiftUIImage
            loadCount += 1
        } catch {
            self.error = error
        }
        isLoading = false
    }
}

struct CachedImageView: View {
    let url: URL
    @State private var loader = ImageLoader()

    var body: some View {
        content
            .task(id: url) {
                await loader.load(url: url)
            }
    }

    @ViewBuilder
    private var content: some View {
        if let image = loader.image {
            image
                .resizable()
                .scaledToFill()
        } else if loader.isLoading {
            ZStack {
                Color(.systemFill)
                ProgressView()
                    .tint(.imgIndigo)
            }
        } else if loader.error != nil {
            ZStack {
                Color(hex: "#FCEBEB")
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(Color.animCoral)
            }
        } else {
            Color(.systemFill)
        }
    }}

struct ImageLoaderVisual: View {
    @State private var selectedDemo = 0
    @State private var cacheHits = 0
    @State private var loadCount = 0

    let demoURLs = [
        URL(string: "https://picsum.photos/seed/cache1/300/200")!,
        URL(string: "https://picsum.photos/seed/cache2/300/200")!,
        URL(string: "https://picsum.photos/seed/cache3/300/200")!,
    ]

    let demos = ["Custom loader", "Cache demo", "Retry logic"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Custom image loader", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.imgIndigo)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
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

                switch selectedDemo {
                case 0:
                    // Custom loader in action
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 10) {
                            ForEach(demoURLs.indices, id: \.self) { i in
                                CachedImageView(url: demoURLs[i])
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.imgIndigo)
                            Text("Images are cached in memory after first load. Revisiting this lesson shows them instantly.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.imgIndigoLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // Cache architecture diagram
                    VStack(spacing: 10) {
                        HStack(spacing: 0) {
                            flowNode("App\nrequests\nimage", color: .imgIndigo)
                            flowArrow()
                            flowNode("Cache\nhit?", color: .animAmber, isDecision: true)
                            flowArrow()
                            flowNode("Return\ncached\nimage ✓", color: .formGreen)
                        }
                        HStack {
                            Spacer().frame(width: 70)
                            VStack(spacing: 0) {
                                Image(systemName: "arrow.down").font(.system(size: 10)).foregroundStyle(.secondary)
                                Text("miss").font(.system(size: 9)).foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        HStack(spacing: 0) {
                            flowNode("Network\nfetch\nURL", color: .imgIndigo)
                            flowArrow()
                            flowNode("Decode\nUIImage", color: .imgIndigo)
                            flowArrow()
                            flowNode("Store in\ncache +\nshow", color: .formGreen)
                        }
                        .offset(x: 0)
                    }
                    .padding(10).background(Color(.systemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                default:
                    // Retry pattern diagram
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 0) {
                            flowNode("Load\nURL", color: .imgIndigo)
                            flowArrow()
                            flowNode("Success?", color: .animAmber, isDecision: true)
                            flowArrow()
                            flowNode("Show\nimage", color: .formGreen)
                        }
                        HStack {
                            Spacer().frame(width: 70)
                            VStack(spacing: 0) {
                                Image(systemName: "arrow.down").font(.system(size: 10)).foregroundStyle(.secondary)
                                Text("error").font(.system(size: 9)).foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .font(.system(size: 14)).foregroundStyle(Color.animCoral)
                            Text("Retry: change .id() → AsyncImage recreates → new load attempt")
                                .font(.system(size: 10)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color(hex: "#FCEBEB")).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(10).background(Color(.systemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                }
            }
        }
    }

    func flowNode(_ text: String, color: Color, isDecision: Bool = false) -> some View {
        Text(text)
            .font(.system(size: 8, weight: .semibold))
            .foregroundStyle(color)
            .multilineTextAlignment(.center)
            .frame(width: 62, height: 48)
            .background(color.opacity(0.1))
            .clipShape(isDecision ? AnyShape(RoundedRectangle(cornerRadius: 6)) : AnyShape(RoundedRectangle(cornerRadius: 8)))
            .overlay(isDecision ?
                     AnyView(RoundedRectangle(cornerRadius: 6).stroke(color.opacity(0.4), lineWidth: 1)) :
                     AnyView(EmptyView()))
    }

    func flowArrow() -> some View {
        Image(systemName: "arrow.right")
            .font(.system(size: 9)).foregroundStyle(.secondary)
            .frame(width: 18)
    }
}

struct ImageLoaderExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Custom image loader")
            Text("AsyncImage covers most cases, but sometimes you need more control - a persistent memory cache, retry logic, or pre-fetching. An @Observable loader class with async/await and an actor-based cache is the modern Swift pattern.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "actor ImageCache - thread-safe image cache. Actor protects the dictionary from concurrent access.", color: .imgIndigo)
                StepRow(number: 2, text: "@Observable class ImageLoader - check cache first, then fetch, then store result in cache.", color: .imgIndigo)
                StepRow(number: 3, text: ".task(id: url) - runs when the view appears or when url changes. Automatically cancels on disappear.", color: .imgIndigo)
                StepRow(number: 4, text: "Retry: expose a retryID and call load() again. Or use a different URL to trigger .task(id:) re-run.", color: .imgIndigo)
                StepRow(number: 5, text: "Pre-fetch: call loader.load(url:) from a background task before the view scrolls into view.", color: .imgIndigo)
            }

            CalloutBox(style: .info, title: "For production - use a library", contentBody: "For production apps with aggressive caching, disk persistence, and progressive loading, use a dedicated library. Kingfisher and Nuke are the two most popular Swift image loading libraries - both integrate well with SwiftUI.")

            CodeBlock(code: """
// Actor-based cache
actor ImageCache {
    static let shared = ImageCache()
    private var cache: [URL: Image] = [:]

    func image(for url: URL) -> Image? { cache[url] }
    func store(_ image: Image, for url: URL) {
        cache[url] = image
    }
}

// Observable loader
@Observable
class ImageLoader {
    var image: Image?
    var isLoading = false
    var error: Error?

    func load(url: URL) async {
        if let cached = await ImageCache.shared.image(for: url) {
            image = cached; return
        }
        isLoading = true
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                let img = Image(uiImage: uiImage)
                await ImageCache.shared.store(img, for: url)
                image = img
            }
        } catch { self.error = error }
        isLoading = false
    }
}

// View
struct CachedImage: View {
    let url: URL
    @State private var loader = ImageLoader()

    var body: some View {
        Group {
            if let image = loader.image {
                image.resizable().scaledToFill()
            } else if loader.isLoading {
                ProgressView()
            } else {
                Image(systemName: "photo")
            }
        }
        .task(id: url) { await loader.load(url: url) }
    }
}
""")
        }
    }
}
