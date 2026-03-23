//
//
//  0_symbolbrowser.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `23/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 0: Symbol Browser

struct SymbolBrowserVisual: View {
    @State private var searchText = ""
    @State private var selectedCategory = "Weather"
    @State private var copiedSymbol: String? = nil
    @State private var selectedRenderingMode = 0

    let renderingModes = ["Mono", "Hier", "Multi"]

    var filteredSymbols: [String] {
        let pool: [String]
        if selectedCategory == "All" {
            pool = SymbolLibrary.all.flatMap { $0.symbols }
        } else {
            pool = SymbolLibrary.all.first { $0.name == selectedCategory }?.symbols ?? []
        }
        if searchText.isEmpty { return pool }
        return pool.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 12) {
                Label("Symbol browser", systemImage: "square.grid.3x3.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sfGreen)

                // Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                    TextField("Search symbols...", text: $searchText)
                        .font(.system(size: 14))
                    if !searchText.isEmpty {
                        Button { searchText = "" } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color(.systemFill))
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // Category pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        categoryPill("All", count: SymbolLibrary.all.flatMap { $0.symbols }.count)
                        ForEach(SymbolLibrary.all, id: \.name) { cat in
                            categoryPill(cat.name, count: cat.symbols.count)
                        }
                    }
                }

                // Rendering mode + count row
                HStack(spacing: 8) {
                    Text("Preview:")
                        .font(.system(size: 11)).foregroundStyle(.secondary)
                    HStack(spacing: 0) {
                        ForEach(renderingModes.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.25)) { selectedRenderingMode = i }
                            } label: {
                                Text(renderingModes[i])
                                    .font(.system(size: 11, weight: selectedRenderingMode == i ? .semibold : .regular))
                                    .foregroundStyle(selectedRenderingMode == i ? .white : .secondary)
                                    .padding(.horizontal, 10).padding(.vertical, 5)
                                    .background(selectedRenderingMode == i ? Color.sfGreen : Color.clear)
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                    .background(Color(.systemFill))
                    .clipShape(Capsule())
                    Spacer()
                    Text("\(filteredSymbols.count) symbols")
                        .font(.system(size: 11)).foregroundStyle(Color(.tertiaryLabel))
                }

                // Symbol grid
                let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 5)
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(filteredSymbols, id: \.self) { sym in
                        Button {
                            UIPasteboard.general.string = sym
                            withAnimation(.spring(response: 0.3)) { copiedSymbol = sym }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation { copiedSymbol = nil }
                            }
                        } label: {
                            VStack(spacing: 4) {
                                symbolImage(sym)
                                    .frame(width: 26, height: 26)
                                Text(sym.components(separatedBy: ".").first ?? sym)
                                    .font(.system(size: 7))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(copiedSymbol == sym ? Color.sfGreenLight : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(copiedSymbol == sym ? Color.sfGreen : Color.clear, lineWidth: 1.5)
                            )
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Copied feedback
                if let copied = copiedSymbol {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.sfGreen)
                            .font(.system(size: 12))
                        Text("\"\(copied)\" copied")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(Color.sfGreen)
                        Spacer()
                    }
                    .padding(10)
                    .background(Color.sfGreenLight)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
    }

    @ViewBuilder
    func symbolImage(_ name: String) -> some View {
        switch selectedRenderingMode {
        case 1:
            Image(systemName: name)
                .font(.system(size: 20))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.sfGreen)
        case 2:
            Image(systemName: name)
                .font(.system(size: 20))
                .symbolRenderingMode(.multicolor)
        default:
            Image(systemName: name)
                .font(.system(size: 20))
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(Color.sfGreen)
        }
    }

    func categoryPill(_ name: String, count: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                selectedCategory = name
                searchText = ""
            }
        } label: {
            HStack(spacing: 3) {
                Text(name)
                    .font(.system(size: 11, weight: selectedCategory == name ? .semibold : .regular))
                Text("·\(count)")
                    .font(.system(size: 10))
                    .foregroundStyle(selectedCategory == name ? Color.sfGreen.opacity(0.6) : Color(.tertiaryLabel))
            }
            .foregroundStyle(selectedCategory == name ? Color.sfGreen : .secondary)
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(selectedCategory == name ? Color.sfGreenLight : Color(.systemFill))
            .clipShape(Capsule())
        }
        .buttonStyle(PressableButtonStyle())
    }
}

