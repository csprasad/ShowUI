//
//
//  Lesson4_Actor.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Visual
struct ActorVisual: View {
    @State private var taskAPosition: CGFloat = 0
    @State private var taskBPosition: CGFloat = 0
    @State private var taskAOnBridge = false
    @State private var taskBWaiting = false
    @State private var taskADone = false
    @State private var taskBOnBridge = false
    @State private var taskBDone = false
    @State private var balance = 100
    @State private var gateColor = Color(hex: "#534AB7")
    @State private var phase = 0
    @State private var logMessages: [String] = []

    var body: some View {
        VisualCard {
            VStack(spacing: 16) {
                HStack {
                    Label("Actor", systemImage: "lock.shield.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "#534AB7"))
                    Spacer()
                    VStack(alignment: .trailing, spacing: 1) {
                        Text("balance").font(.system(size: 10)).foregroundStyle(.secondary)
                        Text("$\(balance)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(balance == 20 ? Color(hex: "#1D9E75") : Color(hex: "#534AB7"))
                            .animation(.spring(), value: balance)
                    }
                }

                // Bridge visual
                GeometryReader { geo in
                    let w = geo.size.width
                    ZStack {
                        // Road
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.secondarySystemBackground))
                            .frame(width: w * 0.7, height: 12)

                        // Pillars
                        RoundedRectangle(cornerRadius: 3).fill(Color(.systemFill)).frame(width: 8, height: 36).offset(x: -w * 0.22)
                        RoundedRectangle(cornerRadius: 3).fill(Color(.systemFill)).frame(width: 8, height: 36).offset(x: w * 0.22)

                        // Actor gate
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(gateColor.opacity(0.15))
                                .frame(width: 44, height: 32)
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(gateColor, lineWidth: 1.5)
                                .frame(width: 44, height: 32)
                            Text("actor")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(gateColor)
                        }

                        // Task A dot
                        taskDot(label: "A", color: Color(hex: "#B5D4F4"), textColor: Color(hex: "#0C447C"), opacity: taskADone ? 0.2 : 1.0)
                            .offset(x: -w * 0.42 + taskAPosition * w * 0.84)

                        // Task B dot
                        taskDot(label: "B", color: Color(hex: "#9FE1CB"), textColor: Color(hex: "#085041"), opacity: taskBDone ? 0.2 : 1.0)
                            .offset(x: -w * 0.42 + taskBPosition * w * 0.84)

                        // Wait indicator
                        if taskBWaiting && !taskBOnBridge {
                            Text("waiting...")
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                                .offset(x: -w * 0.28, y: 22)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 60)

                // Log
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(logMessages.enumerated()), id: \.offset) { _, msg in
                        Text(msg)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 60, alignment: .topLeading)
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))

                Button(phase == 0 ? "Simulate actor" : phase < 6 ? "Next →" : "Replay") {
                    if phase == 6 { reset() } else { nextStep() }
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(Color(hex: "534AB7"))
                .clipShape(Capsule())
            }
        }
    }

    func taskDot(label: String, color: Color, textColor: Color, opacity: Double) -> some View {
        ZStack {
            Circle().fill(color).frame(width: 30, height: 30)
            Text(label).font(.system(size: 12, weight: .bold)).foregroundStyle(textColor)
        }
        .opacity(opacity)
    }

    func addLog(_ msg: String) {
        withAnimation(.easeIn(duration: 0.2)) { logMessages.append(msg) }
    }

    func nextStep() {
        phase += 1
        switch phase {
        case 1:
            withAnimation { gateColor = Color(hex: "#E24B4A") }
            withAnimation(.easeInOut(duration: 0.8)) { taskAPosition = 0.5 }
            addLog("→ Task A enters actor. Gate locked.")
        case 2:
            taskBWaiting = true
            addLog("→ Task B tries to enter... blocked. Waiting.")
        case 3:
            balance = 50
            addLog("→ Task A withdraws $50. balance = $50")
        case 4:
            withAnimation(.easeInOut(duration: 0.6)) { taskAPosition = 1.0; taskADone = true }
            withAnimation { gateColor = Color(hex: "#534AB7") }
            addLog("→ Task A exits. Gate unlocked.")
        case 5:
            taskBWaiting = false; taskBOnBridge = true
            withAnimation(.easeInOut(duration: 0.8)) { taskBPosition = 0.5 }
            withAnimation { gateColor = Color(hex: "#E24B4A") }
            addLog("→ Task B enters actor. Gate locked again.")
        case 6:
            balance = 20
            withAnimation(.easeInOut(duration: 0.6)) { taskBPosition = 1.0; taskBDone = true }
            withAnimation { gateColor = Color(hex: "#1D9E75") }
            addLog("→ Task B withdraws $30. balance = $20. Done.")
        default: break
        }
    }

    func reset() {
        withAnimation {
            phase = 0; taskAPosition = 0; taskBPosition = 0
            taskAOnBridge = false; taskBWaiting = false; taskADone = false
            taskBOnBridge = false; taskBDone = false; balance = 100
            gateColor = Color(hex: "534AB7"); logMessages = []
        }
    }
}

// MARK: - Explanation
struct ActorExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "How actors work")
            Text("An actor is a single-lane bridge. Only one task can be inside at a time. Others wait at the gate. This means the read-then-write problem can never happen, because there's no gap between the read and the write.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Task A enters the actor. The gate locks automatically.", color: Color(hex: "#534AB7"))
                StepRow(number: 2, text: "Task B arrives and sees the gate locked, so it waits.", color: Color(hex: "#534AB7"))
                StepRow(number: 3, text: "Task A reads, calculates, and writes the new balance. No interruption possible.", color: Color(hex: "#534AB7"))
                StepRow(number: 4, text: "Task A exits. The gate unlocks. Task B enters and does the same.", color: Color(hex: "#534AB7"))
            }

            CalloutBox(style: .success, title: "Always correct", contentBody: "The final balance is always $20, no matter how many tasks try to access it simultaneously. The actor guarantees it.")

            CalloutBox(style: .warning, title: "Actor reentrancy", contentBody: "If your actor method contains an await, another task can enter while the first is suspended. Always complete your read + write in a single non-suspending step.")

            CodeBlock(code: """
actor BankAccount {
    private var balance = 100

    func withdraw(_ amount: Int) {
        guard balance >= amount else { return }
        balance -= amount  // read + write > no await between them
    }
}

// Usage
let account = BankAccount()
await account.withdraw(50)  // safe from any task
""")
        }
    }
}

#Preview {
    ActorVisual()
}
