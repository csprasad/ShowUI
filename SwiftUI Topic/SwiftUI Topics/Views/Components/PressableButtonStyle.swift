//
//
//  PressableButtonStyle.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Pressable Button Style
/// Reusable press-down scale effect. Use across any topic that needs tactile buttons.
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.clear)
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.65), value: configuration.isPressed)
    }
}
