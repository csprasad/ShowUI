//
//
//  7_sheetsInNavigation.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `03/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
 
// MARK: - LESSON 7: Sheets Inside Navigation
 
struct SheetsInNavVisual: View {
    @State private var path = NavigationPath()
    @State private var showSheet = false
    @State private var showCover = false
    @State private var selectedPattern = 0
 
    let patterns = ["Sheet from list", "Sheet from detail", "Full screen cover"]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Sheets in navigation", systemImage: "rectangle.on.rectangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.navBlue)
 
                // Pattern selector
                HStack(spacing: 8) {
                    ForEach(patterns.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedPattern = i
                                path = NavigationPath()
                            }
                        } label: {
                            Text(patterns[i])
                                .font(.system(size: 10, weight: selectedPattern == i ? .semibold : .regular))
                                .foregroundStyle(selectedPattern == i ? Color.navBlue : .secondary)
                                .padding(.horizontal, 8).padding(.vertical, 5)
                                .background(selectedPattern == i ? Color.navBlueLight : Color(.systemFill))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
 
                // Demo
                NavigationStack(path: $path) {
                    List(NavCategory.samples) { cat in
                        NavigationLink(value: cat) {
                            Label(cat.name, systemImage: cat.icon).foregroundStyle(cat.color)
                        }
                    }
                    .navigationTitle("Topics")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        if selectedPattern == 0 {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    showSheet = true
                                } label: {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                    }
                    // Sheet on the LIST (root) — correct placement
                    .sheet(isPresented: $showSheet) {
                        sheetContent("Sheet from list root")
                    }
                    .navigationDestination(for: NavCategory.self) { cat in
                        // Detail view
                        detailView(cat)
                    }
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemFill), lineWidth: 1))
 
                // Pattern notes
                let notes = [
                    "Toolbar '+' button on the root opens a sheet. The sheet modifier is on the List, inside NavigationStack.",
                    "Navigate into a detail view - the '+' button there opens a sheet. Sheet modifier on the detail view.",
                    "Navigate into a detail - the cover button opens fullScreenCover. Applied on the detail view.",
                ]
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.navBlue)
                    Text(notes[selectedPattern]).font(.system(size: 12)).foregroundStyle(.secondary)
                }
                .padding(10).background(Color.navBlueLight).clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut(duration: 0.2), value: selectedPattern)
            }
        }
    }
 
    @ViewBuilder
    func detailView(_ cat: NavCategory) -> some View {
        List(cat.items) { item in
            Label(item.name, systemImage: item.icon)
        }
        .navigationTitle(cat.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if selectedPattern == 1 || selectedPattern == 2 {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if selectedPattern == 2 { showCover = true }
                        else { showSheet = true }
                    } label: {
                        Image(systemName: selectedPattern == 2 ? "arrow.up.left.and.arrow.down.right" : "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            sheetContent("Sheet from \(cat.name)")
        }
        .fullScreenCover(isPresented: $showCover) {
            sheetContent("Full screen from \(cat.name)", isFullScreen: true)
        }
    }
 
    func sheetContent(_ title: String, isFullScreen: Bool = false) -> some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: isFullScreen ? "rectangle.fill" : "rectangle.bottomhalf.inset.filled")
                    .font(.system(size: 48)).foregroundStyle(Color.navBlue)
                Text(title).font(.system(size: 20, weight: .bold))
                Text("This is a separate navigation context — it has its own NavigationStack if needed")
                    .font(.system(size: 13)).foregroundStyle(.secondary)
                    .multilineTextAlignment(.center).padding(.horizontal, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { showSheet = false; showCover = false }
                }
            }
        }
    }
}
 
struct SheetsInNavExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Sheets inside NavigationStack")
            Text("Sheets and NavigationStack coexist cleanly - a sheet creates a new independent presentation context, separate from the navigation stack. The sheet can have its own NavigationStack inside it if needed.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "Apply .sheet on the view inside NavigationStack that shows the toolbar button - not on the NavigationStack itself.", color: .navBlue)
                StepRow(number: 2, text: "A sheet presented from inside a navigation stack is a separate presentation - it doesn't push onto the stack.", color: .navBlue)
                StepRow(number: 3, text: "Wrap sheet content in NavigationStack { } if the sheet needs its own navigation hierarchy.", color: .navBlue)
                StepRow(number: 4, text: "fullScreenCover works the same way - it's a separate context from the navigation stack.", color: .navBlue)
            }
 
            CalloutBox(style: .warning, title: "Don't put .sheet on NavigationStack", contentBody: "Attaching .sheet to NavigationStack instead of its content causes the sheet to appear and disappear unexpectedly during navigation. Always attach it to the specific view that presents the sheet - usually the one with the toolbar button.")
 
            CalloutBox(style: .info, title: "Sheet with its own navigation", contentBody: "A common pattern: a sheet that contains a multi-step form or flow. Wrap the sheet content in NavigationStack to push between steps within the sheet, independent of the presenting stack.")
 
            CodeBlock(code: """
// ✓ Sheet on the content view - correct
NavigationStack {
    ListView()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") { showSheet = true }
            }
        }
        .sheet(isPresented: $showSheet) {   // ← on ListView, not NavigationStack
            AddItemSheet()
        }
        .navigationDestination(for: Item.self) { item in
            DetailView(item: item)
                .sheet(isPresented: $showEditSheet) {
                    EditItemSheet(item: item)  // ← on detail view
                }
        }
}
 
// Sheet with its own navigation hierarchy
.sheet(isPresented: $showSheet) {
    NavigationStack {          // ← independent stack inside sheet
        OnboardingStep1()
            .navigationDestination(for: Int.self) { step in
                OnboardingStep(number: step)
            }
    }
}
""")
        }
    }
}
