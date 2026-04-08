//
//
//  8_Performance.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Performance & Patterns
struct GridPerformanceVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Lazy vs eager", "ID stability", "Cell anatomy"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Performance & patterns", systemImage: "speedometer")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gridPurple)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.gridPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.gridPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Lazy vs eager diagram
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            performanceCard(
                                title: "LazyVGrid",
                                badge: "Lazy ✓",
                                badgeColor: Color.formGreen,
                                points: [
                                    "Renders visible cells only",
                                    "Cells created on scroll",
                                    "Efficient for 100s of items",
                                    "Inside ScrollView required",
                                ]
                            )
                            performanceCard(
                                title: "VStack + ForEach",
                                badge: "Eager ✗",
                                badgeColor: Color.animCoral,
                                points: [
                                    "Renders ALL cells upfront",
                                    "Slow for large data sets",
                                    "Good for <20 fixed items",
                                    "No ScrollView needed",
                                ]
                            )
                        }
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.right.circle.fill").font(.system(size: 12)).foregroundStyle(Color.gridPurple)
                            Text("Use LazyVGrid for any grid that might grow beyond 20 items")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.gridPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // ID stability
                    VStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 6) {
                            idRow(isGood: false, code: "ForEach(items.indices, id: \\.self)",
                                  desc: "Index as ID - animations break when items reorder")
                            idRow(isGood: false, code: "ForEach(items, id: \\.name)",
                                  desc: "Name as ID - breaks if name changes")
                            idRow(isGood: true, code: "ForEach(items) { }  // Identifiable",
                                  desc: "Stable UUID - correct animations always")
                            idRow(isGood: true, code: "struct Item: Identifiable { let id = UUID() }",
                                  desc: "Add this once, use everywhere")
                        }
                        .padding(10).background(Color(.systemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 12)).foregroundStyle(Color.animAmber)
                            Text("Unstable IDs cause insertion/deletion animations to flash or reorder incorrectly")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color(hex: "#FAEEDA")).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                default:
                    // Cell anatomy best practices
                    VStack(spacing: 8) {
                        HStack(alignment: .top, spacing: 12) {
                            // Good cell
                            VStack(alignment: .leading, spacing: 5) {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill").font(.system(size: 11)).foregroundStyle(Color.formGreen)
                                    Text("Good cell").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.formGreen)
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("• Light weight view").font(.system(size: 10)).foregroundStyle(.secondary)
                                    Text("• No @StateObject").font(.system(size: 10)).foregroundStyle(.secondary)
                                    Text("• Receives data as let").font(.system(size: 10)).foregroundStyle(.secondary)
                                    Text("• .equatable() if static").font(.system(size: 10)).foregroundStyle(.secondary)
                                    Text("• Explicit frame size").font(.system(size: 10)).foregroundStyle(.secondary)
                                }
                            }
                            .padding(10).background(Color(hex: "#E1F5EE")).clipShape(RoundedRectangle(cornerRadius: 10))

                            // Bad cell
                            VStack(alignment: .leading, spacing: 5) {
                                HStack(spacing: 4) {
                                    Image(systemName: "xmark.circle.fill").font(.system(size: 11)).foregroundStyle(Color.animCoral)
                                    Text("Slow cell").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.animCoral)
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("• Complex nested views").font(.system(size: 10)).foregroundStyle(.secondary)
                                    Text("• @StateObject in cell").font(.system(size: 10)).foregroundStyle(.secondary)
                                    Text("• GeometryReader always").font(.system(size: 10)).foregroundStyle(.secondary)
                                    Text("• Heavy .onAppear work").font(.system(size: 10)).foregroundStyle(.secondary)
                                    Text("• Unbounded frame").font(.system(size: 10)).foregroundStyle(.secondary)
                                }
                            }
                            .padding(10).background(Color(hex: "#FCEBEB")).clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
        }
    }

    func performanceCard(title: String, badge: String, badgeColor: Color, points: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title).font(.system(size: 12, weight: .semibold)).foregroundStyle(.primary)
                Spacer()
                Text(badge).font(.system(size: 9, weight: .bold)).foregroundStyle(.white)
                    .padding(.horizontal, 6).padding(.vertical, 2).background(badgeColor).clipShape(Capsule())
            }
            ForEach(points, id: \.self) { pt in
                HStack(alignment: .top, spacing: 4) {
                    Text("·").foregroundStyle(.secondary)
                    Text(pt).font(.system(size: 10)).foregroundStyle(.secondary)
                }
            }
        }
        .padding(10).background(Color(.systemBackground)).clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    func idRow(isGood: Bool, code: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: isGood ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 13)).foregroundStyle(isGood ? Color.formGreen : Color.animCoral)
                .padding(.top, 1)
            VStack(alignment: .leading, spacing: 2) {
                Text(code).font(.system(size: 10, design: .monospaced)).foregroundStyle(isGood ? Color.formGreen : Color.animCoral)
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct GridPerformanceExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Grid performance patterns")
            Text("A grid's performance depends on two things: the laziness of the container (LazyVGrid renders only visible cells), and the stability of cell IDs (stable IDs enable correct animations and prevent unnecessary re-renders).")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "LazyVGrid renders cells only when scrolled into view - critical for 100+ item grids.", color: .gridPurple)
                StepRow(number: 2, text: "Never use index as ID (id: \\.self on indices) - shuffle breaks all animations.", color: .gridPurple)
                StepRow(number: 3, text: "Conform your model to Identifiable with a stable UUID - set it once in the struct definition.", color: .gridPurple)
                StepRow(number: 4, text: "Keep cells lightweight - avoid GeometryReader on every cell unless necessary.", color: .gridPurple)
                StepRow(number: 5, text: ".equatable() on a cell view that receives only value types prevents re-renders when the value hasn't changed.", color: .gridPurple)
            }

            CalloutBox(style: .warning, title: "GeometryReader on every cell is expensive", contentBody: "GeometryReader creates a layout pass for every cell. If you only need square cells, use .aspectRatio(1) instead - it's much cheaper. Only reach for GeometryReader when you genuinely need the exact size value inside the cell.")

            CalloutBox(style: .success, title: ".task(id:) for cell data loading", contentBody: "For grids where each cell loads its own data (e.g. a thumbnail), use .task(id: item.id) inside the cell. It starts the async work when the cell appears, automatically cancels when the cell scrolls off screen, and restarts if the id changes.")

            CodeBlock(code: """
// ✓ Stable ID - Identifiable model
struct Photo: Identifiable {
    let id = UUID()       // stable across app lifetime
    var title: String
    var thumbnailURL: URL
}

// ✓ Efficient cell
struct PhotoCell: View, Equatable {
    let photo: Photo      // value type - equatable

    var body: some View {
        AsyncImage(url: photo.thumbnailURL) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            Color.gray.opacity(0.2)
        }
        .aspectRatio(1, contentMode: .fit)  // no GeometryReader
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// ✓ Main grid
ScrollView {
    LazyVGrid(columns: columns, spacing: 4) {
        ForEach(photos) { photo in
            PhotoCell(photo: photo)
                .equatable()  // skip re-render if photo unchanged
        }
    }
}
""")
        }
    }
}
