//
//
//  TopicDetailView.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

struct TopicDetailView: View {
    let topic: any TopicProtocol
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                topicHeader
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 28)

                if topic.lessons.isEmpty {
                    EmptyLessonsView()
                } else {
                    lessonList
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Topics")
                            .font(.system(size: 16))
                    }
                    .foregroundStyle(topic.accentColor)
                }
            }
        }
    }

    // MARK: - Topic Header
    private var topicHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(topic.color)
                        .frame(width: 52, height: 52)
                    Image(systemName: topic.icon)
                        .font(.system(size: 24))
                        .foregroundStyle(topic.accentColor)
                }
                VStack(alignment: .leading, spacing: 3) {
                    TagBadge(text: topic.tag, color: topic.accentColor)
                    Text(topic.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                }
            }
            Text(topic.subtitle)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(3)

            // Progress indicator
            HStack(spacing: 6) {
                Image(systemName: "book.pages.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(topic.accentColor)
                Text("\(topic.lessons.count) lessons")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(topic.accentColor)
            }
            .padding(.top, 2)
        }
    }

    // MARK: - Lesson List
    private var lessonList: some View {
        LazyVStack(spacing: 10) {
            ForEach(topic.lessons) { lesson in
                NavigationLink(destination: LessonDetailView(lesson: lesson, topic: topic)) {
                    LessonRowCard(lesson: lesson, accentColor: topic.accentColor)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
}
