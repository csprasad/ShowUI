//
//
//  5_DynamicType.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Dynamic Text Sizing
struct TextDynamicTypeVisual: View {
    @State private var simulatedSize: DynamicTypeSize = .medium
    
    let sizes: [DynamicTypeSize] = [.xSmall, .medium, .large, .xLarge, .xxLarge, .xxxLarge, .accessibility1]
    
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Dynamic Type Simulator", systemImage: "textformat.size")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.animTeal)

                // The comparison area
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        tagBadge("Adaptive (.body)", color: .animTeal)
                        Text("This text scales with the slider.")
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        tagBadge("Fixed (17pt)", color: .animCoral)
                        Text("This text stays the same size.")
                            .font(.system(size: 17))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .dynamicTypeSize(simulatedSize) // Scales the entire container
                
                // Controls
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "textformat.size.smaller")
                        Slider(value: Binding(
                            get: { Double(sizes.firstIndex(of: simulatedSize) ?? 1) },
                            set: { index in simulatedSize = sizes[Int(index)] }
                        ), in: 0...6, step: 1)
                        Image(systemName: "textformat.size.larger")
                    }
                    .tint(.animTeal)
                    
                    Text("Current Scale: \(String(describing: simulatedSize).uppercased())")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                
                if simulatedSize >= .xxxLarge {
                    CalloutBox(style: .warning, title: "Accessibility Alert", contentBody: "Notice how the Fixed text now looks tiny and unreadable compared to the Adaptive text. Users with vision impairments would struggle to read the Fixed version.")
                }
            }
        }
    }
    
    func tagBadge(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 9, weight: .bold))
            .foregroundStyle(color)
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(color.opacity(0.1))
            .clipShape(Capsule())
    }
}

struct TextDynamicTypeExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Why use Semantic Styles?")
            Text("Hardcoding font sizes (e.g., 17pt) prevents the system from helping users who need larger text. Semantic styles act as a contract between you and iOS: 'I want a body-sized label, you handle the actual pixels.'")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Semantic styles (.title, .headline, .body) are the gold standard for iOS apps.", color: .animTeal)
                StepRow(number: 2, text: "Fixed sizes (.system(size:)) should only be used for elements that absolutely cannot scale, like a clock face.", color: .animTeal)
                StepRow(number: 3, text: "Use .dynamicTypeSize(...range) to allow scaling but prevent it from getting so large it breaks your UI.", color: .animTeal)
            }

            CodeBlock(code: """
// ✓ Best Practice: Scaling
Text("I scale beautifully")
    .font(.body)

// ✗ Avoid: Hardcoded pixels
Text("I am stuck at 17pt")
    .font(.system(size: 17))

// ✓ Controlled Scaling
Text("Scale, but not too much")
    .font(.title)
    .dynamicTypeSize(... .xxxLarge)
""")
        }
    }
}
