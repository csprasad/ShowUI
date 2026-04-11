//
//
//  5_@Statewith@Observable.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Observation

// MARK: - Models

@Observable
class BindTimerModel {
    var count       = 0
    var isRunning   = false
    private var timer: Timer?

    func start() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.count += 1
        }
    }
    func stop()  { isRunning = false; timer?.invalidate(); timer = nil }
    func reset() { stop(); count = 0 }
    deinit { timer?.invalidate() }
}

@Observable
class AppSettings {
    var accentColor: String = "green"
    var fontSize: Double    = 14
    var isDense: Bool       = false
    var userName: String    = "Alice"

    var color: Color {
        switch accentColor {
        case "green":  return .obsGreen
        case "blue":   return .navBlue
        case "orange": return .scrollOrange
        default:       return .obsGreen
        }
    }
}

@Observable
class NotificationStore {
    var count      = 3
    var messages   = ["Meeting at 3pm", "PR approved", "Deploy done"]
    func dismiss(_ idx: Int) { messages.remove(at: idx); count = messages.count }
    func addNew()  { messages.insert("New notification", at: 0); count = messages.count }
}

// MARK: - LESSON 5: @State with @Observable
struct StateWithObservableVisual: View {
    // @State owns the @Observable model
    @State private var timer    = BindTimerModel()
    @State private var settings = AppSettings()
    @State private var selectedDemo = 0
    let demos = ["Ownership", "Lifetime", "vs @StateObject"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("@State with @Observable", systemImage: "square.and.pencil.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.obsGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; timer.reset() }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.obsGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.obsGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Live timer demo
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .stroke(Color.obsGreen.opacity(0.15), lineWidth: 10)
                                .frame(width: 100, height: 100)
                            Circle()
                                .trim(from: 0, to: min(CGFloat(timer.count) / 60.0, 1))
                                .stroke(Color.obsGreen, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .frame(width: 100, height: 100)
                                .animation(.spring(duration: 0.3), value: timer.count)
                            Text("\(timer.count)")
                                .font(.system(size: 28, weight: .bold, design: .monospaced))
                                .foregroundStyle(Color.obsGreen)
                                .contentTransition(.numericText())
                                .animation(.spring(duration: 0.2), value: timer.count)
                        }
                        .frame(maxWidth: .infinity)

                        HStack(spacing: 8) {
                            Button(timer.isRunning ? "Stop" : "Start") {
                                timer.isRunning ? timer.stop() : timer.start()
                            }
                            .smallObsButton(color: timer.isRunning ? Color.animCoral : Color.obsGreen)
                            Button("Reset") { timer.reset() }
                                .smallObsButton(color: .secondary)
                        }

                        codeChip("@State private var timer = TimerModel()\n// @State owns the model - lives as long as this view")
                    }

                case 1:
                    // Lifetime diagram
                    VStack(spacing: 8) {
                        lifetimeRow("View appears", desc: "@State creates TimerModel()", icon: "play.circle.fill", color: .obsGreen)
                        lifetimeRow("View re-renders", desc: "@State kept alive - model unchanged", icon: "arrow.clockwise.circle.fill", color: .obsEmerald)
                        lifetimeRow("View disappears", desc: "@State deallocated - TimerModel deinit called", icon: "stop.circle.fill", color: .animCoral)
                        lifetimeRow("View reappears", desc: "NEW TimerModel() created from scratch", icon: "arrow.counterclockwise.circle.fill", color: .animAmber)

                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.obsGreen)
                            Text("@State keeps the model alive across re-renders. When the view leaves the hierarchy, @State is deallocated and the model's deinit runs.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // @State vs @StateObject comparison
                    VStack(spacing: 8) {
                        compCell(title: "@State + @Observable (iOS 17+)",
                                 code: "@State private var m = MyModel()",
                                 pros: ["Simpler - no wrapper needed", "Fine-grained tracking per property", "Works with value types too"],
                                 cons: ["iOS 17+ only"])
                        compCell(title: "@StateObject + ObservableObject",
                                 code: "@StateObject private var m = MyModel()",
                                 pros: ["iOS 14+", "Familiar pattern"],
                                 cons: ["All-or-nothing: @Published", "Whole object re-render on any change"])
                    }
                }
            }
        }
    }

    func lifetimeRow(_ event: String, desc: String, icon: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 16)).foregroundStyle(color).frame(width: 22)
            VStack(alignment: .leading, spacing: 1) {
                Text(event).font(.system(size: 12, weight: .semibold)).foregroundStyle(color)
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func compCell(title: String, code: String, pros: [String], cons: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.obsGreen)
            Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.obsGreen)
                .padding(5).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 5))
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(pros, id: \.self) { p in
                        HStack(spacing: 3) { Text("✓").foregroundStyle(Color.obsGreen); Text(p).font(.system(size: 9)).foregroundStyle(.secondary) }
                    }
                }
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(cons, id: \.self) { c in
                        HStack(spacing: 3) { Text("·").foregroundStyle(Color.anAmber); Text(c).font(.system(size: 9)).foregroundStyle(.secondary) }
                    }
                }
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(8).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func codeChip(_ code: String) -> some View {
        Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.obsGreen)
            .padding(8).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private extension View {
    func smallObsButton(color: Color) -> some View {
        self.font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 10)
            .background(color).clipShape(RoundedRectangle(cornerRadius: 10))
            .buttonStyle(PressableButtonStyle())
    }
}

struct StateWithObservableExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "@State var model = MyModel()")
            Text("With the new Observation framework, @State owns @Observable models. The view holds the model's lifetime - it's created when the view appears and destroyed when it leaves. @State prevents the model from being recreated on every re-render.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@State private var model = MyModel() - creates the model once when the view appears.", color: .obsGreen)
                StepRow(number: 2, text: "The model persists across re-renders - @State storage survives body re-evaluation.", color: .obsGreen)
                StepRow(number: 3, text: "When the view leaves the hierarchy, @State is deallocated and the model's deinit runs.", color: .obsGreen)
                StepRow(number: 4, text: "To share the model: pass it as a parameter (let model: MyModel) or via environment.", color: .obsGreen)
                StepRow(number: 5, text: "To access elsewhere: .environment(model) injects it into the view hierarchy.", color: .obsGreen)
            }

            CalloutBox(style: .warning, title: "Don't use @State in the wrong place", contentBody: "@State inside a ForEach row is recreated when the row's identity changes. For models that should outlive a specific row, keep them in the parent view or a higher-level store.")

            CodeBlock(code: """
// ✓ @State owns the model
struct HomeView: View {
    @State private var store = ProductStore()

    var body: some View {
        List(store.products) { product in
            ProductRow(product: product)
                .onTapGesture { store.select(product) }
        }
        .task { await store.load() }
    }
}

// Pass down as parameter - NOT as @State in child
struct ProductRow: View {
    let product: Product       // value - no @State needed
    // OR
    let store: ProductStore    // reference - pass from parent
}

// Share via environment
HomeView()
    .environment(store)        // inject into tree
""")
        }
    }
}
