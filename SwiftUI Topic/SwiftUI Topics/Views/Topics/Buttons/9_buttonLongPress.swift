//
//
//  9_buttonLongPress.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 9: Long Press & Context Menu
struct LongPressVisual: View {
    @State private var isLongPressing = false
    @State private var longPressProgress: CGFloat = 0
    @State private var lastAction = "Nothing yet"
    @State private var scale: CGFloat = 1.0
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Long press & context menu", systemImage: "hand.point.up.left.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.btnPurple)
 
                // Last action
                HStack(spacing: 6) {
                    Image(systemName: "return").font(.system(size: 11)).foregroundStyle(.secondary)
                    Text(lastAction).font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
 
                // Long press with visual feedback
                VStack(spacing: 6) {
                    Text("Long press (hold 0.5s)")
                        .font(.system(size: 11, weight: .medium)).foregroundStyle(.secondary)
 
                    Button { lastAction = "Tapped (short)" } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.btnPurpleLight)
                                .frame(height: 50)
                            // Progress fill
                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.btnPurple.opacity(0.3))
                                    .frame(width: geo.size.width * longPressProgress)
                                    .animation(.linear(duration: 0.5), value: longPressProgress)
                            }
                            .frame(height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
 
                            Text(isLongPressing ? "Hold..." : "Tap or hold")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.btnPurple)
                        }
                    }
                    .buttonStyle(PressableButtonStyle())
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.5)
                            .onChanged { _ in
                                isLongPressing = true
                                longPressProgress = 1.0
                            }
                            .onEnded { _ in
                                lastAction = "Long pressed!"
                                isLongPressing = false
                                longPressProgress = 0
                            }
                    )
                }
 
                // Context menu
                VStack(spacing: 6) {
                    Text("Long press for context menu")
                        .font(.system(size: 11, weight: .medium)).foregroundStyle(.secondary)
 
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(colors: [Color.btnPurple, Color(hex: "#3C3489")],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(height: 60)
                        .overlay(
                            Label("Hold me", systemImage: "hand.point.up.left")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white)
                        )
                        .contextMenu {
                            Button { lastAction = "Copied" } label: {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                            Button { lastAction = "Shared" } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                            Divider()
                            Button(role: .destructive) { lastAction = "Deleted" } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
    }
}
 
struct LongPressExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Long press & context menus")
            Text("Long press gestures add a secondary action layer to buttons and views. Context menus surface on long press automatically, and they're the standard iOS pattern for in-place actions without navigating away.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "LongPressGesture(minimumDuration: 0.5) fires after the user holds for the specified time.", color: .btnPurple)
                StepRow(number: 2, text: ".simultaneousGesture() lets a long press and tap coexist on the same button.", color: .btnPurple)
                StepRow(number: 3, text: ".contextMenu { } adds a long-press menu to any view, following the standard iOS behavior, no custom gesture needed.", color: .btnPurple)
                StepRow(number: 4, text: ".onLongPressGesture(minimumDuration:) is a simpler modifier-based approach for when you don't need a Button.", color: .btnPurple)
            }
 
            CalloutBox(style: .info, title: "simultaneousGesture is key", contentBody: "Using .gesture() on a Button overrides the tap gesture. Use .simultaneousGesture() instead so both the tap action and the long press fire independently without conflicting.")
 
            CalloutBox(style: .success, title: "Context menu preview", contentBody: "Add a preview: closure to contextMenu to show a custom view when the menu appears, such as an image. This is great for image galleries and file browsers where you want a large preview on hold.")
 
            CodeBlock(code: """
// Long press gesture on a button
Button { shortTap() } label: { Text("Action") }
    .simultaneousGesture(
        LongPressGesture(minimumDuration: 0.6)
            .onEnded { _ in longPress() }
    )
 
// Simple long press modifier
Text("Hold me")
    .onLongPressGesture(minimumDuration: 0.5) {
        haptic()
    }
 
// Context menu
Image("photo")
    .contextMenu {
        Button("Save to Photos") { save() }
        Button("Share") { share() }
        Button(role: .destructive) { delete() } label: {
            Label("Delete", systemImage: "trash")
        }
    } preview: {
        // Custom preview on hold
        Image("photo").resizable().scaledToFit()
    }
""")
        }
    }
}
