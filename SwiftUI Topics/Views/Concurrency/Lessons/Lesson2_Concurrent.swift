//
//
//  Lesson2_Concurrent.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
 
// MARK: - Visual
struct ConcurrentVisual: View {
    private let totalSeconds: CGFloat = 2.2
    private let labelWidth:   CGFloat = 96
    private let barHeight:    CGFloat = 28
 
    private let rows: [(label: String, duration: CGFloat, color: Color, textColor: Color, timeLabel: String)] = [
        ("fetchProfile",   1.0, Color(hex: "#B5D4F4"), Color(hex: "#0C447C"), "1s"),
        ("fetchPosts",     2.0, Color(hex: "#9FE1CB"), Color(hex: "#085041"), "2s"),
        ("fetchFollowers", 1.5, Color(hex: "#FAC775"), Color(hex: "#633806"), "1.5s"),
    ]
 
    @State private var animatedWidths: [CGFloat]          = [0, 0, 0]
    @State private var done:           [Bool]             = [false, false, false]
    @State private var showTotal                          = false
    @State private var trackW: CGFloat                    = 0
    @State private var replayTask: Task<Void, Never>?     = nil
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("Concurrent", systemImage: "arrow.triangle.branch")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#0F6E56"))
                    Spacer()
                    Button("Replay") { replay() }
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(hex: "#0F6E56"))
                }
 
                GeometryReader { geo in
                    let tw       = geo.size.width - labelWidth - 10
                    let pxPerSec = tw / totalSeconds
 
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
 
                        // Total bar — exactly 2s wide, lines up with 2s tick
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
                                        .fill(Color(hex: "#1D9E75").opacity(0.7))
                                        .frame(width: 2.0 * pxPerSec, height: 22)
                                        .transition(.opacity)
 
                                    Text("2s — slowest task")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundStyle(Color(hex: "#085041"))
                                        .padding(.leading, 8)
                                        .transition(.opacity)
                                }
                            }
                            .frame(width: tw)
                        }
 
                        // Tick marks — hardcoded, pixel-exact
                        HStack(spacing: 0) {
                            Spacer().frame(width: labelWidth + 10)
                            ZStack(alignment: .leading) {
                                Text("0s").font(.system(size: 10)).foregroundStyle(.tertiary)
                                    .offset(x: 0)
                                Text("1s").font(.system(size: 10)).foregroundStyle(.tertiary)
                                    .offset(x: 1.0 * pxPerSec - 6)
                                Text("2s").font(.system(size: 10)).foregroundStyle(.tertiary)
                                    .offset(x: 2.0 * pxPerSec - 6)
                            }
                            .frame(width: tw, height: 16, alignment: .leading)
                        }
                    }
                    .onAppear {
                        trackW = tw
                        DispatchQueue.main.async { replay() }
                    }
                }
                .frame(height: 210)
            }
        }
    }
 
    func replay() {
        replayTask?.cancel()
        replayTask = Task {
            guard trackW > 0 else { return }
            animatedWidths = [0, 0, 0]
            done           = [false, false, false]
            showTotal      = false
            let pxPerSec   = trackW / totalSeconds
 
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
// MARK: - Explanation
struct ConcurrentExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "How it works")
            Text("Concurrent tasks all start at the same moment. They overlap in time, so the total wait is only as long as the slowest single task, not the sum of all of them.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "All three requests fire simultaneously at t=0.", color: Color(hex: "#0F6E56"))
                StepRow(number: 2, text: "fetchProfile finishes first at 1s.", color: Color(hex: "#185FA5"))
                StepRow(number: 3, text: "fetchFollowers finishes at 1.5s.", color: Color(hex: "#854F0B"))
                StepRow(number: 4, text: "fetchPosts is the slowest, at 2s everything is done.", color: Color(hex: "#0F6E56"))
            }

            CalloutBox(style: .success, title: "Total: 2 seconds", content: "2s instead of 4.5s; a 55% reduction. None of the requests depended on each other, so there was no reason to wait.")

            CodeBlock(code: """
// async let — all three start immediately
async let profile   = fetchProfile()
async let posts     = fetchPosts()
async let followers = fetchFollowers()

// Await all three at once
let (p, po, f) = try await (profile, posts, followers)
""")
        }
    }
}


#Preview {
    ConcurrentVisual()
}
