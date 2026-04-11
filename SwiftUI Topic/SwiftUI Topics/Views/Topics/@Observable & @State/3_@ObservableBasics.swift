//
//
//  3_@ObservableBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Observation

// MARK: - Shared Observable models
@Observable
class ShoppingCart {
    var items: [String]  = ["Apples", "Bread", "Milk"]
    var discount: Double = 0.1
    var promoCode        = ""

    var subtotal: Double { Double(items.count) * 4.99 }
    var total: Double    { subtotal * (1 - discount) }

    func addItem(_ item: String) { items.append(item) }
    func removeItem(at index: Int) { items.remove(at: index) }
    func applyPromo(_ code: String) {
        promoCode = code
        discount  = code.lowercased() == "save20" ? 0.2 : 0.1
    }
}

@Observable
class UserProfile {
    var name  = "Alice"
    var email = "alice@example.com"
    var score = 42
}

@Observable
class RenderTracker {
    var title         = "Hello"
    var subtitle      = "World"
    var count         = 0
    var titleRenders  = 0
    var subtitleRenders = 0
    var countRenders  = 0
}

// MARK: - LESSON 3: @Observable Basics
struct ObservableBasicsVisual: View {
    @State private var cart    = ShoppingCart()
    @State private var newItem = ""
    @State private var promo   = ""
    @State private var selectedDemo = 0
    let demos = ["Live cart", "Properties", "vs"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("@Observable basics", systemImage: "eye.circle.fill")
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
                    // Live shopping cart
                    VStack(spacing: 10) {
                        ForEach(cart.items.indices, id: \.self) { i in
                            HStack(spacing: 8) {
                                Image(systemName: "cart.fill").font(.system(size: 12)).foregroundStyle(Color.obsGreen)
                                Text(cart.items[i]).font(.system(size: 13))
                                Spacer()
                                Text("$4.99").font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary)
                                Button {
                                    withAnimation(.spring(bounce: 0.3)) { cart.removeItem(at: i) }
                                } label: {
                                    Image(systemName: "minus.circle.fill").foregroundStyle(Color.animCoral)
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                            .padding(.horizontal, 10).padding(.vertical, 7)
                            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        HStack(spacing: 8) {
                            TextField("Add item…", text: $newItem)
                                .textFieldStyle(.roundedBorder)
                                .font(.system(size: 13))
                            Button {
                                if !newItem.trimmingCharacters(in: .whitespaces).isEmpty {
                                    withAnimation(.spring(bounce: 0.3)) { cart.addItem(newItem); newItem = "" }
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill").font(.system(size: 22)).foregroundStyle(Color.obsGreen)
                            }
                            .buttonStyle(PressableButtonStyle())
                        }

                        HStack(spacing: 8) {
                            TextField("Promo code", text: $promo)
                                .textFieldStyle(.roundedBorder).font(.system(size: 12))
                            Button("Apply") { cart.applyPromo(promo) }
                                .font(.system(size: 12, weight: .semibold)).foregroundStyle(Color.obsGreen)
                                .buttonStyle(PressableButtonStyle())
                        }

                        Divider()
                        HStack {
                            Text("Total (\(Int(cart.discount * 100))% off)")
                                .font(.system(size: 12)).foregroundStyle(.secondary)
                            Spacer()
                            Text(cart.total, format: .currency(code: "USD"))
                                .font(.system(size: 16, weight: .bold)).foregroundStyle(Color.obsGreen)
                                .contentTransition(.numericText())
                                .animation(.spring(duration: 0.3), value: cart.total)
                        }
                    }

                case 1:
                    // Properties explained
                    VStack(alignment: .leading, spacing: 8) {
                        propRow(icon: "circle.fill", label: "Stored properties", code: "var name = \"Alice\"", desc: "Automatically tracked - any mutation triggers re-render", ok: true)
                        propRow(icon: "function", label: "Computed properties", code: "var total: Double { subtotal * rate }", desc: "NOT auto-tracked - tracked via its dependencies", ok: true)
                        propRow(icon: "lock.fill", label: "nonisolated", code: "nonisolated var id = UUID()", desc: "Opted out of observation - no tracking", ok: false)
                        propRow(icon: "xmark.square.fill", label: "_$observationRegistrar", code: "// auto-injected by macro", desc: "The observation plumbing - transparent to you", ok: true)

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.obsGreen)
                            Text("@Observable uses Swift macros to synthesize the registration and access tracking code automatically.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // Side-by-side comparison
                    VStack(spacing: 8) {
                        compRow(
                            oldTitle: "ObservableObject",
                            oldCode: "@Published var count = 0\n@Published var name = \"\"",
                            newTitle: "@Observable",
                            newCode: "var count = 0\nvar name = \"\""
                        )
                        compRow(
                            oldTitle: "View property",
                            oldCode: "@StateObject var m = MyModel()\n@ObservedObject var m: MyModel",
                            newTitle: "View property",
                            newCode: "@State var m = MyModel()"
                        )
                        compRow(
                            oldTitle: "Environment",
                            oldCode: ".environmentObject(m)\n@EnvironmentObject var m: MyModel",
                            newTitle: "Environment",
                            newCode: ".environment(m)\n@Environment(MyModel.self) var m"
                        )
                        compRow(
                            oldTitle: "Granularity",
                            oldCode: "objectWillChange fires for\nANY property change",
                            newTitle: "Granularity",
                            newCode: "Only accessed properties\ntrigger re-render"
                        )
                    }
                }
            }
        }
    }

    func propRow(icon: String, label: String, code: String, desc: String, ok: Bool) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon).font(.system(size: 12)).foregroundStyle(ok ? Color.obsGreen : Color.animCoral).padding(.top, 1)
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.system(size: 11, weight: .semibold))
                Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(ok ? Color.obsGreen : Color.animCoral)
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(ok ? Color.obsGreenLight.opacity(0.5) : Color(hex: "#FCEBEB")).clipShape(RoundedRectangle(cornerRadius: 8))
    }
    

    func compRow(oldTitle: String, oldCode: String, newTitle: String, newCode: String) -> some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 3) {
                Text(oldTitle).font(.system(size: 9, weight: .semibold)).foregroundStyle(Color.animCoral)
                Text(oldCode).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.animCoral)
            }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(7).background(Color(hex: "#FCEBEB")).clipShape(RoundedRectangle(cornerRadius: 6))

            Image(systemName: "arrow.right").font(.system(size: 11)).foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 3) {
                Text(newTitle).font(.system(size: 9, weight: .semibold)).foregroundStyle(Color.obsGreen)
                Text(newCode).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.obsGreen)
            }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(7).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }
}


