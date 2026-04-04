//
//
//  6_TextPrivacy.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Text Privacy & Selectable Text
struct TextPrivacyVisual: View {
    @State private var isRedacted = false
    @State private var showCopyHint = false
    
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Privacy & Selection", systemImage: "eye.slash.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.animTeal)

                // SELECTABLE AREA
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("SELECTABLE TEXT")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.secondary)
                        Image(systemName: "pointer.arrow.and.square.on.square.dashed")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.animTeal)
                    }
                    
                    Text("Long-press this paragraph to reveal the system text selection menu. You can copy this specific text to your clipboard.")
                        .font(.system(size: 14))
                        .padding(12)
                        .contentShape(RoundedRectangle(cornerRadius: 8))
                        .textSelection(.enabled) // The Core Feature
                        .background(Color.animTeal.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Color.animTeal.opacity(0.2), lineWidth: 1)
                        )
                }
                
                Divider().padding(.vertical, 4)
                
                // Redacted Area
                VStack(alignment: .leading, spacing: 8) {
                    Text("SENSITIVE DATA")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Transaction ID")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Text("TXN-99284-AXP-01")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                        }
                        Spacer()
                        Text("$1,240.50")
                            .font(.system(size: 16, weight: .black))
                            .foregroundStyle(Color.animTeal)
                    }
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .redacted(reason: isRedacted ? .placeholder : []) // The Core Feature
                }

                // Controls
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        isRedacted.toggle()
                    }
                } label: {
                    Label(isRedacted ? "Reveal Sensitive Info" : "Hide Sensitive Info",
                          systemImage: isRedacted ? "eye" : "eye.slash")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(isRedacted ? Color.animTeal : Color.animCoral)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PressableButtonStyle()) // Using shared component
            }
        }
    }
}

struct TextPrivacyExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Interaction & Privacy")
            Text("Modern apps need to balance user convenience (copying data) with security (hiding sensitive info during previews or loading).")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".textSelection(.enabled) allows standard iOS text interaction on views that are usually static.", color: Color.animTeal)
                StepRow(number: 2, text: ".redacted(reason: .placeholder) creates a 'shimmer' or block effect, perfect for loading states or privacy filters.", color: Color.animTeal)
                StepRow(number: 3, text: "Redaction is hierarchical: applying it to a VStack affects all children automatically.", color: Color.animTeal)
            }

            CodeBlock(code: """
// Enable Copy/Paste menu
Text("Interactive Content")
    .textSelection(.enabled)

// Hide data (e.g. for a blurred multitasking preview)
VStack {
    Text("User Balance")
    Text("$5,000")
}
.redacted(reason: isLocked ? .placeholder : [])
""")
        }
    }
}
