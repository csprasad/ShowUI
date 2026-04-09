//
//
//  3_SheetBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Shared sheet mock components
struct SheetMockView: View {
    let title: String
    var subtitle: String = "Sheet content"
    var accentColor: Color = .asRed
    var showHandle: Bool = true
    var height: CGFloat = 80

    var body: some View {
        VStack(spacing: 0) {
            if showHandle {
                Capsule().fill(Color(.systemGray4)).frame(width: 32, height: 4).padding(.top, 6)
            }
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.system(size: 11, weight: .semibold)).foregroundStyle(.primary)
                    Text(subtitle).font(.system(size: 9)).foregroundStyle(.secondary)
                }
                Spacer()
                Circle().fill(accentColor.opacity(0.15)).frame(width: 18, height: 18)
                    .overlay(Text("×").font(.system(size: 10)).foregroundStyle(accentColor))
            }
            .padding(.horizontal, 10).padding(.vertical, 6)
        }
        .frame(height: height)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.08), radius: 6, y: -2)
    }
}

struct PhoneMockContainer<Content: View>: View {
    var height: CGFloat = 160
    let content: Content
    init(height: CGFloat = 160, @ViewBuilder content: () -> Content) {
        self.height = height
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 14).fill(Color(.secondarySystemBackground))
            content
        }
        .frame(maxWidth: .infinity).frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - LESSON 3: Sheet Basics (diagram)

struct SheetBasicsDiagramVisual: View {
    @State private var showIsPresented   = false
    @State private var selectedItem: String? = nil
    @State private var selectedDemo      = 0
    @State private var lastDismiss       = "-"

    let items = ["Profile", "Settings", "Help"]
    let demos = ["isPresented", "item binding", "onDismiss"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Sheet basics", systemImage: "rectangle.bottomhalf.inset.filled")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.asRed)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.asRed : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.asRedLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // isPresented demo
                    VStack(spacing: 10) {
                        // Architecture diagram
                        VStack(spacing: 6) {
                            diagramBox("@State var showSheet = false", color: .asRed, isCode: true)
                            Image(systemName: "arrow.down").font(.system(size: 11)).foregroundStyle(.secondary)
                            diagramBox("Button { showSheet = true }", color: .asRed, isCode: true)
                            Image(systemName: "arrow.down").font(.system(size: 11)).foregroundStyle(.secondary)
                            diagramBox(".sheet(isPresented: $showSheet) { Content() }", color: .asRed, isCode: true)
                        }
                        .padding(10).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))

