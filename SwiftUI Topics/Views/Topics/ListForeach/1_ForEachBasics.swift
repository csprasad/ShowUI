//
//
//  1_ForEachBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: ForEach Basics
struct ForEachBasicsVisual: View {
    @State private var selectedMode = 0
    let modes = ["Identifiable", "id: \\.self", "indices"]

    let fruits = ["Apple", "Banana", "Cherry", "Dragonfruit"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("ForEach basics", systemImage: "repeat.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.lfBlue)

                // Mode selector
                HStack(spacing: 8) {
                    ForEach(modes.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedMode = i }
                        } label: {
                            Text(modes[i])
                                .font(.system(size: 11, weight: selectedMode == i ? .semibold : .regular))
                                .foregroundStyle(selectedMode == i ? Color.lfBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedMode == i ? Color.lfBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Live demo
                VStack(spacing: 0) {
                    switch selectedMode {
                    case 0:
                        // Identifiable
                        ForEach(LFContact.samples.prefix(4)) { contact in
                            contactRow(contact)
                            if contact.id != LFContact.samples[3].id { Divider().padding(.leading, 50) }
                        }
                    case 1:
                        // id: \.self — plain strings
                        ForEach(fruits, id: \.self) { fruit in
                            HStack(spacing: 10) {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 8)).foregroundStyle(Color.lfBlue)
                                Text(fruit).font(.system(size: 14))
                                Spacer()
                            }
                            .padding(.horizontal, 14).padding(.vertical, 8)
                            if fruit != fruits.last { Divider().padding(.leading, 30) }
                        }
                    default:
                        // indices
                        ForEach(fruits.indices, id: \.self) { i in
                            HStack(spacing: 10) {
                                Text("\(i + 1)")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    .foregroundStyle(.white)
                                    .frame(width: 22, height: 22)
                                    .background(Color.lfBlue)
                                    .clipShape(Circle())
                                Text(fruits[i]).font(.system(size: 14))
                                Spacer()
                            }
                            .padding(.horizontal, 14).padding(.vertical, 8)
                            if i < fruits.indices.last! { Divider().padding(.leading, 46) }
                        }
                    }
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                // Code for selected mode
                let codes = [
                    "ForEach(contacts) { contact in\n    // contact.id used automatically\n}",
                    "ForEach(strings, id: \\.self) { str in\n    // str itself is the ID\n}",
                    "ForEach(array.indices, id: \\.self) { i in\n    // array[i] for value\n    // i for position\n}",
                ]
                Text(codes[selectedMode])
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(Color.lfBlue)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.lfBlueLight)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .animation(.easeInOut(duration: 0.15), value: selectedMode)
            }
        }
    }

    func contactRow(_ contact: LFContact) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.lfBlue)
                .frame(width: 32, height: 32)
                .overlay(Text(contact.initial).font(.system(size: 13, weight: .semibold)).foregroundStyle(.white))
            VStack(alignment: .leading, spacing: 1) {
                Text(contact.name).font(.system(size: 14, weight: .medium))
                Text(contact.role).font(.system(size: 12)).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 14).padding(.vertical, 8)
    }
}

struct ForEachBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "ForEach — iterating over data")
            Text("ForEach generates views from a collection. It is not a loop — it's a view builder that creates a view for each element. SwiftUI uses the id to track identity across re-renders and animate additions, removals, and reorders correctly.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "ForEach(items) — works when items conform to Identifiable. SwiftUI uses item.id automatically.", color: .lfBlue)
                StepRow(number: 2, text: "ForEach(items, id: \\.self) — for types that are Hashable but not Identifiable (strings, ints). The value itself is the ID.", color: .lfBlue)
                StepRow(number: 3, text: "ForEach(items.indices, id: \\.self) — when you need the index alongside the value. Avoid when you can — index-based iteration breaks animations.", color: .lfBlue)
                StepRow(number: 4, text: "ForEach is NOT limited to List — use it inside VStack, HStack, ScrollView, or anywhere you need generated views.", color: .lfBlue)
            }

            CalloutBox(style: .danger, title: "IDs must be unique and stable", contentBody: "If two items share the same ID, SwiftUI gets confused and produces wrong animations or crashes. If IDs change between renders (random UUIDs), SwiftUI treats every item as new each time — destroying all animations.")

            CalloutBox(style: .info, title: "Identifiable is the best approach", contentBody: "Conform your model to Identifiable by adding 'let id = UUID()'. This is the most reliable pattern — stable, unique IDs that SwiftUI can track across state changes.")

            CodeBlock(code: """
// Best — Identifiable model
struct Contact: Identifiable {
    let id = UUID()   // stable, unique
    var name: String
}
ForEach(contacts) { contact in
    Text(contact.name)
}

// OK — Hashable values as ID
ForEach(["Swift", "iOS", "Xcode"], id: \\.self) { item in
    Text(item)
}

// Use indices when you need position
ForEach(items.indices, id: \\.self) { i in
    Text("\\(i + 1). \\(items[i].name)")
}

// Works anywhere — not just List
VStack {
    ForEach(items) { item in
        ItemCard(item: item)
    }
}
""")
        }
    }
}
