//
//
//  MainContainerView.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `16/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

enum TabItem {
    case home, settings, filter, search
}

#Preview {
    MainContainerView()
}

struct MainContainerView: View {
    @State private var selectedTab: TabItem = .home
    @State private var searchText: String = ""
    @State private var selectedTag: String = "All"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // --- Home Tab ---
            Tab("Home", systemImage: "house.fill", value: .home) {
                topicBrowser()
            }
            
            // --- Filter Tab ---
            // Tapping this can toggle a state rather than just switching views
            Tab("Filter", systemImage: "line.3.horizontal.decrease.circle", value: .filter) {
                topicBrowser()
            }
            
            // --- Native Search Tab ---
            Tab(value: .search, role: .search) {
                topicBrowser()
            }
        }
        .searchable(text: $searchText, prompt: "Search lessons...")
        .tabViewStyle(.sidebarAdaptable)
        .applyLiquidFilterBar(isEnabled: selectedTab == .filter) {
            filterChipRow
        }
    }
    
    // MARK: - View Helpers
    private var filterChipRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(TopicRegistry.availableTags, id: \.self) { tag in
                    FilterChip(text: tag, isSelected: selectedTag == tag) {
                        selectedTag = tag
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .frame(height: 100)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.05), radius: 10)
        }
    }
    
    @ViewBuilder
    private func topicBrowser() -> some View {
        NavigationStack {
            HomeView(selectedTag: $selectedTag, searchText: $searchText)
                .toolbar(.hidden, for: .navigationBar) // Hides the "Double Header"
        }
    }
}
