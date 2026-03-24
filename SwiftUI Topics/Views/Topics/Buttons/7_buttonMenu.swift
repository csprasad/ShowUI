//
//
//  7_buttonMenu.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Menu Button
struct MenuButtonVisual: View {
    @State private var selectedSort = "Date"
    @State private var lastAction = "Nothing yet"
 
    let sortOptions = ["Date", "Name", "Size", "Type"]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Menu button", systemImage: "ellipsis.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.btnPurple)
 
                // Last action
                HStack(spacing: 6) {
                    Image(systemName: "return").font(.system(size: 11)).foregroundStyle(.secondary)
                    Text(lastAction).font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
 
                // Basic Menu
                HStack(spacing: 10) {
                    Menu {
                        Button {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { lastAction = "Opened share sheet" }
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        Button {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { lastAction = "Duplicated" }
                        } label: {
                            Label("Duplicate", systemImage: "doc.on.doc")
                        }
                        Divider()
                        Button(role: .destructive) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { lastAction = "Deleted" }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(Color.btnPurple)
                    }
 
                    Text("Basic menu")
                        .font(.system(size: 13)).foregroundStyle(.secondary)
                    Spacer()
                }
 
                Divider()
 
                // Picker menu for sort
                HStack(spacing: 10) {
                    Menu {
                        Picker("Sort by", selection: $selectedSort) {
                            ForEach(sortOptions, id: \.self) { option in
                                Label(option, systemImage: sortIcon(option)).tag(option)
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 13))
                            Text("Sort: \(selectedSort)")
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundStyle(Color.btnPurple)
                        .padding(.horizontal, 12).padding(.vertical, 7)
                        .background(Color.btnPurpleLight)
                        .clipShape(Capsule())
                    }
                    Spacer()
                }
 
                Divider()
 
                // Submenu
                HStack(spacing: 10) {
                    Menu {
                        Button {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { lastAction = "Export as PDF" }
                        } label: {
                            Label("PDF", systemImage: "doc.richtext")
                        }
                        Menu("Export as...") {
                            Button {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { lastAction = "Export as PNG" }
                            } label: {
                                Label("PNG Image", systemImage: "photo")
                            }
                            Button {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { lastAction = "Export as CSV" }
                            } label: {
                                Label("CSV Spreadsheet", systemImage: "tablecells")
                            }
                            Button {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { lastAction = "Export as JSON" }
                            } label: {
                                Label("JSON Data", systemImage: "curlybraces")
                            }
                        }
                        Divider()
                        Button(role: .destructive) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { lastAction = "Cleared all" }
                        } label: {
                            Label("Clear all", systemImage: "trash")
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Text("With submenu")
                                .font(.system(size: 13, weight: .medium))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .foregroundStyle(Color.btnPurple)
                        .padding(.horizontal, 12).padding(.vertical, 7)
                        .background(Color.btnPurpleLight)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    Spacer()
                }
            }
        }
    }
 
    func sortIcon(_ option: String) -> String {
        switch option {
        case "Date": return "calendar"
        case "Name": return "textformat"
        case "Size": return "arrow.up.and.down"
        default: return "tag"
        }
    }
}


struct MenuButtonExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Menu buttons")
            Text("Menu presents a contextual list of actions when tapped. Unlike confirmationDialog, Menu is non-destructive by nature, it's a discovery tool. The label can be any view, whether it's an icon, a text+chevron, or a full button.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: "Menu { actions } label: { view } - the label is tappable, the content is the action list.", color: .btnPurple)
                StepRow(number: 2, text: "Button, Picker, and nested Menu all work inside the menu content.", color: .btnPurple)
                StepRow(number: 3, text: "Divider() adds a visual separator between action groups.", color: .btnPurple)
                StepRow(number: 4, text: "Picker inside Menu renders as a grouped selection - no extra styling needed.", color: .btnPurple)
                StepRow(number: 5, text: "Nested Menu creates submenus, useful for Export As... style patterns.", color: .btnPurple)
            }
 
            CalloutBox(style: .success, title: "Picker in Menu is underused", contentBody: "Wrapping a Picker in a Menu gives you a compact sort/filter control that takes zero screen space when closed. It's one of SwiftUI's most underused patterns.")
 
            CalloutBox(style: .info, title: "menuOrder and primaryAction", contentBody: ".menuOrder(.fixed) preserves your ordering. Menu can also take a primaryAction, which is triggered by a long press or secondary tap. When a direct tap fires the primary action while a long press or secondary tap opens the menu.")
 
            CodeBlock(code: """
// Basic menu
Menu {
    Button("Share") { share() }
    Button("Duplicate") { duplicate() }
    Divider()
    Button(role: .destructive) { delete() } label: {
        Label("Delete", systemImage: "trash")
    }
} label: {
    Image(systemName: "ellipsis.circle.fill")
}
 
// Picker menu - sort control
Menu {
    Picker("Sort by", selection: $sortOrder) {
        Text("Date").tag(SortOrder.date)
        Text("Name").tag(SortOrder.name)
        Text("Size").tag(SortOrder.size)
    }
} label: {
    Label("Sort", systemImage: "arrow.up.arrow.down")
}
 
// Primary action + menu on long press
Menu {
    Button("Open in Safari") { openSafari() }
    Button("Copy link") { copyLink() }
} label: {
    Text("Visit site")
} primaryAction: {
    openInApp()
}
""")
        }
    }
}
 