                        Button {
                            showIsPresented = true
                        } label: {
                            Text("Present sheet")
                                .font(.system(size: 14, weight: .semibold)).foregroundStyle(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 11)
                                .background(Color.asRed).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressableButtonStyle())
                        .sheet(isPresented: $showIsPresented) {
                            NavigationStack {
                                VStack(spacing: 14) {
                                    Image(systemName: "rectangle.bottomhalf.inset.filled")
                                        .font(.system(size: 44)).foregroundStyle(Color.asRed)
                                    Text("isPresented sheet").font(.system(size: 18, weight: .bold))
                                    Text("Swipe down or tap Done to dismiss")
                                        .font(.system(size: 13)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .navigationTitle("Sheet")
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { showIsPresented = false } } }
                            }
                        }
                    }

                case 1:
                    // item binding demo
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            ForEach(items, id: \.self) { item in
                                Button {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { selectedItem = item }
                                } label: {
                                    Text(item)
                                        .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                                        .frame(maxWidth: .infinity).padding(.vertical, 9)
                                        .background(Color.asRed).clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                        .sheet(item: $selectedItem) { item in
                            VStack(spacing: 14) {
                                Image(systemName: "person.circle.fill").font(.system(size: 48)).foregroundStyle(Color.asRed)
                                Text(item).font(.system(size: 22, weight: .bold))
                                Text("Sheet opened for «\(item)»").font(.system(size: 13)).foregroundStyle(.secondary)
                                Button("Close") { selectedItem = nil }
                                    .buttonStyle(.borderedProminent).tint(.asRed)
                            }
                            .padding().presentationDetents([.medium])
                        }

                        diagramBox(".sheet(item: $selectedItem) { item in\n    DetailView(item: item)\n}", color: .asRed, isCode: true)
                    }

                default:
                    // onDismiss
                    VStack(spacing: 10) {
                        Button {
                            showIsPresented = true
                        } label: {
                            Text("Present + track dismiss")
                                .font(.system(size: 14, weight: .semibold)).foregroundStyle(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 11)
                                .background(Color.asRed).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressableButtonStyle())
                        .sheet(isPresented: $showIsPresented, onDismiss: {
                            lastDismiss = "Sheet dismissed at \(Date().formatted(.dateTime.hour().minute().second()))"
                        }) {
                            VStack(spacing: 14) {
                                Text("Swipe down to dismiss").font(.system(size: 16, weight: .semibold))
                                Text("onDismiss fires when closed").font(.system(size: 12)).foregroundStyle(.secondary)
                                Button("Done") { showIsPresented = false }.buttonStyle(.borderedProminent).tint(.asRed)
                            }
                            .padding().presentationDetents([.medium])
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "arrow.uturn.left.circle.fill").foregroundStyle(Color.asRed).font(.system(size: 12))
                            Text(lastDismiss).font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.asRedLight).clipShape(RoundedRectangle(cornerRadius: 8))
                        .animation(.easeInOut(duration: 0.2), value: lastDismiss)
                    }
                }
            }
        }
    }

    func diagramBox(_ text: String, color: Color, isCode: Bool = false) -> some View {
        Text(text)
            .font(isCode ? .system(size: 10, design: .monospaced) : .system(size: 11))
            .foregroundStyle(color)
            .padding(.horizontal, 10).padding(.vertical, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(color.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

struct SheetBasicsDiagramExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: ".sheet - bottom modal")
            Text(".sheet presents a modal that slides up from the bottom. There are two binding styles: isPresented for a simple toggle, and item for data-driven sheets that automatically receive the item they were opened for.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".sheet(isPresented: $bool) { Content() } - simplest. Toggle the bool to show/hide.", color: .asRed)
                StepRow(number: 2, text: ".sheet(item: $optionalItem) { item in Content(item: item) } - data-driven. Non-nil = present, nil = dismiss.", color: .asRed)
                StepRow(number: 3, text: "onDismiss: - fires after the sheet is dismissed, whether by swipe, button, or programmatic nil.", color: .asRed)
                StepRow(number: 4, text: "Wrap sheet content in NavigationStack { } for title + toolbar buttons inside the sheet.", color: .asRed)
                StepRow(number: 5, text: "@Environment(\\.dismiss) inside sheet - call dismiss() to close the sheet programmatically.", color: .asRed)
            }

            CalloutBox(style: .success, title: "Prefer item: over isPresented:", contentBody: ".sheet(item:) is more expressive. The closure receives the item directly - no need to separately store which item was tapped. When the sheet is dismissed, item automatically becomes nil.")

            CodeBlock(code: """
// isPresented - simple toggle
@State private var showSheet = false

Button("Open") { showSheet = true }
    .sheet(isPresented: $showSheet) {
        MySheetContent()
    }

// item - data-driven
@State private var selectedUser: User? = nil

List(users) { user in
    Button(user.name) { selectedUser = user }
}
.sheet(item: $selectedUser) { user in
    UserDetailSheet(user: user)
}

// With NavigationStack + done button
.sheet(isPresented: $show) {
    NavigationStack {
        SheetContent()
            .navigationTitle("Details")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { show = false }
                }
            }
    }
}

// Dismiss from inside
struct SheetContent: View {
    @Environment(\\.dismiss) var dismiss
    var body: some View {
        Button("Close") { dismiss() }
    }
}
""")
        }
    }
}
