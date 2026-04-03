//
//
//  5_navigationBar.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `03/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
 
// MARK: - LESSON 5: Navigation Bar
struct NavBarVisual: View {
    @State private var selectedConfig = 0
    @State private var selectedPlacement = 0

    let configs = ["Large title", "Inline", "Hidden bar", "Custom toolbar"]
    let placements = [".navigationBarTrailing", ".navigationBarLeading", ".principal", ".bottomBar"]
    let placementDescs = ["Right side - Add, Edit, Done", "Left side - menu, back override", "Center - title with icon", "Bottom bar - bulk actions"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Navigation bar", systemImage: "menubar.rectangle")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.navBlue)

                // Title mode selector
                let cols = Array(repeating: GridItem(.flexible(), spacing: 6), count: 2)
                LazyVGrid(columns: cols, spacing: 6) {
                    ForEach(configs.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedConfig = i }
                        } label: {
                            Text(configs[i])
                                .font(.system(size: 11, weight: selectedConfig == i ? .semibold : .regular))
                                .foregroundStyle(selectedConfig == i ? Color.navBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedConfig == i ? Color.navBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Mock screen showing selected config
                ZStack {
                    Color(.secondarySystemBackground)
                    navBarMock
                }
                .frame(maxWidth: .infinity).frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: selectedConfig)

                // Toolbar placement reference
                VStack(alignment: .leading, spacing: 6) {
                    Text("Toolbar placements")
                        .font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                    ForEach(placements.indices, id: \.self) { i in
                        HStack(spacing: 8) {
                            Text(placements[i])
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundStyle(Color.navBlue)
                                .frame(width: 155, alignment: .leading)
                            Text(placementDescs[i])
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(10)
                .background(Color.navBlueLight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    @ViewBuilder
    private var navBarMock: some View {
        VStack(spacing: 0) {
            switch selectedConfig {
            case 0:
                // Large title
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button { } label: { Image(systemName: "plus").font(.system(size: 12)) }
                    }
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(Color(.systemBackground).opacity(0.9))
                    .overlay(Divider(), alignment: .bottom)
                    HStack {
                        Text("Large Title")
                            .font(.system(size: 22, weight: .bold))
                        Spacer()
                    }
                    .padding(.horizontal, 12).padding(.top, 4)
                    Divider()
                    HStack { Text("Item 1").font(.system(size: 12)); Spacer(); Image(systemName: "chevron.right").font(.system(size: 9)).foregroundStyle(.tertiary) }
                        .padding(.horizontal, 12).padding(.vertical, 6)
                    Divider()
                    Spacer()
                }

            case 1:
                // Inline
                VStack(spacing: 0) {
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left").font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.navBlue)
                            Text("Back").font(.system(size: 11)).foregroundStyle(Color.navBlue)
                        }
                        Spacer()
                        Text("Inline Title").font(.system(size: 13, weight: .semibold))
                        Spacer()
                        Button { } label: { Text("Edit").font(.system(size: 11)).foregroundStyle(Color.navBlue) }
                    }
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(Color(.systemBackground).opacity(0.9))
                    .overlay(Divider(), alignment: .bottom)
                    HStack { Text("Content here").font(.system(size: 12)).foregroundStyle(.secondary); Spacer() }
                        .padding(.horizontal, 12).padding(.vertical, 8)
                    Spacer()
                }

            case 2:
                // Hidden bar
                ZStack {
                    Color.navBlueLight
                    VStack(spacing: 8) {
                        Text("No navigation bar").font(.system(size: 13, weight: .semibold)).foregroundStyle(Color.navBlue)
                        Text(".navigationBarHidden(true)").font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                        Text("Provide your own back/close control").font(.system(size: 10)).foregroundStyle(.tertiary)
                    }
                }

            default:
                // Custom toolbar
                VStack(spacing: 0) {
                    HStack {
                        Button { } label: { Image(systemName: "line.3.horizontal").font(.system(size: 13)).foregroundStyle(Color.navBlue) }
                        Spacer()
                        Text("Custom").font(.system(size: 13, weight: .semibold))
                        Spacer()
                        HStack(spacing: 10) {
                            Button { } label: { Image(systemName: "magnifyingglass").font(.system(size: 12)).foregroundStyle(Color.navBlue) }
                            Button { } label: { Image(systemName: "plus").font(.system(size: 12)).foregroundStyle(Color.navBlue) }
                        }
                    }
                    .padding(.horizontal, 10).padding(.vertical, 7)
                    .background(Color(.systemBackground).opacity(0.9))
                    .overlay(Divider(), alignment: .bottom)
                    Spacer()
                    // Bottom bar
                    Divider()
                    HStack {
                        Button { } label: { Image(systemName: "square.and.arrow.up").font(.system(size: 13)).foregroundStyle(Color.navBlue) }
                        Spacer()
                        Button { } label: { Image(systemName: "star").font(.system(size: 13)).foregroundStyle(Color.navBlue) }
                        Spacer()
                        Button { } label: { Image(systemName: "trash").font(.system(size: 13)).foregroundStyle(Color.animCoral) }
                    }
                    .padding(.horizontal, 20).padding(.vertical, 6)
                    .background(Color(.systemBackground).opacity(0.9))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

struct NavBarExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Navigation bar & toolbar")
            Text("The navigation bar is configured by modifiers applied inside NavigationStack - on the content view, not on the stack itself. Toolbar items are placed using .toolbar { } with explicit placement values.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: ".navigationTitle(\"...\") - sets the title text. Apply on the content view inside the stack.", color: .navBlue)
                StepRow(number: 2, text: ".navigationBarTitleDisplayMode(.large / .inline / .automatic) - large shows a big title on scroll up, inline stays compact.", color: .navBlue)
                StepRow(number: 3, text: ".toolbar { ToolbarItem(placement:) } - add buttons to leading, trailing, bottom, or principal position.", color: .navBlue)
                StepRow(number: 4, text: ".navigationBarBackButtonHidden(true) - hides the back button. Provide your own dismiss control.", color: .navBlue)
                StepRow(number: 5, text: ".toolbarBackground(.visible, for: .navigationBar) - forces the bar background visible even when at the top.", color: .navBlue)
            }
 
            CalloutBox(style: .info, title: "Toolbar placement options", contentBody: ".navigationBarLeading, .navigationBarTrailing, .principal (center), .bottomBar, .keyboard (above keyboard), .confirmationAction, .cancellationAction, .destructiveAction.")
 
            CalloutBox(style: .warning, title: "Each screen sets its own bar", contentBody: "When you navigate to a detail view, its .navigationTitle and .toolbar modifiers replace the previous screen's bar. The back button is added automatically - you don't configure it in the destination.")
 
            CodeBlock(code: """
List(items) { item in
    NavigationLink(value: item) { Text(item.name) }
}
.navigationTitle("My List")
.navigationBarTitleDisplayMode(.large)
.toolbar {
    // Right side button
    ToolbarItem(placement: .navigationBarTrailing) {
        Button("Add") { showAddSheet = true }
    }
 
    // Left side button
    ToolbarItem(placement: .navigationBarLeading) {
        EditButton()
    }
 
    // Bottom bar - shows below the content
    ToolbarItem(placement: .bottomBar) {
        HStack {
            Button("Share") { }
            Spacer()
            Button("Delete") { }
                .foregroundStyle(.red)
        }
    }
}
 
// Force bar background visible
.toolbarBackground(.visible, for: .navigationBar)
.toolbarBackground(Color.blue, for: .navigationBar)
""")
        }
    }
}
