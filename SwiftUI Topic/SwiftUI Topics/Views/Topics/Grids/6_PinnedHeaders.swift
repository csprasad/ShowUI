//
//
//  6_PinnedHeaders.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Pinned Headers
struct PinnedHeadersVisual: View {
    @State private var usePinned = true
    @State private var selectedSection = 0

    let sections: [(title: String, color: Color, items: [GridItem_Data])] = [
        ("Featured",  Color(hex: "#7E22CE"), GridItem_Data.samples(6)),
        ("Popular",   Color(hex: "#1D4ED8"), GridItem_Data.samples(8)),
        ("Recent",    Color(hex: "#0F766E"), GridItem_Data.samples(6)),
    ]

    let columns = Array(repeating: SwiftUI.GridItem(.flexible(), spacing: 6), count: 3)

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Pinned headers", systemImage: "pin.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gridPurple)

                HStack(spacing: 12) {
                    Toggle("Pin headers", isOn: $usePinned).tint(.gridPurple).font(.system(size: 13))
                    Spacer()
                    Text(usePinned ? "Scroll - headers stay sticky" : "Scroll - headers move with content")
                        .font(.system(size: 11)).foregroundStyle(.secondary)
                }
                .padding(10).background(Color.gridPurpleLight).clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut(duration: 0.2), value: usePinned)

                // Grid with sections
                ScrollView {
                    LazyVGrid(
                        columns: columns,
                        spacing: 6,
                        pinnedViews: usePinned ? [.sectionHeaders] : []
                    ) {
                        ForEach(sections.indices, id: \.self) { sIdx in
                            let section = sections[sIdx]
                            Section {
                                ForEach(section.items) { item in
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(section.color.opacity(0.7 + Double(item.index % 3) * 0.1))
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay(Text(item.label).font(.system(size: 10, weight: .semibold)).foregroundStyle(.white))
                                }
                            } header: {
                                HStack(spacing: 8) {
                                    Circle().fill(section.color).frame(width: 8, height: 8)
                                    Text(section.title)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(section.color)
                                    Spacer()
                                    Text("\(section.items.count) items")
                                        .font(.system(size: 11)).foregroundStyle(.secondary)
                                }
                                .padding(.horizontal, 12).padding(.vertical, 8)
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .padding(.horizontal, 2)
                }
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemFill), lineWidth: 0.5))
                .animation(.spring(response: 0.35), value: usePinned)
            }
        }
    }
}

struct PinnedHeadersExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Pinned section headers")
            Text("pinnedViews on LazyVGrid and LazyHGrid makes section headers (and footers) stick to the top of the scroll view as you scroll past their section - exactly like the Contacts app header behavior.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "LazyVGrid(columns:spacing:pinnedViews: [.sectionHeaders]) - pass the set of views to pin.", color: .gridPurple)
                StepRow(number: 2, text: "Wrap content in Section { cells } header: { headerView } - the header view is what gets pinned.", color: .gridPurple)
                StepRow(number: 3, text: ".sectionFooters - also valid. Both can be pinned: [.sectionHeaders, .sectionFooters].", color: .gridPurple)
                StepRow(number: 4, text: "Give headers .background(.regularMaterial) so they look correct when content slides behind.", color: .gridPurple)
                StepRow(number: 5, text: "Pinned headers work in LazyVGrid, LazyHGrid, and List.", color: .gridPurple)
            }

            CalloutBox(style: .success, title: "Material background on pinned headers", contentBody: "When a pinned header sits above scrolling content, use .background(.regularMaterial) on the header view. This gives the frosted-glass look that makes it clear content is scrolling behind it.")

            CodeBlock(code: """
LazyVGrid(
    columns: columns,
    spacing: 8,
    pinnedViews: [.sectionHeaders]  // pin headers
) {
    ForEach(sections) { section in
        Section {
            // Grid cells
            ForEach(section.items) { item in
                CellView(item: item)
            }
        } header: {
            // This view sticks to the top
            HStack {
                Text(section.title).fontWeight(.semibold)
                Spacer()
                Text("\\(section.items.count)")
            }
            .padding(12)
            .background(.regularMaterial)  // frosted glass
        }
    }
}

// Also works for footers
pinnedViews: [.sectionHeaders, .sectionFooters]
""")
        }
    }
}

