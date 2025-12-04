//
//  ExperimentUIView.swift
//  SwiftUI Topics
//
//  Created by CS Prasad on 10/08/24.
//

import SwiftUI

struct ExperimentUIView: View {
    @State private var showBottomSheet = false
    @State private var selectedValue: String?
    
    @State private var showingCredits = false


    var body: some View {
        VStack {
            Button("Show Credits") {
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



struct ExperimentUIView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentUIView()
    }
}
