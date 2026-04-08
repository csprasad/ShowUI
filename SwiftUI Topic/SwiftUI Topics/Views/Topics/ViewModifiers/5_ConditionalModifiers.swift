//
//
//  5_ConditionalModifiers.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `08/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: Conditional Modifiers
struct ConditionalModifierVisual: View {
    @State private var isSelected = false
    @State private var isError = false
    @State private var isDisabled = false
    @State private var isDarkPreview = false
    @State private var selectedPattern = 0

    let patterns = ["if/else", "ternary", ".modifier(if:)"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Conditional modifiers", systemImage: "arrow.triangle.branch")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.vmGreen)

                HStack(spacing: 8) {
                    ForEach(patterns.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedPattern = i }
                        } label: {
                            Text(patterns[i])
                                .font(.system(size: 11, weight: selectedPattern == i ? .semibold : .regular))
                                .foregroundStyle(selectedPattern == i ? Color.vmGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedPattern == i ? Color.vmGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
                Divider()

                switch selectedPattern {
                case 0:
                    // if/else pattern
                    VStack(spacing: 12) {
                        sectionHeader()
                        
                        HStack(spacing: 10) {
                            toggleChip("Selected", isOn: $isSelected, color: .vmGreen)
                            toggleChip("Error", isOn: $isError, color: .animCoral)
                            toggleChip("Disabled", isOn: $isDisabled, color: .secondary)
                        }
                        
                        flowArrow

                        // The view that changes
                        Group {
                            if isError {
                                HStack(spacing: 8) {
                                    Image(systemName: "exclamationmark.circle.fill").foregroundStyle(Color.animCoral)
                                    Text("Invalid input").font(.system(size: 14))
                                }
                                .padding(12).background(Color(hex: "#FCEBEB")).clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.animCoral.opacity(0.4), lineWidth: 1.5))
                            } else if isSelected {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.vmGreen)
                                    Text("Selected item").font(.system(size: 14))
                                }
                                .padding(12).background(Color.vmGreenLight).clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.vmGreen.opacity(0.4), lineWidth: 1.5))
                            } else {
                                HStack(spacing: 8) {
                                    Image(systemName: "circle").foregroundStyle(.secondary)
                                    Text("Normal state").font(.system(size: 14))
                                }
                                .padding(12).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .opacity(isDisabled ? 0.4 : 1.0)
                        .animation(.spring(response: 0.3), value: isSelected)
                        .animation(.spring(response: 0.3), value: isError)
                        .animation(.easeInOut(duration: 0.2), value: isDisabled)

                        Text("Use if/else for modifiers that change view type or structure").font(.system(size: 10)).foregroundStyle(.secondary)
                    }

                case 1:
                    // Ternary - same type modifiers
                    VStack(spacing: 12) {
                        sectionHeader()
                        
                        HStack(spacing: 10) {
                            toggleChip("Highlighted", isOn: $isSelected, color: .vmGreen)
                            toggleChip("Error", isOn: $isError, color: .animCoral)
                        }
                        
                        flowArrow

                        // Ternary for same-type modifiers
                        Text("Email address")
                            .font(.system(size: 14))
                            .foregroundStyle(isError ? Color.animCoral : isSelected ? Color.vmGreen : .primary)
                            .padding(12)
                            .background(isError ? Color(hex: "#FCEBEB") : isSelected ? Color.vmGreenLight : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(isError ? Color.animCoral : isSelected ? Color.vmGreen : Color.clear, lineWidth: 1.5)
                            )
                            .animation(.spring(response: 0.25), value: isSelected)
                            .animation(.spring(response: 0.25), value: isError)

                        Text("Ternary works great when modifier type doesn't change, only its value").font(.system(size: 10)).foregroundStyle(.secondary)
                    }

