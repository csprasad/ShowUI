//
//
//  4_buttonLoadingState.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
 
// MARK: - LESSON 4: Loading State
struct LoadingStateVisual: View {
    @State private var isLoading = false
    @State private var isSuccess = false
    @State private var selectedPattern = 0
 
    let patterns = ["Inline spinner", "Replace label", "Progress fill"]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Loading state", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.btnPurple)
 
                // Pattern selector
                HStack(spacing: 8) {
                    ForEach(patterns.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedPattern = i
                                isLoading = false
                                isSuccess = false
                            }
                        } label: {
                            Text(patterns[i])
                                .font(.system(size: 10, weight: selectedPattern == i ? .semibold : .regular))
                                .foregroundStyle(selectedPattern == i ? Color.btnPurple : .secondary)
                                .padding(.horizontal, 8).padding(.vertical, 5)
                                .background(selectedPattern == i ? Color.btnPurpleLight : Color(.systemFill))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
 
                // Live demo
                ZStack {
                    Color(.secondarySystemBackground)
                    patternDemo
                }
                .frame(maxWidth: .infinity).frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 14))
 
                // Trigger + reset
                HStack(spacing: 10) {
                    Button {
                        simulateLoad()
                    } label: {
                        Text(isLoading ? "Loading..." : isSuccess ? "Done ✓" : "Trigger load")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(isSuccess ? Color.animTeal : Color.btnPurple)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(PressableButtonStyle())
                    .disabled(isLoading)
 
                    if isSuccess {
                        Button {
                            withAnimation { isSuccess = false }
                        } label: {
                            Text("Reset")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.btnPurple)
                                .padding(.vertical, 10).padding(.horizontal, 16)
                                .background(Color.btnPurpleLight)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressableButtonStyle())
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        }
    }
 
    func simulateLoad() {
        withAnimation(.spring(response: 0.3)) { isLoading = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.spring(duration: 0.4, bounce: 0.3)) {
                isLoading = false
                isSuccess = true
            }
        }
    }
 
    @ViewBuilder
    private var patternDemo: some View {
        switch selectedPattern {
        case 0:
            // Pattern 1: Spinner inline with label
            Button { } label: {
                HStack(spacing: 10) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                            .scaleEffect(0.8)
                            .transition(.scale.combined(with: .opacity))
                    } else if isSuccess {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .transition(.scale.combined(with: .opacity))
                    }
                    Text(isLoading ? "Saving..." : isSuccess ? "Saved" : "Save document")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 24).padding(.vertical, 13)
                .background(isSuccess ? Color.animTeal : Color.btnPurple)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(PressableButtonStyle())
            .disabled(isLoading)
            .animation(.spring(response: 0.3), value: isLoading)
            .animation(.spring(response: 0.3), value: isSuccess)
 
        case 1:
            // Pattern 2: Full label replacement
            Button { } label: {
                ZStack {
                    if isLoading {
                        HStack(spacing: 8) {
                            ProgressView().tint(.white).scaleEffect(0.8)
                            Text("Processing...").font(.system(size: 15, weight: .semibold)).foregroundStyle(.white)
                        }
                        .transition(.opacity)
                    } else if isSuccess {
                        Label("Complete!", systemImage: "checkmark.circle.fill")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                            .transition(.opacity)
                    } else {
                        Text("Upload file")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                            .transition(.opacity)
                    }
                }
                .frame(width: 180).padding(.vertical, 13)
                .background(isSuccess ? Color.animTeal : Color.btnPurple)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(PressableButtonStyle())
            .disabled(isLoading)
            .animation(.easeInOut(duration: 0.25), value: isLoading)
            .animation(.easeInOut(duration: 0.25), value: isSuccess)
 
        default:
            // Pattern 3: Progress fill
            GeometryReader { geo in
                Button { } label: {
                    ZStack(alignment: .leading) {
                        // Background
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.btnPurple.opacity(0.2))
 
                        // Fill
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSuccess ? Color.animTeal : Color.btnPurple)
                            .frame(width: isLoading
                                   ? geo.size.width * 0.7
                                   : isSuccess ? geo.size.width : 0)
                            .animation(.easeInOut(duration: 1.8), value: isLoading)
                            .animation(.spring(response: 0.4), value: isSuccess)
 
                        Text(isLoading ? "Uploading..." : isSuccess ? "Complete!" : "Start upload")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(isLoading || isSuccess ? .white : Color.btnPurple)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(height: 48)
                }
                .buttonStyle(PressableButtonStyle())
                .disabled(isLoading)
            }
            .frame(height: 48)
            .padding(.horizontal, 24)
        }
    }
}
 
struct LoadingStateExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Loading state patterns")
            Text("A loading button has three states: idle, loading, and success (or error). The key is disabling the button during loading to prevent double-taps, and giving clear visual feedback for each state transition.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "@State var isLoading - drive all three states from this single Bool.", color: .btnPurple)
                StepRow(number: 2, text: ".disabled(isLoading) - prevents tapping again mid-request. Critical for network calls.", color: .btnPurple)
                StepRow(number: 3, text: "Inline spinner - ProgressView() inside the label alongside changing text.", color: .btnPurple)
                StepRow(number: 4, text: "Wrap state changes in withAnimation - smooth transitions between idle, loading, success.", color: .btnPurple)
            }
 
            CalloutBox(style: .success, title: "Task-based async pattern", contentBody: "In iOS 15+, use .task or an async button action directly. The button disables itself while the async work runs, no manual isLoading needed with the right architecture.")
 
            CalloutBox(style: .warning, title: "Always show success or error", contentBody: "A button that spins then just returns to idle is confusing. Always transition to a success or error state so users know their action completed.")
 
            CodeBlock(code: """
@State private var isLoading = false
@State private var isSuccess = false
 
Button {
    Task {
        isLoading = true
        defer { isLoading = false }
        do {
            try await uploadFile()
            isSuccess = true
        } catch {
            // handle error
        }
    }
} label: {
    HStack(spacing: 8) {
        if isLoading {
            ProgressView().tint(.white).scaleEffect(0.8)
        }
        Text(isLoading ? "Uploading..." : "Upload")
            .foregroundStyle(.white)
    }
    .padding(.horizontal, 24).padding(.vertical, 13)
    .background(Color.blue)
    .clipShape(RoundedRectangle(cornerRadius: 12))
}
.disabled(isLoading)
""")
        }
    }
}
