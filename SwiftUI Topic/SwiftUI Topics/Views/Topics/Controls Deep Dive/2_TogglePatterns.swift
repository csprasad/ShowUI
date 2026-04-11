//
//
//  2_TogglePatterns.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Toggle Patterns
struct TogglePatternsVisual: View {
    @State private var features: [String: Bool] = [
        "WiFi": true, "Bluetooth": false, "AirDrop": true,
        "Hotspot": false, "VPN": false, "Location": true
    ]
    @State private var selectedMode  = 0
    @State private var notifOn       = true
    @State private var soundOn       = false
    @State private var badgeOn       = false
    @State private var bannerOn      = false
    @State private var favoritedIDs  = Set<Int>()
    @State private var selectedDemo  = 0

    let featureIcons = ["WiFi":"wifi", "Bluetooth":"antenna.radiowaves.left.and.right", "AirDrop":"arrow.turn.up.forward.iphone.fill", "Hotspot":"personalhotspot", "VPN":"lock.shield", "Location":"location.fill"]

    let demos = ["Multi-select", "Dependent chain", "Icon toggles"]

    var allOn: Bool { features.values.allSatisfy { $0 } }
    var someOn: Bool { features.values.contains { $0 } }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Toggle patterns", systemImage: "checklist")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cdPurple)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.cdPurple : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.cdPurpleLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Multi-select with select-all
                    VStack(spacing: 0) {
                        // Select all row
                        HStack {
                            Text("All features")
                                .font(.system(size: 14, weight: .semibold))
                            Text("(\(features.values.filter { $0 }.count)/\(features.count))")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Toggle("", isOn: Binding(
                                get: { allOn },
                                set: { v in withAnimation { features.keys.forEach { features[$0] = v } } }
                            ))
                            .tint(.cdPurple).labelsHidden()
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(Color.cdPurpleLight)

                        ForEach(Array(features.keys.sorted()), id: \.self) { key in
                            Divider().padding(.leading, 50)
                            HStack(spacing: 12) {
                                Image(systemName: featureIcons[key] ?? "circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(features[key] == true ? Color.cdPurple : .secondary)
                                    .frame(width: 22)
                                Text(key).font(.system(size: 14))
                                Spacer()
                                Toggle("", isOn: Binding(
                                    get: { features[key] ?? false },
                                    set: { v in withAnimation { features[key] = v } }
                                ))
                                .tint(.cdPurple).labelsHidden()
                            }
                            .padding(.horizontal, 14).padding(.vertical, 9)
                            .background(Color(.systemBackground))
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                case 1:
                    // Dependent chain - child toggles enable/disable
                    VStack(spacing: 0) {
                        HStack {
                            Label("Notifications", systemImage: "bell.fill")
                                .font(.system(size: 14))
                            Spacer()
                            Toggle("", isOn: $notifOn).tint(.cdPurple).labelsHidden()
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(Color(.systemBackground))

                        // Child toggles - disabled unless parent is on
                        let children: [(String, String, Binding<Bool>)] = [
                            ("Sound",   "speaker.wave.2.fill", $soundOn),
                            ("Badge",   "app.badge.fill",      $badgeOn),
                            ("Banners", "rectangle.and.text.magnifyingglass", $bannerOn),
                        ]
                        ForEach(children, id: \.0) { name, icon, binding in
                            Divider().padding(.leading, 50)
                            HStack(spacing: 12) {
                                Image(systemName: icon)
                                    .font(.system(size: 13))
                                    .foregroundStyle(notifOn ? Color.cdPurple : .secondary)
                                    .frame(width: 22)
                                Text(name).font(.system(size: 14))
                                    .foregroundStyle(notifOn ? .primary : .secondary)
                                Spacer()
                                Toggle("", isOn: binding)
                                    .tint(.cdPurple)
                                    .labelsHidden()
                                    .disabled(!notifOn)
                            }
                            .padding(.horizontal, 14).padding(.vertical, 8)
                            .padding(.leading, 10)
                            .background(Color(.systemBackground))
                            .opacity(notifOn ? 1 : 0.5)
                            .animation(.easeInOut(duration: 0.2), value: notifOn)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                    .onChange(of: notifOn) { _, on in
                        if !on { withAnimation { soundOn = false; badgeOn = false; bannerOn = false } }
                    }

                default:
                    // Animated icon toggles grid
                    VStack(spacing: 10) {
                        let items: [(Int, String, String, String, Color)] = [
                            (0, "heart.fill",    "heart",    "Favourite",  .animCoral),
                            (1, "star.fill",     "star",     "Starred",    .animAmber),
                            (2, "bookmark.fill", "bookmark", "Saved",      .cdPurple),
                            (3, "bell.fill",     "bell",     "Alerts",     .navBlue),
                            (4, "pin.fill",      "pin",      "Pinned",     .formGreen),
                            (5, "eye.fill",      "eye",      "Visible",    .scrollOrange),
                        ]
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                            ForEach(items, id: \.0) { id, onIcon, offIcon, label, color in
                                let isOn = favoritedIDs.contains(id)
                                VStack(spacing: 6) {
                                    Button {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            if isOn { favoritedIDs.remove(id) } else { favoritedIDs.insert(id) }
                                        }
                                    } label: {
                                        Image(systemName: isOn ? onIcon : offIcon)
                                            .font(.system(size: 24))
                                            .foregroundStyle(isOn ? color : Color(.systemGray3))
                                            .frame(width: 56, height: 56)
                                            .background(isOn ? color.opacity(0.12) : Color(.systemFill))
                                            .clipShape(RoundedRectangle(cornerRadius: 14))
                                            .scaleEffect(isOn ? 1.0 : 0.95)
                                    }
                                    .buttonStyle(PressableButtonStyle())
                                    Text(label).font(.system(size: 10)).foregroundStyle(isOn ? color : .secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct TogglePatternsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Toggle patterns")
            Text("Toggles compose into powerful UI patterns. Select-all with a derived binding, dependent child toggles that enable/disable based on a parent, and icon-based favorites are the three most common real-world Toggle scenarios.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Select all: Binding(get: { items.allSatisfy { $0.on } }, set: { v in items set all }) - single toggle controls all.", color: .cdPurple)
                StepRow(number: 2, text: ".disabled(!parentToggle.isOn) - child toggles greyed out and inactive when parent is off.", color: .cdPurple)
                StepRow(number: 3, text: ".onChange(of: parentOn) { _, on in if !on { reset children } } - auto-reset children when parent is toggled off.", color: .cdPurple)
                StepRow(number: 4, text: "Icon toggles: Button + Set<ID> pattern - cleaner than Toggle for grid-based multi-select.", color: .cdPurple)
                StepRow(number: 5, text: "Count display: Text(\"\\(items.filter { $0.on }.count)/\\(items.count)\") - live summary beside the select-all.", color: .cdPurple)
            }

            CalloutBox(style: .info, title: "Derived binding for select-all", contentBody: "The derived Binding is read-only on get (all items are on?) and write-only on set (set all to the new value). This is a clean, no-extra-state approach - the binding derives from the source of truth.")

            CodeBlock(code: """
// Select-all derived binding
@State private var items = [Item]()

Toggle("Select all", isOn: Binding(
    get: { items.allSatisfy(\\.isSelected) },
    set: { all in
        withAnimation {
            items.indices.forEach {
                items[$0].isSelected = all
            }
        }
    }
))

// Dependent toggle chain
Toggle("Notifications", isOn: $notifOn)
Toggle("Sound", isOn: $soundOn)
    .disabled(!notifOn)     // can't enable without parent
    .opacity(notifOn ? 1 : 0.5)

// Auto-reset children
.onChange(of: notifOn) { _, on in
    if !on {
        soundOn = false
        badgesOn = false
    }
}
""")
        }
    }
}

