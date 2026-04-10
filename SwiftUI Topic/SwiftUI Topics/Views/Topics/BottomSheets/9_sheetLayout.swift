//
//
//  9_sheetLayout.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 9: Sheet Content Layout
struct SheetLayoutVisual: View {
    @State private var showSheet = false
    @State private var selectedLayout = 0
 
    let layouts = ["Safe areas", "Scrollable", "Keyboard aware"]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Sheet content layout", systemImage: "rectangle.and.text.magnifyingglass")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sheetGreen)
 
                // Layout selector
                HStack(spacing: 8) {
                    ForEach(layouts.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedLayout = i }
                        } label: {
                            Text(layouts[i])
                                .font(.system(size: 11, weight: selectedLayout == i ? .semibold : .regular))
                                .foregroundStyle(selectedLayout == i ? Color.sheetGreen : .secondary)
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(selectedLayout == i ? Color.sheetGreenLight : Color(.systemFill))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
 
                // Info callout per layout
                let infos = [
                    "Sheets have their own safe area. .ignoresSafeArea() inside a sheet works independently of the parent.",
                    "Use ScrollView inside sheets for content taller than the detent height. It prevents conflict with the drag gesture.",
                    "Sheets handle keyboard avoidance automatically - content scrolls up when the keyboard appears.",
                ]
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.sheetGreen)
                    Text(infos[selectedLayout]).font(.system(size: 12)).foregroundStyle(.secondary)
                }
                .padding(10).background(Color.sheetGreenLight).clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut(duration: 0.2), value: selectedLayout)
 
                Button {
                    showSheet = true
                } label: {
                    Text("Open demo")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(Color.sheetGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PressableButtonStyle())
                .sheet(isPresented: $showSheet) {
                    layoutSheet
                }
            }
        }
    }
 
    @ViewBuilder
    private var layoutSheet: some View {
        switch selectedLayout {
        case 0:
            SafeAreaDemoSheet()
        case 1:
            ScrollableDemoSheet()
        default:
            KeyboardDemoSheet()
        }
    }
}
 
struct SafeAreaDemoSheet: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            ZStack {
                // This fills to the bottom edge including safe area
                Color.sheetGreenLight.ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("Sheet safe areas")
                        .font(.system(size: 20, weight: .bold))
                    Text("The green background extends to the bottom edge using .ignoresSafeArea(). Sheets have independent safe areas from the parent view.")
                        .font(.system(size: 14)).foregroundStyle(.secondary)
                        .multilineTextAlignment(.center).padding(.horizontal, 24)
                    Spacer()
                }
                .padding(.top, 24)
            }
            .navigationTitle("Safe Areas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
 
struct ScrollableDemoSheet: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(1..<15) { i in
                        HStack(spacing: 12) {
                            Circle().fill(Color.sheetGreen.opacity(0.3)).frame(width: 40, height: 40)
                                .overlay(Text("\(i)").font(.system(size: 14, weight: .bold)).foregroundStyle(Color.sheetGreen))
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Item \(i)").font(.system(size: 14, weight: .semibold))
                                Text("ScrollView handles sheet drag vs scroll conflict")
                                    .font(.system(size: 12)).foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal, 20)
                        Divider().padding(.leading, 72)
                    }
                }
                .padding(.top, 8)
            }
            .navigationTitle("Scrollable Sheet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
 
struct KeyboardDemoSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var text1 = ""
    @State private var text2 = ""
    @State private var text3 = ""
 
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Tap a field - the sheet scrolls to keep it visible above the keyboard")
                        .font(.system(size: 14)).foregroundStyle(.secondary)
                        .multilineTextAlignment(.center).padding(.horizontal, 24)
 
                    ForEach(["Name", "Email", "Message"], id: \.self) { label in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(label).font(.system(size: 13, weight: .semibold)).foregroundStyle(.secondary)
                            TextField(label, text: label == "Name" ? $text1 : label == "Email" ? $text2 : $text3)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding(.horizontal, 20)
                    }
                    Spacer(minLength: 40)
                }
                .padding(.top, 16)
            }
            .navigationTitle("Keyboard Aware")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}

struct SheetLayoutExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Layout inside sheets")
            Text("Sheets have their own layout context, with their own safe areas, their own scroll coordination with the drag gesture, and automatic keyboard avoidance. Understanding these helps avoid common layout bugs.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "Safe areas inside a sheet are independent - .ignoresSafeArea() affects the sheet's own safe area, not the parent.", color: .sheetGreen)
                StepRow(number: 2, text: "ScrollView inside a sheet automatically coordinates with the drag gesture - pull down past the top to dismiss.", color: .sheetGreen)
                StepRow(number: 3, text: "Keyboard avoidance is automatic - sheets scroll content up when the keyboard appears.", color: .sheetGreen)
                StepRow(number: 4, text: ".presentationContentInteraction(.scrolls) - at the smallest detent, scrolling the content expands the sheet instead of scrolling.", color: .sheetGreen)
            }
 
            CalloutBox(style: .success, title: "Always use ScrollView for variable height content", contentBody: "If your sheet content might exceed the detent height, wrap it in a ScrollView. Without it, content clips at the detent boundary and users can't access it.")
 
            CalloutBox(style: .info, title: "NavigationStack inside sheets", contentBody: "Wrapping sheet content in NavigationStack gives you a proper navigation bar with title and toolbar items inside the sheet. It also handles the back button for pushed views within the sheet.")
 
            CodeBlock(code: """
// Scrollable sheet
.sheet(isPresented: $show) {
    NavigationStack {
        ScrollView {
            VStack {
                // Content taller than .medium
                ForEach(items) { item in
                    ItemRow(item: item)
                }
            }
        }
        .navigationTitle("Items")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { dismiss() }
            }
        }
    }
    .presentationDetents([.medium, .large])
}
 
// Scroll vs drag behaviour
.presentationContentInteraction(.scrolls)
// .scrolls: scroll content first, then resize
// .resizes (default): resize first, then scroll
""")
        }
    }
}
 
