//
//
//  SharedComponents.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Visual Container
struct VisualCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
            .padding(.horizontal, 20)
    }
}

// MARK: - Task Pill
struct TaskPill: View {
    let label: String
    let color: Color
    let textColor: Color
    var isActive: Bool = true

    var body: some View {
        Text(label)
            .font(.system(size: 13, weight: .semibold, design: .monospaced))
            .foregroundStyle(textColor)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(color.opacity(isActive ? 1 : 0.3))
            .clipShape(Capsule())
    }
}

// MARK: - Timeline Bar
struct TimelineBar: View {
    let label: String
    let color: Color
    let textColor: Color
    let progress: CGFloat
    let delay: CGFloat
    let totalWidth: CGFloat

    var body: some View {
        HStack(spacing: 10) {
            Text(label)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 90, alignment: .trailing)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color(.systemFill))
                    .frame(height: 28)

                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(color)
                    .frame(width: totalWidth * progress, height: 28)
                    .offset(x: totalWidth * delay)
            }
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        }
    }
}

// MARK: - Step Explanation Row
struct StepRow: View {
    let number: Int
    let text: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 26, height: 26)
                Text("\(number)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(color)
            }
            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }
}

// MARK: - Code Block
struct CodeBlock: View {
    let code: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.primary)
                .padding(14)
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// MARK: - Callout Box
struct CalloutBox: View {
    enum Style { case danger, success, info, warning }
    let style: Style
    let title: String
    let content: String

    var accentColor: Color {
        switch style {
        case .danger: return Color(hex: "#E24B4A")
        case .success: return Color(hex: "#1D9E75")
        case .info: return Color(hex: "#378ADD")
        case .warning: return Color(hex: "#BA7517")
        }
    }
    var bgColor: Color {
        switch style {
        case .danger: return Color(hex: "#FCEBEB")
        case .success: return Color(hex: "#E1F5EE")
        case .info: return Color(hex: "#E6F1FB")
        case .warning: return Color(hex: "#FAEEDA")
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Rectangle()
                .fill(accentColor)
                .frame(width: 3)
                .clipShape(Capsule())
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(accentColor)
                Text(content)
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

// MARK: - Section Header
struct SectionHeader: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .padding(.bottom, 2)
    }
}
