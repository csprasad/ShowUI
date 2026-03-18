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

struct ConcurrencyView: View {
    @State private var selectedLesson: Lesson? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    lessonList
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
            .navigationDestination(for: Lesson.self) { lesson in
                LessonDetailView(lesson: lesson)
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .center, spacing: 6) {
            Text("Visual lessons for Swift concurrency")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }

    private var lessonList: some View {
        LazyVStack(spacing: 12, pinnedViews: []) {
            ForEach(groupedLessons, id: \.tag) { group in
                sectionHeader(group.tag)
                ForEach(group.lessons) { lesson in
                    NavigationLink(value: lesson) {
                        LessonCard(lesson: lesson)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }

    private func sectionHeader(_ tag: String) -> some View {
        Text(tag.uppercased())
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(.secondary)
            .kerning(1.2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            .padding(.bottom, 2)
    }

    private var groupedLessons: [(tag: String, lessons: [Lesson])] {
        let order = ["Basics", "Problem", "Solution", "Patterns", "Lifecycle", "Safety"]
        var dict: [String: [Lesson]] = [:]
        for lesson in Lesson.all {
            dict[lesson.tag, default: []].append(lesson)
        }
        return order.compactMap { tag in
            guard let lessons = dict[tag] else { return nil }
            return (tag: tag, lessons: lessons)
        }
    }
}

struct LessonCard: View {
    let lesson: Lesson

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(lesson.color)
                    .frame(width: 52, height: 52)
                Image(systemName: lesson.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(lesson.accentColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("0\(lesson.number)")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundStyle(.tertiary)
                    Spacer()
                }
                Text(lesson.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                Text(lesson.subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    ConcurrencyView()
}
