//
//
//  7_OldvsNew.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Observation

// MARK: - LESSON 7: Old vs New
// Old pattern
class OldCounterModel: ObservableObject {
    @Published var count    = 0
    @Published var name     = "Counter"
    @Published var history: [Int] = []

    func increment() { count += 1; history.append(count) }
    func reset()     { count = 0; history = [] }
}

// New pattern
@Observable
class NewCounterModel {
    var count    = 0
    var name     = "Counter"
    var history: [Int] = []

    func increment() { count += 1; history.append(count) }
    func reset()     { count = 0; history = [] }
}

struct OldVsNewVisual: View {
    // Old
    @StateObject private var oldModel = OldCounterModel()
    // New
    @State private var newModel       = NewCounterModel()
    @State private var selectedDemo   = 0
    let demos = ["Side-by-side", "Migration guide", "@Bindable"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Old vs new patterns", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.obsGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
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
                    // Live side by side
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            counterPanel(
                                title: "ObservableObject",
                                count: oldModel.count,
                                history: oldModel.history,
                                color: .animCoral,
                                onIncrement: { oldModel.increment() },
                                onReset: { oldModel.reset() }
                            )
                            counterPanel(
                                title: "@Observable",
                                count: newModel.count,
                                history: newModel.history,
                                color: .obsGreen,
                                onIncrement: { newModel.increment() },
                                onReset: { newModel.reset() }
                            )
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill").font(.system(size: 12)).foregroundStyle(Color.obsGreen)
                            Text("Both work the same from a user perspective. @Observable is simpler to write and renders more efficiently.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // Migration guide
                    VStack(spacing: 8) {
                        migrationRow("class Model: ObservableObject {", to: "@Observable class Model {")
                        migrationRow("@Published var count = 0", to: "var count = 0")
                        migrationRow("@StateObject var m = M()", to: "@State var m = M()")
                        migrationRow("@ObservedObject var m: M", to: "let m: M (or pass by ref)")
                        migrationRow(".environmentObject(m)", to: ".environment(m)")
                        migrationRow("@EnvironmentObject var m: M", to: "@Environment(M.self) var m")
                        migrationRow("objectWillChange.send()", to: "// not needed - automatic")

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.navBlue)
                            Text("When targeting iOS 16 and earlier, keep ObservableObject. For iOS 17+ only apps, migrate to @Observable.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color(hex: "#EAF0FE")).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // @Bindable
                    VStack(spacing: 10) {
                        Text("@Bindable - get bindings from @Observable models")
                            .font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        BindableDemo(model: newModel)

                        CodeBlock(code: """
// @Bindable creates $bindings from @Observable
struct EditView: View {
    @Bindable var model: NewCounterModel

    var body: some View {
        TextField("Name", text: $model.name)
        //                      ↑ $ works via @Bindable
    }
}

// Or inline in body
struct InlineView: View {
    let model: NewCounterModel
    var body: some View {
        @Bindable var m = model
        TextField("Name", text: $m.name)
    }
}
""")
                    }
                }
            }
        }
    }

    func counterPanel(title: String, count: Int, history: [Int], color: Color, onIncrement: @escaping () -> Void, onReset: @escaping () -> Void) -> some View {
        VStack(spacing: 8) {
            Text(title).font(.system(size: 10, weight: .semibold)).foregroundStyle(color)
            Text("\(count)")
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundStyle(color)
                .contentTransition(.numericText())
                .animation(.spring(duration: 0.2), value: count)
            Text("[\(history.suffix(3).map { "\($0)" }.joined(separator: ","))]")
                .font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
            HStack(spacing: 6) {
                Button("+") { onIncrement() }
                    .font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
                    .frame(width: 32, height: 32).background(color).clipShape(Circle())
                    .buttonStyle(PressableButtonStyle())
                Button("⟳") { onReset() }
                    .font(.system(size: 14)).foregroundStyle(.secondary)
                    .frame(width: 32, height: 32).background(color.opacity(0.2)).clipShape(Circle())
                    .buttonStyle(PressableButtonStyle())
            }
        }
        .frame(maxWidth: .infinity).padding(10)
        .background(color.opacity(0.06)).clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func migrationRow(_ old: String, to new: String) -> some View {
        HStack(spacing: 8) {
            Text(old).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.animCoral)
                .padding(5).background(Color(hex: "#FCEBEB")).clipShape(RoundedRectangle(cornerRadius: 5))
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "arrow.right").font(.system(size: 10)).foregroundStyle(.secondary)
            Text(new).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.obsGreen)
                .padding(5).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 5))
                .frame(maxWidth: .infinity, alignment: .leading)
        } .frame(maxWidth: .infinity)
    }
}

struct BindableDemo: View {
    @Bindable var model: NewCounterModel

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                Text("Name:").font(.system(size: 12)).foregroundStyle(.secondary)
                TextField("Model name", text: $model.name)
                    .textFieldStyle(.roundedBorder).font(.system(size: 12))
            }
            HStack {
                Text("Current: \"\(model.name)\"").font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.obsGreen)
                Spacer()
                Text("count: \(model.count)").font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
            }
        }
        .padding(10).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct OldVsNewExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "ObservableObject vs @Observable")
            Text("@Observable replaces ObservableObject with a macro-based approach. The main advantages: no @Published boilerplate, fine-grained per-property tracking, simpler view property declarations, and cleaner environment injection.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "class Model: ObservableObject { @Published var x } → @Observable class Model { var x }", color: .obsGreen)
                StepRow(number: 2, text: "@StateObject → @State, @ObservedObject → let or @State passed in.", color: .obsGreen)
                StepRow(number: 3, text: ".environmentObject() → .environment(), @EnvironmentObject → @Environment(Type.self)", color: .obsGreen)
                StepRow(number: 4, text: "@Bindable var model: MyModel - creates $ bindings from @Observable properties.", color: .obsGreen)
                StepRow(number: 5, text: "Keep ObservableObject for iOS 14/15/16 targets. Use @Observable for iOS 17+ only.", color: .obsGreen)
            }

            CalloutBox(style: .info, title: "@Bindable for bindings", contentBody: "With @Observable, $ bindings don't work directly on a let constant. Use @Bindable var m = model at the top of body, or declare the property as @Bindable in the view struct. This gives you $m.name etc.")

            CodeBlock(code: """
// Before - ObservableObject
class CartStore: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading = false
}
struct CartView: View {
    @StateObject var store = CartStore()
    @ObservedObject var store: CartStore  // received from parent
}

// After - @Observable
@Observable
class CartStore {
    var items: [Item] = []
    var isLoading = false
}
struct CartView: View {
    @State var store = CartStore()  // owns it
    // OR
    let store: CartStore            // passed from parent

    // For bindings:
    @Bindable var store: CartStore
    TextField("Name", text: $store.name)
}
""")
        }
    }
}
