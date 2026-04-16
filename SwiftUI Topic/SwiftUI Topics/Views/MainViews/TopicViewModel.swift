//
//
//  TopicViewModel.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `16/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Category List


// MARK: - Animations ViewModel
class TopicViewModel: ObservableObject {
    @Published var selectedCategory: String? = nil
    
    @Published var topics: [any TopicProtocol] = TopicRegistry.all
    
    func items(for category: String) -> [any TopicProtocol] {
        topics.filter { $0.tag == category }
    }
    
    var filteredAnimations: [any TopicProtocol] {
        guard let selectedCategory = selectedCategory else {
            return topics
        }
        return topics.filter { $0.tag == selectedCategory }
    }
}
