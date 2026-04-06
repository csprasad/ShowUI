//
//
//  TopicCard.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Topic Card
struct TopicCard: View {
    let topic: any TopicProtocol

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Icon area
            HStack(alignment: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(topic.color)
                        .frame(width: 48, height: 48)
                    Image(systemName: topic.icon)
                        .font(.system(size: 22))
                        .foregroundStyle(topic.accentColor)
                }
                Spacer()
                TagBadge(text: topic.tag, color: topic.accentColor)
            }
            .padding(.bottom, 14)

            // Text
            Text(topic.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)
                .padding(.bottom, 4)

            Text(topic.subtitle)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 10)

            // Lesson count
            HStack(spacing: 4) {
                Image(systemName: "book.pages")
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
                Text("\(topic.lessons.count) lessons")
                    .font(.system(size: 12))
                    .foregroundStyle(.tertiary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 160, alignment: .topLeading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}
