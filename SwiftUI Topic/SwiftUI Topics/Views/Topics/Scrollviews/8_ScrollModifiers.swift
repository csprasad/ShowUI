//
//
//  8_ScrollModifiers.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Scroll Modifiers
struct ScrollModifiersVisual: View {
    @State private var selectedModifier = 0
    @State private var clipDisabled     = false
    @State private var bounceMode       = 1
    @State private var dismissMode      = 0
    @State private var text             = ""
    @FocusState private var focused: Bool

    let modifiers = ["scrollClipDisabled", "scrollBounce", "dismissKeyboard", "contentMargins"]
    let cards     = ScrollCard.samples(6)

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Scroll modifiers", systemImage: "ellipsis.rectangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.scrollOrange)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(modifiers.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedModifier = i }
                            } label: {
                                Text(modifiers[i])
                                    .font(.system(size: 10, weight: selectedModifier == i ? .semibold : .regular, design: .monospaced))
                                    .foregroundStyle(selectedModifier == i ? Color.scrollOrange : .secondary)
                                    .padding(.horizontal, 9).padding(.vertical, 6)
                                    .background(selectedModifier == i ? Color.scrollOrangeLight : Color(.systemFill))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }

                switch selectedModifier {
                case 0:
                    // scrollClipDisabled
                    VStack(spacing: 10) {
                        Toggle("scrollClipDisabled", isOn: $clipDisabled).tint(.scrollOrange).font(.system(size: 12))
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(cards) { card in
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(card.color)
                                        .frame(width: 100, height: 80)
                                        .shadow(color: card.color.opacity(0.4), radius: 8, y: 4)
                                        .overlay(Text(card.label).font(.system(size: 11, weight: .bold)).foregroundStyle(.white))
                                }
                            }
                            .padding(.horizontal, 14).padding(.vertical, 12)
                        }
                        .scrollClipDisabled(clipDisabled)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        Text(clipDisabled ? "Shadows visible outside scroll bounds ✓" : "Shadows clipped at scroll boundary")
                            .font(.system(size: 11)).foregroundStyle(.secondary)
                    }

                case 1:
                    // scrollBounceBehavior
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            ForEach([(0, "automatic"), (1, "basedOnSize"), (2, "always")], id: \.0) { val, label in
                                Button {
                                    withAnimation(.spring(response: 0.3)) { bounceMode = val }
                                } label: {
                                    Text(".\(label)")
                                        .font(.system(size: 9, weight: bounceMode == val ? .semibold : .regular, design: .monospaced))
                                        .foregroundStyle(bounceMode == val ? Color.scrollOrange : .secondary)
                                        .padding(.horizontal, 7).padding(.vertical, 5)
                                        .background(bounceMode == val ? Color.scrollOrangeLight : Color(.systemFill))
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                        ScrollView {
                            VStack(spacing: 6) {
                                ForEach(bounceMode == 2 ? cards.prefix(2) : cards.prefix(4)) { card in
                                    RoundedRectangle(cornerRadius: 8).fill(card.color.opacity(0.8))
                                        .frame(maxWidth: .infinity).frame(height: 38)
                                        .overlay(Text(card.label).font(.system(size: 11, weight: .semibold)).foregroundStyle(.white))
                                }
                            }
                        }
                        .scrollBounceBehavior(
                            bounceMode == 0 ? .automatic :
                            bounceMode == 1 ? .basedOnSize : .always
                        )
                        .frame(height: bounceMode == 2 ? 100 : 160)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text([".automatic - system default", ".basedOnSize - only bounces if content exceeds frame", ".always - bounces even if content fits"][bounceMode])
                            .font(.system(size: 11)).foregroundStyle(.secondary)
                    }

                case 2:
                    // scrollDismissesKeyboard
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            ForEach([(0, "immediately"), (1, "interactively"), (2, "never")], id: \.0) { val, label in
                                Button {
                                    withAnimation(.spring(response: 0.3)) { dismissMode = val }
                                } label: {
                                    Text(".\(label)")
                                        .font(.system(size: 9, weight: dismissMode == val ? .semibold : .regular, design: .monospaced))
                                        .foregroundStyle(dismissMode == val ? Color.scrollOrange : .secondary)
                                        .padding(.horizontal, 7).padding(.vertical, 5)
                                        .background(dismissMode == val ? Color.scrollOrangeLight : Color(.systemFill))
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                        TextField("Tap to show keyboard, then scroll", text: $text)
                            .textFieldStyle(.roundedBorder)
                            .focused($focused)
                            .onTapGesture { focused = true }
                        ScrollView {
                            VStack(spacing: 6) {
                                ForEach(cards) { card in
                                    RoundedRectangle(cornerRadius: 8).fill(card.color.opacity(0.8))
                                        .frame(maxWidth: .infinity).frame(height: 38)
                                        .overlay(Text(card.label).font(.system(size: 11, weight: .semibold)).foregroundStyle(.white))
                                }
                            }
                        }
                        .scrollDismissesKeyboard(dismissMode == 0 ? .immediately : dismissMode == 1 ? .interactively : .never)
                        .frame(height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                default:
                    // contentMargins
                    VStack(spacing: 10) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(cards) { card in
                                    RoundedRectangle(cornerRadius: 12).fill(card.color)
                                        .frame(width: 90, height: 65)
                                        .overlay(Text(card.label).font(.system(size: 11, weight: .bold)).foregroundStyle(.white))
                                }
                            }
                        }
                        .contentMargins(.horizontal, 16, for: .scrollContent)
                        .frame(height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .background(Color(.secondarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 12)))

                        Text(".contentMargins adds inset padding that the scroll content respects - first/last items don't clip")
                            .font(.system(size: 11)).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

struct ScrollModifiersExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Scroll modifier toolkit")
            Text("SwiftUI provides several modifiers to refine scroll behavior - clip control, bounce behavior, keyboard dismissal, and content margins. Each solves a specific common problem in production scroll views.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".scrollClipDisabled() - allows content like shadows to render outside the scroll view bounds. Essential for card carousels with visible shadows.", color: .scrollOrange)
                StepRow(number: 2, text: ".scrollBounceBehavior(.basedOnSize) - prevents the rubber-band bounce when content is shorter than the scroll frame. Avoids jarring UX on short lists.", color: .scrollOrange)
                StepRow(number: 3, text: ".scrollDismissesKeyboard(.interactively) - keyboard dismisses as the user drags. .immediately dismisses on any scroll.", color: .scrollOrange)
                StepRow(number: 4, text: ".contentMargins(.horizontal, 16) - adds inset-aware padding. First and last items scroll to the edge correctly.", color: .scrollOrange)
                StepRow(number: 5, text: ".scrollIndicatorsFlash() - momentarily shows scroll indicators. Good for drawing attention to a scrollable area.", color: .scrollOrange)
            }

            CalloutBox(style: .success, title: ".contentMargins vs .padding in scroll views", contentBody: ".padding inside a scroll view doesn't extend to the edges - the first/last items still clip. .contentMargins(.horizontal, 16) correctly pads both the content and the scroll position so first/last items are fully visible.")

            CodeBlock(code: """
// Clip shadows outside scroll frame
ScrollView(.horizontal) {
    carouselCards
}
.scrollClipDisabled()   // shadows visible ✓

// No bounce when content fits
ScrollView {
    shortContent
}
.scrollBounceBehavior(.basedOnSize)

// Keyboard dismissal
ScrollView {
    formContent
}
.scrollDismissesKeyboard(.interactively)

// Correct edge padding
ScrollView(.horizontal) {
    HStack { cards }
}
.contentMargins(.horizontal, 16, for: .scrollContent)
// vs .padding which clips at scroll boundaries ✗

// Flash indicators
scrollView
    .scrollIndicatorsFlash(onAppear: true)
    .scrollIndicatorsFlash(trigger: someValue)
""")
        }
    }
}
