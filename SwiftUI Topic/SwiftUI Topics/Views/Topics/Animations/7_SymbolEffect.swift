//
//
//  7_SymbolEffect.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Symbol Effects
struct SymbolEffectVisual: View {
    @State private var trigger = 0
    @State private var isActive = false
    @State private var selectedEffect = 0

    struct EffectOption {
        let name: String
        let icon: String
        let description: String
    }

    let effects: [EffectOption] = [
        EffectOption(name: "bounce",      icon: "bell.fill",         description: "Jumps up and springs back"),
        EffectOption(name: "pulse",       icon: "heart.fill",        description: "Fades in and out repeatedly"),
        EffectOption(name: "rotate",      icon: "arrow.circlepath",  description: "Spins around its center"),
        EffectOption(name: "wiggle",      icon: "trash.fill",        description: "Shakes left and right"),
        EffectOption(name: "breathe",     icon: "lungs.fill",        description: "Scales up and down softly"),
        EffectOption(name: "appear",      icon: "star.fill",         description: "Animates in from nothing"),
        EffectOption(name: "disappear",   icon: "moon.fill",         description: "Animates out to nothing"),
        EffectOption(name: "variable",    icon: "speaker.wave.3.fill", description: "Animates variable layers"),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Symbol effects", systemImage: "star.circle.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.animPurple)
                    Spacer()
                    Text("iOS 17+")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.animPurple)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color(hex: "#EEEDFE"))
                        .clipShape(Capsule())
                }

                // Large symbol preview
                ZStack {
                    Color(.secondarySystemBackground)
                    symbolPreview
                }
                .frame(maxWidth: .infinity)
                .frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Trigger buttons
                HStack(spacing: 10) {
                    Button { trigger += 1 } label: {
                        Text("Trigger once")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(Color.animPurple)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }.buttonStyle(PressableButtonStyle())

                    Button { isActive.toggle() } label: {
                        Text(isActive ? "Stop loop" : "Loop")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.animPurple)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(Color(hex: "#EEEDFE"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }.buttonStyle(PressableButtonStyle())
                }

                // Effect grid
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(effects.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedEffect = i
                                isActive = false
                                trigger = 0
                            }
                        } label: {
                            VStack(spacing: 5) {
                                Image(systemName: effects[i].icon)
                                    .font(.system(size: 18))
                                    .foregroundStyle(selectedEffect == i ? Color.animPurple : .secondary)
                                    .frame(width: 36, height: 36)
                                    .background(selectedEffect == i ? Color(hex: "#EEEDFE") : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text(effects[i].name)
                                    .font(.system(size: 9, weight: selectedEffect == i ? .semibold : .regular))
                                    .foregroundStyle(selectedEffect == i ? Color.animPurple : .secondary)
                                    .lineLimit(1)
                            }
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Description
                Text(effects[selectedEffect].description)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .animation(.easeInOut(duration: 0.15), value: selectedEffect)
            }
        }
    }

    @ViewBuilder
    private var symbolPreview: some View {
        let icon = effects[selectedEffect].icon
        let size: CGFloat = 56

        switch selectedEffect {
        case 0: // bounce - discrete trigger is iOS 17+, repeating loop is iOS 18+
            if #available(iOS 18.0, *) {
                Image(systemName: icon).font(.system(size: size))
                    .foregroundStyle(Color.animPurple)
                    .symbolEffect(.bounce, value: trigger)
                    .symbolEffect(.bounce.byLayer, options: .repeating, isActive: isActive)
            } else {
                Image(systemName: icon).font(.system(size: size))
                    .foregroundStyle(Color.animPurple)
                    .symbolEffect(.bounce, value: trigger)
            }
        case 1: // pulse - iOS 17+
            Image(systemName: icon).font(.system(size: size))
                .foregroundStyle(Color.animCoral)
                .symbolEffect(.pulse, value: trigger)
                .symbolEffect(.pulse, options: .repeating, isActive: isActive)
 
        case 2: // variableColor - iOS 17+
            Image(systemName: icon).font(.system(size: size))
                .foregroundStyle(Color.animTeal)
                .symbolEffect(.variableColor, value: trigger)
                .symbolEffect(.variableColor.iterative.reversing, options: .repeating, isActive: isActive)
 
        case 3: // appear - iOS 17+
            Image(systemName: icon).font(.system(size: size))
                .foregroundStyle(Color.animPurple)
                .symbolEffect(.appear, isActive: trigger % 2 == 1)
 
        case 4: // disappear - iOS 17+
            Image(systemName: icon).font(.system(size: size))
                .foregroundStyle(Color.animPink)
                .symbolEffect(.disappear, isActive: trigger % 2 == 1)
 
        case 5: // wiggle - iOS 18+
            if #available(iOS 18.0, *) {
                Image(systemName: icon).font(.system(size: size))
                    .foregroundStyle(Color.animAmber)
                    .symbolEffect(.wiggle, value: trigger)
                    .symbolEffect(.wiggle, options: .repeating, isActive: isActive)
            } else {
                unavailableOverlay("wiggle")
            }
 
        case 6: // breathe - iOS 18+
            if #available(iOS 18.0, *) {
                Image(systemName: icon).font(.system(size: size))
                    .foregroundStyle(Color.animBlue)
                    .symbolEffect(.breathe, value: trigger)
                    .symbolEffect(.breathe, options: .repeating, isActive: isActive)
            } else {
                unavailableOverlay("breathe")
            }
 
        default: // rotate - iOS 18+
            if #available(iOS 18.0, *) {
                Image(systemName: icon).font(.system(size: size))
                    .foregroundStyle(Color.animTeal)
                    .symbolEffect(.rotate, value: trigger)
                    .symbolEffect(.rotate, options: .repeating, isActive: isActive)
            } else {
                unavailableOverlay("rotate")
            }
        }
    }
    
    func unavailableOverlay(_ name: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 28))
                .foregroundStyle(.secondary)
            Text(".\(name) requires iOS 18+")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
    }
}