struct ObservableBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "@Observable - iOS 17+")
            Text("@Observable is a Swift macro that synthesizes observation infrastructure. Simply mark a class with @Observable and all its stored properties are automatically tracked - no @Published needed. Views only re-render when properties they actually read change.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "@Observable class MyModel - add the macro. All stored vars are tracked automatically.", color: .obsGreen)
                StepRow(number: 2, text: "No @Published - every stored property is observable by default. Opt out with @ObservationIgnored.", color: .obsGreen)
                StepRow(number: 3, text: "In views: just use the model's properties - SwiftUI automatically subscribes to what you read.", color: .obsGreen)
                StepRow(number: 4, text: "Computed properties track their own dependencies - if they read tracked properties, they invalidate correctly.", color: .obsGreen)
                StepRow(number: 5, text: "Works on iOS 17+ - use ObservableObject for iOS 16 and earlier.", color: .obsGreen)
            }

            CalloutBox(style: .success, title: "No @Published, no ObjectWillChange", contentBody: "@Observable removes all the boilerplate. No protocol conformance, no @Published on every property, no AnyCancellable, no objectWillChange. Just add @Observable and use the class.")

            CodeBlock(code: """
// New @Observable - iOS 17+
@Observable
class CounterModel {
    var count = 0          // automatically tracked
    var name = "Counter"   // automatically tracked

    @ObservationIgnored    // opt out of tracking
    var id = UUID()

    var label: String {    // computed - tracks count + name
        "\\(name): \\(count)"
    }

    func increment() { count += 1 }
}

// In SwiftUI view
struct ContentView: View {
    @State private var model = CounterModel()

    var body: some View {
        VStack {
            Text(model.label)   // subscribes to count + name
            Button("Add") { model.increment() }
        }
    }
}
""")
        }
    }
}
