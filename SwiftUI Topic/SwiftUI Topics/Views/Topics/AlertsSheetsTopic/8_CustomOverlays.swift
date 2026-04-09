//
//
//  8_CustomOverlays.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Custom Overlays
struct CustomOverlayVisual: View {
    @State private var selectedOverlay   = 0
    @State private var showToast         = false
    @State private var showTooltip       = false
    @State private var showBanner        = false
    @State private var selectedCard: Int? = nil
    @Namespace private var ns

    let overlays = ["Toast", "Tooltip", "Expand card"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Custom overlays", systemImage: "square.on.square.dashed")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.asRed)

                HStack(spacing: 8) {
                    ForEach(overlays.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedOverlay = i }
                        } label: {
                            Text(overlays[i])
                                .font(.system(size: 12, weight: selectedOverlay == i ? .semibold : .regular))
                                .foregroundStyle(selectedOverlay == i ? Color.asRed : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedOverlay == i ? Color.asRedLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedOverlay {
                case 0:
                    // Toast notification
                    VStack(spacing: 12) {
                        ZStack(alignment: .top) {
                            // Background content
                            VStack(spacing: 8) {
                                ForEach([0, 1, 2], id: \.self) { i in
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemFill))
                                        .frame(maxWidth: .infinity).frame(height: 44)
                                        .overlay(Text("Row \(i + 1)").font(.system(size: 12)).foregroundStyle(.secondary))
                                }
                            }
                            .padding(.horizontal, 2)

                            // Toast
                            if showToast {
                                HStack(spacing: 10) {
                                    Image(systemName: "checkmark.circle.fill").font(.system(size: 16)).foregroundStyle(Color.formGreen)
                                    Text("Saved successfully!").font(.system(size: 13, weight: .semibold))
                                }
                                .padding(.horizontal, 16).padding(.vertical, 10)
                                .background(.regularMaterial)
                                .clipShape(Capsule())
                                .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
                                .padding(.top, 8)
                                .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .frame(height: 170)

                        Button {
                            withAnimation(.spring(response: 0.4)) { showToast = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation(.easeOut(duration: 0.35)) { showToast = false }
                            }
                        } label: {
                            Text("Show toast")
                                .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 10)
                                .background(Color.asRed).clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }

                case 1:
                    // Tooltip
                    VStack(spacing: 14) {
                        ZStack(alignment: .topLeading) {
                            HStack(spacing: 12) {
                                Button {
                                    withAnimation(.spring(response: 0.35)) { showTooltip.toggle() }
                                } label: {
                                    HStack(spacing: 6) {
                                        Text("What is this?").font(.system(size: 13))
                                        Image(systemName: "questionmark.circle.fill").font(.system(size: 16)).foregroundStyle(Color.asRed)
                                    }
                                }
                                .buttonStyle(PressableButtonStyle())
                                Spacer()
                            }
                            .padding(12).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 12))

                            if showTooltip {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.asRed)
                                        Text("Tooltip").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.asRed)
                                    }
                                    Text("This is a custom tooltip built with ZStack + offset, no system API needed.")
                                        .font(.system(size: 11)).foregroundStyle(.secondary)
                                }
                                .padding(10)
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
                                .frame(width: 220)
                                .offset(x: 0, y: 54)
                                .zIndex(1)
                                .transition(.scale(scale: 0.9, anchor: .topLeading).combined(with: .opacity))
                            }
                        }
                        .frame(height: 130, alignment: .top)
                    }

                default:
                    // Expand card with matchedGeometryEffect
                    VStack(spacing: 12) {
                        let colors: [Color] = [.asRed, .navBlue, .formGreen]
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { i in
                                if selectedCard != i {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(colors[i])
                                        .frame(height: 80)
                                        .overlay(Text("Tap").font(.system(size: 12, weight: .bold)).foregroundStyle(.white))
                                        .matchedGeometryEffect(id: i, in: ns)
                                        .onTapGesture { withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) { selectedCard = i } }
                                } else {
                                    Color.clear.frame(height: 80)
                                }
                            }
                        }

                        if let sel = selectedCard {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(colors[sel])
                                    .matchedGeometryEffect(id: sel, in: ns)
                                    .frame(maxWidth: .infinity).frame(height: 120)
                                VStack(spacing: 8) {
                                    Text("Expanded card \(sel + 1)").font(.system(size: 16, weight: .bold)).foregroundStyle(.white)
                                    Button("Close") {
                                        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) { selectedCard = nil }
                                    }
                                    .font(.system(size: 12)).foregroundStyle(.white.opacity(0.9))
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }
                        }

                        Text("matchedGeometryEffect creates seamless expand/collapse animation")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

struct CustomOverlayExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Custom overlays")
            Text("System presentations (sheet, alert, popover) don't cover every case. Custom overlays - toasts, tooltips, expand-in-place cards - are built with ZStack, .overlay, .transition, and matchedGeometryEffect.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Toast: ZStack alignment + conditional view + .transition(.move + .opacity) + auto-hide timer.", color: .asRed)
                StepRow(number: 2, text: "Tooltip: .overlay(alignment:) with a conditional VStack + .transition(.scale + .opacity).", color: .asRed)
                StepRow(number: 3, text: "matchedGeometryEffect - animates a view's frame between its source and destination positions.", color: .asRed)
                StepRow(number: 4, text: "ZStack + .zIndex - control layering for overlays. Higher zIndex sits on top.", color: .asRed)
                StepRow(number: 5, text: ".safeAreaInset for toasts - keeps them in the visible area above content.", color: .asRed)
            }

            CalloutBox(style: .info, title: "matchedGeometryEffect for hero transitions", contentBody: "When the same view ID is in two states (thumbnail + expanded), matchedGeometryEffect animates its frame, size, and position between them. Wrap the animation in withAnimation for a smooth spring transition.")

            CodeBlock(code: """
// Toast notification
ZStack(alignment: .top) {
    content
    if showToast {
        ToastView(message: "Saved!")
            .transition(.move(edge: .top).combined(with: .opacity))
    }
}

// Auto-hide after 2 seconds
.onAppear {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        withAnimation { showToast = false }
    }
}

// matchedGeometryEffect - expand in place
@Namespace private var ns
@State private var isExpanded = false

if !isExpanded {
    ThumbnailView()
        .matchedGeometryEffect(id: "card", in: ns)
        .onTapGesture { withAnimation(.spring()) { isExpanded = true } }
} else {
    FullView()
        .matchedGeometryEffect(id: "card", in: ns)
        .onTapGesture { withAnimation(.spring()) { isExpanded = false } }
}
""")
        }
    }
}
