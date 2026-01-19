//
//  ButtonStyles.swift
//  SwiftUI Topics
//
//  Created by codeAlligator on 01/01/26.
//

import SwiftUI

struct ButtonStyles: View {
    
    var body: some View {
        List {
            NavigationLink("Default") {
                ButtonShowcaseView()
            }

            NavigationLink("Common in Practice") {
                ProductionButtonShowcaseView()
            }
            
            NavigationLink("Like Buttons") {
                LikeButtons()
            }
        }
        .navigationTitle("Button Styles")
    }
}
