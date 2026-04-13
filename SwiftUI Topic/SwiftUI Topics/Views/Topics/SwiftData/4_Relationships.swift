//
//
//  4_Relationships.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Relationships
struct SDRelationshipsVisual: View {
    @State private var selectedDemo = 0
    let demos = ["One-to-many", "Cascade rules", "Inverse links"]

    // Simulated relationship data
    @State private var projects: [DemoProject] = [
        DemoProject(name: "ShowUI App", tasks: ["Build UI", "Add tests", "Ship v1"]),
        DemoProject(name: "Side project", tasks: ["Prototype", "Validate idea"]),
        DemoProject(name: "Learning", tasks: ["SwiftData", "async/await"]),
    ]
    @State private var selectedProject: DemoProject?
    @State private var newTaskTitle = ""

    struct DemoProject: Identifiable {
        let id    = UUID()
        var name:  String
        var tasks: [String]
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Relationships", systemImage: "arrow.triangle.branch")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sdBlue)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; selectedProject = nil }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.sdBlue : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.sdBlueLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // One-to-many live explorer
                    oneToManyExplorer

                case 1:
                    // Cascade rules diagram
                    cascadeRulesDiagram
                default:
                    // Inverse links
                    inverseLinksDiagram
                }
            }
        }
    }
    
    @ViewBuilder
    private var oneToManyExplorer: some View {
        VStack(spacing: 8) {
            Text("Project → Tasks (one-to-many)").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

            ForEach($projects) { $project in
                projectRow(for: $project)
            }
        }
    }
    
    @ViewBuilder
    private func projectRow(for project: Binding<DemoProject>) -> some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3)) {
                    // We compare IDs to toggle the expansion
                    selectedProject = (selectedProject?.id == project.id) ? nil : project.wrappedValue
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "folder.fill").foregroundStyle(Color.sdBlue).font(.system(size: 14))
                    Text(project.wrappedValue.name).font(.system(size: 13, weight: .semibold))
                    Spacer()
                    Text("\(project.wrappedValue.tasks.count) tasks")
                        .font(.system(size: 10)).foregroundStyle(.secondary)
                    Image(systemName: selectedProject?.id == project.id ? "chevron.up" : "chevron.down")
                        .font(.system(size: 10)).foregroundStyle(.secondary)
                }
                .padding(.horizontal, 10).padding(.vertical, 9)
                .background(Color.sdBlueLight.opacity(0.5))
            }
            .buttonStyle(PressableButtonStyle())

            if selectedProject?.id == project.id {
                taskEntrySection(for: project)
            }
        }
        .background(Color.sdBlueLight)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(selectedProject?.id == project.id ? Color.sdBlue.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }

    @ViewBuilder
    private func taskEntrySection(for project: Binding<DemoProject>) -> some View {
        VStack(spacing: 4) {
            ForEach(project.wrappedValue.tasks, id: \.self) { task in
                HStack(spacing: 8) {
                    Circle().fill(Color.sdBlue).frame(width: 5, height: 5).padding(.leading, 20)
                    Text(task).font(.system(size: 12)).foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.vertical, 4)
            }

            HStack(spacing: 6) {
                TextField("New task…", text: $newTaskTitle)
                    .textFieldStyle(.roundedBorder).font(.system(size: 12))
                    .padding(.leading, 16)
                
                Button {
                    let t = newTaskTitle.trimmingCharacters(in: .whitespaces)
                    guard !t.isEmpty else { return }
                    withAnimation {
                        project.wrappedValue.tasks.append(t)
                        newTaskTitle = ""
                    }
                } label: {
                    Image(systemName: "plus.circle.fill").foregroundStyle(Color.sdBlue)
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
        .padding(.bottom, 6).background(Color.sdBlueLight)
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
    
    
    @ViewBuilder
    private var cascadeRulesDiagram: some View {
        VStack(spacing: 8) {
            cascadeRow(rule: ".cascade",   color: .animCoral,   icon: "trash.fill",
                       desc: "Deleting the parent deletes all children (tasks). Most common for owned relationships.")
            cascadeRow(rule: ".nullify",   color: .animAmber,   icon: "minus.circle.fill",
                       desc: "Deleting the parent sets children's back-reference to nil. Use when children can exist without parent.")
            cascadeRow(rule: ".noAction",  color: .secondary,   icon: "xmark.circle.fill",
                       desc: "No automatic action. You must handle orphan cleanup manually.")
            cascadeRow(rule: ".deny",      color: .formGreen,   icon: "lock.fill",
                       desc: "Prevents deletion of parent if it has children. Forces you to clean up children first.")

            codeNote("@Relationship(deleteRule: .cascade) var tasks: [Task]")
        }

    }
    
    @ViewBuilder
    private var inverseLinksDiagram: some View {
        VStack(spacing: 8) {
            Text("SwiftData infers inverse relationships automatically").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

            inverseRow(from: "Project", to: "Task", fromProp: "var tasks: [Task]", toProp: "var project: Project?",
                       desc: "SwiftData automatically sets task.project when you add a task to project.tasks")
            inverseRow(from: "User", to: "Post", fromProp: "var posts: [Post]", toProp: "var author: User",
                       desc: "One-to-many: User owns many Posts. author back-link maintained automatically.")
            inverseRow(from: "Tag", to: "Article", fromProp: "var articles: [Article]", toProp: "var tags: [Tag]",
                       desc: "Many-to-many: both sides are arrays. SwiftData creates a join table.")

            codeNote("@Relationship(inverse: \\Task.$project)\nvar tasks: [Task] = []")
        }

    }

    func cascadeRow(rule: String, color: Color, icon: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon).font(.system(size: 14)).foregroundStyle(color).frame(width: 20)
            VStack(alignment: .leading, spacing: 3) {
                Text(rule).font(.system(size: 11, weight: .semibold, design: .monospaced)).foregroundStyle(color)
                Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(8).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func inverseRow(from: String, to: String, fromProp: String, toProp: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 8) {
                Text(from).font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.sdBlue)
                    .padding(.horizontal, 7).padding(.vertical, 3).background(Color.sdBlueLight).clipShape(Capsule())
                Image(systemName: "arrow.left.arrow.right").font(.system(size: 10)).foregroundStyle(.secondary)
                Text(to).font(.system(size: 10, weight: .semibold)).foregroundStyle(Color(hex: "#7C3AED"))
                    .padding(.horizontal, 7).padding(.vertical, 3).background(Color(hex: "#F5F3FF")).clipShape(Capsule())
            }
            HStack(spacing: 8) {
                Text(fromProp).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdBlue)
                Text("↔").foregroundStyle(.secondary)
                Text(toProp).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color(hex: "#7C3AED"))
            }
            Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(8).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func codeNote(_ text: String) -> some View {
        Text(text).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.sdBlue)
            .padding(7).background(Color.sdBlueLight).clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

struct SDRelationshipsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "@Relationship - linking models")
            Text("@Relationship declares typed links between @Model classes. SwiftData infers inverse relationships automatically. The deleteRule controls what happens to related objects when the owner is deleted.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "var tasks: [Task] = [] - to-many. SwiftData creates a foreign key automatically.", color: .sdBlue)
                StepRow(number: 2, text: "@Relationship(deleteRule: .cascade) var tasks - delete parent deletes all tasks.", color: .sdBlue)
                StepRow(number: 3, text: "var project: Project? - to-one (optional). Back-reference maintained by SwiftData.", color: .sdBlue)
                StepRow(number: 4, text: "Many-to-many: [Tag] on one side, [Article] on the other - SwiftData handles the join table.", color: .sdBlue)
                StepRow(number: 5, text: "@Relationship(inverse: \\Task.$project) - explicit inverse when SwiftData can't infer it.", color: .sdBlue)
            }

            CalloutBox(style: .success, title: "Inverse relationships are automatic", contentBody: "When you add an item to project.tasks, SwiftData automatically sets item.project = project on the other side. You rarely need to manage both sides manually.")

            CodeBlock(code: """
@Model
class Project {
    var name: String

    @Relationship(deleteRule: .cascade)
    var tasks: [Task] = []       // to-many

    init(name: String) { self.name = name }
}

@Model
class Task {
    var title: String
    var isDone: Bool = false

    // SwiftData infers this inverse
    var project: Project?        // to-one optional

    init(title: String) { self.title = title }
}

// Usage
let project = Project(name: "My App")
context.insert(project)

let task = Task(title: "Ship it")
project.tasks.append(task)    // sets task.project automatically

// Many-to-many
@Model class Article {
    var tags: [Tag] = []
}
@Model class Tag {
    var articles: [Article] = []
}
""")
        }
    }
}

