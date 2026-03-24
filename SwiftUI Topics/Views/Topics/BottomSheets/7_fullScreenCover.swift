//
//
//  7_fullScreenCover.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
 
// MARK: - LESSON 7: Full Screen Cover
struct FullScreenCoverVisual: View {
    @State private var showSheet = false
    @State private var showFullScreen = false
    @State private var selectedComparison = 0
 
    let comparisons: [(aspect: String, sheet: String, fullScreen: String)] = [
        ("Presentation",  "Slides up, partial overlay",       "Fills entire screen"),
        ("Dismissal",     "Swipe down to dismiss",            "Cannot swipe to dismiss"),
        ("Background",    "Background visible/dimmed",        "Background fully hidden"),
        ("Use case",      "Secondary content, quick actions", "Onboarding, login, camera"),
        ("Status bar",    "Parent's status bar",              "Can customise status bar"),
    ]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Full screen cover", systemImage: "rectangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sheetGreen)
 
                // Comparison table
                VStack(spacing: 1) {
                    // Header
                    HStack(spacing: 0) {
                        Text("").frame(maxWidth: .infinity, alignment: .leading)
                        Text(".sheet").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.sheetGreen)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(".fullScreenCover").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.animCoral)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .lineLimit(2).minimumScaleFactor(0.7)
                    }
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(Color(.systemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
 
                    ForEach(comparisons.indices, id: \.self) { i in
                        HStack(spacing: 0) {
                            Text(comparisons[i].aspect)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(comparisons[i].sheet)
                                .font(.system(size: 10))
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                            Text(comparisons[i].fullScreen)
                                .font(.system(size: 10))
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 10).padding(.vertical, 8)
                        .background(i % 2 == 0 ? Color(.systemFill).opacity(0.5) : Color.clear)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
 
                // Open both buttons
                HStack(spacing: 10) {
                    Button {
                        showSheet = true
                    } label: {
                        Text(".sheet")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.sheetGreen)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11)
                            .background(Color.sheetGreenLight)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(PressableButtonStyle())
                    .sheet(isPresented: $showSheet) {
                        MockSheetContent(title: ".sheet", subtitle: "Partial overlay — swipe down to dismiss")
                    }
 
                    Button {
                        showFullScreen = true
                    } label: {
                        Text(".fullScreenCover")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11)
                            .background(Color.animCoral)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(PressableButtonStyle())
                    .fullScreenCover(isPresented: $showFullScreen) {
                        FullScreenContent()
                    }
                }
            }
        }
    }
}
 
struct FullScreenContent: View {
    @Environment(\.dismiss) var dismiss
 
    var body: some View {
        ZStack {
            Color.animCoral.ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "rectangle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.white.opacity(0.8))
                Text(".fullScreenCover")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                Text("Covers the entire screen.\nNo swipe-to-dismiss — you must provide a close button.")
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.animCoral)
                        .padding(.horizontal, 32).padding(.vertical, 14)
                        .background(.white)
                        .clipShape(Capsule())
                }
                .buttonStyle(PressableButtonStyle())
                .padding(.top, 20)
            }
        }
    }
}
 
struct FullScreenCoverExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: ".fullScreenCover vs .sheet")
            Text(".fullScreenCover presents a view that covers the entire screen, including the status bar area. Unlike .sheet, it cannot be dismissed by swiping, and you must provide an explicit dismiss control.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "Use .fullScreenCover for flows that take over the whole app, like onboarding, login, camera, media playback.", color: .sheetGreen)
                StepRow(number: 2, text: "Always provide a dismiss button — users cannot swipe down to close a fullScreenCover.", color: .sheetGreen)
                StepRow(number: 3, text: "The presenting view is completely hidden — no partial background visible.", color: .sheetGreen)
                StepRow(number: 4, text: "The API is identical to .sheet — isPresented:, item:, onDismiss: all work the same way.", color: .sheetGreen)
            }
 
            CalloutBox(style: .danger, title: "Always include a close button", contentBody: "There is no swipe-to-dismiss on fullScreenCover. If you forget the close button, users are trapped. Use @Environment(\\.dismiss) and always make it reachable from the top of the screen.")
 
            CalloutBox(style: .info, title: "Good use cases", contentBody: "Onboarding flows, login/signup, camera or photo picker, video player, AR experiences, and any flow where you want to completely replace the current context.")
 
            CodeBlock(code: """
// fullScreenCover
Button("Start onboarding") {
    showOnboarding = true
}
.fullScreenCover(isPresented: $showOnboarding) {
    OnboardingFlow()
}
 
// Inside fullScreenCover — must provide dismiss
struct OnboardingFlow: View {
    @Environment(\\.dismiss) var dismiss
 
    var body: some View {
        // Always a way out
        Button("Get started") { dismiss() }
    }
}
 
// Choose based on context:
// .sheet    → secondary info, quick actions, filters
// .fullScreenCover → onboarding, login, camera, media
""")
        }
    }
}
