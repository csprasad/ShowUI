//
//
//  6_@Environmentwith@Observable.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: @Environment with @Observable models
struct EnvironmentModelsVisual: View {
    @State private var settings = AppSettings()
    @State private var notifs   = NotificationStore()
    @State private var selectedDemo = 0
    let demos = ["Environment chain", "Read in child", "vs"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("@Environment with models", systemImage: "arrow.down.left.and.arrow.up.right.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.obsGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.obsGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.obsGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Settings editor + preview that reads from environment
                    VStack(spacing: 10) {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Name:").font(.system(size: 12)).foregroundStyle(.secondary)
                                TextField("Name", text: $settings.userName).textFieldStyle(.roundedBorder).font(.system(size: 12))
                            }
                            HStack {
                                Text("Size: \(Int(settings.fontSize))pt").font(.system(size: 12)).foregroundStyle(.secondary)
                                Slider(value: $settings.fontSize, in: 10...22, step: 1).tint(.obsGreen)
                            }
                            HStack(spacing: 8) {
                                Text("Accent:").font(.system(size: 12)).foregroundStyle(.secondary)
                                ForEach(["green", "blue", "orange"], id: \.self) { name in
                                    Button {
                                        withAnimation { settings.accentColor = name }
                                    } label: {
                                        Circle().fill(name == "green" ? Color.obsGreen : name == "blue" ? Color.navBlue : Color.scrollOrange)
                                            .frame(width: 22, height: 22)
                                            .overlay(Circle().stroke(.white, lineWidth: settings.accentColor == name ? 2.5 : 0))
                                    }.buttonStyle(PressableButtonStyle())
                                }
                            }
                        }
                        .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

                        // Child reads from environment
                        SettingsPreviewChild()
                            .environment(settings)   // ← inject here
                    }

                case 1:
                    // Notification list - child reads + mutates environment model
                    VStack(spacing: 8) {
                        HStack {
                            Text("Notifications (\(notifs.count))")
                                .font(.system(size: 13, weight: .semibold))
                            Spacer()
                            Button("+ Add") {
                                withAnimation(.spring(bounce: 0.3)) { notifs.addNew() }
                            }.font(.system(size: 12)).foregroundStyle(Color.obsGreen)
                            .buttonStyle(PressableButtonStyle())
                        }

                        ForEach(notifs.messages.indices, id: \.self) { i in
                            HStack(spacing: 8) {
                                Circle().fill(Color.obsGreen).frame(width: 8, height: 8)
                                Text(notifs.messages[i]).font(.system(size: 12))
                                Spacer()
                                Button {
                                    withAnimation(.spring(bounce: 0.2)) { notifs.dismiss(i) }
                                } label: {
                                    Image(systemName: "xmark").font(.system(size: 10, weight: .bold)).foregroundStyle(.secondary)
                                }.buttonStyle(PressableButtonStyle())
                            }
                            .padding(.horizontal, 10).padding(.vertical, 7)
                            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        codeChip(".environment(notifs) - inject once at root, any descendant can read it")
                    }

                default:
                    // old vs new comparison
                    VStack(spacing: 8) {
                        compRow2(
                            oldTitle: "Inject (ObservableObject)",
                            oldCode: ".environmentObject(model)",
                            newTitle: "Inject (@Observable)",
                            newCode: ".environment(model)"
                        )
                        compRow2(
                            oldTitle: "Read in child",
                            oldCode: "@EnvironmentObject var m: MyModel",
                            newTitle: "Read in child",
                            newCode: "@Environment(MyModel.self) var m"
                        )
                        compRow2(
                            oldTitle: "Crash behavior",
                            oldCode: "Crashes at runtime if not injected",
                            newTitle: "Crash behavior",
                            newCode: "Optional: @Environment(M.self) var m? -\nnil if not injected"
                        )

                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill").font(.system(size: 12)).foregroundStyle(Color.obsGreen)
                            Text("Prefer @Observable + .environment() for new iOS 17+ code.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    func compRow2(oldTitle: String, oldCode: String, newTitle: String, newCode: String) -> some View {
        HStack(spacing: 6) {
            VStack(alignment: .leading, spacing: 2) {
                Text(oldTitle).font(.system(size: 9, weight: .semibold)).foregroundStyle(Color.animCoral)
                Text(oldCode).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.animCoral)
            }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(6).background(Color(hex: "#FCEBEB")).clipShape(RoundedRectangle(cornerRadius: 6)).frame(maxWidth: .infinity)

            Image(systemName: "arrow.right").font(.system(size: 11)).foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 2) {
                Text(newTitle).font(.system(size: 9, weight: .semibold)).foregroundStyle(Color.obsGreen)
                Text(newCode).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.obsGreen)
            }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(6).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 6)).frame(maxWidth: .infinity)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }

    func codeChip(_ code: String) -> some View {
        Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.obsGreen)
            .padding(8).background(Color.obsGreenLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct SettingsPreviewChild: View {
    @Environment(AppSettings.self) private var settings

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "eye.fill").font(.system(size: 11)).foregroundStyle(settings.color)
                Text("Preview from environment").font(.system(size: 11, weight: .semibold)).foregroundStyle(settings.color)
            }
            Text("Hello, \(settings.userName)!")
                .font(.system(size: settings.fontSize))
                .foregroundStyle(settings.color)
            Text("This child reads AppSettings from the environment - no parameter passing needed.")
                .font(.system(size: 10)).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
        .padding(10).background(settings.color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(settings.color.opacity(0.3), lineWidth: 1))
        .animation(.spring(response: 0.3), value: settings.accentColor)
        .animation(.easeInOut(duration: 0.1), value: settings.fontSize)
    }
}

struct EnvironmentModelsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: ".environment() with @Observable")
            Text(".environment(model) injects an @Observable model into the view hierarchy. Any descendant can read it with @Environment(ModelType.self). Only descendants that actually read the model's properties are affected by changes.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Inject: SomeView().environment(myModel) - inject at any level in the hierarchy.", color: .obsGreen)
                StepRow(number: 2, text: "Read: @Environment(MyModel.self) var model - automatically subscribes to accessed properties.", color: .obsGreen)
                StepRow(number: 3, text: "Mutate: model.property = newValue - the change propagates back to the original model.", color: .obsGreen)
                StepRow(number: 4, text: "Optional environment: @Environment(M.self) var m? - nil if not injected, no crash.", color: .obsGreen)
                StepRow(number: 5, text: "Multiple models: inject each separately. .environment(settings).environment(cart).", color: .obsGreen)
            }

            CalloutBox(style: .info, title: "Environment for truly global models", contentBody: "Only inject via environment if the model is needed by many views at different levels of the tree. For models needed by only 2-3 closely related views, passing as a parameter is cleaner and easier to reason about.")

            CodeBlock(code: """
// Root - own and inject the model
struct RootView: View {
    @State private var settings = AppSettings()

    var body: some View {
        ContentView()
            .environment(settings)
    }
}

// Deep child - reads from environment
struct DeepChildView: View {
    @Environment(AppSettings.self) private var settings

    var body: some View {
        Text(settings.userName)             // subscribes to userName
            .font(.system(size: settings.fontSize))
    }
}

// Mutate through environment
struct EditView: View {
    @Environment(AppSettings.self) private var settings

    var body: some View {
        @Bindable var s = settings           // for bindings
        TextField("Name", text: $s.userName)
    }
}
""")
        }
    }
}

