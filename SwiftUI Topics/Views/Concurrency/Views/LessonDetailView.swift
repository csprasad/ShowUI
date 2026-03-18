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
    let lesson: Lesson
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                lessonHeader
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 24)

                lessonVisual
                    .padding(.bottom, 32)

                lessonExplanation
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
                        Text("Lessons")
                            .font(.system(size: 16))
                    }
                    .foregroundStyle(lesson.accentColor)
                }
            }
        }
    }

    private var lessonHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(lesson.color)
                        .frame(width: 44, height: 44)
                    Image(systemName: lesson.icon)
                        .font(.system(size: 20))
                        .foregroundStyle(lesson.accentColor)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Lesson \(lesson.number) · \(lesson.tag)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                    Text(lesson.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                }
            }
            Text(lesson.subtitle)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(3)
        }
    }

    @ViewBuilder
    private var lessonVisual: some View {
        switch lesson.number {
        case 1: SequentialVisual()
        case 2: ConcurrentVisual()
        case 3: RaceConditionVisual()
        case 4: ActorVisual()
        case 5: AsyncLetVisual()
        case 6: TaskGroupVisual()
        case 7: CancellationVisual()
        case 8: SendableVisual()
        default: EmptyView()
        }
    }

    @ViewBuilder
    private var lessonExplanation: some View {
        switch lesson.number {
        case 1: SequentialExplanation()
        case 2: ConcurrentExplanation()
        case 3: RaceConditionExplanation()
        case 4: ActorExplanation()
        case 5: AsyncLetExplanation()
        case 6: TaskGroupExplanation()
        case 7: CancellationExplanation()
        case 8: SendableExplanation()
        default: EmptyView()
        }
    }
}
