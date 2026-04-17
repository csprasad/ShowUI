//
//
//  10_Timer&Notifications.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `17/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine

// MARK: - LESSON 10: Timer & Notifications
struct CBTimerNotifVisual: View {
    @State private var selectedDemo  = 0
    @State private var timerCount    = 0
    @State private var timerRunning  = false
    @State private var timerCancellable: AnyCancellable?
    @State private var cancellables  = Set<AnyCancellable>()
    @State private var interval: Double = 1.0
    let demos = ["Timer.publish", "NotificationCenter", "Keyboard & lifecycle"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Timer & notifications", systemImage: "timer")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cbOrange)

                tabSelector(demos: demos, selected: $selectedDemo)

                switch selectedDemo {
                case 0: timerView
                case 1: notificationView
                default: keyboardLifecycleView
                }
            }
        }
    }

    var timerView: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text("Interval:").font(.system(size: 12)).foregroundStyle(.secondary)
                Slider(value: $interval, in: 0.25...3, step: 0.25).tint(.cbOrange)
                    .onChange(of: interval) { _, _ in
                        if timerRunning { stopTimer(); startTimer() }
                    }
                Text("\(interval, specifier: "%.2f")s").font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.cbOrange).frame(width: 44)
            }

            HStack(spacing: 16) {
                Text("\(timerCount)")
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
                    .foregroundStyle(timerRunning ? .cbOrange : Color(.systemGray3))
                    .frame(width: 72)
                    .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: timerCount)

                VStack(spacing: 6) {
                    Button(timerRunning ? "❚❚ Stop" : "▶ Start") {
                        timerRunning ? stopTimer() : startTimer()
                    }
                    .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 10)
                    .background(timerRunning ? Color.animCoral : Color.cbOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .buttonStyle(PressableButtonStyle())

                    Button("Reset") {
                        stopTimer(); withAnimation { timerCount = 0 }
                    }
                    .font(.system(size: 11)).foregroundStyle(Color.cbOrange)
                    .frame(maxWidth: .infinity).padding(.vertical, 7)
                    .background(Color.cbOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    .buttonStyle(PressableButtonStyle())
                }
            }
            .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "// Timer.publish - fires on interval\nlet timer = Timer.publish(\n    every: 1.0, on: .main, in: .common\n).autoconnect()\n\n// In view:\nText(\"\\(count)\")\n    .onReceive(timer) { _ in count += 1 }\n\n// Store and cancel later:\ntimer.sink { _ in count += 1 }\n    .store(in: &cancellables)")
        }
    }

    var notificationView: some View {
        VStack(spacing: 8) {
            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: """
// NotificationCenter publisher
NotificationCenter.default
    .publisher(for: UIApplication.didBecomeActiveNotification)
    .sink { _ in refreshData() }
    .store(in: &cancellables)

// Custom notification
extension Notification.Name {
    static let userDidLogout = Notification.Name("userDidLogout")
}
NotificationCenter.default
    .publisher(for: .userDidLogout)
    .sink { notification in
        // notification.object - the sender
        // notification.userInfo - extra data
        clearSession()
    }
    .store(in: &cancellables)

// Post a notification (imperative side)
NotificationCenter.default.post(name: .userDidLogout, object: nil)
""")

            VStack(spacing: 6) {
                notifRow("UIApplication.didBecomeActive", "App returned to foreground")
                notifRow("UIApplication.willResignActive", "App going to background")
                notifRow("UIDevice.orientationDidChange", "Device rotated")
                notifRow("UIResponder.keyboardWillShow", "Keyboard about to appear")
                notifRow("NSManagedObjectContextDidSave", "CoreData/SwiftData saved")
            }
        }
    }

    var keyboardLifecycleView: some View {
        VStack(spacing: 8) {
            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: """
// Keyboard height publisher
let keyboardPublisher = NotificationCenter.default
    .publisher(for: UIResponder.keyboardWillShowNotification)
    .merge(with: NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification))
    .compactMap { notification -> CGFloat? in
        guard let frame = notification.userInfo?[
            UIResponder.keyboardFrameEndUserInfoKey
        ] as? CGRect else { return nil }
        let isShowing = notification.name ==
            UIResponder.keyboardWillShowNotification
        return isShowing ? frame.height : 0
    }
    .removeDuplicates()

// Scene phase
@Environment(\\.scenePhase) var scenePhase
.onChange(of: scenePhase) { _, phase in
    if phase == .active { refreshData() }
}

// App lifecycle via NotificationCenter
NotificationCenter.default
    .publisher(for: UIApplication.didEnterBackgroundNotification)
    .sink { _ in saveState() }
    .store(in: &cancellables)
""")
        }
    }

    func startTimer() {
        timerRunning = true
        timerCancellable = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect().sink { _ in withAnimation { timerCount += 1 } }
    }

    func stopTimer() {
        timerRunning = false
        timerCancellable?.cancel(); timerCancellable = nil
    }

    func notifRow(_ name: String, _ desc: String) -> some View {
        HStack(spacing: 8) {
            Text(name).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.cbOrange).frame(width: 160, alignment: .leading)
            Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(6).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 6))
    }

    func tabSelector(demos: [String], selected: Binding<Int>) -> some View {
        HStack(spacing: 8) {
            ForEach(demos.indices, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.3)) { selected.wrappedValue = i; stopTimer() }
                } label: {
                    Text(demos[i])
                        .font(.system(size: 11, weight: selected.wrappedValue == i ? .semibold : .regular))
                        .foregroundStyle(selected.wrappedValue == i ? Color.cbOrange : .secondary)
                        .frame(maxWidth: .infinity).padding(.vertical, 7)
                        .background(selected.wrappedValue == i ? Color.cbOrangeLight : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
    }
}

struct CBTimerNotifExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Timer and NotificationCenter publishers")
            Text("Timer.publish creates a metronomic publisher. NotificationCenter.publisher bridges system and custom notifications into the reactive world. Both integrate cleanly with .onReceive in SwiftUI views.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Timer.publish(every:on:in:).autoconnect() - fires on every interval. autoconnect() skips manual .connect().", color: .cbOrange)
                StepRow(number: 2, text: "NotificationCenter.default.publisher(for: notifName) - publisher for any Foundation notification.", color: .cbOrange)
                StepRow(number: 3, text: ".compactMap - extract typed values from notification.userInfo dictionaries.", color: .cbOrange)
                StepRow(number: 4, text: ".onReceive(timer) { _ in } - view modifier version. Auto-cancels when view disappears.", color: .cbOrange)
                StepRow(number: 5, text: "Keyboard height: observe keyboardWillShow + keyboardWillHide, merge, compactMap height.", color: .cbOrange)
            }

            CodeBlock(code: """
// Timer - 1s tick
let timer = Timer.publish(every: 1, on: .main, in: .common)
    .autoconnect()

Text("\\(elapsed)s")
    .onReceive(timer) { _ in elapsed += 1 }

// Notification from system
NotificationCenter.default
    .publisher(for: UIApplication.didBecomeActiveNotification)
    .sink { _ in checkForUpdates() }
    .store(in: &cancellables)

// Keyboard height
NotificationCenter.default
    .publisher(for: UIResponder.keyboardWillShowNotification)
    .compactMap { notif in
        (notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? CGRect)?.height
    }
    .assign(to: &$keyboardHeight)
""")
        }
    }
}
