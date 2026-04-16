//
//
//  HomeView.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import SwiftUI

#Preview {
    HomeView()
}

struct HomeView: View {
    @State private var selectedTag: String = "All" // Default state
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false // Toggle state
    @FocusState private var isSearchFieldFocused: Bool // For keyboard focus
    
    private let allTopics = TopicRegistry.all
    
    private var filteredTopics: [any TopicProtocol] {
        allTopics.filter { topic in
            let matchesTag = (selectedTag == "All" || topic.tag == selectedTag)
            let matchesSearch = searchText.isEmpty ||
                                topic.title.localizedCaseInsensitiveContains(searchText)
            return matchesTag && matchesSearch
        }
    }
    
    // unique tags from registry
    private var availableTags: [String] {
        let tags = allTopics.map { $0.tag }
        return ["All"] + Array(Set(tags)).sorted()
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    customHeader
                    filterBar
                    topicGrid
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }

    // MARK: - Custom Toggleable Header
        private var customHeader: some View {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    if !isSearching {
                        // Standard Title View
                        VStack(alignment: .leading, spacing: 6) {
                            Text("iOS Topics")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                            Text("Visual lessons for every concept")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        
                        // Search Trigger Button
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isSearching = true
                                isSearchFieldFocused = true
                            }
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.black)
                                .padding(10)
                                .background(Color.primary.opacity(0.05))
                                .clipShape(Circle())
                        }
                    } else {
                        // Full Search Bar Mode
                        HStack(spacing: 12) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.secondary)
                                
                                TextField("Search topics...", text: $searchText)
                                    .focused($isSearchFieldFocused)
                                    .textInputAutocapitalization(.never)
                                
                                if !searchText.isEmpty {
                                    Button { searchText = "" } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.secondary)
                                    }.tint(.black)
                                }
                            }
                            .padding(12)
                            .background(Color.primary.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            // Cancel Button to go back
                            Button("Cancel") {
                                withAnimation(.spring()) {
                                    isSearching = false
                                    searchText = ""
                                    isSearchFieldFocused = false
                                }
                            }.tint(.black)
                            .font(.system(size: 16, weight: .medium))
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
            .padding(.bottom, 28)
        }
    
    // MARK: - Topic Grid
        private var topicGrid: some View {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(filteredTopics, id: \.id) { topic in
                    NavigationLink(destination: TopicDetailView(topic: topic)) {
                        TopicCard(topic: topic)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    
    // MARK: - Filter Bar
        private var filterBar: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(availableTags, id: \.self) { tag in
                        FilterChip(
                            text: tag,
                            isSelected: selectedTag == tag,
                            action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedTag = tag
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 20)
        }
}
