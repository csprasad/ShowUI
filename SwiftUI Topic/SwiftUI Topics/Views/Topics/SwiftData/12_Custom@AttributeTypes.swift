//
//
//  12_Custom@AttributeTypes.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `12/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 12: Custom @Attribute Types
struct CustomAttributeVisual: View {
    @State private var selectedDemo = 0
    let demos = ["Codable types", "Transformable", "External storage"]

    // Simulated custom type display
    enum Priority: Int, Codable, CaseIterable {
        case low = 0, medium = 1, high = 2
        var label: String { ["Low", "Medium", "High"][rawValue] }
        var color: Color { [Color.formGreen, Color.animAmber, Color.animCoral][rawValue] }
    }

    struct TagList: Codable {
        var tags: [String]
        init(_ tags: [String] = []) { self.tags = tags }
    }

    @State private var selectedPriority: Priority = .medium
    @State private var tagList = TagList(["swift", "swiftui"])
    @State private var newTag  = ""

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Custom @Attribute types", systemImage: "lock.doc.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sdPurple)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.sdPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.sdPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Codable properties
                    VStack(spacing: 10) {
                        Text("Codable structs/enums stored as JSON blobs").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        // Priority enum picker
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Priority (enum: Codable)").font(.system(size: 10)).foregroundStyle(.secondary)
                            HStack(spacing: 6) {
                                ForEach(Priority.allCases, id: \.self) { p in
                                    Button(p.label) {
                                        withAnimation { selectedPriority = p }
                                    }
                                    .font(.system(size: 11, weight: selectedPriority == p ? .semibold : .regular))
                                    .foregroundStyle(selectedPriority == p ? .white : p.color)
                                    .padding(.horizontal, 10).padding(.vertical, 6)
                                    .background(selectedPriority == p ? p.color : p.color.opacity(0.12))
                                    .clipShape(Capsule())
                                    .buttonStyle(PressableButtonStyle())
                                }
                            }
                            codeSnip("// Stored as JSON: {\"rawValue\":1}\n@Model class Item {\n    var priority: Priority = .low\n}")
                        }
                        .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))

                        // TagList Codable struct
                        VStack(alignment: .leading, spacing: 6) {
                            Text("TagList (Codable struct)").font(.system(size: 10)).foregroundStyle(.secondary)
                            FlowLayout(spacing: 6) {
                                ForEach(tagList.tags, id: \.self) { tag in
                                    HStack(spacing: 3) {
                                        Text("#\(tag)").font(.system(size: 11)).foregroundStyle(Color.sdPurple)
                                        Button { withAnimation { tagList.tags.removeAll { $0 == tag } } } label: {
                                            Image(systemName: "xmark").font(.system(size: 8, weight: .bold)).foregroundStyle(.secondary)
                                        }.buttonStyle(PressableButtonStyle())
                                    }
                                    .padding(.horizontal, 8).padding(.vertical, 4)
                                    .background(Color.sdPurpleLight).clipShape(Capsule())
                                }
                            }
                            HStack(spacing: 6) {
                                TextField("add tag…", text: $newTag)
                                    .textFieldStyle(.roundedBorder).font(.system(size: 12))
                                    .autocorrectionDisabled().textInputAutocapitalization(.never)
                                    .submitLabel(.done)
                                    .onSubmit {
                                        let t = newTag.trimmingCharacters(in: .whitespaces)
                                        if !t.isEmpty { withAnimation { tagList.tags.append(t); newTag = "" } }
                                    }
                                Button { let t = newTag.trimmingCharacters(in: .whitespaces); if !t.isEmpty { withAnimation { tagList.tags.append(t); newTag = "" } } } label: {
                                    Image(systemName: "plus.circle.fill").foregroundStyle(Color.sdPurple)
                                }.buttonStyle(PressableButtonStyle())
                            }
                            codeSnip("// Stored as JSON blob in DB\nvar tags: TagList = TagList()")
                        }
                        .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // Transformable - custom ValueTransformer
                    VStack(spacing: 8) {
                        typeCard(
                            icon: "arrow.2.squarepath",
                            title: "ValueTransformer (pre-Codable pattern)",
                            desc: "For types that need custom binary serialisation or legacy CoreData transformable attributes.",
                            code: "class ColorTransformer: ValueTransformer {\n    override func transformedValue(_ v: Any?) -> Any? {\n        guard let color = v as? UIColor else { return nil }\n        return try? NSKeyedArchiver.archivedData(\n            withRootObject: color,\n            requiringSecureCoding: true)\n    }\n    override func reverseTransformedValue(_ v: Any?) -> Any? {\n        guard let data = v as? Data else { return nil }\n        return try? NSKeyedUnarchiver.unarchivedObject(\n            ofClass: UIColor.self, from: data)\n    }\n}\n// Register before first use:\nValueTransformer.setValueTransformer(\n    ColorTransformer(), forName: .colorTransformer)"
                        )
                        typeCard(
                            icon: "checkmark.seal.fill",
                            title: "Prefer Codable for new code",
                            desc: "Any type conforming to Codable is automatically handled - stored as JSON. Much simpler than ValueTransformer.",
                            code: "struct ColorValue: Codable {\n    var red: Double, green: Double, blue: Double\n}\n\n@Model class Theme {\n    var primary: ColorValue = ColorValue(red: 0, green: 0, blue: 1)\n}"
                        )
                    }

                default:
                    // External storage
                    VStack(spacing: 8) {
                        typeCard(
                            icon: "externaldrive.fill",
                            title: "@Attribute(.externalStorage) for large data",
                            desc: "Data > ~1MB should use externalStorage. SwiftData stores it on disk and saves only a reference in the DB row - keeps the SQLite file small and fast.",
                            code: "@Model class Document {\n    var title: String = \"\"\n\n    @Attribute(.externalStorage)\n    var fileData: Data?      // stored on disk, not in DB\n\n    @Attribute(.externalStorage)\n    var thumbnail: Data?     // ditto\n}"
                        )
                        typeCard(
                            icon: "lock.shield.fill",
                            title: "@Attribute(.allowsCloudEncryption)",
                            desc: "Mark sensitive fields to be encrypted in CloudKit. The data is encrypted at rest in the cloud - requires user to be signed in to iCloud.",
                            code: "@Model class HealthRecord {\n    @Attribute(.allowsCloudEncryption)\n    var bloodPressure: String = \"\"\n\n    @Attribute(.allowsCloudEncryption)\n    var notes: String = \"\"\n}"
                        )
                    }
                }
            }
        }
    }

    func typeCard(icon: String, title: String, desc: String, code: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 13)).foregroundStyle(Color.sdPurple)
                Text(title).font(.system(size: 11, weight: .semibold))
            }
            Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            Text(code).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdPurple)
                .padding(6).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func codeSnip(_ text: String) -> some View {
        Text(text).font(.system(size: 8, design: .monospaced)).foregroundStyle(Color.sdPurple)
            .padding(6).background(Color.sdPurpleLight).clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

struct CustomAttributeExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Custom @Attribute types")
            Text("SwiftData stores Codable types as JSON blobs automatically. Use @Attribute(.externalStorage) for large binary data to keep the SQLite file lean. @Attribute(.allowsCloudEncryption) encrypts sensitive fields in CloudKit.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Any Codable property is stored as JSON - structs, enums, arrays, nested types.", color: .sdPurple)
                StepRow(number: 2, text: "@Attribute(.externalStorage) var data: Data? - blob stored on disk, reference in DB.", color: .sdPurple)
                StepRow(number: 3, text: "@Attribute(.allowsCloudEncryption) - field encrypted in iCloud. User must be signed in.", color: .sdPurple)
                StepRow(number: 4, text: "@Attribute(originalName: \"old\") var new - rename column without data loss in migration.", color: .sdPurple)
                StepRow(number: 5, text: "Enums must be RawRepresentable + Codable - stored as their rawValue JSON.", color: .sdPurple)
            }

            CalloutBox(style: .info, title: "Codable vs transformable", contentBody: "If your type conforms to Codable, just declare it as a property - SwiftData handles JSON serialisation automatically. ValueTransformer is the old CoreData approach; only use it for types you cannot make Codable.")

            CodeBlock(code: """
// Enum - must be Codable + RawRepresentable
enum Status: String, Codable { case draft, published, archived }

// Codable struct - stored as JSON blob
struct Location: Codable {
    var lat: Double; var lon: Double
}

@Model class Article {
    var title: String = ""
    var status: Status = .draft          // → "draft" in DB
    var location: Location?              // → {"lat":..,"lon":..}
    var tags: [String] = []             // → ["swift","ios"]

    @Attribute(.externalStorage)
    var heroImage: Data?                 // stored on disk

    @Attribute(.allowsCloudEncryption)
    var privateNotes: String = ""        // encrypted in cloud

    @Attribute(originalName: "body")     // renamed from "body"
    var content: String = ""
}
""")
        }
    }
}

