//
//
//  4_ derived.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `01/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Derived State

struct DerivedStateVisual: View {
    @State private var items: [String] = ["Milk", "Eggs", "Bread"]
    @State private var searchText = ""
    @State private var newItem = ""
    @State private var temperature: Double = 22.0

    // Derived — computed from state, no @State needed
    var filteredItems: [String] {
        searchText.isEmpty ? items : items.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var itemCount: Int { items.count }

    var temperatureLabel: String {
        switch temperature {
        case ..<0:   return "Freezing 🥶"
        case 0..<15: return "Cold 🧥"
        case 15..<25:return "Comfortable 😊"
        case 25..<35:return "Warm ☀️"
        default:     return "Hot 🔥"
        }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Derived state", systemImage: "function")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sbOrange)

                // Shopping list with search
                VStack(alignment: .leading, spacing: 8) {
                    sectionLabel("Filtered list - computed from @State")

                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass").foregroundStyle(.secondary).font(.system(size: 13))
                        TextField("Search...", text: $searchText)
                            .font(.system(size: 13))
                        if !searchText.isEmpty {
                            Button { searchText = "" } label: {
                                Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                    .padding(8)
                    .background(Color(.systemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    // filteredItems is a computed property — no @State
                    ForEach(filteredItems, id: \.self) { item in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle")
                                .foregroundStyle(Color.sbOrange).font(.system(size: 14))
                            Text(item).font(.system(size: 13))
                            Spacer()
                        }
                        .padding(.horizontal, 8).padding(.vertical, 4)
                    }

                    // itemCount is derived
                    Text("\(itemCount) item\(itemCount == 1 ? "" : "s") total")
                        .font(.system(size: 11)).foregroundStyle(.tertiary)

                    HStack(spacing: 8) {
                        TextField("Add item...", text: $newItem)
                            .font(.system(size: 13))
                            .padding(8)
                            .background(Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Button {
                            if !newItem.isEmpty {
                                withAnimation { items.append(newItem); newItem = "" }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(!newItem.isEmpty ? Color.sbOrange : Color(.systemGray4))
                        }
                        .buttonStyle(PressableButtonStyle())
                        .disabled(newItem.isEmpty)
                    }
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Divider()

                // Temperature label — derived from Double
                VStack(alignment: .leading, spacing: 8) {
                    sectionLabel("Derived label from Double state")
                    HStack(spacing: 10) {
                        Text("\(Int(temperature))°C")
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.sbOrange)
                            .frame(width: 60)
                        Slider(value: $temperature, in: -9...40, step: 1).tint(.sbOrange)
                    }
                    Text(temperatureLabel)
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .animation(.easeInOut(duration: 0.2), value: temperature)
                }
            }
        }
    }

    func sectionLabel(_ text: String) -> some View {
        Text(text).font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
    }
}

struct DerivedStateExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Derived state - computed properties")
            Text("Not every value needs @State. If a value can be computed from existing @State, it should be a regular computed property - no wrapper needed. SwiftUI recalculates it every time body runs, which happens whenever the underlying @State changes.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "If you can write 'var x: T { ... }' using only other @State values, do that instead of adding @State var x.", color: .sbOrange)
                StepRow(number: 2, text: "Derived values are always in sync - they recompute from scratch each render, so they can never be stale.", color: .sbOrange)
                StepRow(number: 3, text: "Filter, sort, count, format, combine - all perfect candidates for derived computed properties.", color: .sbOrange)
                StepRow(number: 4, text: "Fewer @State properties = simpler view logic and fewer opportunities for state to get out of sync.", color: .sbOrange)
            }

            CalloutBox(style: .success, title: "The rule of thumb", contentBody: "Only use @State for values that are directly set by user interaction or async work. Everything else - labels, filtered lists, formatted strings, counts - should be computed properties derived from that minimal state.")

            CalloutBox(style: .warning, title: "Don't cache derived values in @State", contentBody: "A common mistake: @State var filteredItems = [] updated in .onChange. This creates a stale data problem - the filtered list can lag behind the search text. A computed property is always current.")

            CodeBlock(code: """
struct ShoppingList: View {
    // Minimal @State - only what's directly set
    @State private var items = ["Milk", "Eggs"]
    @State private var searchText = ""

    // Derived — computed from @State, always in sync
    var filteredItems: [String] {
        searchText.isEmpty
            ? items
            : items.filter { $0.contains(searchText) }
    }

    var isEmpty: Bool { items.isEmpty }
    var count: String { "\\(items.count) items" }

    var body: some View {
        // filteredItems recomputes whenever items or searchText changes
        ForEach(filteredItems, id: \\.self) { item in
            Text(item)
        }
    }
}
""")
        }
    }
}