struct SymbolBrowserExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "SF Symbol browser")
            Text("A curated reference of 300 commonly used SF Symbols organised by category. Tap any symbol to copy its name to clipboard, and paste directly into Image(systemName:) in your code.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Search by any part of a name, like 'arrow', 'person', 'doc', 'fill' etc.", color: .sfGreen)
                StepRow(number: 2, text: "Browse by category to discover symbols you didn't know existed.", color: .sfGreen)
                StepRow(number: 3, text: "Switch rendering mode to preview how each symbol looks in mono, hierarchical and multicolor.", color: .sfGreen)
                StepRow(number: 4, text: "Tap any symbol: its name is copied to your clipboard, ready to paste.", color: .sfGreen)
            }

            CalloutBox(style: .info, title: "SF Symbols app", contentBody: "For the full 5,000+ library with export, weight previews and category metadata, download the free SF Symbols app from Apple's developer site.")

            CalloutBox(style: .success, title: "Naming convention", contentBody: "Symbol names follow a pattern: noun.modifier.modifier. 'arrow.down.circle.fill' = arrow pointing down, inside a circle, filled. Learning this pattern lets you guess names without looking them up.")

            CodeBlock(code: """
// Basic
Image(systemName: "star.fill")

// With rendering mode
Image(systemName: "cloud.bolt.rain.fill")
    .symbolRenderingMode(.multicolor)

// In a Label
Label("Favorites", systemImage: "star.fill")

// Copy a name from the browser above
// and paste it here:
Image(systemName: "YOUR_COPIED_NAME")
""")
        }
    }
}

// MARK: - Symbol Library

struct SymbolCategory {
    let name: String
    let symbols: [String]
}

