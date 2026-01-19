//
//  ButtonsView.swift
//  SwiftUI Topics
//
//  Created by codeAlligator on 01/01/26.
//

import SwiftUI

struct ProductionButtonShowcaseView: View {
    
    @State private var isLoading = false
    @State private var isEnabled = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                
                section("Text Buttons")
                row {
                    Button("Default") {}
                    Button("Prominent") {}
                        .buttonStyle(.borderedProminent)
                }
                
                section("Image Buttons")
                row {
                    Button {
                        print("Heart tapped")
                    } label: {
                        Image(systemName: "heart.fill")
                    }
                    
                    Button {
                        print("Trash tapped")
                    } label: {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.bordered)
                }
                
                section("Text + Image")
                row {
                    Button {
                        print("Edit")
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        print("Delete")
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .buttonStyle(.bordered)
                }
                
                section("Loading / Async Buttons")
                row {
                    Button {
                        simulateLoading()
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else {
                            Text("Submit")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isLoading)
                }
                
                section("Disabled State")
                row {
                    Button("Disabled") {}
                        .buttonStyle(.borderedProminent)
                        .disabled(isEnabled)
                    
                    Toggle("Enabled", isOn: $isEnabled)
                        .labelsHidden()
                }
                
                section("Full-width CTA")
                Button {
                    print("Primary CTA")
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                section("Custom Production Button")
                Button {
                    print("Custom tapped")
                } label: {
                    HStack {
                        Image(systemName: "bolt.fill")
                        Text("Boost")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryCapsuleButtonStyle())
            }
            .padding()
        }
        .navigationTitle("Production Styles")
    }
    
    private func simulateLoading() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
}


struct PrimaryCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                Capsule()
                    .fill(configuration.isPressed ? Color.blue.opacity(0.6) : Color.blue)
            )
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

private func section(_ title: String) -> some View {
    Text(title)
        .font(.title3.bold())
}

private func row<Content: View>(
    @ViewBuilder content: () -> Content
) -> some View {
    HStack(spacing: 16) {
        content()
    }
}
