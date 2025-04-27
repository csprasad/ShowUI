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
    @State private var currentBlendModeIndex = 0
    
    @State private var showBottomSheet = false
    @State private var selectedValue: String?
    
    @State private var showingCredits = false

    let blendModes: [BlendMode] = [
        .normal, .multiply, .screen, .overlay, .darken, .lighten, .colorDodge, .colorBurn,
        .softLight, .hardLight, .difference, .exclusion, .hue, .saturation, .color, .luminosity,
        .sourceAtop, .destinationOver, .destinationOut, .plusDarker, .plusLighter
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
            BottomSheetView(currentBlendModeIndex: $currentBlendModeIndex, blendModes: blendModes, blendModeName: blendModeName)
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
        
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
                .frame(maxWidth: .infinity, maxHeight: 300)
            
            Rectangle()
                .fill(selectedColor)
                .frame(width: 600, height: 150)
                .rotationEffect(.degrees(-20))
                .offset(x: 0, y: 0)
                .blendMode(currentBlendMode)
        }
        .clipped()
        .frame(height: 300)
    }
}

// MARK: - Color Picker Integration
struct ColorPickerAndButton: View {
    @Binding var selectedColor: Color
    @Binding var isImagePickerPresented: Bool

    var body: some View {
        HStack {
            Spacer()
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
                    .foregroundColor(.black).opacity(0.6)
                    .frame(width: 50, height: 50)
            }
            .padding()
        }
        .frame(maxHeight: 60)
    }
}

// MARK: - Pop up sheet Integration
struct BottomSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var currentBlendModeIndex: Int
    
    let blendModes: [BlendMode]
    let blendModeName: (BlendMode) -> String

    var body: some View {
        ZStack {
            VStack {
                Text("select blend modes")
                    .font(.system(.headline))

                List {
                    ForEach(blendModes.indices, id: \.self) { index in
                        Button(action: {
                            currentBlendModeIndex = index
                            dismiss()
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(self.blendModeName(blendModes[index]))
//                                        .font(.custom("Futura", size: 20))
                                }
                                Spacer()
                            }
                            .padding(8)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .listStyle(PlainListStyle())
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
