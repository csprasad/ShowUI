//
//
//  Lesson5_AsyncLet.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 5: async let
 
struct AsyncLetVisual: View {
    private let totalSeconds: CGFloat = 2.2
    private let labelWidth:   CGFloat = 96
    private let barHeight:    CGFloat = 28
 
    private let rows: [(label: String, duration: CGFloat, color: Color, textColor: Color, timeLabel: String)] = [
        ("fetchProfile",   1.0, Color(hex: "#B5D4F4"), Color(hex: "#0C447C"), "1s"),
        ("fetchPosts",     2.0, Color(hex: "#9FE1CB"), Color(hex: "#085041"), "2s"),
        ("fetchFollowers", 1.5, Color(hex: "#FAC775"), Color(hex: "#633806"), "1.5s"),
    ]
 
    @State private var animatedWidths: [CGFloat] = [0, 0, 0]
    @State private var done:           [Bool]    = [false, false, false]
    @State private var showTotal                 = false
    @State private var replayTask: Task<Void, Never>? = nil
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("async let", systemImage: "bolt.horizontal.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#3B6D11"))
                    Spacer()
                    Button("Replay") { replay() }
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(hex: "#3B6D11"))
                }
 
                Text("All three tasks fire at t = 0")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
 
                GeometryReader { geo in
                    let tw = max(0, geo.size.width - labelWidth - 10)
                    let pxPerSec = tw > 0 ? tw / totalSeconds : 1
 
                    VStack(spacing: 8) {
                        ForEach(rows.indices, id: \.self) { i in
                            let row = rows[i]
                            HStack(spacing: 10) {
                                Text(row.label)
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundStyle(.secondary)
                                    .frame(width: labelWidth, alignment: .trailing)
 
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(.systemFill))
                                        .frame(width: tw, height: barHeight)
 
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(row.color)
                                        .frame(width: animatedWidths[i], height: barHeight)
 
                                    if animatedWidths[i] > 28 {
                                        Text(row.timeLabel)
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundStyle(row.textColor)
                                            .padding(.leading, 8)
                                            .transition(.opacity)
                                    }
 
                                    if done[i] {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 13))
                                            .foregroundStyle(row.textColor)
                                            .offset(x: animatedWidths[i] - 20)
                                            .transition(.scale.combined(with: .opacity))
                                    }
                                }
                                .frame(width: tw)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
 
                        Divider().padding(.vertical, 2)
 
                        // Total bar - exactly 2s wide, lines up with 2s tick
                        HStack(spacing: 10) {
                            Text("Total")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(.secondary)
                                .frame(width: labelWidth, alignment: .trailing)
 
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(.systemFill))
                                    .frame(width: tw, height: 22)
 
                                if showTotal {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(hex: "#1D9E75").opacity(0.8))
                                        .frame(width: 2.0 * pxPerSec, height: 22)
                                        .transition(.opacity)
 
                                    Text("2s - slowest task")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundStyle(Color(hex: "#085041"))
                                        .padding(.leading, 8)
                                        .transition(.opacity)
                                }
                            }
                            .frame(width: tw)
                        }
 
                        // Tick marks - pixel-exact at 0, 1, 2s
                        HStack(spacing: 0) {
                            Spacer().frame(width: labelWidth + 10)
                            ZStack(alignment: .leading) {
                                ForEach([0, 1, 2], id: \.self) { sec in
                                    Text("\(Int(sec))s")
                                        .font(.system(size: 10))
                                        .foregroundStyle(.tertiary)
                                        .offset(x: sec * pxPerSec - 6)
                                }
                            }
                            .frame(width: tw, height: 16, alignment: .leading)
                        }
                    }
                    .onAppear {
                        guard tw > 0 else { return }
                        DispatchQueue.main.async { replay(trackWidth: tw) }
                    }
                }
                .frame(height: 210)
            }
        }
    }
 
    func replay(trackWidth: CGFloat = 0) {
        replayTask?.cancel()
        replayTask = Task {
            animatedWidths = [0, 0, 0]
            done           = [false, false, false]
            showTotal      = false
            let pxPerSec   = trackWidth / totalSeconds

            // All bars fire simultaneously
            withAnimation(.linear(duration: 1.2).delay(0.2)) { animatedWidths[0] = 1.0 * pxPerSec }
            withAnimation(.linear(duration: 1.8).delay(0.2)) { animatedWidths[2] = 1.5 * pxPerSec }
            withAnimation(.linear(duration: 2.4).delay(0.2)) { animatedWidths[1] = 2.0 * pxPerSec }

            try? await Task.sleep(for: .seconds(1.4))
            guard !Task.isCancelled else { return }
            withAnimation(.spring()) { done[0] = true }

            try? await Task.sleep(for: .seconds(0.6))
            guard !Task.isCancelled else { return }
            withAnimation(.spring()) { done[2] = true }

            try? await Task.sleep(for: .seconds(0.6))
            guard !Task.isCancelled else { return }
            withAnimation(.spring()) { done[1] = true }
            withAnimation(.easeIn(duration: 0.4)) { showTotal = true }
        }
    }
}

struct AsyncLetExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "How async let works")
            Text("async let declares a child task immediately without waiting. The task starts running in the background. When you await the result, Swift waits only at that point, by which time the task may already be finished.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
            VStack(spacing: 12) {
                StepRow(number: 1, text: "All three async let lines execute instantly, with no waiting.", color: Color(hex: "#3B6D11"))
                StepRow(number: 2, text: "The await line is where execution pauses until all three are done.", color: Color(hex: "#3B6D11"))
                StepRow(number: 3, text: "Note the tuple destructuring on the left, this is the correct Swift syntax.", color: Color(hex: "#3B6D11"))
            }
            CalloutBox(style: .success, title: "Use async let when", contentBody: "You have a fixed, known set of independent async tasks. If the count is dynamic, use a TaskGroup instead.")
            CodeBlock(code: """
async let profile   = fetchProfile()
async let posts     = fetchPosts()
async let followers = fetchFollowers()

// Destructure - this is the correct syntax
let (p, po, f) = try await (profile, posts, followers)
""")
        }
    }
}

#Preview {
    AsyncLetVisual()
}
