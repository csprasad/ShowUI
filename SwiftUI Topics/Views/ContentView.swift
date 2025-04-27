//
//  ContentView.swift
//  SwiftUI Topics
//
//  Created by CS Prasad on 09/08/24.
//

import SwiftUI

struct ContentView: View {
    
    var list: some View {
        List {
            Grouping(title: "Blend Modes", content: { BlendModeView() })
            Grouping(title: "Experiment") { ExperimentUIView()}
        }
    }
    
    var body: some View {
        NavigationView {
            list.navigationBarTitle("SwiftUI - Topics")
            Text("Select a group")
        }
        .accentColor(.accentColor)
    }
}

struct Grouping<Content: View>: View {
    var title: String
    var content: () -> Content
    
    var body: some View {
        NavigationLink(destination: GroupView(title: title, content: content)) {
            Text(title).font(.headline).padding(.vertical, 8)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
