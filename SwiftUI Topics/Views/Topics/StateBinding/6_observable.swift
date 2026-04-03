//
//
//  6_observable.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `01/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: @Observable

@Observable
class CounterModel {
    var count = 0
    var label = "Start counting"

    func increment() {
        count += 1
        label = count < 5 ? "Keep going!" : count < 10 ? "Nice work!" : "Legend 🏆"
    }

    func reset() {
        count = 0
        label = "Start counting"
    }
}

@Observable
class TimerModel {
    var seconds = 0
    var isRunning = false
    private var timer: Timer?

    func start() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.seconds += 1
        }
    }

    func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func reset() {
        stop()
        seconds = 0
    }
}

struct ObservableVisual: View {
    @State private var counter = CounterModel()
    @State private var timerModel = TimerModel()

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("@Observable", systemImage: "eye.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.sbOrange)
                    Spacer()
                    Text("iOS 17+")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.sbOrange)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.sbOrangeLight).clipShape(Capsule())
                }

                // Counter model demo
                VStack(spacing: 10) {
                    sectionLabel("CounterModel - @Observable class")
                    ZStack {
                        Color(.secondarySystemBackground)
                        VStack(spacing: 6) {
                            Text("\(counter.count)")
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.sbOrange)
                                .contentTransition(.numericText())
                                .animation(.spring(duration: 0.3), value: counter.count)
                            Text(counter.label)
                                .font(.system(size: 13)).foregroundStyle(.secondary)
                                .animation(.easeInOut(duration: 0.2), value: counter.label)
                        }
                    }
                    .frame(maxWidth: .infinity).frame(height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    HStack(spacing: 10) {
                        Button {
                            counter.increment()
                        } label: {
                            Text("Increment")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 9)
                                .background(Color.sbOrange)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PressableButtonStyle())

                        Button {
                            counter.reset()
                        } label: {
                            Text("Reset")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color.sbOrange)
                                .frame(maxWidth: .infinity).padding(.vertical, 9)
                                .background(Color.sbOrangeLight)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                Divider()

                // Timer model demo
                VStack(spacing: 8) {
                    sectionLabel("TimerModel - multiple views reading same model")
                    HStack(spacing: 12) {
                        // Two separate views reading the same model
                        ObservableTimerDisplay(model: timerModel)
                        ObservableTimerControls(model: timerModel)
                    }
                }
            }
        }
    }

    func sectionLabel(_ text: String) -> some View {
        Text(text).font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
    }
}

struct ObservableTimerDisplay: View {
    var model: TimerModel  // no wrapper needed with @Observable

    var body: some View {
        VStack(spacing: 4) {
            Text(timeString(model.seconds))
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundStyle(model.isRunning ? Color.sbOrange : .secondary)
                .animation(.easeInOut(duration: 0.2), value: model.isRunning)
            Text("Display view")
                .font(.system(size: 9)).foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func timeString(_ s: Int) -> String {
        String(format: "%02d:%02d", s / 60, s % 60)
    }
}

struct ObservableTimerControls: View {
    var model: TimerModel  // same model, no wrapper

    var body: some View {
        VStack(spacing: 6) {
            Button {
                model.isRunning ? model.stop() : model.start()
            } label: {
                Text(model.isRunning ? "Stop" : "Start")
                    .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 7)
                    .background(model.isRunning ? Color.animCoral : Color.sbOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(PressableButtonStyle())

            Button { model.reset() } label: {
                Text("Reset")
                    .font(.system(size: 12)).foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity).padding(.vertical, 6)
                    .background(Color(.systemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(PressableButtonStyle())

            Text("Controls view")
                .font(.system(size: 9)).foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ObservableExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "@Observable - iOS 17+")
            Text("@Observable is Swift's modern observation system. Mark a class with @Observable and any SwiftUI view that reads its properties automatically re-renders when they change - with no @Published, no ObservableObject, no explicit binding setup.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Mark your class with @Observable - that's all the setup needed.", color: .sbOrange)
                StepRow(number: 2, text: "In the view, use @State var model = MyModel() if this view owns it, or var model: MyModel if it's passed in.", color: .sbOrange)
                StepRow(number: 3, text: "No @Published needed - every stored property is automatically observed.", color: .sbOrange)
                StepRow(number: 4, text: "SwiftUI only re-renders views that actually read the changed property - finer granularity than ObservableObject.", color: .sbOrange)
            }

            CalloutBox(style: .success, title: "vs ObservableObject", contentBody: "ObservableObject re-renders ALL views observing the object when ANY @Published property changes. @Observable re-renders only views that read the specific property that changed. Much more efficient.")

            CalloutBox(style: .info, title: "Computed properties work too", contentBody: "If a view reads a computed property on an @Observable class, SwiftUI tracks which stored properties that computed property depends on and re-renders only when those change.")

            CodeBlock(code: """
// Define the model
@Observable
class UserModel {
    var name = ""
    var score = 0
    var level: String { score < 10 ? "Beginner" : "Pro" }
}

// View that OWNS the model
struct RootView: View {
    @State private var user = UserModel()  // creates and owns it

    var body: some View {
        ChildView(user: user)
    }
}

// View that RECEIVES the model
struct ChildView: View {
    var user: UserModel  // no wrapper needed

    var body: some View {
        Text(user.name)   // auto-observed
        Text(user.level)  // computed - tracked automatically
    }
}
""")
        }
    }
}

