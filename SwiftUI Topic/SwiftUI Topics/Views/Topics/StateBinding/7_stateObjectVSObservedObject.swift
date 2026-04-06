//
//
//  7_stateObjectVSObservedObject.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `01/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: StateObject vs ObservedObject

@Observable
class SharedCounter {
    var value = 0
    func increment() { value += 1 }
}

struct StateObjectVisual: View {
    // @State owns the @Observable model - created once
    @State private var ownedCounter = SharedCounter()

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Ownership vs reference", systemImage: "person.2.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sbOrange)

                // Visual showing ownership
                VStack(spacing: 10) {
                    sectionLabel("@State - this view OWNS the model")
                    ownershipDemo(
                        label: "@State var model = MyModel()",
                        description: "Created once. Survives re-renders. This view is the source of truth.",
                        color: Color.sbOrange,
                        bgColor: Color.sbOrangeLight,
                        isOwner: true
                    )
                }

                VStack(spacing: 10) {
                    sectionLabel("var model - this view REFERENCES a model")
                    ownershipDemo(
                        label: "var model: MyModel",
                        description: "Passed in from outside. This view reads and writes but doesn't own.",
                        color: Color.animTeal,
                        bgColor: Color(hex: "#E1F5EE"),
                        isOwner: false
                    )
                }

                Divider()

                // Live demo: parent owns, children reference
                sectionLabel("One model, multiple views")
                HStack(spacing: 10) {
                    // Two children reading the same owned model
                    OwnershipChildA(counter: ownedCounter)
                    OwnershipChildB(counter: ownedCounter)
                }

                Text("Both children share the same counter - tap either button")
                    .font(.system(size: 11)).foregroundStyle(.tertiary)
            }
        }
    }

    func ownershipDemo(label: String, description: String, color: Color, bgColor: Color, isOwner: Bool) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: isOwner ? "crown.fill" : "arrow.right.circle")
                .font(.system(size: 16))
                .foregroundStyle(color)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundStyle(color)
                Text(description)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(10)
        .background(bgColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func sectionLabel(_ text: String) -> some View {
        Text(text).font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
    }
}

struct OwnershipChildA: View {
    var counter: SharedCounter

    var body: some View {
        VStack(spacing: 6) {
            Text("\(counter.value)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(Color.sbOrange)
                .contentTransition(.numericText())
                .animation(.spring(duration: 0.3), value: counter.value)
            Button {
                counter.increment()
            } label: {
                Text("View A +1")
                    .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 8)
                    .background(Color.sbOrange).clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(PressableButtonStyle())
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct OwnershipChildB: View {
    var counter: SharedCounter

    var body: some View {
        VStack(spacing: 6) {
            Text("\(counter.value)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(Color.animTeal)
                .contentTransition(.numericText())
                .animation(.spring(duration: 0.3), value: counter.value)
            Button {
                counter.increment()
            } label: {
                Text("View B +1")
                    .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 8)
                    .background(Color.animTeal).clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(PressableButtonStyle())
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct StateObjectExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Ownership - who creates the model?")
            Text("The key question when using an @Observable class is: who is responsible for creating it? The view that creates it owns it and must use @State. Views that receive it from outside just use a plain var - no wrapper.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Owner view: @State private var model = MyModel() - creates once, survives re-renders, is the source of truth.", color: .sbOrange)
                StepRow(number: 2, text: "Reference view: var model: MyModel - passed in from outside, no @State needed.", color: .sbOrange)
                StepRow(number: 3, text: "For the old ObservableObject pattern: @StateObject owns, @ObservedObject references.", color: .sbOrange)
                StepRow(number: 4, text: "If you use @ObservedObject where you should use @StateObject, the model gets recreated every time the parent re-renders - a common and subtle bug.", color: .sbOrange)
            }

            CalloutBox(style: .danger, title: "The @StateObject vs @ObservedObject bug", contentBody: "Using @ObservedObject var model = MyModel() means a new model is created every time the parent view renders. All state inside it resets. Always use @StateObject to own, @ObservedObject to reference (old API) - or @State to own with the new @Observable.")

            CalloutBox(style: .info, title: "With @Observable (iOS 17+)", contentBody: "The distinction is simpler: @State owns (creates and stores), plain var references. No need for @StateObject or @ObservedObject with @Observable classes.")

            CodeBlock(code: """
// ---- Modern API (@Observable, iOS 17+) ----

// Owner - creates the model
struct ParentView: View {
    @State private var model = CartModel()  // owns it

    var body: some View {
        CartSummary(cart: model)
        CheckoutButton(cart: model)
    }
}

// References - receive it
struct CartSummary: View {
    var cart: CartModel  // no wrapper needed
}

// ---- Legacy API (ObservableObject) ----

class CartModel: ObservableObject {
    @Published var items: [Item] = []
}

struct ParentView: View {
    @StateObject private var model = CartModel()  // owns

    var body: some View {
        ChildView(model: model)
    }
}

struct ChildView: View {
    @ObservedObject var model: CartModel  // references
}
""")
        }
    }
}


