//
//
//  3_Injecting@ObservableModels.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `13/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Observation

// MARK: - Shared models for lesson 3
@Observable
class CartModel {
    var items: [CartItemModel] = []
    var promoApplied = false

    struct CartItemModel: Identifiable {
        let id = UUID()
        var name: String
        var price: Double
        var qty: Int
    }

    var total: Double { items.reduce(0) { $0 + $1.price * Double($1.qty) } * (promoApplied ? 0.9 : 1.0) }
    var itemCount: Int { items.reduce(0) { $0 + $1.qty } }

    func add(_ name: String, price: Double) {
        if let i = items.firstIndex(where: { $0.name == name }) {
            items[i].qty += 1
        } else {
            items.append(CartItemModel(name: name, price: price, qty: 1))
        }
    }
    func remove(_ id: UUID) { items.removeAll { $0.id == id } }
}

@Observable
class UserSession {
    var name     = "Alice"
    var isLoggedIn = true
    var role: String = "admin"
    var renderCount = 0
}

// MARK: - LESSON 3: Injecting @Observable Models
struct InjectObservableVisual: View {
    @State private var cart    = CartModel()
    @State private var session = UserSession()
    @State private var selectedDemo = 0
    let demos = [".env(model)", "re-render", "vs env-Objc"]

    let products = [("Coffee", 3.50), ("Croissant", 2.80), ("Juice", 4.20), ("Bagel", 2.50)]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Injecting @Observable models", systemImage: "cpu.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.envGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.envGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.envGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Live cart demo with environment injection
                    VStack(spacing: 8) {
                        // Product buttons (inject cart via environment)
                        HStack(spacing: 6) {
                            ForEach(products.prefix(4), id: \.0) { name, price in
                                Button {
                                    withAnimation(.spring(bounce: 0.3)) { cart.add(name, price: price) }
                                } label: {
                                    VStack(spacing: 2) {
                                        Text(name).font(.system(size: 10, weight: .semibold))
                                        Text("$\(price, specifier: "%.2f")").font(.system(size: 9)).foregroundStyle(.secondary)
                                    }
                                    .frame(maxWidth: .infinity).padding(.vertical, 7)
                                    .background(Color.envGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }

                        // Cart summary - reads from environment
                        CartSummaryView()
                            .environment(cart)

                        // Toggle promo
                        HStack {
                            Toggle("10% promo code", isOn: $cart.promoApplied.animation()).tint(.envGreen)
                                .font(.system(size: 12))
                        }
                    }

                case 1:
                    // Fine-grained re-render demo
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Button("Change name") {
                                session.name = ["Alice", "Bob", "Carol", "Dave"].filter { $0 != session.name }.randomElement()!
                            }.smallEnvButton(color: .envGreen)
                            Button("Change role") {
                                session.role = ["admin", "editor", "viewer"].filter { $0 != session.role }.randomElement()!
                            }.smallEnvButton(color: .envTeal)
                            Button("Toggle login") {
                                session.isLoggedIn.toggle()
                            }.smallEnvButton(color: session.isLoggedIn ? .animCoral : .formGreen)
                        }

                        // These sub-views each read different properties
                        VStack(spacing: 6) {
                            NameOnlyView(session: session)
                            RoleOnlyView(session: session)
                            LoginStatusView(session: session)
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.envGreen)
                            Text("Each sub-view only re-renders when ITS property changes - tap each button to see which render count increments.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.envGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // old vs new
                    VStack(spacing: 8) {
                        compRow2(
                            old: "class Store: ObservableObject {\n @Published var count = 0\n}",
                            new: "@Observable\nclass Store {\n    var count = 0\n}",
                            oldLabel: "ObservableObject", newLabel: "@Observable"
                        )
                        compRow2(
                            old: ".environmentObject(store)\n// injects into tree",
                            new: ".environment(store)\n// same - but typed",
                            oldLabel: "Inject", newLabel: "Inject"
                        )
                        compRow2(
                            old: "@EnvironmentObject var store: Store\n//crashes if not injected!",
                            new: "@Environment(Store.self) var store\n//type-based, optional variant exists",
                            oldLabel: "Read", newLabel: "Read"
                        )
                        compRow2(
                            old: "objectWillChange fires for ALL\n@Published changes - full re-render",
                            new: "Only properties accessed in body\ntrigger re-render (fine-grained)",
                            oldLabel: "Perf", newLabel: "Perf"
                        )
                    }
                }
            }
        }
    }

    func compRow2(old: String, new: String, oldLabel: String, newLabel: String) -> some View {
        HStack(spacing: 6) {
            VStack(alignment: .leading, spacing: 2) {
                Text(oldLabel).font(.system(size: 8, weight: .semibold)).foregroundStyle(Color.animCoral)
                Text(old).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.animCoral)
            }
            .padding(6).background(Color(hex: "#FCEBEB")).clipShape(RoundedRectangle(cornerRadius: 6)).frame(maxWidth: .infinity)
            Image(systemName: "arrow.right").font(.system(size: 10)).foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text(newLabel).font(.system(size: 8, weight: .semibold)).foregroundStyle(Color.envGreen)
                Text(new).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.envGreen)
            }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(6).background(Color.envGreenLight).clipShape(RoundedRectangle(cornerRadius: 6)).frame(maxWidth: .infinity)
        }
    }
}

