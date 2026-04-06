//
//
//  ImagesTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `07/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Images & AsyncImage Topic
struct ImagesTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Images & AsyncImage"
    let subtitle    = "Resizable, aspect ratio, clipping, filters and async loading"
    let icon        = "photo.fill"
    let color       = Color(hex: "#EEF2FF")
    let accentColor = Color(hex: "#4338CA")
    let tag         = "Foundations"

    @MainActor
    var lessons: [AnyLesson] {
        ImagesLessons.all.map { AnyLesson($0) }
    }
}

enum ImagesLessons {
    @MainActor
    static let all: [any LessonProtocol] = [
        ILesson(number: 1, title: "Image basics",        subtitle: "SF Symbols vs asset images, rendering modes, resizable",                icon: "photo",                          visual: AnyView(ImageBasicsVisual()),        explanation: AnyView(ImageBasicsExplanation())),
        ILesson(number: 2, title: "Resizable", subtitle: ".resizable(), .scaledToFit, .scaledToFill, aspectRatio",              icon: "arrow.up.left.and.arrow.down.right.circle", visual: AnyView(ResizableVisual()),  explanation: AnyView(ResizableExplanation())),
        ILesson(number: 3, title: "Clipping & shapes",   subtitle: ".clipShape(), .cornerRadius, overlay borders and masks",               icon: "seal.fill",                      visual: AnyView(ClippingVisual()),           explanation: AnyView(ClippingExplanation())),
        ILesson(number: 4, title: "Image modifiers",     subtitle: ".saturation, .contrast, .blur, .colorMultiply and visual effects",     icon: "wand.and.stars",                 visual: AnyView(ImageModifiersVisual()),     explanation: AnyView(ImageModifiersExplanation())),
        ILesson(number: 5, title: "AsyncImage basics",   subtitle: "Loading remote images, placeholder and error states",                  icon: "icloud.and.arrow.down.fill",     visual: AnyView(AsyncImageBasicsVisual()),   explanation: AnyView(AsyncImageBasicsExplanation())),
        ILesson(number: 6, title: "AsyncImage phases",   subtitle: "URLSession phases - empty, success, failure and custom loading UI",   icon: "square.stack.3d.forward.dottedline.fill", visual: AnyView(AsyncImagePhasesVisual()), explanation: AnyView(AsyncImagePhasesExplanation())),
        ILesson(number: 7, title: "Image grid",          subtitle: "LazyVGrid photo grid, tap to expand, aspect-ratio cells",              icon: "square.grid.3x3.fill",           visual: AnyView(ImageGridVisual()),          explanation: AnyView(ImageGridExplanation())),
        ILesson(number: 8, title: "Custom image loader", subtitle: "Caching, retry logic and wrapping URLSession in async/await",          icon: "arrow.triangle.2.circlepath",    visual: AnyView(ImageLoaderVisual()),        explanation: AnyView(ImageLoaderExplanation())),
    ]
}

struct ILesson: LessonProtocol {
    let id          = UUID()
    let number:     Int
    let title:      String
    let subtitle:   String
    let icon:       String
    let visual:     AnyView
    let explanation: AnyView
}

extension Color {
    static let imgIndigo      = Color(hex: "#4338CA")
    static let imgIndigoLight = Color(hex: "#EEF2FF")
}

// MARK: - Shared gradient placeholder (no image assets needed)
struct GradientPlaceholder: View {
    let index: Int
    var width: CGFloat? = nil
    var height: CGFloat? = nil

    private let palettes: [[Color]] = [
        [Color(hex: "#4338CA"), Color(hex: "#7C3AED")],
        [Color(hex: "#065F46"), Color(hex: "#1D4ED8")],
        [Color(hex: "#B45309"), Color(hex: "#DC2626")],
        [Color(hex: "#7C3AED"), Color(hex: "#DB2777")],
        [Color(hex: "#0369A1"), Color(hex: "#0891B2")],
        [Color(hex: "#15803D"), Color(hex: "#4338CA")],
        [Color(hex: "#C2410C"), Color(hex: "#B45309")],
        [Color(hex: "#9333EA"), Color(hex: "#2563EB")],
        [Color(hex: "#065F46"), Color(hex: "#1D4ED8")],
        [Color(hex: "#065F46"), Color(hex: "#1D4ED8")],
        [Color(hex: "#0F766E"), Color(hex: "#0284C7")],
    ]

    private let icons = [
        "mountain.2.fill", "building.fill", "leaf.fill",
        "star.fill", "globe.americas.fill", "camera.fill",
        "heart.fill", "moon.stars.fill", "flame.fill"
    ]

    var colors: [Color] { palettes[index % palettes.count] }
    var icon: String { icons[index % icons.count] }

    var body: some View {
        ZStack {
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            Image(systemName: icon)
                .font(.system(size: min(width ?? 44, height ?? 44) * 0.3))
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(width: width, height: height)
    }
}
