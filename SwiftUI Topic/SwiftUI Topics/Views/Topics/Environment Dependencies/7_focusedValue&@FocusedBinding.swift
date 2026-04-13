//
//
//  7_focusedValue&@FocusedBinding.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: focusedValue & @FocusedBinding
struct FocusedDocument: Equatable {
    var title: String
    var wordCount: Int
    var hasUnsavedChanges: Bool
}

struct FocusedValueVisual: View {
    @State private var selectedDemo = 0
    @State private var doc1 = FocusedDocument(title: "README.md", wordCount: 342, hasUnsavedChanges: false)
    @State private var doc2 = FocusedDocument(title: "Notes.txt",   wordCount: 87,  hasUnsavedChanges: true)
    @State private var activeDoc = 0
    let demos = ["focused Value", "focused SceneValue", "Use cases"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("focusedValue & @FocusedBinding", systemImage: "scope")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.envGreen)
                    Spacer()
                    Text("macOS / iPadOS").font(.system(size: 9, weight: .semibold)).foregroundStyle(Color.envGreen)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.envGreenLight).clipShape(Capsule())
                }

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.envGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.envGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // focusedValue demo - select doc, toolbar reads it
                    VStack(spacing: 10) {
                        Text("Active document drives the toolbar command").font(.system(size: 11)).foregroundStyle(.secondary)

                        // Document panels - tap to make active
                        HStack(spacing: 8) {
                            docPanel(doc: $doc1, index: 0)
                            docPanel(doc: $doc2, index: 1)
                        }

                        // "Toolbar" reads the active document
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                Image(systemName: "menubar.rectangle").foregroundStyle(Color.envGreen).font(.system(size: 12))
                                Text("Toolbar (reads focusedValue)").font(.system(size: 11, weight: .semibold))
                            }
                            let doc = activeDoc == 0 ? doc1 : doc2
                            HStack(spacing: 12) {
                                Label(doc.title, systemImage: "doc.fill").font(.system(size: 12)).foregroundStyle(Color.envGreen)
                                Text("\(doc.wordCount) words").font(.system(size: 11)).foregroundStyle(.secondary)
                                if doc.hasUnsavedChanges {
                                    Text("● Unsaved").font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.animAmber)
                                }
                                Spacer()
                                Button("Save") {
                                    if activeDoc == 0 { doc1.hasUnsavedChanges = false }
                                    else { doc2.hasUnsavedChanges = false }
                                }
                                .font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
                                .padding(.horizontal, 12).padding(.vertical, 5)
                                .background(Color.envGreen).clipShape(RoundedRectangle(cornerRadius: 7))
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                        .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

                        PlainCodeBlock(fgColor: Color.envGreen, bgColor: Color.envGreenLight, code:"// Document view publishes focused value:\n.focusedValue(\\.document, doc)\n\n// Toolbar reads it:\n@FocusedValue(\\.document) var document: Doc?\nText(document?.title ?? \"None\")")
                    }

                case 1:
                    // focusedSceneValue
                    VStack(spacing: 8) {
                        PlainCodeBlock(fgColor: Color.envGreen, bgColor: Color.envGreenLight, code: """
// focusedSceneValue - window-scoped
// Same as focusedValue but scoped to the window

struct DocumentCommands: Commands {
    @FocusedValue(\\.document) var doc: Doc?

    var body: some Commands {
        CommandMenu("Document") {
            Button("Save") {
                doc?.save()
            }
            .disabled(doc == nil || !doc!.hasChanges)
            .keyboardShortcut("s")

            Button("Export…") {
                doc?.export()
            }
            .disabled(doc == nil)
            .keyboardShortcut("e", modifiers: [.command, .shift])
        }
    }
}

// Declare the focused value key
struct DocumentFocusedKey: FocusedValueKey {
    typealias Value = DocumentViewModel
}
extension FocusedValues {
    var document: DocumentViewModel? {
        get { self[DocumentFocusedKey.self] }
        set { self[DocumentFocusedKey.self] = newValue }
    }
}
""")
                    }

                default:
                    // Use cases
                    VStack(spacing: 8) {
                        useCaseRow(icon: "menubar.rectangle",       title: "Menu commands",       desc: "Commands bar reads focused window's data to enable/disable menu items like Save, Export, Undo")
                        useCaseRow(icon: "keyboard.badge.eye",      title: "Keyboard shortcuts",  desc: ".keyboardShortcut on commands that operate on the focused document or selection")
                        useCaseRow(icon: "rectangle.2.swap",        title: "Multi-window",        desc: "iPadOS split view - each window has its own focused value, toolbar adapts per window")
                        useCaseRow(icon: "sidebar.leading",         title: "Inspector panel",     desc: "Inspector reads the selection from the focused content area to show relevant properties")
                        useCaseRow(icon: "iphone.gen3.landscape",   title: "iOS rare",            desc: "Less common on iOS - mainly useful in split-view or multi-scene iPad apps")
                    }
                }
            }
        }
    }

    func docPanel(doc: Binding<FocusedDocument>, index: Int) -> some View {
        let isActive = activeDoc == index
        return VStack(spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "doc.fill").font(.system(size: 13)).foregroundStyle(isActive ? Color.envGreen : .secondary)
                Text(doc.wrappedValue.title).font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(isActive ? Color.envGreen : .primary)
                if doc.wrappedValue.hasUnsavedChanges {
                    Circle().fill(Color.animAmber).frame(width: 6, height: 6)
                }
            }
            Text("\(doc.wrappedValue.wordCount) words").font(.system(size: 10)).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity).padding(10)
        .background(isActive ? Color.envGreen.opacity(0.1) : Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(isActive ? Color.envGreen : Color.clear, lineWidth: 1.5))
        .onTapGesture { withAnimation(.spring(response: 0.25)) { activeDoc = index } }
        .animation(.spring(response: 0.25), value: isActive)
    }

    func useCaseRow(icon: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon).font(.system(size: 14)).foregroundStyle(Color.envGreen).frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 11, weight: .semibold))
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(Color.envGreenLight.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct FocusedValueExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "focusedValue - window-scoped publishing")
            Text(".focusedValue publishes a value for the focused window so Commands, menu bar items, and keyboard shortcut handlers can read it. Essential for document-based macOS/iPadOS apps where menus must reflect the current window's state.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Declare FocusedValueKey + FocusedValues extension - same pattern as EnvironmentKey.", color: .envGreen)
                StepRow(number: 2, text: ".focusedValue(\\.myKey, value) on the focused view - publishes when that view is focused.", color: .envGreen)
                StepRow(number: 3, text: "@FocusedValue(\\.myKey) var value: T? - reads in Commands, toolbars. Nil when nothing focused.", color: .envGreen)
                StepRow(number: 4, text: ".focusedSceneValue - publishes for the whole scene regardless of focused subview.", color: .envGreen)
                StepRow(number: 5, text: "Use to enable/disable menu commands based on document state (.disabled(doc == nil)).", color: .envGreen)
            }

            CodeBlock(code: """
// 1. Declare the key
struct DocKey: FocusedValueKey {
    typealias Value = Document
}
extension FocusedValues {
    var document: Document? {
        get { self[DocKey.self] }
        set { self[DocKey.self] = newValue }
    }
}

// 2. Publish from content view
DocumentEditor(doc: $doc)
    .focusedValue(\\.document, doc)
    // OR scene-level:
    .focusedSceneValue(\\.document, doc)

// 3. Read in Commands
struct AppCommands: Commands {
    @FocusedValue(\\.document) var doc: Document?

    var body: some Commands {
        CommandGroup(after: .saveItem) {
            Button("Export PDF") { doc?.exportPDF() }
                .disabled(doc == nil)
                .keyboardShortcut("p", modifiers: [.command, .shift])
        }
    }
}
""")
        }
    }
}
