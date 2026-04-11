//
//
//  4_Fine-GrainedObservation.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Fine-Grained Observation
@Observable
class SplitModel {
    var title     = "Dashboard"
    var count     = 0
    var isLoading = false
    var tags      = ["swift", "swiftui"]
}

struct TitleOnlyView: View {
    let model: SplitModel
    @State private var renders = 0

    var body: some View {
        return HStack {
            Text("Title: \(model.title)").font(.system(size: 13))
            Spacer()
            renderBadge(renders)
        }
        .padding(8).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
        .onAppear { renders += 1 }
        .onChange(of: model.title) { _, _ in renders += 1 }
    }
}

struct CountOnlyView: View {
    let model: SplitModel
    @State private var renders = 0

    var body: some View {
        return HStack {
            Text("Count: \(model.count)").font(.system(size: 13))
            Spacer()
            renderBadge(renders)
        }
        .padding(8).background(Color(hex: "#EEF2FF")).clipShape(RoundedRectangle(cornerRadius: 8))
        .onAppear { renders += 1 }
        .onChange(of: model.count) { _, _ in renders += 1 }
    }
}

struct LoadingOnlyView: View {
    let model: SplitModel
    @State private var renders = 0

    var body: some View {
        return HStack {
            if model.isLoading {
                ProgressView().tint(.animCoral).scaleEffect(0.8)
            } else {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.formGreen).font(.system(size: 14))
            }
            Text(model.isLoading ? "Loading…" : "Ready").font(.system(size: 13))
            Spacer()
            renderBadge(renders)
        }
        .padding(8).background(Color(hex: "#FEF2F2")).clipShape(RoundedRectangle(cornerRadius: 8))
        .onAppear { renders += 1 }
        .onChange(of: model.isLoading) { _, _ in renders += 1 }
    }
}

private func renderBadge(_ count: Int) -> some View {
    Text("\(count) renders")
        .font(.system(size: 9, design: .monospaced))
        .foregroundStyle(.secondary)
        .padding(.horizontal, 6).padding(.vertical, 2)
        .background(Color(.systemFill))
        .clipShape(Capsule())
}

struct FineGrainedVisual: View {
    @State private var model = SplitModel()
    @State private var selectedDemo = 0
    let demos = ["Per-property", "Access patterns", "Tracking"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Fine-grained observation", systemImage: "line.diagonal.arrow")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.obsGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.obsGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.obsGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Live per-property tracking
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Each sub-view only re-renders when its specific property changes")
                            .font(.system(size: 10)).foregroundStyle(.secondary)

                        TitleOnlyView(model: model)
                        CountOnlyView(model: model)
                        LoadingOnlyView(model: model)

                        HStack(spacing: 6) {
                            Button("title") { model.title = ["Dashboard", "Analytics", "Settings", "Profile"].randomElement()! }
                                .smallGreenButton()
                            Button("count") { model.count += 1 }
                                .smallGreenButton()
                            Button("loading") { model.isLoading.toggle() }
                                .smallGreenButton()
                        }

                        Text("Tap each button - only the relevant row's render count increases ✓")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }

                case 1:
                    // Access patterns that affect tracking
                    VStack(spacing: 8) {
                        accessRow(good: true,
                                  title: "Read in body",
                                  code: "Text(model.title)\nText(\"\\(model.count)\")",
                                  desc: "Both accessed → subscribed to both. Renders when either changes.")
                        accessRow(good: true,
                                  title: "Conditional access",
                                  code: "if model.isAdmin {\n  Text(model.adminLabel)\n}",
                                  desc: "If isAdmin = false, adminLabel is NEVER read → not subscribed.")
                        accessRow(good: false,
                                  title: "Closure access (withObservationTracking needed)",
                                  code: "Button { print(model.title) }",
                                  desc: "Closures don't track - only the body pass reads matter.")
                        accessRow(good: true,
                                  title: "Extract to sub-view",
                                  code: "SubView(model: model)",
                                  desc: "SubView tracks its own reads independently - great for isolation.")
                    }

                default:
                    // withObservationTracking
                    VStack(alignment: .leading, spacing: 10) {
                        Text("withObservationTracking - observe from non-view code")
                            .font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        CodeBlock(code:"""
// Track changes in non-view code
withObservationTracking {
    // Access properties to subscribe
    let title = model.title
    let count = model.count
    updateUI(title: title, count: count)
} onChange: {
    // Called when title OR count changes
    DispatchQueue.main.async {
        withObservationTracking {
            updateUI(...)
        } onChange: { /* re-register */ }
    }
}
""")

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.obsGreen)
                            Text("withObservationTracking is for UIKit bridges and non-SwiftUI code. In SwiftUI views, tracking is automatic.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    func accessRow(good: Bool, title: String, code: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: good ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                .font(.system(size: 13)).foregroundStyle(good ? Color.obsGreen : Color.animAmber).padding(.top, 1)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.system(size: 11, weight: .semibold))
                Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(good ? Color.obsGreen : Color.animAmber)
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(good ? Color.obsGreenLight.opacity(0.6) : Color(hex: "#FAEEDA")).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private extension View {
    func smallGreenButton() -> some View {
        self.font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
            .padding(.horizontal, 12).padding(.vertical, 7)
            .background(Color.obsGreen).clipShape(RoundedRectangle(cornerRadius: 8))
            .buttonStyle(PressableButtonStyle())
    }
}

struct FineGrainedExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Fine-grained observation")
            Text("@Observable's biggest advantage: a view only re-renders when properties it actually reads in body change. If a view reads model.title but not model.count, changing count doesn't re-render that view. This is fundamentally more efficient than ObservableObject.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Only body reads count - accessing model.title in body subscribes to title changes only.", color: .obsGreen)
                StepRow(number: 2, text: "Conditional access: if model.isAdmin { model.adminLabel } - adminLabel not subscribed when isAdmin is false.", color: .obsGreen)
                StepRow(number: 3, text: "Extract to sub-view - each sub-view tracks its own property reads independently.", color: .obsGreen)
                StepRow(number: 4, text: "Closures don't track - model access inside Button { } action closures doesn't subscribe.", color: .obsGreen)
                StepRow(number: 5, text: "withObservationTracking - manual tracking for UIKit or background code.", color: .obsGreen)
            }

            CalloutBox(style: .success, title: "Extract to sub-views for efficiency", contentBody: "The best way to leverage fine-grained observation: extract each part of your UI into its own View struct. Each sub-view only subscribes to the properties it reads - unrelated changes don't trigger re-renders.")

            CodeBlock(code: """
@Observable class Store {
    var cart = Cart()      // read by CartView
    var profile = Profile() // read by ProfileView
}

// CartView only re-renders when cart changes
struct CartView: View {
    let store: Store
    var body: some View {
        Text(store.cart.itemCount)  // subscribes to cart only
    }
}

// ProfileView only re-renders when profile changes
struct ProfileView: View {
    let store: Store
    var body: some View {
        Text(store.profile.name)    // subscribes to profile only
    }
}
// Changing profile doesn't render CartView ✓
""")
        }
    }
}