private struct CartSummaryView: View {
    @Environment(CartModel.self) var cart

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "cart.fill").foregroundStyle(Color.envGreen)
                Text("Cart (\(cart.itemCount) items)").font(.system(size: 13, weight: .semibold))
                Spacer()
                Text(cart.total, format: .currency(code: "USD"))
                    .font(.system(size: 14, weight: .bold)).foregroundStyle(Color.envGreen)
                    .contentTransition(.numericText()).animation(.spring(duration: 0.3), value: cart.total)
            }
            ForEach(cart.items) { item in
                HStack(spacing: 8) {
                    Text("×\(item.qty)").font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                    Text(item.name).font(.system(size: 11))
                    Spacer()
                    Text(item.price * Double(item.qty), format: .currency(code: "USD"))
                        .font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                    Button { cart.remove(item.id) } label: {
                        Image(systemName: "xmark.circle.fill").foregroundStyle(Color.animCoral).font(.system(size: 12))
                    }.buttonStyle(PressableButtonStyle())
                }
            }
            if cart.items.isEmpty {
                Text("Cart is empty - add items above").font(.system(size: 11)).foregroundStyle(.secondary)
            }
        }
        .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private func renderBadge(_ n: Int) -> some View {
    Text("\(n) renders").font(.system(size: 9, design: .monospaced))
        .foregroundStyle(.secondary).padding(.horizontal, 6).padding(.vertical, 2)
        .background(Color(.systemFill)).clipShape(Capsule())
}

private struct NameOnlyView: View {
    let session: UserSession
    @State private var renders = 0
    var body: some View {
        let _ = { renders += 1 }()
        return HStack {
            Text("Name: \(session.name)").font(.system(size: 12))
            Spacer(); renderBadge(renders)
        }
        .padding(8).background(Color.envGreenLight).clipShape(RoundedRectangle(cornerRadius: 7))
    }
}
private struct RoleOnlyView: View {
    let session: UserSession
    @State private var renders = 0
    var body: some View {
        let _ = { renders += 1 }()
        return HStack {
            Text("Role: \(session.role)").font(.system(size: 12))
            Spacer(); renderBadge(renders)
        }
        .padding(8).background(Color(hex: "#EEF2FF")).clipShape(RoundedRectangle(cornerRadius: 7))
    }
}
private struct LoginStatusView: View {
    let session: UserSession
    @State private var renders = 0
    var body: some View {
        let _ = { renders += 1 }()
        return HStack {
            Image(systemName: session.isLoggedIn ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(session.isLoggedIn ? Color.formGreen : Color.animCoral)
            Text(session.isLoggedIn ? "Logged in" : "Logged out").font(.system(size: 12))
            Spacer(); renderBadge(renders)
        }
        .padding(8).background(Color(hex: "#FFF7ED")).clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

private extension View {
    func smallEnvButton(color: Color) -> some View {
        self.font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 8)
            .background(color).clipShape(RoundedRectangle(cornerRadius: 8))
            .buttonStyle(PressableButtonStyle())
    }
}

struct InjectObservableExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: ".environment() with @Observable")
            Text(".environment(model) injects any @Observable class into the view tree. Descendants read it with @Environment(ModelType.self). Only views that read changed properties re-render - far more efficient than ObservableObject.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Inject: someView.environment(myModel) - inject at the level where it's needed.", color: .envGreen)
                StepRow(number: 2, text: "@Environment(Store.self) var store - read in any descendant. Type-based, not string-keyed.", color: .envGreen)
                StepRow(number: 3, text: "Fine-grained: each view only subscribes to properties it reads. Unread properties don't trigger re-renders.", color: .envGreen)
                StepRow(number: 4, text: "@Bindable var model = model - to get $ bindings from an environment model.", color: .envGreen)
                StepRow(number: 5, text: "Multiple models: chain .environment() calls - each is keyed by its type.", color: .envGreen)
            }

            CalloutBox(style: .warning, title: "@Environment crashes if not injected", contentBody: "@Environment(Store.self) crashes at runtime if Store was never injected. Use the optional variant @Environment(Store.self) var store? - nil if not present. Always inject at the root for app-wide models.")

            CodeBlock(code: """
// Root - own and inject
@main struct App: App {
    @State private var cart    = CartStore()
    @State private var session = UserSession()

    var body: some Scene {
        WindowGroup { RootView() }
            .environment(cart)
            .environment(session)
    }
}

// Deep child - reads from environment
struct CheckoutButton: View {
    @Environment(CartStore.self) var cart

    var body: some View {
        Button("Pay \\(cart.total, format: .currency(code: "USD"))") {
            cart.checkout()
        }
    }
}

// Binding from environment model
struct NameEditor: View {
    @Environment(UserSession.self) var session

    var body: some View {
        @Bindable var s = session     // enables $s.name
        TextField("Name", text: $s.name)
    }
}
""")
        }
    }
}
