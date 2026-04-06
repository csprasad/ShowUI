//
//
//  3_Slider&Stepper.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Slider & Stepper
struct SliderStepperVisual: View {
    @State private var fontSize: Double = 16
    @State private var opacity: Double = 1.0
    @State private var rating: Double = 3
    @State private var quantity = 1
    @State private var pages = 1
    @State private var selectedDemo = 0

    let demos = ["Slider", "Stepper", "Combined"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Slider & Stepper", systemImage: "slider.horizontal.3")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.formGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 12, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.formGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.formGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    VStack(spacing: 12) {
                        // Font size slider
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Font size").font(.system(size: 12)).foregroundStyle(.secondary)
                                Spacer()
                                Text("\(Int(fontSize))pt")
                                    .font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.formGreen)
                            }
                            Slider(value: $fontSize, in: 10...32, step: 1).tint(.formGreen)
                            Text("The quick brown fox")
                                .font(.system(size: fontSize))
                                .animation(.spring(response: 0.2), value: fontSize)
                        }
                        .padding(12).background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                        // Opacity slider with labels
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Opacity").font(.system(size: 12)).foregroundStyle(.secondary)
                                Spacer()
                                Text(String(format: "%.0f%%", opacity * 100))
                                    .font(.system(size: 12, design: .monospaced)).foregroundStyle(Color.formGreen)
                            }
                            
                            HStack {
                                Image(systemName: "sun.min")
                                Slider(value: $opacity, in: 0...1)
                                Image(systemName: "sun.max.fill").foregroundStyle(Color.formGreen)
                            }

                            RoundedRectangle(cornerRadius: 8).fill(Color.formGreen)
                                .frame(height: 32).opacity(opacity)
                                .animation(.easeInOut(duration: 0.05), value: opacity)
                        }
                        .padding(12).background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                        // Star rating slider
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Rating").font(.system(size: 12)).foregroundStyle(.secondary)
                                Spacer()
                                HStack(spacing: 2) {
                                    ForEach(1...5, id: \.self) { star in
                                        Image(systemName: star <= Int(rating) ? "star.fill" : "star")
                                            .font(.system(size: 14))
                                            .foregroundStyle(star <= Int(rating) ? Color.animAmber : Color(.systemGray4))
                                    }
                                }
                                .animation(.spring(response: 0.2), value: rating)
                            }
                            Slider(value: $rating, in: 1...5, step: 1).tint(.animAmber)
                        }
                        .padding(12).background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                    }

                case 1:
                    VStack(spacing: 10) {
                        // Basic stepper
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Quantity").font(.system(size: 14))
                                Text("1–10 items").font(.system(size: 11)).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Stepper(value: $quantity, in: 1...10) {
                                Text("\(quantity)").font(.system(size: 16, weight: .semibold)).foregroundStyle(Color.formGreen)
                            }
                        }
                        .padding(12).background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                        // Stepper with step
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Pages").font(.system(size: 14))
                                Text("Increments of 10").font(.system(size: 11)).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Stepper(value: $pages, in: 1...200, step: 10) {
                                Text("\(pages)").font(.system(size: 16, weight: .semibold)).foregroundStyle(Color.formGreen)
                            }
                        }
                        .padding(12).background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                    }

                default:
                    // Combined slider + stepper
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Font size - slider for coarse, stepper for fine")
                            .font(.system(size: 11)).foregroundStyle(.secondary)

                        HStack(spacing: 10) {
                            Slider(value: $fontSize, in: 10...32, step: 1).tint(.formGreen)
                            Stepper("", value: $fontSize, in: 10...32, step: 1).labelsHidden()
                        }

                        Text("The quick brown fox jumps over the lazy dog")
                            .font(.system(size: fontSize))
                            .lineLimit(2)
                            .animation(.spring(response: 0.2), value: fontSize)

                        Text("\(Int(fontSize))pt")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(Color.formGreen)
                    }
                    .padding(12).background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                }
            }
        }
    }
}

struct SliderStepperExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Slider & Stepper")
            Text("Slider provides continuous or stepped value selection with a drag thumb. Stepper provides precise increment/decrement buttons. They're complementary - use Slider for coarse ranges, Stepper for exact values.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Slider(value: $x, in: 0...100) - continuous. step: 1 makes it discrete.", color: .formGreen)
                StepRow(number: 2, text: "minimumValueLabel: and maximumValueLabel: - views shown at each end of the slider track.", color: .formGreen)
                StepRow(number: 3, text: "Stepper(value: $x, in: 1...10) - +/- buttons. step: n increments by n.", color: .formGreen)
                StepRow(number: 4, text: "Stepper with onIncrement/onDecrement for fully custom behavior - no automatic binding.", color: .formGreen)
            }

            CalloutBox(style: .success, title: "Combine slider + stepper", contentBody: "For precise numeric input, pair a Slider for fast coarse adjustment with a Stepper for fine-tuning one unit at a time. Both bound to the same @State value.")

            CodeBlock(code: """
// Basic slider
Slider(value: $volume, in: 0...100)
    .tint(.blue)

// Stepped with labels
Slider(value: $size, in: 8...72, step: 1) {
    Text("Font size")          // accessibility label
} minimumValueLabel: {
    Text("A").font(.caption)
} maximumValueLabel: {
    Text("A").font(.title)
}

// Stepper
Stepper("Quantity: \\(qty)", value: $qty, in: 1...99)
Stepper(value: $qty, in: 1...99, step: 5) {
    Label("\\(qty) items", systemImage: "cart")
}

// Custom increment logic
Stepper {
    Text(formatted)
} onIncrement: {
    value = nextValidValue(after: value)
} onDecrement: {
    value = prevValidValue(before: value)
}
""")
        }
    }
}
