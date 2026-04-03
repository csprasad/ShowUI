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
    @State private var selectedPattern = 0
    let patterns = ["Sheet from root", "Sheet from detail", "Sheet with nav"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Sheets in navigation", systemImage: "rectangle.on.rectangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.navBlue)

                HStack(spacing: 8) {
                    ForEach(patterns.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedPattern = i }
                        } label: {
                            Text(patterns[i])
                                .font(.system(size: 11, weight: selectedPattern == i ? .semibold : .regular))
                                .foregroundStyle(selectedPattern == i ? Color.navBlue : .secondary)
                                .padding(.horizontal, 8).padding(.vertical, 6)
                                .background(selectedPattern == i ? Color.navBlueLight : Color(.systemFill))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                ZStack {
                    Color(.secondarySystemBackground)
                    sheetDiagram.padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedPattern)

                let descs = [
                    "The sheet modifier goes on the root content view inside NavigationStack - not on NavigationStack itself. A toolbar button toggles the sheet.",
                    "When navigated to a detail view, that detail view can present its own sheet. The sheet modifier goes on the detail view.",
                    "A sheet can have its own independent NavigationStack inside it - for multi-step flows like onboarding or forms. It's completely separate from the presenting stack.",
                ]
                Text(descs[selectedPattern])
                    .font(.system(size: 12)).foregroundStyle(.secondary).lineSpacing(2)
                    .animation(.easeInOut(duration: 0.2), value: selectedPattern)
            }
        }
    }

    @ViewBuilder
    private var sheetDiagram: some View {
        switch selectedPattern {
        case 0:
            // Sheet from root
            HStack(alignment: .top, spacing: 12) {
                // Stack
                VStack(spacing: 4) {
                    Text("NavigationStack").font(.system(size: 8, weight: .semibold)).foregroundStyle(.secondary)
                    VStack(spacing: 0) {
                        HStack {
                            Text("Root View").font(.system(size: 9, weight: .semibold))
                            Spacer()
                            Image(systemName: "plus").font(.system(size: 9)).foregroundStyle(Color.navBlue)
                        }
                        .padding(.horizontal, 8).padding(.vertical, 5)
                        .background(Color(.systemBackground))
                        .overlay(Divider(), alignment: .bottom)
                        Text(".sheet(isPresented:)")
                            .font(.system(size: 7, design: .monospaced)).foregroundStyle(Color.navBlue)
                            .padding(4)
                        Spacer()
                    }
                    .frame(width: 100, height: 70)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.navBlue.opacity(0.3), lineWidth: 1))
                }

                Image(systemName: "arrow.up.right").font(.system(size: 12)).foregroundStyle(Color.navBlue).padding(.top, 30)

                // Sheet
                VStack(spacing: 4) {
                    Text("Sheet").font(.system(size: 8, weight: .semibold)).foregroundStyle(.secondary)
                    VStack(spacing: 4) {
                        Capsule().fill(Color(.systemGray4)).frame(width: 24, height: 3).padding(.top, 4)
                        Text("Sheet content").font(.system(size: 9))
                        Text("Separate context\nfrom the stack").font(.system(size: 7)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                        Spacer()
                    }
                    .frame(width: 90, height: 70)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(.systemFill), lineWidth: 1))
                }
            }

        case 1:
            // Sheet from detail
            HStack(alignment: .top, spacing: 6) {
                miniScreen("Root", items: ["Item A ›"])
                Image(systemName: "arrow.right").font(.system(size: 10)).foregroundStyle(.secondary).padding(.top, 25)
                VStack(spacing: 4) {
                    Text("Detail View").font(.system(size: 8, weight: .semibold)).foregroundStyle(.secondary)
                    VStack(spacing: 3) {
                        HStack {
                            HStack(spacing: 2) {
                                Image(systemName: "chevron.left").font(.system(size: 7))
                                Text("Back").font(.system(size: 7))
                            }.foregroundStyle(Color.navBlue)
                            Spacer()
                            Image(systemName: "ellipsis").font(.system(size: 9)).foregroundStyle(Color.navBlue)
                        }
                        .padding(.horizontal, 6).padding(.vertical, 4)
                        .background(Color(.systemBackground))
                        .overlay(Divider(), alignment: .bottom)
                        Text(".sheet(isPresented:)").font(.system(size: 7, design: .monospaced)).foregroundStyle(Color.navBlue).padding(3)
                        Text("applied here").font(.system(size: 7)).foregroundStyle(.secondary)
                        Spacer()
                    }
                    .frame(width: 90, height: 65)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.navBlue.opacity(0.3), lineWidth: 1))
                }
                Image(systemName: "arrow.up.right").font(.system(size: 10)).foregroundStyle(Color.navBlue).padding(.top, 25)
                miniSheet("Sheet")
            }

        default:
            // Sheet with own NavigationStack
            HStack(alignment: .top, spacing: 8) {
                VStack(spacing: 4) {
                    Text("App stack").font(.system(size: 8, weight: .semibold)).foregroundStyle(.secondary)
                    miniScreen("Root", items: ["Open →"])
                }
                Image(systemName: "arrow.up.right").font(.system(size: 10)).foregroundStyle(Color.navBlue).padding(.top, 20)
                VStack(spacing: 4) {
                    Text("Sheet (independent)").font(.system(size: 8, weight: .semibold)).foregroundStyle(.secondary)
                    VStack(spacing: 0) {
                        Capsule().fill(Color(.systemGray4)).frame(width: 20, height: 2).padding(.top, 3)
                        HStack {
                            Spacer()
                            Text("Cancel").font(.system(size: 7)).foregroundStyle(Color.navBlue)
                        }
                        .padding(.horizontal, 6).padding(.vertical, 3)
                        .background(Color(.systemBackground))
                        .overlay(Divider(), alignment: .bottom)
                        HStack {
                            Text("Step 1").font(.system(size: 8))
                            Spacer()
                            Image(systemName: "arrow.right.circle").font(.system(size: 10)).foregroundStyle(Color.navBlue)
                        }
                        .padding(.horizontal, 6).padding(.vertical, 3)
                        Text("NavigationStack").font(.system(size: 7, design: .monospaced)).foregroundStyle(Color.navBlue)
                        Text("inside sheet").font(.system(size: 7)).foregroundStyle(.secondary)
                        Spacer()
                    }
                    .frame(width: 110, height: 70)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.navBlue.opacity(0.3), lineWidth: 1))
                }
            }
        }
    }

    func miniScreen(_ title: String, items: [String] = []) -> some View {
        VStack(spacing: 0) {
            Text(title).font(.system(size: 9, weight: .semibold))
                .padding(.horizontal, 6).padding(.vertical, 4)
                .background(Color(.systemBackground))
                .overlay(Divider(), alignment: .bottom)
                .frame(maxWidth: .infinity)
            ForEach(items.prefix(2), id: \.self) { item in
                Text(item).font(.system(size: 9)).padding(.horizontal, 6).padding(.vertical, 3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider().padding(.leading, 6)
            }
            Spacer()
        }
        .frame(width: 80, height: 65)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(.systemFill), lineWidth: 0.5))
    }

    func miniSheet(_ title: String) -> some View {
        VStack(spacing: 3) {
            Capsule().fill(Color(.systemGray4)).frame(width: 20, height: 2).padding(.top, 3)
            Text(title).font(.system(size: 9, weight: .semibold))
            Text("Sheet content").font(.system(size: 8)).foregroundStyle(.secondary)
            Spacer()
        }
        .frame(width: 80, height: 65)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(.systemFill), lineWidth: 0.5))
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
