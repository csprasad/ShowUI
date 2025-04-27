//
//  GroupView.swift
//  SwiftUI Topics
//
//  Created by CS Prasad on 27/04/25.
//

import SwiftUI

struct GroupView<Content: View>: View {
    var title: String
    let content: () -> Content
    
    var body: some View {
            content()
        .navigationBarTitle(title, displayMode: .inline)
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView(title: "Group", content: { Text("Content") })
            .previewLayout(.sizeThatFits)
    }
}
