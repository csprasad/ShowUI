//
//
//  8_multipleSources.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `01/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Multiple State Sources

struct MultipleSourcesVisual: View {
    // Local state — owned here
    @State private var localCount = 0
    // @Observable model — shared logic
    @State private var sharedModel = ProfileModel()
    // System environment
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Multiple state sources", systemImage: "square.3.layers.3d.top.filled")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sbOrange)

                // Show all three sources in one view
                VStack(spacing: 10) {
                    // Local @State
                    sourceRow(
                        icon: "1.circle.fill",
                        label: "@State (local)",
                        value: "tapped \(localCount)×",
                        color: .sbOrange
                    ) {
                        withAnimation { localCount += 1 }
                    }

                    // @Observable model
                    sourceRow(
                        icon: "2.circle.fill",
                        label: "@Observable model",
                        value: sharedModel.displayName,
                        color: .animTeal
                    ) {
                        sharedModel.cycle()
                    }

                    // Environment
                    HStack(spacing: 12) {
                        Image(systemName: "3.circle.fill")
                            .font(.system(size: 18)).foregroundStyle(Color.animPurple)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("@Environment")
                                .font(.system(size: 12, weight: .semibold)).foregroundStyle(Color.animPurple)
                            Text("colorScheme: .\(colorScheme == .dark ? "dark" : "light") (read-only)")
                                .font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: colorScheme == .dark ? "moon.fill" : "sun.max.fill")
                            .foregroundStyle(colorScheme == .dark ? .indigo : .yellow)
                    }
                    .padding(12)
                    .background(Color(.systemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                // How they combine in one body
                CalloutBox(style: .info, title: "All sources work together", contentBody: "A single view body can read @State, @Observable properties, and @Environment values simultaneously. SwiftUI tracks each dependency independently and re-renders only when something this view actually reads changes.")

                // Composition demo
                sectionLabel("Composed result using all three")
                HStack(spacing: 8) {
                    Circle()
                        .fill(colorScheme == .dark ? Color.animPurple : Color.sbOrange)
                        .frame(width: 12, height: 12)
                    Text("\(sharedModel.displayName) · \(localCount) tap\(localCount == 1 ? "" : "s") · \(colorScheme == .dark ? "dark" : "light")")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut(duration: 0.2), value: localCount)
                .animation(.easeInOut(duration: 0.2), value: sharedModel.displayName)
            }
        }
    }

    func sourceRow(icon: String, label: String, value: String, color: Color, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon).font(.system(size: 18)).foregroundStyle(color)
                VStack(alignment: .leading, spacing: 1) {
                    Text(label).font(.system(size: 12, weight: .semibold)).foregroundStyle(color)
                    Text(value).font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                }
                Spacer()
                Text("tap")
                    .font(.system(size: 11)).foregroundStyle(color.opacity(0.6))
            }
            .padding(12)
            .background(color.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(PressableButtonStyle())
    }

    func sectionLabel(_ text: String) -> some View {
        Text(text).font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
    }
}

@Observable
class ProfileModel {
    private let names = ["Alice", "Bob", "Charlie", "Diana", "Eli"]
    private var index = 0

    var displayName: String { names[index] }

    func cycle() {
        withAnimation(.spring(duration: 0.3)) {
            index = (index + 1) % names.count
        }
    }
}

struct MultipleSourcesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Combining state sources")
            Text("Real views rarely have a single source of state. A typical screen reads local UI state (@State), shared business logic (@Observable), system context (@Environment), and data passed from a parent (@Binding) - all at once.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@State for local UI state that belongs only to this view - selection, expand/collapse, animation triggers.", color: .sbOrange)
                StepRow(number: 2, text: "@Observable for shared business logic - cart, user session, settings - that multiple views need.", color: .sbOrange)
                StepRow(number: 3, text: "@Binding for values owned by a parent that this view needs to read and write.", color: .sbOrange)
                StepRow(number: 4, text: "@Environment for cross-cutting concerns - theme, locale, system appearance - injected at the root.", color: .sbOrange)
            }

            CalloutBox(style: .success, title: "Decision guide", contentBody: "Ask: who owns this value? If only this view - @State. If a parent - @Binding. If a business logic class - @Observable. If the system or app root - @Environment.")

            CalloutBox(style: .warning, title: "Avoid mixing ownership", contentBody: "The most common architecture mistake is using @State for values that should be in an @Observable model, or passing @Observable objects through many layers of @Binding. Keep each type of state in its correct home.")

            CodeBlock(code: """
struct ProductDetailView: View {
    // From parent - product being shown
    let product: Product

    // Local UI state - belongs here only
    @State private var isExpanded = false
    @State private var selectedImageIndex = 0

    // Shared model - cart state affects many views
    @State private var cart = CartModel()  // or via @Environment

    // System context - adapts layout
    @Environment(\\.horizontalSizeClass) var sizeClass
    @Environment(\\.colorScheme) var scheme

    var body: some View {
        ScrollView {
            // Uses product (let - immutable input)
            // Uses isExpanded (@State - local toggle)
            // Uses cart (@Observable - shared logic)
            // Uses sizeClass (@Environment - layout decision)
        }
    }
}
""")
        }
    }
}

