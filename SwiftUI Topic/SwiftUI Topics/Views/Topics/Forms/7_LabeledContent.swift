//
//
//  7_LabeledContent.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: LabeledContent, GroupBox, DisclosureGroup
struct LabeledContentVisual: View {
    @State private var selectedDemo = 0
    @State private var isExpanded = true
    @State private var isAdvancedExpanded = false

    let demos = ["LabeledContent", "GroupBox", "DisclosureGroup"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("LabeledContent & GroupBox", systemImage: "sidebar.squares.leading")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.formGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 10, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.formGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.formGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // LabeledContent
                    VStack(spacing: 0) {
                        labeledRow("Plan", value: "Pro")
                        Divider().padding(.leading, 16)
                        labeledRow("Storage", value: "12.4 GB / 50 GB")
                        Divider().padding(.leading, 16)
                        labeledRow("Member since", value: "June 2022")
                        Divider().padding(.leading, 16)
                        // Custom value view
                        HStack {
                            Text("Status").font(.system(size: 14))
                            Spacer()
                            HStack(spacing: 4) {
                                Circle().fill(Color.formGreen).frame(width: 7, height: 7)
                                Text("Active").font(.system(size: 14)).foregroundStyle(Color.formGreen)
                            }
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                    }
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                case 1:
                    // GroupBox
                    VStack(spacing: 10) {
                        GroupBox {
                            VStack(alignment: .leading, spacing: 8) {
                                Toggle("Enable analytics", isOn: .constant(true))
                                    .tint(.formGreen).font(.system(size: 13))
                                Toggle("Crash reports", isOn: .constant(true))
                                    .tint(.formGreen).font(.system(size: 13))
                                Toggle("Usage data", isOn: .constant(false))
                                    .tint(.formGreen).font(.system(size: 13))
                            }
                        } label: {
                            Label("Data & Privacy", systemImage: "lock.shield.fill")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color.formGreen)
                        }

                        GroupBox {
                            HStack(spacing: 12) {
                                VStack(spacing: 4) {
                                    Text("24").font(.system(size: 22, weight: .bold)).foregroundStyle(Color.formGreen)
                                    Text("Sessions").font(.system(size: 10)).foregroundStyle(.secondary)
                                }
                                Divider()
                                VStack(spacing: 4) {
                                    Text("4.8h").font(.system(size: 22, weight: .bold)).foregroundStyle(Color.formGreen)
                                    Text("Total time").font(.system(size: 10)).foregroundStyle(.secondary)
                                }
                                Divider()
                                VStack(spacing: 4) {
                                    Text("142").font(.system(size: 22, weight: .bold)).foregroundStyle(Color.formGreen)
                                    Text("Actions").font(.system(size: 10)).foregroundStyle(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        } label: {
                            Label("Your Activity", systemImage: "chart.bar.fill")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color.formGreen)
                        }
                    }

                default:
                    // DisclosureGroup
                    VStack(spacing: 8) {
                        DisclosureGroup(isExpanded: $isExpanded) {
                            VStack(alignment: .leading, spacing: 6) {
                                labeledRow("Username", value: "alice_dev")
                                Divider().padding(.leading, 16)
                                labeledRow("Email", value: "alice@dev.io")
                            }
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        } label: {
                            Label("Account info", systemImage: "person.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.formGreen)
                        }
                        .padding(10)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                        DisclosureGroup(isExpanded: $isAdvancedExpanded) {
                            VStack(alignment: .leading, spacing: 6) {
                                labeledRow("API endpoint", value: "v2.api.dev.io")
                                Divider().padding(.leading, 16)
                                labeledRow("Debug mode", value: "Off")
                            }
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        } label: {
                            Label("Advanced", systemImage: "wrench.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                        .padding(10)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                    }
                }
            }
        }
    }

    func labeledRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label).font(.system(size: 14))
            Spacer()
            Text(value).font(.system(size: 14)).foregroundStyle(.secondary)
        }
        .padding(.horizontal, 14).padding(.vertical, 10)
    }
}

struct LabeledContentExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "LabeledContent, GroupBox & DisclosureGroup")
            Text("Three layout containers that complement Form. LabeledContent is a key-value row. GroupBox is a labeled card container. DisclosureGroup is a collapsible section.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "LabeledContent(\"Key\", value: \"Value\") - renders a label-value row. Use for read-only data.", color: .formGreen)
                StepRow(number: 2, text: "LabeledContent { customView } label: { } - custom value view, not just a string.", color: .formGreen)
                StepRow(number: 3, text: "GroupBox(label:) { content } - a labeled card. Great for grouping related controls outside of a Form.", color: .formGreen)
                StepRow(number: 4, text: "DisclosureGroup(isExpanded: $bool) { content } label: { } - collapsible with programmatic control.", color: .formGreen)
                StepRow(number: 5, text: "DisclosureGroup inside Form - sections that users can collapse. .disclosureGroupStyle() for custom arrows.", color: .formGreen)
            }

            CalloutBox(style: .info, title: "GroupBox outside Form", contentBody: "GroupBox gives you a rounded, labeled card for grouping content anywhere - not just inside Form. Use it on detail screens, dashboards, or info panels where Form's full-screen styling isn't appropriate.")

            CodeBlock(code: """
// LabeledContent - read-only row
LabeledContent("Version", value: "2.0.1")

// Custom value view
LabeledContent {
    HStack {
        Circle().fill(.green).frame(width: 8, height: 8)
        Text("Active").foregroundStyle(.green)
    }
} label: {
    Text("Status")
}

// GroupBox - labeled card
GroupBox {
    Toggle("Notifications", isOn: $notif)
    Toggle("Sounds", isOn: $sounds)
} label: {
    Label("Alerts", systemImage: "bell.fill")
}

// DisclosureGroup - collapsible
@State private var expanded = false

DisclosureGroup(isExpanded: $expanded) {
    Text("Hidden content")
    Text("More hidden content")
} label: {
    Label("Advanced", systemImage: "gear")
}

// Inside Form - collapsible section
Form {
    DisclosureGroup("Developer Options") {
        Toggle("Debug logging", isOn: $debug)
    }
}
""")
        }
    }
}
