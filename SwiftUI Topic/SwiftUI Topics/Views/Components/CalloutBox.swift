//
//
//  CalloutBox.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Callout Box
struct CalloutBox: View {
    enum Style { case danger, success, info, warning }

    let style: Style
    let title: String
    let contentBody: String

    var accentColor: Color {
        switch style {
        case .danger:  return Color(hex: "#E24B4A")
        case .success: return Color(hex: "#1D9E75")
        case .info:    return Color(hex: "#378ADD")
        case .warning: return Color(hex: "#BA7517")
        }
    }

    var bgColor: Color {
        switch style {
        case .danger:  return Color(hex: "#FCEBEB")
        case .success: return Color(hex: "#E1F5EE")
        case .info:    return Color(hex: "#E6F1FB")
        case .warning: return Color(hex: "#FAEEDA")
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Capsule()
                .fill(accentColor)
                .frame(width: 3)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(accentColor)
                Text(contentBody)
                    .font(.system(size: 13))
                    .foregroundStyle(accentColor.opacity(0.85))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(12)
        .background(bgColor)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
