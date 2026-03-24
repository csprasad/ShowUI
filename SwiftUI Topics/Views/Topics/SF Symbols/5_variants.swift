//
//
//  5_variants.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `23/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Symbol Variants
struct VariantsVisual: View {
    @State private var selectedBase = 0
    @State private var selectedVariant = 0
 
    let bases = ["heart", "star", "bell", "bookmark", "person", "folder", "doc", "trash"]
 
    struct VariantOption {
        let name: String
        let variant: SymbolVariants
    }
 
    let variants: [VariantOption] = [
        VariantOption(name: "none",       variant: .none),
        VariantOption(name: ".fill",      variant: .fill),
        VariantOption(name: ".slash",     variant: .slash),
        VariantOption(name: ".circle",    variant: .circle),
        VariantOption(name: ".circle.fill", variant: .circle.fill),
        VariantOption(name: ".square",    variant: .square),
        VariantOption(name: ".square.fill", variant: .square.fill),
        VariantOption(name: ".rectangle", variant: .rectangle),
    ]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Symbol variants", systemImage: "heart.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sfGreen)
 
                // Grid showing all variants of selected base
                let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(variants.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedVariant = i }
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: bases[selectedBase])
                                    .font(.system(size: 28))
                                    .symbolVariant(variants[i].variant)
                                    .foregroundStyle(selectedVariant == i ? Color.sfGreen : .secondary)
                                    .frame(width: 44, height: 44)
                                    .background(selectedVariant == i ? Color.sfGreenLight : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text(variants[i].name)
                                    .font(.system(size: 9, design: .monospaced))
                                    .foregroundStyle(selectedVariant == i ? Color.sfGreen : Color(.tertiaryLabel))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
 
                // Base symbol selector
                VStack(alignment: .leading, spacing: 6) {
                    Text("Base symbol")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(bases.indices, id: \.self) { i in
                                Button {
                                    withAnimation(.spring(response: 0.3)) { selectedBase = i }
                                } label: {
                                    Image(systemName: bases[i])
                                        .font(.system(size: 18))
                                        .foregroundStyle(selectedBase == i ? Color.sfGreen : .secondary)
                                        .frame(width: 36, height: 36)
                                        .background(selectedBase == i ? Color.sfGreenLight : Color(.systemFill))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                    }
                }
 
                // Code
                Text("Image(systemName: \"\(bases[selectedBase])\")\n    .symbolVariant(\(variants[selectedVariant].name))")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(Color.sfGreen)
                    .padding(10)
                    .background(Color.sfGreenLight)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .animation(.easeInOut(duration: 0.15), value: selectedVariant)
                    .animation(.easeInOut(duration: 0.15), value: selectedBase)
            }
        }
    }
}
struct VariantsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Symbol variants")
            Text("Variants are systematic modifications to a base symbol fill, slash, enclosing shapes. They let you express state and context consistently across the whole symbol library without memorising different symbol names.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".fill - solid filled version. Use for selected or active states.", color: .sfGreen)
                StepRow(number: 2, text: ".slash - adds a diagonal slash. Universally means disabled or off.", color: .sfGreen)
                StepRow(number: 3, text: ".circle / .square / .rectangle - wraps the symbol in a shape. Adds visual weight, good for buttons.", color: .sfGreen)
                StepRow(number: 4, text: ".circle.fill combines variants, making the circle gets a fill background.", color: .sfGreen)
            }

            CalloutBox(style: .success, title: "Environment-based variants", contentBody: ".symbolVariant() on a container applies to all symbols inside. Great for toolbars, tab bars, or any group where you want consistent variant treatment.")

            CalloutBox(style: .info, title: "Not all variants exist for all symbols", contentBody: "If a variant doesn't exist for a symbol, SwiftUI falls back to the base symbol silently. Always test with your specific symbols in the SF Symbols app.")

            CodeBlock(code: """
// Direct variant
Image(systemName: "heart")
    .symbolVariant(.fill)    // heart.fill

Image(systemName: "bell")
    .symbolVariant(.slash)   // bell.slash

// Combined variants
Image(systemName: "star")
    .symbolVariant(.circle.fill)  // star.circle.fill

// Environment - all symbols inside get .fill
Label("Liked", systemImage: "heart")
    .symbolVariant(.fill)

// Toggle variant based on state
Image(systemName: "bookmark")
    .symbolVariant(isBookmarked ? .fill : .none)
    .foregroundStyle(isBookmarked ? .yellow : .secondary)
""")
        }
    }
}
