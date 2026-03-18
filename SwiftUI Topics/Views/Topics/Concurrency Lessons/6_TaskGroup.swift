//
//
//  Lesson_TaskGroup.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Task Groups

struct TaskGroupVisual: View {
    @State private var items: [(id: Int, label: String, color: Color, progress: CGFloat, done: Bool, orderFinished: Int?)] = []
    @State private var running = false
    @State private var finishedCount = 0

    let taskData: [(String, Color, Double)] = [
        ("image_001", Color(hex: "#B5D4F4"), 1.0),
        ("image_002", Color(hex: "#9FE1CB"), 1.8),
        ("image_003", Color(hex: "#FAC775"), 0.7),
        ("image_004", Color(hex: "#F5C4B3"), 1.4),
        ("image_005", Color(hex: "#CECBF6"), 2.0),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("Task Group", systemImage: "square.grid.2x2.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#854F0B"))
                    Spacer()
                    Button(running ? "Running..." : "Run group") { runGroup() }
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(hex: "#854F0B"))
                        .disabled(running)
                }

                if !items.isEmpty {
                    VStack(spacing: 8) {
                        ForEach(items, id: \.id) { item in
                            taskGroupRow(item)
                        }
                    }

                    if finishedCount > 0 {
                        Text("Completed in arrival order, not submission order")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(hex: "#854F0B"))
                            .padding(.top, 4)
                    }
                } else {
                    Text("Tap 'Run group' to spawn tasks")
                        .font(.system(size: 13))
                        .foregroundStyle(.tertiary)
                        .frame(maxWidth: .infinity, minHeight: 60, alignment: .center)
                }
            }
        }
    }

    func taskGroupRow(_ item: (id: Int, label: String, color: Color, progress: CGFloat, done: Bool, orderFinished: Int?)) -> some View {
        HStack(spacing: 10) {
            Text(item.label)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .trailing)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6).fill(Color(.systemFill)).frame(height: 26)
                    RoundedRectangle(cornerRadius: 6).fill(item.color).frame(width: max(0, geo.size.width * item.progress), height: 26)
                }
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .frame(height: 26)

            if item.done, let order = item.orderFinished {
                ZStack {
                    Circle().fill(Color(hex: "#1D9E75").opacity(0.15)).frame(width: 24, height: 24)
                    Text("#\(order)").font(.system(size: 10, weight: .bold)).foregroundStyle(Color(hex: "#1D9E75"))
                }
                .transition(.scale.combined(with: .opacity))
            } else {
                Circle().fill(Color(.systemFill)).frame(width: 24, height: 24)
            }
        }
    }
    
    @State private var groupTask: Task<Void, Never>? = nil

    func runGroup() {
            groupTask?.cancel()
            groupTask = Task {
                running = true
                finishedCount = 0
                items = taskData.enumerated().map { i, d in
                    (id: i, label: d.0, color: d.1, progress: 0, done: false, orderFinished: nil)
                }
     
                // Spawn a child task per item — mirrors how TaskGroup actually works
                await withTaskGroup(of: (Int, Double).self) { group in
                    for (i, data) in taskData.enumerated() {
                        let duration = data.2
                        group.addTask {
                            await MainActor.run {
                                withAnimation(.linear(duration: duration).delay(0.1)) {
                                    items[i].progress = 1.0
                                }
                            }
                            try? await Task.sleep(for: .seconds(duration + 0.1))
                            return (i, duration)
                        }
                    }
     
                    for await (i, _) in group {
                        guard !Task.isCancelled else { return }
                        finishedCount += 1
                        let order = finishedCount
                        withAnimation(.spring()) {
                            items[i].done = true
                            items[i].orderFinished = order
                        }
                        if finishedCount == taskData.count {
                            running = false
                        }
                    }
                }
            }
        }
}

struct TaskGroupExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "How Task Groups work")
            Text("Task Groups let you spawn a dynamic number of concurrent tasks, and wait for all of them to complete. Useful when you don't know the count at compile time. Results arrive as tasks complete, not in the order they were added.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
            CalloutBox(style: .warning, title: "Completion order, not submission order", contentBody: "The #1 Task Group mistake. If your UI needs ordered results? Like a photo grid or a feed then carry the original index with each result and sort before returning.")
            CalloutBox(style: .success, title: "Use Task Groups when", contentBody: "The number of tasks is determined at runtime. e.g., downloading every image in a list whose size you only know after a network call.")
            CodeBlock(code: """
func downloadImages(urls: [URL]) async throws -> [UIImage] {
    try await withThrowingTaskGroup(of: (Int, UIImage?).self) { group in
        for (index, url) in urls.enumerated() {
            group.addTask {
                let image = try await downloadImage(url)
                return (index, image)   // carry index!
            }
        }
        var results = [(Int, UIImage)]()
        for try await (index, image) in group {
            if let image { results.append((index, image)) }
        }
        return results.sorted { $0.0 < $1.0 }.map { $0.1 }
    }
}
""")
        }
    }
}

#Preview {
    TaskGroupVisual()
}
