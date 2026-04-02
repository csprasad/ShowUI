//
//
//  7_effectsReference.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `23/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Symbol Effects (Reference)
struct EffectsReferenceVisual: View {
    @State private var trigger = 0
    @State private var selectedEffect = 0
 
    struct EffectRef {
        let name: String
        let icon: String
        let minOS: String
    }
 
    let effects: [EffectRef] = [
        EffectRef(name: ".bounce",       icon: "bell.fill",           minOS: "17"),
        EffectRef(name: ".pulse",        icon: "heart.fill",          minOS: "17"),
        EffectRef(name: ".variableColor",icon: "speaker.wave.3.fill", minOS: "17"),
        EffectRef(name: ".appear",       icon: "star.fill",           minOS: "17"),
        EffectRef(name: ".wiggle",       icon: "trash.fill",          minOS: "18"),
        EffectRef(name: ".breathe",      icon: "lungs.fill",          minOS: "18"),
        EffectRef(name: ".rotate",       icon: "arrow.circlepath",    minOS: "18"),
    ]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Symbol effects", systemImage: "sparkles")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.sfGreen)
                    Spacer()
                    HStack(spacing: 4) {
                        Text("iOS 17+")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(Color.sfGreen)
                            .padding(.horizontal, 8).padding(.vertical, 3)
                            .background(Color.sfGreenLight)
                            .clipShape(Capsule())
                    }
                }
 
                // Preview
                ZStack {
                    Color(.secondarySystemBackground)
                    effectPreview
                }
                .frame(maxWidth: .infinity).frame(height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 14))
 
                Button {
                    trigger += 1
                } label: {
                    Text("Trigger once")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.sfGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PressableButtonStyle())
 
                // Effect chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(effects.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedEffect = i; trigger = 0 }
                            } label: {
                                HStack(spacing: 4) {
                                    Text(effects[i].name)
                                        .font(.system(size: 11, weight: selectedEffect == i ? .semibold : .regular, design: .monospaced))
                                        .foregroundStyle(selectedEffect == i ? Color.sfGreen : .secondary)
                                    if effects[i].minOS == "18" {
                                        Text("18+")
                                            .font(.system(size: 8, weight: .medium))
                                            .foregroundStyle(Color.animAmber)
                                    }
                                }
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(selectedEffect == i ? Color.sfGreenLight : Color(.systemFill))
                                .clipShape(Capsule())
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }
            }
        }
    }
 
    @ViewBuilder
    private var effectPreview: some View {
        let e = effects[selectedEffect]
        switch selectedEffect {
        case 0:
            Image(systemName: e.icon).font(.system(size: 52)).foregroundStyle(Color.sfGreen)
                .symbolEffect(.bounce, value: trigger)
        case 1:
            Image(systemName: e.icon).font(.system(size: 52)).foregroundStyle(Color.sfGreen)
                .symbolEffect(.pulse, value: trigger)
        case 2:
            Image(systemName: e.icon).font(.system(size: 52)).foregroundStyle(Color.sfGreen)
                .symbolEffect(.variableColor, value: trigger)
        case 3:
            Image(systemName: e.icon).font(.system(size: 52)).foregroundStyle(Color.sfGreen)
                .symbolEffect(.appear, isActive: trigger % 2 == 1)
        case 4:
            if #available(iOS 18, *) {
                Image(systemName: e.icon).font(.system(size: 52)).foregroundStyle(Color.sfGreen)
                    .symbolEffect(.wiggle, value: trigger)
            } else { Text("iOS 18+ required").font(.system(size: 13)).foregroundStyle(.secondary) }
        case 5:
            if #available(iOS 18, *) {
                Image(systemName: e.icon).font(.system(size: 52)).foregroundStyle(Color.sfGreen)
                    .symbolEffect(.breathe, value: trigger)
            } else { Text("iOS 18+ required").font(.system(size: 13)).foregroundStyle(.secondary) }
        default:
            if #available(iOS 18, *) {
                Image(systemName: e.icon).font(.system(size: 52)).foregroundStyle(Color.sfGreen)
                    .symbolEffect(.rotate, value: trigger)
            } else { Text("iOS 18+ required").font(.system(size: 13)).foregroundStyle(.secondary) }
        }
    }
}
struct EffectsReferenceExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Symbol effects - quick reference")
            Text("Symbol effects are covered in depth in the Animations topic (Lesson 7). This is a quick reference for the most common effects and their availability.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".bounce, .pulse, .variableColor, .appear, .disappear - iOS 17+", color: .sfGreen)
                StepRow(number: 2, text: ".wiggle, .breathe, .rotate - iOS 18+", color: .sfGreen)
                StepRow(number: 3, text: "value: trigger - fires once when value changes.", color: .sfGreen)
                StepRow(number: 4, text: "options: .repeating, isActive: bool - loops while true.", color: .sfGreen)
            }

            CalloutBox(style: .info, title: "See Animations → Lesson 7", contentBody: "The full interactive lesson with all effects, trigger vs loop modes, and layer-aware behaviour is in the Animations topic.")

            CodeBlock(code: """
// Trigger once - value changes fire the effect
Image(systemName: "bell.fill")
    .symbolEffect(.bounce, value: notificationCount)

// Loop - runs while isActive is true
Image(systemName: "arrow.circlepath")
    .symbolEffect(.rotate, options: .repeating, isActive: isLoading)

// iOS 18+ effects need availability check
if #available(iOS 18, *) {
    Image(systemName: "trash.fill")
        .symbolEffect(.wiggle, value: deleteCount)
}
""")
        }
    }
}
