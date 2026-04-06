//
//
//  Lessons5to8.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Sendable

struct SendableVisual: View {
    @State private var selectedType = 0
    let types = ["struct", "final class", "class (mutable)", "actor"]

    var typeInfo: (safe: Bool, reason: String, color: Color) {
        switch selectedType {
        case 0: return (true,  "Structs with Sendable properties are automatically Sendable, because their properties are also Sendable. Value types are copied, not shared.", Color(hex: "#1D9E75"))
        case 1: return (true,  "A final class with only let stored properties can safely cross boundaries, because its state can never change.", Color(hex: "#1D9E75"))
        case 2: return (false, "A mutable class with var properties is NOT Sendable. Two tasks could mutate it simultaneously, causing a race condition.", Color(hex: "#E24B4A"))
        case 3: return (true,  "Actors are inherently Sendable. Their internal state is protected by the actor's isolation guarantee.", Color(hex: "#1D9E75"))
        default: return (true, "", .clear)
        }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Sendable", systemImage: "checkmark.seal.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#993556"))
                    Spacer()
                }

                Text("Select a type to see if it can safely cross task boundaries:")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)

                // Type selector
                HStack(spacing: 8) {
                    ForEach(Array(types.enumerated()), id: \.offset) { i, t in
                        Button(t) { withAnimation(.spring()) { selectedType = i } }
                            .font(.system(size: 12, weight: selectedType == i ? .semibold : .regular, design: .monospaced))
                            .foregroundStyle(selectedType == i ? .white : Color(hex: "#993556"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(selectedType == i ? Color(hex: "#993556") : Color(hex: "#FBEAF0"))
                            .clipShape(Capsule())
                    }
                }
                .fixedSize(horizontal: false, vertical: true)

                // Boundary diagram
                HStack(spacing: 0) {
                    taskBox(label: "Task A", color: Color(hex: "#E6F1FB"), textColor: Color(hex: "#0C447C"))

                    VStack(spacing: 4) {
                        Image(systemName: typeInfo.safe ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(typeInfo.color)
                            .animation(.spring(), value: selectedType)
                        Text("boundary")
                            .font(.system(size: 9))
                            .foregroundStyle(.tertiary)
                    }
                    .frame(width: 60)

                    taskBox(label: "Task B", color: Color(hex: "#E1F5EE"), textColor: Color(hex: "#085041"))
                }
                .padding(.vertical, 4)

                // Result
                HStack(spacing: 8) {
                    Image(systemName: typeInfo.safe ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(typeInfo.color)
                    Text(typeInfo.safe ? "Safe to pass across tasks" : "Compiler error in strict mode")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(typeInfo.color)
                }
                .animation(.spring(), value: selectedType)

                Text(typeInfo.reason)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
                    .animation(.easeIn(duration: 0.2), value: selectedType)
            }
        }
    }

    func taskBox(label: String, color: Color, textColor: Color) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(textColor)
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 70, height: 50)
                .overlay(
                    Text(types[selectedType])
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundStyle(textColor.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(4)
                )
        }
    }
}

struct SendableExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "What Sendable means")
            Text("Sendable is a protocol that tells the compiler: this type is safe to pass across concurrency boundaries. In Swift 6 strict mode, passing a non-Sendable type between tasks is a compile-time error.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
            VStack(spacing: 12) {
                StepRow(number: 1, text: "Structs and enums with Sendable properties are automatically Sendable, because they're copied, not shared.", color: Color(hex: "#993556"))
                StepRow(number: 2, text: "A final class with only let properties can conform to Sendable, because its state is immutable.", color: Color(hex: "#993556"))
                StepRow(number: 3, text: "Actors are inherently Sendable - their isolation protects their mutable state.", color: Color(hex: "#993556"))
                StepRow(number: 4, text: "A standard mutable class is not automatically Sendable, because its mutable state can be shared between tasks. Attempting to do so will cause the compiler rejects it at a task boundary.", color: Color(hex: "#993556"))
            }
            CalloutBox(style: .success, title: "Caught at compile time", contentBody: "This is how Swift 6 eliminates the race condition ghost bug, before your code ever runs.")
            CodeBlock(code: """
// Automatically Sendable - struct, immutable
struct UserProfile: Sendable {
    let id: UUID
    let name: String
}

// Sendable - actor protects its own mutable state
actor ProfileCache {
    private var cache: [UUID: UserProfile] = [:]
}

// NOT Sendable - mutable class, compiler error
class Config {
    var threshold = 10  // var = unsafe to share
}
""")
        }
    }
}

#Preview {
    SendableVisual()
}
