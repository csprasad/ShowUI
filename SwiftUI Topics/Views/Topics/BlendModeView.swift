//
//  SwiftUIView.swift
//  SwiftUI Topics
//
//  Created by CS Prasad on 09/08/24.
//

import SwiftUI
import PhotosUI

private func blendModeName(_ blendMode: BlendMode) -> String {
    let blendModeNames: [BlendMode: String] = [
        .normal: "Normal", .multiply: "Multiply", .screen: "Screen", .overlay: "Overlay",
        .darken: "Darken", .lighten: "Lighten", .colorDodge: "Color Dodge", .colorBurn: "Color Burn",
        .softLight: "Soft Light", .hardLight: "Hard Light", .difference: "Difference", .exclusion: "Exclusion",
        .hue: "Hue", .saturation: "Saturation", .color: "Color", .luminosity: "Luminosity",
        .sourceAtop: "Source Atop", .destinationOver: "Destination Over", .destinationOut: "Destination Out",
        .plusDarker: "Plus Darker", .plusLighter: "Plus Lighter"
    ]
    return blendModeNames[blendMode] ?? "Unknown"
}

struct BlendModeView: View {
    @State private var selectedColor: Color = .red
    @State private var selectedImage: UIImage? = UIImage(named: "TajMahal")
    @State private var isImagePickerPresented = false
    @State private var currentBlendModeIndex = 1
    
    @State private var showBottomSheet = false
    @State private var selectedValue: String?
    
    @State private var showingCredits = false

    let blendModes: [BlendMode] = [
        .normal, .multiply, .screen, .overlay,
        .darken, .lighten,
        .colorDodge, .colorBurn,
        .softLight, .hardLight,
        .difference, .exclusion,
        .hue, .saturation, .color, .luminosity
    ]

    var body: some View {
        VStack {
            ImageWithOverlay(
                selectedImage: selectedImage,
                selectedColor: selectedColor,
                currentBlendMode: blendModes[currentBlendModeIndex]
            )
            Divider()
            ColorPickerAndButton(
                selectedColor: $selectedColor,
                isImagePickerPresented: $isImagePickerPresented
            )
            Divider()
            ListView(currentBlendModeIndex: $currentBlendModeIndex, blendModes: blendModes, blendModeName: blendModeName)
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .background(.thinMaterial)
    }
}

// MARK: - Image Integration
struct ImageWithOverlay: View {
    let selectedImage: UIImage?
    let selectedColor: Color
    let currentBlendMode: BlendMode

    var body: some View {
        ZStack {
            Image(uiImage: selectedImage ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
            
            Rectangle()
                .fill(selectedColor)
                .frame(width: 600, height: 250)
                .rotationEffect(.degrees(-20))
                .offset(x: 0, y: 0)
                .blendMode(currentBlendMode)
        }
        .clipped()
        .ignoresSafeArea()
    }
}

// MARK: - Color Picker Integration
struct ColorPickerAndButton: View {
    @Binding var selectedColor: Color
    @Binding var isImagePickerPresented: Bool

    var body: some View {
        HStack {
            Text("Select blend modes")
                .font(.system(.title3))
                .foregroundColor(.primary)
                .padding()
            
            ColorPicker("", selection: $selectedColor)
                .cornerRadius(8)
                .padding()
            
            Spacer()
            
            Button(action: {
                isImagePickerPresented.toggle()
            }) {
                Image(systemName: "photo.on.rectangle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.secondary).opacity(0.6)
                    .frame(width: 40, height: 40)
            }
            .padding()
        }
        .frame(maxHeight: 60)
    }
}

// MARK: - Pop up sheet Integration
struct ListView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var currentBlendModeIndex: Int
    
    let blendModes: [BlendMode]
    let blendModeName: (BlendMode) -> String

    var body: some View {
        ZStack {
            VStack {
                List(blendModes.indices, id: \.self) { index in
                    HStack {
                        Text(blendModeName(blendModes[index]))
                        Spacer()

                        if currentBlendModeIndex == index {
                            Image(systemName: "checkmark")
                                .foregroundColor(.red)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        currentBlendModeIndex = index
                    }
                    .listRowBackground(Color.clear)
                    .padding(.leading, 10)
                    .padding(.trailing, 29)
                }
                .listStyle(.inset)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
        }
    }
}

// MARK: - Image Picker Integration
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
    }
}

struct BlendModeUIView_Previews: PreviewProvider {
    static var previews: some View {
        BlendModeView()
    }
}
