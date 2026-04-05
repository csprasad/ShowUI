//
//
//  8_LayoutPriority.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `05/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Layout Priority
struct LayoutPriorityVisual: View {
    @State private var selectedDemo = 0
    @State private var containerWidth: CGFloat = 280

    let demos = ["Equal priority", "Priority 1", "Priority + fixed"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Layout priority", systemImage: "scale.3d")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.ssPurple)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.ssPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.ssPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Width control
                HStack(spacing: 10) {
                    Image(systemName: "arrow.left.and.right").font(.system(size: 11)).foregroundStyle(.secondary)
                    Slider(value: $containerWidth, in: 100...280, step: 4).tint(.ssPurple)
                    Text("\(Int(containerWidth))pt").font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 40)
                }

                // Live demo
                ZStack {
                    Color(.secondarySystemBackground)
                    priorityDemo
                        .frame(width: containerWidth)
                        .padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.35), value: containerWidth)
                .animation(.spring(response: 0.35), value: selectedDemo)

                let descs = [
                    "No priority set - both Text views share available space equally. Both truncate at the same time.",
                    "Title has .layoutPriority(1) - it gets as much space as it needs first. Badge shrinks/truncates only after title is satisfied.",
                    "Fixed width + high priority - the icon takes exactly what it needs. The title keeps the rest.",
                ]
                Text(descs[selectedDemo])
                    .font(.system(size: 12)).foregroundStyle(.secondary).lineSpacing(2)
                    .animation(.easeInOut(duration: 0.2), value: selectedDemo)
            }
        }
    }

    @ViewBuilder
    private var priorityDemo: some View {
        switch selectedDemo {
        case 0:
            // Equal - both share space
            HStack(spacing: 8) {
                Text("A long title needs space")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.ssPurple)
                    .lineLimit(1)
                    .padding(.horizontal, 8).padding(.vertical, 5)
                    .background(Color.ssPurpleLight).clipShape(RoundedRectangle(cornerRadius: 6))

                Text("Badge label")
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .padding(.horizontal, 8).padding(.vertical, 5)
                    .background(Color(hex: "#9B67F5")).clipShape(RoundedRectangle(cornerRadius: 6))
            }

        case 1:
            // Priority on title
            HStack(spacing: 8) {
                Text("A long title needs space")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.ssPurple)
                    .lineLimit(1)
                    .padding(.horizontal, 8).padding(.vertical, 5)
                    .background(Color.ssPurpleLight).clipShape(RoundedRectangle(cornerRadius: 6))
                    .layoutPriority(1)    // ← gets space first

                Text("Badge label")
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .padding(.horizontal, 8).padding(.vertical, 5)
                    .background(Color(hex: "#9B67F5")).clipShape(RoundedRectangle(cornerRadius: 6))
            }

        default:
            // Fixed icon + priority title
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.ssPurple).clipShape(RoundedRectangle(cornerRadius: 8))

                Text("Title gets remaining space")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.ssPurple)
                    .lineLimit(1)
                    .layoutPriority(1)

                Text("Tag")
                    .font(.system(size: 11))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6).padding(.vertical, 3)
                    .background(Color(hex: "#9B67F5")).clipShape(Capsule())
            }
        }
    }
}

struct LayoutPriorityExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Layout priority")
            Text("When a stack runs out of space, it needs to decide which views shrink and which get truncated. .layoutPriority() controls that decision - higher priority views get their space needs met first, lower priority views shrink first.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Default priority is 0 for all views. Equal priority means equal shrinking.", color: .ssPurple)
                StepRow(number: 2, text: ".layoutPriority(1) on a view means: satisfy this view's space needs before views with lower priority.", color: .ssPurple)
                StepRow(number: 3, text: "Priority doesn't set a fixed size - it sets relative importance when space is scarce.", color: .ssPurple)
                StepRow(number: 4, text: "Fixed-size views (.frame(width:)) never shrink regardless of priority.", color: .ssPurple)
                StepRow(number: 5, text: "Common pattern: give .layoutPriority(1) to the most important Text in a row so it's the last to truncate.", color: .ssPurple)
            }

            CalloutBox(style: .success, title: "The most common use case", contentBody: "A row with an icon, a title, and a badge. Give the title .layoutPriority(1) so when space is tight the badge truncates or disappears before the important title text gets cut off.")

            CalloutBox(style: .info, title: "fixedSize() is the nuclear option", contentBody: ".fixedSize() tells a view to ignore its parent's size offer entirely and use its ideal size. The view will overflow rather than shrink. Useful when a view must never truncate - like a critical label - but use carefully.")

            CodeBlock(code: """
// Without priority - both truncate equally
HStack {
    Text("Important long title")  // truncates at same rate
    Text("Less important badge")  // as badge
}

// With priority - title protected
HStack {
    Text("Important long title")
        .layoutPriority(1)        // gets space first
    Text("Less important badge")  // shrinks/truncates first
}

// Fixed + priority
HStack {
    Image(systemName: "star")
        .frame(width: 24)         // never shrinks (fixed)
    Text("Title")
        .layoutPriority(1)        // second priority
    Text("Badge")                 // shrinks first
}

// fixedSize - never shrinks (use carefully)
Text("Must never truncate")
    .fixedSize()
""")
        }
    }
}

