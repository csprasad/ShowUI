//
//
//  LessonDetailView.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

struct LessonDetailView: View {
    let lesson: AnyLesson
    let topic: any TopicProtocol
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                lessonHeader
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 24)

                lesson.visual
                    .padding(.bottom, 32)

                lesson.explanation
                    .padding(.horizontal, 20)
                    .padding(.bottom, 60)
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
                        Text(topic.title)
                            .font(.system(size: 16))
                    }
                    .foregroundStyle(topic.accentColor)
                }
            }
        }
    }

    // MARK: - Lesson Header
    private var lessonHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(topic.color)
                        .frame(width: 44, height: 44)
                    Image(systemName: lesson.icon)
                        .font(.system(size: 20))
                        .foregroundStyle(topic.accentColor)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Lesson \(lesson.number) · \(topic.tag)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                    Text(lesson.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                }
            }
            Text(lesson.subtitle)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(3)
        }
    }
}
