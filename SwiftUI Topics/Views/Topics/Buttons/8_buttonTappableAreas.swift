//
//
//  8_buttonTappableAreas.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
 
// MARK: - LESSON 8: Tappable Areas & Hit Testing
struct TappableAreasVisual: View {
    @State private var tapLog: [String] = []
    @State private var showHitAreas = true
    @State private var selectedDemo = 0
 
    let demos = ["Small target", "Correct target", "contentShape"]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Tappable areas", systemImage: "scope")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.btnPurple)
 
                // Demo selector
                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; tapLog = [] }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.btnPurple : .secondary)
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(selectedDemo == i ? Color.btnPurpleLight : Color(.systemFill))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
 
                // Demo area
                ZStack {
                    Color(.secondarySystemBackground)
                    demoView
                }
                .frame(maxWidth: .infinity).frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 14))
 
                // Log
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(tapLog.suffix(3).reversed().enumerated()), id: \.offset) { _, entry in
                        Text(entry)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    if tapLog.isEmpty {
                        Text("Try tapping around the button edges...")
                            .font(.system(size: 11))
                            .foregroundStyle(.tertiary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
 
    @ViewBuilder
    private var demoView: some View {
        switch selectedDemo {
        case 0:
            // Problem — tiny hit target
            VStack(spacing: 6) {
                Text("Hit area = icon only")
                    .font(.system(size: 11)).foregroundStyle(.secondary)
                Button {
                    tapLog.insert("✓ Tapped (hit the tiny icon)", at: 0)
                } label: {
                    Image(systemName: "star.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.animCoral)
                    // No padding = tiny hit area
                }
                .buttonStyle(PressableButtonStyle())
                Text("Hard to tap precisely")
                    .font(.system(size: 10)).foregroundStyle(.tertiary)
            }
 
        case 1:
            // Fix — minimum 44×44 tap target
            VStack(spacing: 6) {
                Text("Hit area = 44×44pt minimum")
                    .font(.system(size: 11)).foregroundStyle(.secondary)
                Button {
                    tapLog.insert("✓ Tapped (44pt target)", at: 0)
                } label: {
                    Image(systemName: "star.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.sfGreen)
                        .frame(width: 44, height: 44)
                        .background(Color.sfGreenLight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(PressableButtonStyle())
                Text("Apple's minimum recommended size")
                    .font(.system(size: 10)).foregroundStyle(.tertiary)
            }
 
        default:
            // contentShape expands hit area without changing visuals
            VStack(spacing: 6) {
                Text("contentShape expands hit area")
                    .font(.system(size: 11)).foregroundStyle(.secondary)
                Button {
                    tapLog.insert("✓ Tapped (full row)", at: 0)
                } label: {
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.btnPurple)
                        Text("Tap anywhere in this row")
                            .font(.system(size: 13))
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .contentShape(Rectangle())  // ← makes full width tappable
                }
                .buttonStyle(PressableButtonStyle())
                Text("Without contentShape, only icon+text would register")
                    .font(.system(size: 10)).foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
struct TappableAreasExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Tap targets and hit testing")
            Text("Apple's HIG recommends a minimum tap target of 44×44 points. A button containing only a 16pt icon has a hit area of 16×16, which is far too small. This means users can tap the icon and still interact with the button, even if they aren't touching the icon directly. This practice is called 'ghost tapping', and can cause frustration and is even discouraged on websites. This step ensures that your app always behaves as expected, and will prevent users from missing it 75% of the time for users with large fingers or motor difficulties.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "Use .frame(width: 44, height: 44) on the label to enforce minimum tap target.", color: .btnPurple)
                StepRow(number: 2, text: ".contentShape(Rectangle()) expands the hit area to the full frame without changing appearance.", color: .btnPurple)
                StepRow(number: 3, text: "In List rows, always add .contentShape(Rectangle()) to make the full row tappable.", color: .btnPurple)
                StepRow(number: 4, text: ".allowsHitTesting(false) disables tap events on a view, but it passes through to views below.", color: .btnPurple)
            }
 
            CalloutBox(style: .danger, title: "Image-only buttons are the worst offender", contentBody: "A plain Image button has no padding and no frame, so its hit area is the exact pixel size of the SF Symbol path. Always add .frame(width: 44, height: 44) or padding to reach the minimum.")
 
            CalloutBox(style: .success, title: "contentShape also fixes List rows", contentBody: "SwiftUI List rows with Spacer() in an HStack don't make the Spacer tappable. Add .contentShape(Rectangle()) to the HStack to make the entire row respond to taps.")
 
            CodeBlock(code: """
// Problem — 16pt icon, tiny hit area
Button { } label: {
    Image(systemName: "star")
        .font(.system(size: 16))
}
 
// Fix 1 — explicit minimum frame
Button { } label: {
    Image(systemName: "star")
        .font(.system(size: 16))
        .frame(width: 44, height: 44)
}
 
// Fix 2 — contentShape expands without changing look
Button { } label: {
    HStack {
        Image(systemName: "star")
        Text("Favorite")
        Spacer()
    }
    .contentShape(Rectangle())  // whole row tappable
}
 
// Disable hit testing on overlay
Color.clear
    .allowsHitTesting(false)  // taps pass through
""")
        }
    }
}
