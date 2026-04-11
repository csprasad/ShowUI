//
//
//  3_PickerDeepDive.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Picker Deep Dive
enum PikerAppTheme: String, CaseIterable, Identifiable {
    case system = "System", light = "Light", dark = "Dark"
    var id: Self { self }
    var icon: String { switch self { case .system: "circle.lefthalf.filled"; case .light: "sun.max.fill"; case .dark: "moon.fill" } }
}

enum SortOrder: String, CaseIterable, Identifiable {
    case nameAZ = "A → Z", nameZA = "Z → A", dateNewest = "Newest", dateOldest = "Oldest"
    var id: Self { self }
}

struct PickerDeepDiveVisual: View {
    @State private var theme: PikerAppTheme    = .system
    @State private var sort: SortOrder   = .nameAZ
    @State private var priority          = 1
    @State private var fontSize          = 16
    @State private var country           = "US"
    @State private var selectedDemo      = 0

    let demos = ["All styles", "Inline & wheel", "onChange"]
    let countries = ["IN":"🇮🇳 India", "US":"🇺🇸 United States","UK":"🇬🇧 United Kingdom","DE":"🇩🇪 Germany","JP":"🇯🇵 Japan","AU":"🇦🇺 Australia"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Picker deep dive", systemImage: "list.bullet.circle.fill")
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
                    // All styles
                    VStack(alignment: .leading, spacing: 16) {
                        styleRow(".menu (default)") {
                            Picker("Theme", selection: $theme) {
                                ForEach(PikerAppTheme.allCases) { t in
                                    Label(t.rawValue, systemImage: t.icon).tag(t)
                                }
                            }
                            .pickerStyle(.menu).tint(.cdPurple)
                        }

                        styleRow(".segmented (2-4 items)") {
                            Picker("Priority", selection: $priority) {
                                Text("Low").tag(0)
                                Text("Med").tag(1)
                                Text("High").tag(2)
                            }
                            .pickerStyle(.segmented)
                        }

                        styleRow(".navigationLink (in Form)") {
                            NavigationStack {
                                Form {
                                    Picker("Sort", selection: $sort) {
                                        ForEach(SortOrder.allCases) { s in Text(s.rawValue).tag(s) }
                                    }
                                    .pickerStyle(.navigationLink)
                                }
                                .navigationTitle("Settings")
                                .navigationBarTitleDisplayMode(.inline)
                            }
                            .frame(height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }

                case 1:
                    // Inline and wheel
                    VStack(spacing: 10) {
                        styleRow(".inline - all options visible") {
                            Picker("Sort", selection: $sort) {
                                ForEach(SortOrder.allCases) { s in Text(s.rawValue).tag(s) }
                            }
                            .pickerStyle(.inline)
                            .tint(.cdPurple)
                            .frame(maxHeight: 120)
                        }

                        styleRow(".wheel - drum scroll") {
                            HStack {
                                Picker("Font", selection: $fontSize) {
                                    ForEach([10, 12, 14, 16, 18, 20, 24, 28, 32], id: \.self) { size in
                                        Text("\(size)pt").tag(size)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 80)
                                .clipped()
                            }
                        }
                    }

                default:
                    // onChange demo
                    VStack(alignment: .leading, spacing: 10) {
                        Picker("Country", selection: $country) {
                            ForEach(Array(countries.keys.sorted()), id: \.self) { code in
                                Text(countries[code] ?? code).tag(code)
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .pickerStyle(.menu).tint(.cdPurple)
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(Color.cdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 10))
                        .onChange(of: country) { old, new in
                            // onChange fires with old and new values
                        }

                        VStack(spacing: 10) {
//                            Text(countries[country] ?? country)
//                                .font(.system(size: 16))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Selected: \(country)")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("onChange fires with (old, new) values")
                                    .font(.system(size: 11)).foregroundStyle(.secondary)
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12).background(Color.cdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 12))
                        .animation(.spring(response: 0.3), value: country)

                        // Picker inside Form
                        NavigationStack {
                            Form {
                                Section("Appearance") {
                                    Picker("Theme", selection: $theme) {
                                        ForEach(PikerAppTheme.allCases) { t in
                                            Label(t.rawValue, systemImage: t.icon).tag(t)
                                        }
                                    }
                                    Picker("Sort", selection: $sort) {
                                        ForEach(SortOrder.allCases) { s in Text(s.rawValue).tag(s) }
                                    }
                                }
                            }
                            .navigationTitle("Settings")
                            .navigationBarTitleDisplayMode(.inline)
                        }
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }

    func styleRow<C: View>(_ label: String, @ViewBuilder content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
            content()
        }.padding(.bottom)
    }
}

struct PickerDeepDiveExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Picker - all styles")
            Text("Picker's five styles each suit different contexts. The selection type must match the .tag() type exactly - mismatch silently breaks selection. Enum-backed pickers with CaseIterable are the cleanest pattern.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".pickerStyle(.menu) - compact dropdown. Default outside Form. .tint() controls the button color.", color: .cdPurple)
                StepRow(number: 2, text: ".pickerStyle(.segmented) - horizontal segments. Best for 2–4 short labels.", color: .cdPurple)
                StepRow(number: 3, text: ".pickerStyle(.inline) - shows all options inline with checkmark. Best inside Form.", color: .cdPurple)
                StepRow(number: 4, text: ".pickerStyle(.wheel) - spinning drum. Classic for time, number, or ordered lists.", color: .cdPurple)
                StepRow(number: 5, text: ".pickerStyle(.navigationLink) - pushes a selection screen. Default inside Form on iOS.", color: .cdPurple)
                StepRow(number: 6, text: ".onChange(of: selection) { old, new in } - react to selection changes.", color: .cdPurple)
            }

            CalloutBox(style: .danger, title: "Selection type must match .tag() type", contentBody: "If selection is String but .tag() values are Int, nothing will ever be selected and there's no error. Always use the same type: @State var selection: MyEnum and .tag(MyEnum.value).")

            CodeBlock(code: """
// Enum-backed - cleanest pattern
enum Theme: String, CaseIterable, Identifiable {
    case light, dark, system
    var id: Self { self }
}
@State private var theme: Theme = .system

Picker("Theme", selection: $theme) {
    ForEach(Theme.allCases) { t in
        Text(t.rawValue.capitalized).tag(t)
    }
}
.pickerStyle(.menu)

// In Form - navigationLink by default
Form {
    Picker("Sort by", selection: $sort) {
        ForEach(SortOrder.allCases) { s in
            Text(s.rawValue).tag(s)
        }
    }
}

// React to change
.onChange(of: theme) { old, new in
    applyTheme(new)
}
""")
        }
    }
}
