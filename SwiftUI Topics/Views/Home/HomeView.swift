//
//
//  HomeView.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import SwiftUI

struct HomeView: View {
    private let topics = TopicRegistry.all

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    header
                    topicGrid
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }

    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("iOS Topics")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            Text("Visual lessons for every concept")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 30)
        .padding(.bottom, 28)
    }

    // MARK: - Topic Grid
    private var topicGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            ForEach(topics, id: \.id) { topic in
                NavigationLink(destination: TopicDetailView(topic: topic)) {
                    TopicCard(topic: topic)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
}

#Preview {
    HomeView()
}

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