struct SymbolEffectExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "SF Symbol effects - iOS 17+")
            Text("symbolEffect() applies physics-based animations to SF Symbols using Apple's built-in symbol animation engine. Each effect understands the layers inside the symbol, so they don't just scale or fade the whole image.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".bounce - great for notifications, confirmations, draw attention.", color: .animPurple)
                StepRow(number: 2, text: ".pulse - subtle emphasis, ideal for loading or waiting states.", color: .animPurple)
                StepRow(number: 3, text: ".wiggle - conveys error, deletion, or incorrect action.", color: .animPurple)
                StepRow(number: 4, text: ".variableColor - animates the variable color layers in sequence. Perfect for speaker waves, signal bars.", color: .animPurple)
                StepRow(number: 5, text: ".appear / .disappear - animate the symbol into or out of existence, layer by layer.", color: .animPurple)
            }

            CalloutBox(style: .info, title: "Two trigger styles", contentBody: "value: trigger fires once on change. options: .repeating, isActive: looping fires continuously while a Bool is true. Use the right one for the context.")

            CalloutBox(style: .success, title: "Layer-aware", contentBody: "Unlike a CSS animation, symbolEffect understands the symbol's internal layer structure. .bounce.byLayer bounces each layer independently far more sophisticated than a whole-image scale.")

            CodeBlock(code: """
// Trigger once on tap
Image(systemName: "bell.fill")
    .symbolEffect(.bounce, value: tapCount)

// Loop while active
Image(systemName: "arrow.circlepath")
    .symbolEffect(.rotate, options: .repeating, isActive: isLoading)

// Appear / disappear
Image(systemName: "star.fill")
    .symbolEffect(.appear, isActive: isVisible)

// Variable color - great for signal/volume
Image(systemName: "speaker.wave.3.fill")
    .symbolEffect(.variableColor.iterative.reversing,
                  options: .repeating, isActive: isPlaying)
""")
        }
    }
}
