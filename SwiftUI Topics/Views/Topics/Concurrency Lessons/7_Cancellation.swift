//
//
//  Lessons5to8.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Cancellation

struct CancellationVisual: View {
    @State private var items: [ItemState] = (0..<8).map { ItemState(id: $0) }
    @State private var running = false
    @State private var cancelled = false
    @State private var currentItem = -1

    struct ItemState: Identifiable {
        let id: Int
        var state: CellState = .pending
        enum CellState { case pending, processing, done, cancelled }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("Cancellation", systemImage: "stop.circle.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#993C1D"))
                    Spacer()
                    if running {
                        Button("Cancel task") { triggerCancel() }
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#E24B4A"))
                            .clipShape(Capsule())
                    }
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                    ForEach(items) { item in
                        itemCell(item)
                    }
                }

                HStack(spacing: 16) {
                    legendDot(color: Color(.systemFill), label: "Pending")
                    legendDot(color: Color(hex: "#FAC775"), label: "Processing")
                    legendDot(color: Color(hex: "#9FE1CB"), label: "Done")
                    legendDot(color: Color(hex: "#F09595"), label: "Cancelled")
                }
                .font(.system(size: 11))
                .foregroundStyle(.secondary)

                Button(running ? "Running..." : "Start processing") { startProcessing() }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(running ? Color(.systemFill) : Color(hex: "#993C1D"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .disabled(running)
            }
        }
    }

    func itemCell(_ item: ItemState) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(cellColor(item.state))
                .frame(height: 44)
            VStack(spacing: 2) {
                Image(systemName: cellIcon(item.state))
                    .font(.system(size: 14))
                    .foregroundStyle(cellTextColor(item.state))
                Text("item_\(item.id)")
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(cellTextColor(item.state).opacity(0.8))
            }
        }
        .animation(.spring(duration: 0.3), value: item.state)
    }

    func legendDot(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label)
        }
    }

    func cellColor(_ state: ItemState.CellState) -> Color {
        switch state {
        case .pending: return Color(.systemFill)
        case .processing: return Color(hex: "#FAEEDA")
        case .done: return Color(hex: "#E1F5EE")
        case .cancelled: return Color(hex: "#FCEBEB")
        }
    }

    func cellTextColor(_ state: ItemState.CellState) -> Color {
        switch state {
        case .pending: return .secondary
        case .processing: return Color(hex: "#854F0B")
        case .done: return Color(hex: "#0F6E56")
        case .cancelled: return Color(hex: "#A32D2D")
        }
    }

    func cellIcon(_ state: ItemState.CellState) -> String {
        switch state {
        case .pending: return "circle"
        case .processing: return "arrow.clockwise"
        case .done: return "checkmark.circle.fill"
        case .cancelled: return "xmark.circle.fill"
        }
    }

    func startProcessing() {
        running = true; cancelled = false
        items = (0..<8).map { ItemState(id: $0) }
        processNext(index: 0)
    }

    func processNext(index: Int) {
        guard index < items.count, !cancelled else {
            if cancelled {
                for i in index..<items.count {
                    withAnimation(.spring().delay(Double(i - index) * 0.05)) {
                        items[i].state = .cancelled
                    }
                }
            }
            running = false
            return
        }
        withAnimation(.spring()) { items[index].state = .processing }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if cancelled {
                withAnimation(.spring()) { items[index].state = .cancelled }
                for i in (index+1)..<items.count {
                    withAnimation(.spring().delay(Double(i - index) * 0.05)) { items[i].state = .cancelled }
                }
                running = false
                return
            }
            withAnimation(.spring()) { items[index].state = .done }
            processNext(index: index + 1)
        }
    }

    func triggerCancel() {
        cancelled = true
    }
}

struct CancellationExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "How cancellation works")
            Text("Cancellation in Swift is cooperative. A task doesn't just stop, it must check if it's still needed. This gives the task a chance to clean up before exiting.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
            VStack(spacing: 12) {
                StepRow(number: 1, text: "The common case, poll before each unit of work.", color: Color(hex: "#993C1D"))
                StepRow(number: 2, text: "URLSession handles this for you, so cancelling the parent task cancels all child requests automatically.", color: Color(hex: "#993C1D"))
                StepRow(number: 3, text: "For custom long-running work, use withTaskCancellationHandler to react immediately mid-suspension.", color: Color(hex: "#993C1D"))
            }
            CalloutBox(style: .info, title: "Polling - the common case", contentBody: "Check before each unit of work. If cancelled, CancellationError is thrown and the task unwinds cleanly.")
            CodeBlock(code: """
for item in items {
    try Task.checkCancellation()
    await process(item)
}
""")
            CalloutBox(style: .warning, title: "Advanced - react mid-suspension", contentBody: "checkCancellation only fires when execution reaches that line. If your task is suspended inside a long call, use withTaskCancellationHandler.")
            CodeBlock(code: """
await withTaskCancellationHandler {
    await doLongRunningWork()
} onCancel: {
    cleanUpResources()
}
""")
        }
    }
}

#Preview {
    CancellationVisual()
}
