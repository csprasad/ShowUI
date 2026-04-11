//
//
//  4_PickerPatterns.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Picker Patterns
struct PickerPatternsVisual: View {
    @State private var searchText  = ""
    @State private var selectedTag = ""
    @State private var continent   = "Europe"
    @State private var country     = "France"
    @State private var rating      = 3
    @State private var selectedDemo = 0

    let demos = ["Searchable", "Dependent", "Custom rows"]

    let allTags = ["Swift", "SwiftUI", "UIKit", "Combine", "CoreData", "CloudKit", "ARKit", "Metal", "CoreML", "MapKit", "RealityKit", "HealthKit"]

    var filteredTags: [String] { searchText.isEmpty ? allTags : allTags.filter { $0.localizedCaseInsensitiveContains(searchText) } }

    let continents = ["Europe", "Americas", "Asia", "Oceania"]
    let countriesByContinent: [String: [String]] = [
        "Europe":   ["France", "Germany", "Italy", "Spain", "Netherlands"],
        "Americas": ["USA", "Canada", "Brazil", "Mexico", "Argentina"],
        "Asia":     ["Japan", "China", "India", "South Korea", "Singapore"],
        "Oceania":  ["Australia", "New Zealand", "Fiji"],
    ]

    var countries: [String] { countriesByContinent[continent] ?? [] }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Picker patterns", systemImage: "arrow.triangle.branch")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cdPurple)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.cdPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.cdPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Searchable picker overlay
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                            TextField("Search tags…", text: $searchText)
                                .textFieldStyle(.plain)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                            if !searchText.isEmpty {
                                Button { searchText = "" } label: {
                                    Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                                }.buttonStyle(PressableButtonStyle())
                            }
                        }
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(Color.cdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 10))

                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(filteredTags, id: \.self) { tag in
                                    Button {
                                        withAnimation(.spring(response: 0.3)) { selectedTag = selectedTag == tag ? "" : tag }
                                    } label: {
                                        HStack {
                                            Text(tag).font(.system(size: 14))
                                            Spacer()
                                            if selectedTag == tag {
                                                Image(systemName: "checkmark").font(.system(size: 12, weight: .semibold)).foregroundStyle(Color.cdPurple)
                                            }
                                        }
                                        .padding(.horizontal, 14).padding(.vertical, 10)
                                        .background(selectedTag == tag ? Color.cdPurpleLight : Color(.systemBackground))
                                    }
                                    .buttonStyle(PressableButtonStyle())
                                    if tag != filteredTags.last { Divider().padding(.leading, 14) }
                                }
                            }
                        }
                        .frame(height: 150)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                        if !selectedTag.isEmpty {
                            HStack(spacing: 6) {
                                Image(systemName: "tag.fill").foregroundStyle(Color.cdPurple)
                                Text("Selected: \(selectedTag)").font(.system(size: 12)).foregroundStyle(.secondary)
                            }
                            .padding(8).background(Color.cdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }

                case 1:
                    // Dependent pickers
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            Text("Continent").font(.system(size: 13)).foregroundStyle(.secondary).frame(width: 72)
                            Picker("Continent", selection: $continent) {
                                ForEach(continents, id: \.self) { Text($0) }
                            }
                            .pickerStyle(.menu).tint(.cdPurple)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(Color.cdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 10))

                        HStack(spacing: 10) {
                            Text("Country").font(.system(size: 13)).foregroundStyle(.secondary).frame(width: 72)
                            Picker("Country", selection: $country) {
                                ForEach(countries, id: \.self) { Text($0) }
                            }
                            .pickerStyle(.menu).tint(.cdPurple)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(Color.cdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 10))
                        .onChange(of: continent) { _, _ in country = countries.first ?? "" }

                        HStack(spacing: 8) {
                            Image(systemName: "mappin.circle.fill").foregroundStyle(Color.cdPurple)
                            Text("\(country), \(continent)").font(.system(size: 13)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.cdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
                        .animation(.spring(response: 0.3), value: country)
                    }

                default:
                    // Custom row content
                    VStack(spacing: 10) {
                        // Star rating picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Star rating picker").font(.system(size: 14, weight: .semibold)).foregroundStyle(.secondary)
                            Picker("Rating", selection: $rating) {
                                ForEach(1...5, id: \.self) { n in
                                    HStack(spacing: 2) {
                                        ForEach(1...5, id: \.self) { i in
                                            Image(systemName: i <= n ? "star.fill" : "star")
                                                .font(.system(size: 12))
                                                .foregroundStyle(i <= n ? Color.animAmber : Color(.systemGray4))
                                        }
                                        Text("  \(n) star\(n == 1 ? "" : "s")").font(.system(size: 13))
                                    }
                                    .tag(n)
                                }
                            }
                            .pickerStyle(.inline)
                            .tint(.cdPurple)
                            .frame(maxHeight: 140)
                        }
                        .padding(10).background(Color.cdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 10))

                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { i in
                                Image(systemName: i <= rating ? "star.fill" : "star")
                                    .foregroundStyle(i <= rating ? Color.animAmber : Color(.systemGray4))
                            }
                            Text("(\(rating) stars)").font(.system(size: 15)).foregroundStyle(.secondary)
                        }
                        .animation(.spring(response: 0.3), value: rating)
                    }
                }
            }
        }
    }
}

struct PickerPatternsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Picker patterns")
            Text("For long lists, pair a search field with a custom scrollable list for a searchable picker. For cascading data, reset the child picker when the parent changes. Custom .tag() rows let any SwiftUI view become a picker option.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Searchable picker: TextField + ForEach filtered by search text - build your own scrollable list.", color: .cdPurple)
                StepRow(number: 2, text: "Dependent pickers: .onChange(of: parent) { _, _ in child = childOptions.first ?? fallback }.", color: .cdPurple)
                StepRow(number: 3, text: "Custom rows: any view inside a Picker - HStack with icons, stars, color swatches.", color: .cdPurple)
                StepRow(number: 4, text: "Custom row view needs .tag(value) so the Picker knows what to select.", color: .cdPurple)
            }

            CalloutBox(style: .info, title: "System Picker doesn't support search", contentBody: "SwiftUI's Picker has no built-in search. For searchable selection, build a custom list: store options in an array, filter on a search string, and track selection yourself with a separate @State variable.")

            CodeBlock(code: """
// Dependent pickers
@State private var continent = "Europe"
@State private var country = "France"

let countriesByContinent: [String: [String]] = [
    "Europe": ["France", "Germany", "Italy"],
    "Americas": ["USA", "Canada", "Brazil"]
]
var countries: [String] { countriesByContinent[continent] ?? [] }

Picker("Continent", selection: $continent) {
    ForEach(continents, id: \\.self) { Text($0) }
}
.pickerStyle(.menu)

Picker("Country", selection: $country) {
    ForEach(countries, id: \\.self) { Text($0) }
}
.onChange(of: continent) { _, _ in
    country = countries.first ?? ""  // reset child
}

// Custom row content
Picker("Rating", selection: $stars) {
    ForEach(1...5, id: \\.self) { n in
        Label("\\(n) stars", systemImage: "star.fill")
            .tag(n)
    }
}
""")
        }
    }
}

