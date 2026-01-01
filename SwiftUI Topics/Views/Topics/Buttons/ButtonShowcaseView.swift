//
//  ProductionButton.swift
//  SwiftUI Topics
//
//  Created by codeAlligator on 01/01/26.
//

import SwiftUI

struct ButtonShowcaseView: View {

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                sectionTitle("Button Roles")
                buttonRow(
                    label: "Default",
                    button: Button("Default") {}
                )

                buttonRow(
                    label: "Destructive",
                    button: Button("Delete", role: .destructive) {}
                )

                buttonRow(
                    label: "Cancel",
                    button: Button("Cancel", role: .cancel) {}
                )

                Divider()

                sectionTitle("Built-in Button Styles")
                buttonRow(
                    label: "Automatic",
                    button: Button("Automatic") {}
                )

                buttonRow(
                    label: "Bordered",
                    button: Button("Bordered") {}
                        .buttonStyle(.bordered)
                )

                buttonRow(
                    label: "Bordered Prominent",
                    button: Button("Prominent") {}
                        .buttonStyle(.borderedProminent)
                )

                buttonRow(
                    label: "Plain",
                    button: Button("Plain") {}
                        .buttonStyle(.plain)
                )

                buttonRow(
                    label: "Borderless",
                    button: Button("Borderless") {}
                        .buttonStyle(.borderless)
                )

                Divider()

                sectionTitle("Control Sizes")
                buttonRow(
                    label: "Mini",
                    button: Button("Mini") {}
                        .buttonStyle(.bordered)
                        .controlSize(.mini)
                )

                buttonRow(
                    label: "Small",
                    button: Button("Small") {}
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                )

                buttonRow(
                    label: "Regular",
                    button: Button("Regular") {}
                        .buttonStyle(.bordered)
                        .controlSize(.regular)
                )

                buttonRow(
                    label: "Large",
                    button: Button("Large") {}
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                )

                Divider()

                sectionTitle("Custom Styled Button")
                buttonRow(
                    label: "Custom",
                    button: Button("Custom Style") {}
                        .buttonStyle(CustomCapsuleButtonStyle())
                )
            }
            .padding()
        }
        .navigationTitle("Default Styles")
    }
}

private func sectionTitle(_ text: String) -> some View {
    Text(text)
        .font(.subheadline.bold())
        .padding(.bottom, 4)
}

private func buttonRow<Content: View>(
    label: String,
    button: Content
) -> some View {
    HStack {
        Text(label)
            .font(.subheadline)
            .foregroundStyle(.secondary)

        Spacer()

        button
    }
}

struct CustomCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(configuration.isPressed ? .gray.opacity(0.4) : .blue)
            )
            .foregroundStyle(.white)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