enum SymbolLibrary {
    static let all: [SymbolCategory] = [
        SymbolCategory(name: "Communication", symbols: [
            "message.fill", "message.badge.fill", "bubble.left.fill", "bubble.right.fill",
            "bubble.left.and.bubble.right.fill", "phone.fill", "phone.arrow.up.right.fill",
            "phone.arrow.down.left.fill", "phone.badge.plus", "phone.connection.fill",
            "video.fill", "video.slash.fill", "video.badge.plus", "envelope.fill",
            "envelope.open.fill", "envelope.badge.fill", "paperplane.fill",
            "tray.fill", "tray.2.fill", "tray.and.arrow.up.fill", "tray.and.arrow.down.fill",
            "bell.fill", "bell.badge.fill", "bell.slash.fill", "bell.circle.fill",
            "megaphone.fill", "mic.fill", "mic.slash.fill", "mic.circle.fill",
            "speaker.fill", "speaker.slash.fill", "speaker.wave.2.fill", "speaker.wave.3.fill",
        ]),
        SymbolCategory(name: "Weather", symbols: [
            "sun.max.fill", "sun.min.fill", "sunrise.fill", "sunset.fill",
            "cloud.fill", "cloud.drizzle.fill", "cloud.rain.fill", "cloud.heavyrain.fill",
            "cloud.fog.fill", "cloud.snow.fill", "cloud.bolt.fill", "cloud.bolt.rain.fill",
            "tornado", "tropicalstorm", "hurricane", "thermometer.sun.fill",
            "wind", "snow", "moon.fill", "moon.stars.fill",
            "cloud.moon.fill", "cloud.moon.rain.fill", "sun.haze.fill", "moon.haze.fill",
        ]),
        SymbolCategory(name: "Transport", symbols: [
            "car.fill", "car.2.fill", "bolt.car.fill", "car.rear.fill",
            "bus.fill", "tram.fill", "airplane", "airplane.circle.fill",
            "airplane.departure", "airplane.arrival", "bicycle", "bicycle.circle.fill",
            "scooter", "motorcycle", "ferry.fill", "fuelpump.fill",
            "map.fill", "location.fill", "location.slash.fill", "location.circle.fill",
            "figure.walk", "figure.run", "sailboat.fill", "road.lanes",
        ]),
        SymbolCategory(name: "Health", symbols: [
            "heart.fill", "heart.circle.fill", "heart.slash.fill", "heart.text.square.fill",
            "waveform.path.ecg", "cross.fill", "cross.circle.fill", "staroflife.fill",
            "pills.fill", "pill.fill", "bandage.fill", "stethoscope",
            "syringe.fill", "thermometer", "lungs.fill", "brain.fill",
            "figure.hiking", "dumbbell.fill", "fork.knife", "figure.yoga",
            "leaf.fill", "drop.fill", "flame.fill", "bed.double.fill",
        ]),
        SymbolCategory(name: "Devices", symbols: [
            "iphone", "ipad", "macbook", "applewatch",
            "airpods.gen3", "homepod.fill", "appletv.fill", "tv.fill",
            "display", "desktopcomputer", "keyboard.fill", "rectangle.and.hand.point.up.left.fill",
            "printer.fill", "scanner.fill", "camera.fill", "camera.circle.fill",
            "headphones", "hifispeaker.fill", "battery.100", "battery.25",
            "battery.100.bolt", "cable.connector", "powerplug.fill", "cpu.fill",
        ]),
        SymbolCategory(name: "Connectivity", symbols: [
            "wifi", "wifi.slash", "wifi.circle.fill", "wifi.exclamationmark",
            "network", "globe", "globe.americas.fill", "globe.europe.africa.fill",
            "link", "link.circle.fill", "shareplay", "personalhotspot",
            "airplayvideo", "airplayaudio", "barcode", "qrcode",
            "icloud.fill", "icloud.and.arrow.up.fill", "icloud.and.arrow.down.fill",
            "icloud.slash.fill", "server.rack", "antenna.radiowaves.left.and.right",
            "dot.radiowaves.right", "wave.3.right",
        ]),
        SymbolCategory(name: "Media", symbols: [
            "play.fill", "pause.fill", "stop.fill", "forward.fill", "backward.fill",
            "play.circle.fill", "playpause.fill", "repeat", "repeat.1", "shuffle",
            "music.note", "music.note.list", "music.quarternote.3",
            "waveform", "guitars.fill", "film.fill", "photo.stack.fill",
            "photo.artframe", "books.vertical.fill", "magazine.fill",
            "ticket.fill", "goforward.10", "gobackward.10", "play.rectangle.fill",
        ]),
        SymbolCategory(name: "Files", symbols: [
            "doc.fill", "doc.text.fill", "doc.richtext.fill", "doc.badge.plus",
            "doc.on.doc.fill", "doc.on.clipboard.fill", "clipboard.fill",
            "folder.fill", "folder.circle.fill", "folder.badge.plus", "folder.badge.minus",
            "tray.full.fill", "archivebox.fill", "trash.fill", "trash.circle.fill",
            "trash.slash.fill", "square.and.arrow.up.fill", "square.and.arrow.down.fill",
            "arrow.up.doc.fill", "arrow.down.doc.fill",
            "internaldrive.fill", "list.bullet.clipboard.fill", "doc.viewfinder.fill",
            "externaldrive.fill",
        ]),
        SymbolCategory(name: "Editing", symbols: [
            "pencil", "pencil.circle.fill", "pencil.tip", "square.and.pencil",
            "pencil.slash", "highlighter", "scribble", "scissors",
            "magnifyingglass", "magnifyingglass.circle.fill", "plus.magnifyingglass",
            "minus.magnifyingglass", "wand.and.stars", "wand.and.rays",
            "paintbrush.fill", "paintbrush.pointed.fill",
            "crop", "crop.rotate", "arrow.uturn.backward.circle.fill",
            "arrow.uturn.forward.circle.fill", "text.cursor", "selection.pin.in.out",
            "pencil.and.ruler.fill", "lasso",
        ]),
        SymbolCategory(name: "People", symbols: [
            "person.fill", "person.circle.fill", "person.crop.circle.fill",
            "person.crop.circle.badge.checkmark", "person.crop.circle.badge.plus",
            "person.crop.circle.badge.xmark", "person.2.fill", "person.2.circle.fill",
            "person.3.fill", "person.badge.plus", "person.badge.minus",
            "person.fill.xmark", "person.fill.checkmark", "person.fill.questionmark",
            "figure.stand", "figure.wave", "figure.arms.open",
            "face.smiling.fill", "shared.with.you",
            "person.crop.rectangle.fill", "person.crop.square.fill",
            "person.and.background.dotted", "person.text.rectangle.fill",
            "person.2.badge.gearshape.fill",
        ]),
        SymbolCategory(name: "Security", symbols: [
            "lock.fill", "lock.circle.fill", "lock.slash.fill", "lock.open.fill",
            "lock.shield.fill", "lock.doc.fill", "key.fill", "key.horizontal.fill",
            "shield.fill", "shield.slash.fill", "exclamationmark.shield.fill",
            "checkmark.shield.fill", "xmark.shield.fill", "hand.raised.fill",
            "hand.raised.slash.fill", "eye.fill", "eye.slash.fill",
            "faceid", "touchid", "person.badge.key.fill",
            "network.badge.shield.half.filled", "exclamationmark.lock.fill",
            "lock.rotation", "rectangle.and.hand.point.up.left.fill",
        ]),
        SymbolCategory(name: "Finance", symbols: [
            "creditcard.fill", "creditcard.circle.fill", "banknote.fill",
            "dollarsign.circle.fill", "dollarsign.square.fill",
            "eurosign.circle.fill", "sterlingsign.circle.fill",
            "bitcoinsign.circle.fill", "cart.fill", "cart.badge.plus",
            "bag.fill", "bag.badge.plus", "gift.fill", "giftcard.fill",
            "tag.fill", "tag.circle.fill", "percent",
            "chart.line.uptrend.xyaxis", "chart.bar.fill", "chart.pie.fill",
            "arrow.up.right.circle.fill", "arrow.down.right.circle.fill",
            "building.columns.fill", "dollarsign",
        ]),
        SymbolCategory(name: "Nature", symbols: [
            "leaf.circle.fill", "tree.fill", "ant.fill",
            "ladybug.fill", "bird.fill", "fish.fill", "pawprint.fill",
            "hare.fill", "tortoise.fill", "lizard.fill",
            "mountain.2.fill", "water.waves", "beach.umbrella.fill",
            "camera.macro", "allergens.fill", "carrot.fill",
            "moon.zzz.fill", "cloud.sun.fill", "sun.dust.fill",
            "sparkles", "snowflake.circle.fill", "globe.europe.africa.fill",
            "fossil.shell.fill", "basket.fill",
        ]),
        SymbolCategory(name: "Home", symbols: [
            "house.fill", "house.circle.fill", "building.fill", "building.2.fill",
            "lightbulb.fill", "lightbulb.slash.fill", "lamp.floor.fill",
            "sofa.fill", "bed.double.fill", "bathtub.fill",
            "washer.fill", "dryer.fill", "refrigerator.fill",
            "oven.fill", "microwave.fill", "dishwasher.fill",
            "fork.knife.circle.fill", "cup.and.saucer.fill", "wineglass.fill",
            "birthday.cake.fill", "door.left.hand.open",
            "air.conditioner.horizontal.fill", "shower.fill", "sensor.fill",
        ]),
        SymbolCategory(name: "Arrows", symbols: [
            "arrow.up", "arrow.down", "arrow.left", "arrow.right",
            "arrow.up.left", "arrow.up.right", "arrow.down.left", "arrow.down.right",
            "arrow.up.arrow.down", "arrow.left.arrow.right",
            "arrow.clockwise", "arrow.counterclockwise",
            "arrow.triangle.2.circlepath", "arrow.right.circle.fill",
            "arrow.up.circle.fill", "arrow.down.circle.fill",
            "arrow.uturn.left.circle.fill", "arrow.uturn.right.circle.fill",
            "chevron.up", "chevron.down", "chevron.left", "chevron.right",
            "chevron.up.chevron.down", "arrow.forward.circle.fill",
        ]),
        SymbolCategory(name: "Shapes", symbols: [
            "circle.fill", "square.fill", "triangle.fill", "diamond.fill",
            "hexagon.fill", "pentagon.fill", "octagon.fill", "seal.fill",
            "capsule.fill", "oval.fill", "rectangle.fill", "star.fill",
            "plus.circle.fill", "minus.circle.fill",
            "xmark.circle.fill", "checkmark.circle.fill",
            "exclamationmark.circle.fill", "questionmark.circle.fill",
            "info.circle.fill", "1.circle.fill", "2.circle.fill",
            "3.circle.fill", "a.circle.fill", "b.circle.fill",
        ]),
    ]
}
