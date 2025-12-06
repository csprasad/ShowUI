//
//  BottomSheet.swift
//  SwiftUI Topics
//
//  Created by codeAlligator on 05/12/25.
//


import SwiftUI

struct BottomSheetUIView: View {
    @State private var showBottomSheet = false
    @State private var selectedValue: String?
    
    @State private var showingCredits = false


    var body: some View {
        VStack {
            Button("Show sheet") {
                showingCredits.toggle()
            }
            .sheet(isPresented: $showingCredits) {
                BottomSheet(selectedValue: $selectedValue)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

struct BottomSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedValue: String?

    let items = [
        ("Jarrod Lindgren", "Direct Security Developer"),
        ("Johnnie Steuber", "Internal Response Engineer"),
        ("Adolph Ankunding", "Future Solutions Assistant"),
        ("Donald Gusikowski", "Customer Intranet Liaison"),
        ("Fatima Weber", "Internal Security Designer"),
        ("Jarrod Lindgren", "Direct Security Developer"),
        ("Johnnie Steuber", "Internal Response Engineer"),
        ("Adolph Ankunding", "Future Solutions Assistant"),
        ("Donald Gusikowski", "Customer Intranet Liaison"),
        ("Fatima Weber", "Internal Security Designer"),
        ("Jarrod Lindgren", "Direct Security Developer"),
        ("Johnnie Steuber", "Internal Response Engineer"),
        ("Adolph Ankunding", "Future Solutions Assistant"),
        ("Donald Gusikowski", "Customer Intranet Liaison"),
        ("Fatima Weber", "Internal Security Designer")
    ]

    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach(items.indices, id: \.self) { index in
                        Button(action: {
                            selectedValue = "\(index): \(items[index].0)"
                            dismiss()
                        }) {
                            HStack {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 5, height: 5)

                                VStack(alignment: .leading) {
                                    Text(items[index].0)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .padding(.top, 10)
                        .buttonStyle(.borderless)
                        .foregroundColor(.primary)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}
