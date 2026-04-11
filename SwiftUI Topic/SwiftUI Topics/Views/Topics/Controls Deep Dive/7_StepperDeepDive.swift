//
//
//  7_StepperDeepDive.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Stepper Deep Dive
struct StepperDeepDiveVisual: View {
    @State private var quantity     = 1
    @State private var pages        = 10
    @State private var temperature  = 20.0
    @State private var fontSize     = 16.0
    @State private var isEditing    = false
    @State private var selectedDemo = 0
    let demos = ["Anatomy", "Custom step logic", "Slider + Stepper"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Stepper deep dive", systemImage: "plus.forwardslash.minus")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cdPurple)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.cdPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.cdPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Stepper anatomy
                    VStack(spacing: 10) {
                        // Basic
                        stepperRow("Quantity", icon: "cart.fill") {
                            Stepper(value: $quantity, in: 1...99) {
                                HStack(spacing: 6) {
                                    Text("\(quantity)")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundStyle(Color.cdPurple)
                                        .contentTransition(.numericText())
                                        .animation(.spring(duration: 0.2), value: quantity)
                                    Text("item\(quantity == 1 ? "" : "s")").font(.system(size: 13)).foregroundStyle(.secondary)
                                }
                            }
                        }

                        // Step of 5
                        stepperRow("Pages (×10)", icon: "doc.text.fill") {
                            Stepper(value: $pages, in: 10...500, step: 10) {
                                Text("\(pages)")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.cdPurple)
                                    .contentTransition(.numericText())
                                    .animation(.spring(duration: 0.2), value: pages)
                            }
                        }

                        // Temperature with format
                        stepperRow("Temp", icon: "thermometer.medium") {
                            Stepper(value: $temperature, in: -20...50, step: 0.5) {
                                Text(temperature.formatted(.number.precision(.fractionLength(1))) + "°C")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundStyle(temperature < 0 ? Color.navBlue : temperature > 35 ? Color.animCoral : Color.cdPurple)
                                    .contentTransition(.numericText())
                                    .animation(.spring(duration: 0.2), value: temperature)
                            }
                        }

                        // Stepper with format (bound directly)
                        stepperRow("Font size", icon: "textformat.size") {
                            Stepper(value: $fontSize, in: 8...48, step: 1, format: .number.precision(.fractionLength(0))) {
                                Text(String(format: "%.0fpt", fontSize))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.cdPurple)
                            }
                        }
                    }

                case 1:
                    // Custom increment logic
                    VStack(spacing: 14) {
                        // Exponential steps
                        VStack(spacing: 6) {
                            Text("Exponential steps (×2 / ÷2)").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(quantity)")
                                        .font(.system(size: 32, weight: .bold, design: .rounded)).foregroundStyle(Color.cdPurple)
                                        .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: quantity)
                                    Text("items").font(.system(size: 12)).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Stepper {
                                    EmptyView()
                                } onIncrement: {
                                    withAnimation { quantity = min(quantity * 2, 1024) }
                                } onDecrement: {
                                    withAnimation { quantity = max(quantity / 2, 1) }
                                }
                                .labelsHidden()
                            }
                            .padding(12).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        // Skip-step
                        VStack(spacing: 6) {
                            Text("Skip-step (round to nearest 10)").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                            HStack {
                                Text("\(pages)")
                                    .font(.system(size: 24, weight: .bold, design: .rounded)).foregroundStyle(Color.cdPurple)
                                    .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: pages)
                                Text("pages").font(.system(size: 13)).foregroundStyle(.secondary)
                                Spacer()
                                Stepper {
                                    EmptyView()
                                } onIncrement: {
                                    let next = (pages / 10 + 1) * 10
                                    withAnimation { pages = min(next, 500) }
                                } onDecrement: {
                                    let prev = ((pages - 1) / 10) * 10
                                    withAnimation { pages = max(prev, 0) }
                                }
                                .labelsHidden()
                            }
                            .padding(12).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }

                default:
                    // Slider + Stepper combo
                    VStack(spacing: 14) {
                        Text("Coarse + fine control").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 10) {
                                Text("Font").font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 28)
                                Text(String(format: "%.0fpt", fontSize))
                                    .font(.system(size: fontSize, weight: .bold))
                                    .lineLimit(1)
                                    .animation(.spring(response: 0.2), value: fontSize)
                                Spacer()
                                Stepper("", value: $fontSize, in: 8...48, step: 1).labelsHidden()
                            }
                                Slider(value: $fontSize, in: 8...48, step: 1).tint(.cdPurple)
                            
                            

                            Divider()

                            HStack(spacing: 10) {
                                Text("Temp").font(.system(size: 16)).foregroundStyle(.secondary)
                                Text("\(temperature.formatted(.number.precision(.fractionLength(1))))°C")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundStyle(temperature < 0 ? Color.navBlue : temperature > 30 ? Color.animCoral : Color.cdPurple)
                                    .animation(.spring(response: 0.2), value: temperature)
                                    .contentTransition(.numericText())
                                Spacer()
                                Stepper("", value: $temperature, in: -20...50, step: 0.5).labelsHidden()
                            }
                            
                            Slider(value: $temperature, in: -20...50, step: 0.5).tint(temperature < 0 ? .navBlue : .animCoral)

                            
                        }
                        .padding(12).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 12))

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.cdPurple)
                            Text("Slider = fast coarse drag. Stepper = precise single-unit adjustment. Both bound to the same value.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.cdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    func stepperRow<C: View>(_ label: String, icon: String, @ViewBuilder content: () -> C) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).foregroundStyle(Color.cdPurple).font(.system(size: 15)).frame(width: 22)
            Text(label).font(.system(size: 13)).frame(width: 60, alignment: .leading)
            content()
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
        .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct StepperDeepDiveExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Stepper - full control")
            Text("Stepper provides + and − buttons for precise numeric adjustment. Two forms: the binding form with automatic step math, and the callback form (onIncrement/onDecrement) for fully custom logic like exponential steps or skip-rounding.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Stepper(value: $x, in: 1...99) - automatic. Stepper(value:in:step:) for custom step size.", color: .cdPurple)
                StepRow(number: 2, text: "Stepper(value:in:step:format:) - displays a formatted string in the label area. Clean for numbers.", color: .cdPurple)
                StepRow(number: 3, text: "Stepper { label } onIncrement: { } onDecrement: { } - fully custom. No automatic binding.", color: .cdPurple)
                StepRow(number: 4, text: "onEditingChanged: - fires true when user starts pressing, false when they release.", color: .cdPurple)
                StepRow(number: 5, text: "Pair with Slider on the same binding - Slider for fast coarse, Stepper for precise fine-tuning.", color: .cdPurple)
            }

            CalloutBox(style: .success, title: "Custom logic with callback form", contentBody: "onIncrement/onDecrement free you from fixed steps. Use them for exponential doubling, skip-rounding to multiples, circular wrapping (go past max → reset to min), or any custom increment logic.")

            CodeBlock(code: """
// Binding form
Stepper("Quantity: \\(qty)", value: $qty, in: 1...99)
Stepper(value: $qty, in: 1...99, step: 5) {
    Label("\\(qty) items", systemImage: "cart")
}

// With format
Stepper(value: $temp, in: -20...50, step: 0.5,
        format: .number.precision(.fractionLength(1))) {
    Text("Temperature")
}

// Custom logic - exponential
Stepper {
    Text("\\(value)")
} onIncrement: {
    value = min(value * 2, 1024)
} onDecrement: {
    value = max(value / 2, 1)
}

// Editing changed
Stepper("Value: \\(x)", value: $x) { editing in
    if !editing { saveValue(x) }
}
""")
        }
    }
}
