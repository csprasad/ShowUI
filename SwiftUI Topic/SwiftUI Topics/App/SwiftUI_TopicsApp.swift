//
//
//  SwiftUI_TopicsApp.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/08/24`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import TipKit

@main
struct SwiftUI_TopicsApp: App {
    
    init() {
        try? Tips.resetDatastore()
        
        try? Tips.configure([
            .displayFrequency(.immediate),
            .datastoreLocation(.applicationDefault)
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
