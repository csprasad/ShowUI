//
//
//  Lesson1_Sequential.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Visual
struct SequentialVisual: View {
    // Each task: (label, duration in seconds, start offset in seconds, color, textColor)
    // Total = 4.5s. Track represents 4.5s.
    // Pixel mapping: 1s = trackWidth / 4.5
    private let totalSeconds: CGFloat = 4.5
    private let labelWidth: CGFloat   = 96
    private let barHeight: CGFloat    = 28
    
    private let rows: [(label: String, start: CGFloat, duration: CGFloat, color: Color, textColor: Color, timeLabel: String)] = [
        ("fetchProfile",   0.0, 1.0, Color(hex: "#B5D4F4"), Color(hex: "#0C447C"), "1s"),
        ("fetchPosts",     1.0, 2.0, Color(hex: "#9FE1CB"), Color(hex: "#085041"), "2s"),
        ("fetchFollowers", 3.0, 1.5, Color(hex: "#FAC775"), Color(hex: "#633806"), "1.5s"),
    ]
    
    @State private var animatedWidths: [CGFloat] = [0, 0, 0]
    @State private var done:           [Bool]    = [false, false, false]
    @State private var showTotal = false
    @State private var trackW: CGFloat = 0
    @State private var replayTask: Task<Void, Never>? = nil
    
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("Sequential", systemImage: "arrow.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#185FA5"))
                    Spacer()
                    Button("Replay") { replay() }
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(hex: "#185FA5"))
                }
                
                GeometryReader { geo in
                    let tw = geo.size.width - labelWidth - 10
                    let pxPerSec = tw / totalSeconds
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        // Task bars
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
                                        .offset(x: row.start * pxPerSec)
                                    
                                    if animatedWidths[i] > 24 {
                                        Text(row.timeLabel)
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundStyle(row.textColor)
                                            .offset(x: row.start * pxPerSec + animatedWidths[i] / 2 - 10)
                                            .transition(.opacity)
                                    }
                                }
                                .frame(width: tw)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
                        
                        Divider().padding(.vertical, 2)
                        
                        // Total bar
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
                                        .fill(Color(hex: "#E24B4A").opacity(0.75))
                                        .frame(width: tw, height: 22)
                                        .transition(.opacity)
                                    
                                    Text("4.5s total")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundStyle(Color(hex: "#791F1F"))
                                        .padding(.leading, 8)
                                        .transition(.opacity)
                                }
                            }
                            .frame(width: tw)
                        }
                        
                        // Tick marks: absolute pixel offsets matching pxPerSec
                        HStack(spacing: 0) {
                            Spacer().frame(width: labelWidth + 10)
                            ZStack(alignment: .leading) {
                                ForEach(0...4, id: \.self) { sec in
                                    Text("\(sec)s")
                                        .font(.system(size: 10))
                                        .foregroundStyle(.tertiary)
                                        .offset(x: CGFloat(sec) * pxPerSec - 6)
                                }
                            }
                            .frame(width: tw, height: 16, alignment: .leading)
                        }
                    }
                    .onAppear {
                        trackW = tw
                        DispatchQueue.main.async { replay() }
                    }
                }
                .frame(height: 220)
            }
        }
    }
    
    func replay() {
        guard trackW > 0 else { return }
        replayTask?.cancel()
        replayTask = Task {
            animatedWidths = [0, 0, 0]
            showTotal      = false
            let pxPerSec   = trackW / totalSeconds
 
            // All three start with staggered SwiftUI delays
            withAnimation(.linear(duration: 1.2).delay(0.2)) { animatedWidths[0] = rows[0].duration * pxPerSec }
            withAnimation(.linear(duration: 2.4).delay(1.4)) { animatedWidths[1] = rows[1].duration * pxPerSec }
            withAnimation(.linear(duration: 1.8).delay(3.8)) { animatedWidths[2] = rows[2].duration * pxPerSec }
 
            try? await Task.sleep(for: .seconds(6.2))
            guard !Task.isCancelled else { return }
            withAnimation(.easeIn(duration: 0.4)) { showTotal = true }
        }
    }
    
    
}

// MARK: - Explanation
struct SequentialExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "How it works")
            Text("In sequential execution, each task must fully complete before the next one starts. Think of it like a single checkout lane, where the queue moves one person at a time.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(4)
            
            VStack(spacing: 12) {
                StepRow(number: 1, text: "fetchProfile starts and takes 1 second to complete.", color: Color(hex: "#185FA5"))
                StepRow(number: 2, text: "Only after profile finishes does fetchPosts begin, which takes 2 more seconds.", color: Color(hex: "#0F6E56"))
                StepRow(number: 3, text: "Finally fetchFollowers runs for 1.5 seconds.", color: Color(hex: "#854F0B"))
            }
            
            CalloutBox(style: .danger, title: "Total: 4.5 seconds", content: "You're wasting time. None of these requests depend on each other, so there's no reason to wait.")
            
            CodeBlock(code: """
// Sequential — each line waits for the one above
let profile   = try await fetchProfile()
let posts     = try await fetchPosts()
let followers = try await fetchFollowers()
""")
        }
    }
}


#Preview {
    SequentialVisual()
}
