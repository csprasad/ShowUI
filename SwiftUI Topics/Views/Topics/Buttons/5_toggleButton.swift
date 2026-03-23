//
//
//  5_toggleButton.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Toggle Button
struct ToggleButtonVisual: View {
    @State private var isFavorited = false
    @State private var isFollowing = false
    @State private var selectedTab = 0
    @State private var activeFilters: Set<String> = []
 
    let tabs = ["All", "Photos", "Videos", "Files"]
    let filters = ["Recent", "Shared", "Starred", "Downloads"]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Toggle button", systemImage: "togglepower")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.btnPurple)
 
                // Pattern 1: Icon toggle (favourite)
                sectionLabel("Icon toggle")
                HStack(spacing: 16) {
                    Button {
                        withAnimation(.spring(duration: 0.3, bounce: 0.5)) { isFavorited.toggle() }
                    } label: {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .font(.system(size: 28))
                            .foregroundStyle(isFavorited ? Color.animCoral : .secondary)
                            .scaleEffect(isFavorited ? 1.15 : 1.0)
                    }
                    .buttonStyle(PressableButtonStyle())
 
                    Button {
                        withAnimation(.spring(duration: 0.3, bounce: 0.4)){ isFollowing.toggle() }
                    } label: {
                        Text(isFollowing ? "Following" : "Follow")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(isFollowing ? Color.btnPurple : .white)
                            .padding(.horizontal, 20).padding(.vertical, 9)
                            .background(isFollowing ? Color.btnPurpleLight : Color.btnPurple)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.btnPurple, lineWidth: isFollowing ? 1.5 : 0))
                    }
                    .buttonStyle(PressableButtonStyle())
                    .animation(.spring(response: 0.3), value: isFollowing)
                }
 
                // Pattern 2: Segmented-style tab bar
                sectionLabel("Exclusive selection")
                HStack(spacing: 4) {
                    ForEach(tabs.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedTab = i }
                        } label: {
                            Text(tabs[i])
                                .font(.system(size: 13, weight: selectedTab == i ? .semibold : .regular))
                                .foregroundStyle(selectedTab == i ? Color.btnPurple : .secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(selectedTab == i ? Color.btnPurpleLight : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
                .padding(4)
                .background(Color(.systemFill))
                .clipShape(RoundedRectangle(cornerRadius: 10))
 
                // Pattern 3: Multi-select filter chips
                sectionLabel("Multi-select")
                HStack(spacing: 8) {
                    ForEach(filters, id: \.self) { filter in
                        let isActive = activeFilters.contains(filter)
                        Button {
                            withAnimation(.spring(response: 0.25)) {
                                if isActive { activeFilters.remove(filter) }
                                else { activeFilters.insert(filter) }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                if isActive {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 10, weight: .bold))
                                        .transition(.scale.combined(with: .opacity))
                                }
                                Text(filter)
                                    .font(.system(size: 12, weight: isActive ? .semibold : .regular))
                            }
                            .foregroundStyle(isActive ? Color.btnPurple : .secondary)
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(isActive ? Color.btnPurpleLight : Color(.systemFill))
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(isActive ? Color.btnPurple.opacity(0.4) : Color.clear, lineWidth: 1))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
        }
    }
 
    func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(.secondary)
    }
}
 
struct ToggleButtonExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Toggle buttons")
            Text("A toggle button has two visual states, active and inactive. SwiftUI doesn't have a built-in 'toggle button' component (that's what Toggle is for), but building one from Button + @State is the most flexible approach.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "@State var isSelected, or some other Equatable type, holds the single source of truth for active/inactive.", color: .btnPurple)
                StepRow(number: 2, text: "Ternary expressions on foregroundStyle, background, and symbolVariant drive the visual change.", color: .btnPurple)
                StepRow(number: 3, text: "For exclusive selection (tabs), use an index or enum as state, and have all buttons target that one value, multiple buttons check against it.", color: .btnPurple)
                StepRow(number: 4, text: "For multi-select, use a Set<String>, and watch the insert/remove on tap.", color: .btnPurple)
            }
 
            CalloutBox(style: .info, title: "SwiftUI's Toggle vs toggle button", contentBody: "Toggle is for on/off switches with a label. A toggle button is a Button that visually indicates selected state. Use Button + @State, and it gives you full control over the visual style.")
 
            CalloutBox(style: .success, title: "Animate the state transition", contentBody: "Wrap the toggle action in withAnimation(.spring(bounce: 0.4)), and watch the slight bounce on a heart fill or follow button makes it feel much more satisfying than a plain state change.")
 
            CodeBlock(code: """
// Simple icon toggle
@State private var isFavorited = false
 
Button {
    withAnimation(.spring(bounce: 0.4)) {
        isFavorited.toggle()
    }
} label: {
    Image(systemName: isFavorited ? "heart.fill" : "heart")
        .foregroundStyle(isFavorited ? .red : .secondary)
}
.buttonStyle(PressableButtonStyle())
 
// Exclusive tab selection
@State private var selectedTab = 0
let tabs = ["All", "Photos", "Videos"]
 
ForEach(tabs.indices, id: \\.self) { i in
    Button(tabs[i]) {
        withAnimation(.spring(response: 0.3)) { selectedTab = i }
    }
    .foregroundStyle(selectedTab == i ? .blue : .secondary)
}
 
// Multi-select
@State private var selectedFilters: Set<String> = []
 
Button(filter) {
    if selectedFilters.contains(filter) {
        selectedFilters.remove(filter)
    } else {
        selectedFilters.insert(filter)
    }
}
""")
        }
    }
}
 
