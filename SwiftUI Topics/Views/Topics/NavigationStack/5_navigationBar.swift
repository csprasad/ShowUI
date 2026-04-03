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
    @State private var path = NavigationPath()
 
    let configs = ["Large title", "Inline", "Hidden", "Custom toolbar"]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Navigation bar", systemImage: "menubar.rectangle")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.navBlue)
 
                // Config selector
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(configs.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedConfig = i
                                path = NavigationPath()
                            }
                        } label: {
                            Text(configs[i])
                                .font(.system(size: 12, weight: selectedConfig == i ? .semibold : .regular))
                                .foregroundStyle(selectedConfig == i ? Color.navBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 8)
                                .background(selectedConfig == i ? Color.navBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
 
                // Live demo
                NavigationStack(path: $path) {
                    navBarDemoContent
                        .navigationDestination(for: String.self) { title in
                            Text("Detail: \(title)")
                                .navigationTitle(title)
                                .navigationBarTitleDisplayMode(.inline)
                        }
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemFill), lineWidth: 1))
            }
        }
    }
 
    @ViewBuilder
    private var navBarDemoContent: some View {
        switch selectedConfig {
        case 0:
            // Large title
            List {
                NavigationLink(value: "Detail") { Text("Tap to navigate") }
            }
            .navigationTitle("Large Title")
            .navigationBarTitleDisplayMode(.large)
 
        case 1:
            // Inline title
            List {
                NavigationLink(value: "Detail") { Text("Tap to navigate") }
            }
            .navigationTitle("Inline Title")
            .navigationBarTitleDisplayMode(.inline)
 
        case 2:
            // Hidden bar
            ZStack {
                Color.navBlueLight
                VStack(spacing: 8) {
                    Text("No navigation bar")
                        .font(.system(size: 16, weight: .semibold))
                    NavigationLink(value: "Detail") {
                        Text("Navigate →")
                            .foregroundStyle(Color.navBlue)
                    }
                }
            }
            .navigationBarHidden(true)
 
        default:
            // Custom toolbar
            List {
                NavigationLink(value: "Detail") { Text("Tap to navigate") }
            }
            .navigationTitle("Custom Toolbar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        Button { } label: { Image(systemName: "magnifyingglass") }
                        Button { } label: { Image(systemName: "plus") }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button { } label: { Image(systemName: "square.and.arrow.up") }
                        Spacer()
                        Button { } label: { Image(systemName: "star") }
                        Spacer()
                        Button { } label: { Image(systemName: "trash") }
                    }
                }
            }
        }
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
