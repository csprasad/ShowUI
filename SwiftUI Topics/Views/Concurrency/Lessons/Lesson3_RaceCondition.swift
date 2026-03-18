//
//
//  Lesson3_RaceCondition.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Visual
struct RaceConditionVisual: View {
    @State private var phase = 0
    @State private var balance = 100
    @State private var balanceColor = Color(hex: "#185FA5")
    @State private var taskARead: Int? = nil
    @State private var taskBRead: Int? = nil
    @State private var progressA: CGFloat = 0
    @State private var progressB: CGFloat = 0
    @State private var showCollision = false
    @State private var shaking = false

    let steps = [
        "Tap to start the simulation",
        "Task A reads balance: 100",
        "Task B also reads balance: 100 — same stale value!",
        "Task B writes 70 (100 − 30)",
        "Task A writes 50 (100 − 50) — overwrites Task B!",
        "Data lost. User withdrew 80 but balance only dropped 50."
    ]

    var body: some View {
        VisualCard {
            VStack(spacing: 16) {
                HStack {
                    Label("Race Condition", systemImage: "exclamationmark.triangle.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#A32D2D"))
                    Spacer()
                    Button("Reset") { reset() }
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(hex: "#A32D2D"))
                }

                // Balance display
                VStack(spacing: 4) {
                    Text("balance")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)
                    Text("$\(balance)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(balanceColor)
                        .offset(x: shaking ? -4 : 0)
                        .animation(.default.repeatCount(5, autoreverses: true).speed(8), value: shaking)
                }
                .padding(.vertical, 8)

                // Task lanes
                VStack(spacing: 10) {
                    taskLane(label: "Task A", detail: "withdraw(50)", color: Color(hex: "#B5D4F4"), textColor: Color(hex: "#0C447C"), readValue: taskARead, progress: progressA)
                    taskLane(label: "Task B", detail: "withdraw(30)", color: Color(hex: "#9FE1CB"), textColor: Color(hex: "#085041"), readValue: taskBRead, progress: progressB)
                }

                // Collision indicator
                if showCollision {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color(hex: "#E24B4A"))
                        Text("Task A overwrote Task B's result")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color(hex: "#A32D2D"))
                    }
                    .padding(10)
                    .background(Color(hex: "#FCEBEB"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .transition(.scale.combined(with: .opacity))
                }

                // Step indicator
                Text(steps[min(phase, steps.count - 1)])
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)

                // Step button
                Button(phase == 0 ? "Start simulation" : phase < 5 ? "Next step →" : "Reset") {
                    if phase == 5 { reset() } else { nextStep() }
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(phase == 5 ? Color(hex: "#E24B4A") : Color(hex: "#185FA5"))
                .clipShape(Capsule())
            }
        }
    }

    func taskLane(label: String, detail: String, color: Color, textColor: Color, readValue: Int?, progress: CGFloat) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .trailing, spacing: 2) {
                Text(label)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(textColor)
                Text(detail)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 80, alignment: .trailing)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8).fill(Color(.systemFill)).frame(height: 32)
                    RoundedRectangle(cornerRadius: 8).fill(color).frame(width: max(0, geo.size.width * progress), height: 32)

                    if let v = readValue {
                        Text("read: \(v)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(textColor)
                            .padding(.leading, 10)
                            .transition(.opacity)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .frame(height: 32)

            ZStack {
                Circle().fill(color.opacity(0.4)).frame(width: 32, height: 32)
                if let v = readValue {
                    Text("\(v)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(textColor)
                        .transition(.scale)
                }
            }
        }
    }

    func nextStep() {
        phase += 1
        switch phase {
        case 1:
            withAnimation(.linear(duration: 0.6)) { progressA = 0.5 }
            withAnimation { taskARead = 100 }
        case 2:
            withAnimation(.linear(duration: 0.6)) { progressB = 0.5 }
            withAnimation { taskBRead = 100 }
        case 3:
            balance = 70
            withAnimation(.linear(duration: 0.4)) { progressB = 1.0 }
            withAnimation { balanceColor = Color(hex: "#0F6E56") }
        case 4:
            balance = 50
            withAnimation(.linear(duration: 0.4)) { progressA = 1.0 }
            withAnimation { balanceColor = Color(hex: "#E24B4A") }
            shaking = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { shaking = false }
        case 5:
            withAnimation(.spring()) { showCollision = true }
        default: break
        }
    }

    func reset() {
        withAnimation {
            phase = 0; balance = 100; balanceColor = Color(hex: "#185FA5")
            taskARead = nil; taskBRead = nil; progressA = 0; progressB = 0
            showCollision = false; shaking = false
        }
    }
}

// MARK: - Explanation
struct RaceConditionExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "What went wrong")
            Text("Both tasks read the balance before either had a chance to write. So they both saw 100, calculated from that stale value, and the last writer silently erased the first one's work.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Task A reads balance: 100", color: Color(hex: "#185FA5"))
                StepRow(number: 2, text: "Task B reads balance: 100 — neither has written yet", color: Color(hex: "#0F6E56"))
                StepRow(number: 3, text: "Task B writes 70 (100 − 30)", color: Color(hex: "#0F6E56"))
                StepRow(number: 4, text: "Task A writes 50 (100 − 50) — silently overwrites Task B", color: Color(hex: "#A32D2D"))
            }

            CalloutBox(style: .danger, title: "Silent data loss", content: "The user withdrew $80 total. The balance should be $20. But it shows $50. No error was thrown. No crash. The bug is invisible.")

            CalloutBox(style: .info, title: "Why it's hard to catch", content: "This only happens when the timing lines up exactly. It works perfectly in development and fails unpredictably in production, which is why it's called a ghost bug.")

            CodeBlock(code: """
// Dangerous — class is not protected
class BankAccount {
    var balance = 100

    func withdraw(_ amount: Int) {
        balance -= amount  // NOT safe to call from two tasks
    }
}
""")
        }
    }
}

#Preview {
    RaceConditionVisual()
}
