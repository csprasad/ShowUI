//
//
//  7_safeAreaInset.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: safeAreaInset
struct SafeAreaInsetVisual: View {
    @State private var selectedDemo     = 0
    @State private var showFloating     = true
    @State private var selectedItems    = Set<UUID>()
    let demos  = ["Floating button", "Bottom bar", "Top banner"]
    let cards  = ScrollCard.samples(8)

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("safeAreaInset", systemImage: "rectangle.bottomthird.inset.filled")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.scrollOrange)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.scrollOrange : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.scrollOrangeLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Floating action button
                    VStack(spacing: 8) {
                        Toggle("Show FAB", isOn: $showFloating).tint(.scrollOrange).font(.system(size: 12))
                        ZStack(alignment: .bottomTrailing) {
                            ScrollView {
                                VStack(spacing: 8) {
                                    ForEach(cards) { card in basicRow(card) }
                                }
                                .padding(.horizontal, 2)
                            }
                            .safeAreaInset(edge: .bottom) {
                                if showFloating {
                                    HStack {
                                        Spacer()
                                        Button { } label: {
                                            Image(systemName: "plus")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundStyle(.white)
                                                .frame(width: 48, height: 48)
                                                .background(Color.scrollOrange)
                                                .clipShape(Circle())
                                                .shadow(color: Color.scrollOrange.opacity(0.4), radius: 8, y: 4)
                                        }
                                        .buttonStyle(PressableButtonStyle())
                                        .padding(.trailing, 12)
                                    }
                                    .padding(.bottom, 6)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                }
                            }
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .animation(.spring(response: 0.35), value: showFloating)

                        Text("Last item scrolls above the FAB - not hidden behind it ✓")
                            .font(.system(size: 11)).foregroundStyle(.secondary)
                    }

                case 1:
                    // Bottom action bar
                    VStack(spacing: 8) {
                        ScrollView {
                            VStack(spacing: 6) {
                                ForEach(cards) { card in
                                    Button {
                                        withAnimation {
                                            if selectedItems.contains(card.id) { selectedItems.remove(card.id) }
                                            else { selectedItems.insert(card.id) }
                                        }
                                    } label: {
                                        HStack(spacing: 10) {
                                            Image(systemName: selectedItems.contains(card.id) ? "checkmark.circle.fill" : "circle")
                                                .foregroundStyle(selectedItems.contains(card.id) ? Color.scrollOrange : .secondary)
                                            Text(card.label).font(.system(size: 13))
                                            Spacer()
                                        }
                                        .padding(.horizontal, 12).padding(.vertical, 10)
                                        .background(selectedItems.contains(card.id) ? Color.scrollOrangeLight : Color(.systemFill))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }
                            .padding(.horizontal, 2)
                        }
                        .safeAreaInset(edge: .bottom) {
                            if !selectedItems.isEmpty {
                                HStack(spacing: 10) {
                                    Text("\(selectedItems.count) selected").font(.system(size: 13, weight: .semibold))
                                    Spacer()
                                    Button("Delete") { withAnimation { selectedItems.removeAll() } }
                                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                        .padding(.horizontal, 14).padding(.vertical, 7)
                                        .background(Color.scrollOrange).clipShape(Capsule())
                                        .buttonStyle(PressableButtonStyle())
                                }
                                .padding(.horizontal, 14).padding(.vertical, 10)
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal, 4).padding(.bottom, 4)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }
                        .frame(height: 210)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .animation(.spring(response: 0.35), value: selectedItems.isEmpty)
                    }

                default:
                    // Top banner
                    VStack(spacing: 8) {
                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(cards) { card in basicRow(card) }
                            }
                            .padding(.horizontal, 2)
                        }
                        .safeAreaInset(edge: .top) {
                            HStack(spacing: 8) {
                                Image(systemName: "info.circle.fill").foregroundStyle(.white)
                                Text("Top banner - scroll content starts below this")
                                    .font(.system(size: 12, weight: .medium)).foregroundStyle(.white)
                            }
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.scrollOrange)
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
            }
        }
    }

    func basicRow(_ card: ScrollCard) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(card.color.opacity(0.8))
            .frame(maxWidth: .infinity).frame(height: 44)
            .overlay(Text(card.label).font(.system(size: 12, weight: .semibold)).foregroundStyle(.white))
    }
}

struct SafeAreaInsetExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "safeAreaInset - float views above scroll")
            Text(".safeAreaInset places a view overlapping the scroll content but insets the scroll's safe area so the last item is never hidden. The scroll content is aware of the inset - it scrolls just enough to reveal items fully.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".safeAreaInset(edge: .bottom) { floatingView } - places view at the bottom, insets scroll content.", color: .scrollOrange)
                StepRow(number: 2, text: ".safeAreaInset(edge: .top) - top banners or navigation overlays that don't hide content.", color: .scrollOrange)
                StepRow(number: 3, text: "The scrollable content extends its bottom inset by the safeAreaInset view's height automatically.", color: .scrollOrange)
                StepRow(number: 4, text: "spacing: - optional gap between the inset view and the scroll content edge.", color: .scrollOrange)
            }

            CalloutBox(style: .success, title: "The proper way to float over lists", contentBody: "The old approach - overlaying a button with ZStack - hides list items behind it. .safeAreaInset solves this: the scroll content is inset so the last item can scroll above the button, not behind it.")

            CodeBlock(code: """
// Floating action button - last item visible ✓
ScrollView {
    content
}
.safeAreaInset(edge: .bottom) {
    HStack {
        Spacer()
        Button("+ Add") { }
            .buttonStyle(.borderedProminent)
    }
    .padding(.trailing, 16)
    .padding(.bottom, 8)
}

// Sticky toolbar
.safeAreaInset(edge: .bottom, spacing: 0) {
    if !selectedItems.isEmpty {
        SelectionBar(count: selectedItems.count)
            .transition(.move(edge: .bottom))
    }
}

// Top announcement banner
.safeAreaInset(edge: .top, spacing: 0) {
    AnnouncementBanner()
}
""")
        }
    }
}