                default:
                    // .if() extension
                    VStack(spacing: 12) {
                        sectionHeader()
                        
                        HStack(spacing: 10) {
                            toggleChip("Rounded", isOn: $isSelected, color: .vmGreen)
                            toggleChip("Shadow", isOn: $isError, color: .navBlue)
                            toggleChip("Scale 1.1", isOn: $isDisabled, color: .ssPurple)
                        }
                        
                        flowArrow
                            
                        Text("Apply me!")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20).padding(.vertical, 12)
                            .background(Color.vmGreen)
                            .if(isSelected) { $0.clipShape(Capsule()) }
                            .if(!isSelected) { $0.clipShape(RoundedRectangle(cornerRadius: 8)) }
                            .if(isError) { $0.shadow(color: Color.navBlue.opacity(0.4), radius: 10, y: 4) }
                            .if(isDisabled) { $0.scaleEffect(1.1) }
                            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
                            .animation(.spring(response: 0.35), value: isError)
                            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isDisabled)

                        Text(".if() extension - apply modifier only when condition is true").font(.system(size: 10)).foregroundStyle(.secondary)
                    }
                }
                
            }
        }
    }
    
    private func sectionHeader(_ text: String = "Select Modifiers") -> some View {
        Text(text)
            .font(.system(size: 8, weight: .semibold))
            .textCase(.uppercase)
            .foregroundStyle(.secondary)
    }
    
    private var flowArrow: some View {
        Image(systemName: "arrow.down")
            .font(.system(size: 8, weight: .semibold))
            .foregroundStyle(.secondary)
    }

    func toggleChip(_ label: String, isOn: Binding<Bool>, color: Color) -> some View {
        Button { withAnimation(.spring(response: 0.25)) { isOn.wrappedValue.toggle() } } label: {
            HStack(spacing: 4) {
                Circle().fill(isOn.wrappedValue ? color : Color(.systemGray4)).frame(width: 8, height: 8)
                Text(label).font(.system(size: 11, weight: isOn.wrappedValue ? .semibold : .regular))
                    .foregroundStyle(isOn.wrappedValue ? color : .secondary)
            }
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(isOn.wrappedValue ? color.opacity(0.1) : Color(.systemFill))
            .clipShape(Capsule())
        }
        .buttonStyle(PressableButtonStyle())
    }
}

// .if() extension used in the demo
extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) } else { self }
    }
}

struct ConditionalModifierExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Conditional modifiers")
            Text("Applying modifiers conditionally is one of the most common patterns in SwiftUI. There are three approaches - if/else for structural changes, ternary for value changes, and a custom .if() extension for concise conditional modifier application.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "if/else blocks - best when the modifier changes view type (e.g. background view vs no background).", color: .vmGreen)
                StepRow(number: 2, text: "Ternary - best when only a value changes (.foregroundStyle(isError ? .red : .primary)).", color: .vmGreen)
                StepRow(number: 3, text: ".if(condition) { $0.modifier() } - concise when you want to add a modifier only when a flag is true.", color: .vmGreen)
                StepRow(number: 4, text: "Avoid @ViewBuilder with if - it can create identity instability that breaks animations.", color: .vmGreen)
            }

            CalloutBox(style: .warning, title: "if/else can break animations", contentBody: "When using if/else to toggle modifiers, SwiftUI may see it as two different views - destroying one and creating another. This kills animations. Prefer ternary for animated state changes so SwiftUI knows it's the same view.")

            CalloutBox(style: .info, title: "The .if() extension caveat", contentBody: "The .if() extension is popular but has a subtle issue - it uses @ViewBuilder which can affect view identity. Use it for non-animated state changes. For animated state, stick to ternary on modifier values.")

            CodeBlock(code: """
// Ternary - same view, animated ✓
Text("Label")
    .foregroundStyle(isActive ? .blue : .gray)
    .background(isActive ? Color.blue.opacity(0.1) : .clear)
    .scaleEffect(isActive ? 1.05 : 1.0)
    .animation(.spring(), value: isActive)

// if/else - may break animation identity
Group {
    if isPrimary {
        label.background(.blue)
    } else {
        label.background(.gray)
    }
}

// .if() extension - conditional modifier
extension View {
    @ViewBuilder
    func `if`<T: View>(_ condition: Bool,
                        transform: (Self) -> T) -> some View {
        if condition { transform(self) } else { self }
    }
}

// Usage
Text("Hello")
    .if(isPro) { $0.overlay(ProBadge()) }
    .if(isLarge) { $0.font(.title) }
""")
        }
    }
}
