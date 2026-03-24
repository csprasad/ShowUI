//
//
//  1_sheetBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
 
// MARK: - LESSON 1: Sheet Basics
struct SheetBasicsVisual: View {
    //TODO: - IdentifiedString is temporary solutions to make selectedItem confirms to Identifiable!!
    struct IdentifiedString: Identifiable, Equatable { let id = UUID(); let value: String }
    @State private var showSheet = false
    @State private var showItemSheet = false
    @State private var selectedItem: IdentifiedString? = nil
    let items = ["Settings", "Profile", "Notifications"]
 
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Sheet basics", systemImage: "rectangle.bottomhalf.inset.filled")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sheetGreen)
 
                // isPresented style
                VStack(alignment: .leading, spacing: 6) {
                    Text("isPresented binding")
                        .font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
 
                    Button {
                        showSheet = true
                    } label: {
                        Label("Open sheet", systemImage: "rectangle.bottomhalf.inset.filled")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.sheetGreen)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(PressableButtonStyle())
                    .sheet(isPresented: $showSheet) {
                        MockSheetContent(title: "Basic Sheet")
                    }
                }
 
                Divider()
 
                // item style
                VStack(alignment: .leading, spacing: 8) {
                    Text("item binding, data-driven")
                        .font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
 
                    HStack(spacing: 8) {
                        ForEach(items, id: \.self) { item in
                            Button {
                                selectedItem = IdentifiedString(value: item)
                            } label: {
                                Text(item)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(Color.sheetGreen)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.sheetGreenLight)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }
                .sheet(item: $selectedItem) { identified in
                    MockSheetContent(title: identified.value, subtitle: "Sheet opened for \(identified.value)")
                }
 
                // Dismiss info
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 12)).foregroundStyle(Color.sheetGreen)
                    Text("Inside the sheet, call dismiss() from @Environment(\\.dismiss) to close it programmatically")
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                }
                .padding(10)
                .background(Color.sheetGreenLight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

#Preview {
    SheetBasicsVisual()
}
 
struct SheetBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Presenting sheets")
            Text("Sheets slide up from the bottom and present secondary content. SwiftUI provides two presentation styles, .sheet(isPresented:) and .sheet(item:). The first takes a Binding<Bool> as its parameter, which isPresented for toggling a sheet on/off, and item for data-driven sheets that open when a value becomes non-nil.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)
 
            VStack(spacing: 12) {
                StepRow(number: 1, text: ".sheet(isPresented:) — takes a Binding<Bool>. Set to true to show, false to hide.", color: .sheetGreen)
                StepRow(number: 2, text: ".sheet(item:) — takes a Binding<Item?> where Item is Identifiable. Set to a value to show, nil to hide.", color: .sheetGreen)
                StepRow(number: 3, text: "@Environment(\\.dismiss) — call dismiss() from inside the sheet to close it.", color: .sheetGreen)
                StepRow(number: 4, text: "onDismiss: — closure called after the sheet closes. Use to handle cleanup.", color: .sheetGreen)
            }
 
            CalloutBox(style: .success, title: "Prefer item: over isPresented:", contentBody: "item: is more expressive, as it directly passes the sheet content automatically receives the item it was opened for. It also handles the case where the item changes while the sheet is open.")
 
            CalloutBox(style: .info, title: "Sheet must be on a stable view", contentBody: ".sheet should be attached to a view that stays in the hierarchy not inside a conditional or a ForEach row. If the anchor view disappears, the sheet is dismissed automatically.")
 
            CodeBlock(code: """
// isPresented style
@State private var showSheet = false
 
Button("Open") { showSheet = true }
    .sheet(isPresented: $showSheet) {
        MySheetView()
    }
 
// item style — data-driven
@State private var selectedUser: User? = nil
 
List(users) { user in
    Button(user.name) { selectedUser = user }
}
.sheet(item: $selectedUser) { user in
    UserDetailSheet(user: user)
}
 
// Dismiss from inside the sheet
struct MySheetView: View {
    @Environment(\\.dismiss) var dismiss
 
    var body: some View {
        Button("Close") { dismiss() }
    }
}
""")
        }
    }
}

