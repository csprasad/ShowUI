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

struct HomeView: View {
    @Binding var selectedTag: String
    @Binding var searchText: String
    
    private let allTopics = TopicRegistry.all

    private var filteredTopics: [any TopicProtocol] {
        allTopics.filter { topic in
            let matchesTag = (selectedTag == "All" || topic.tag == selectedTag)
            let matchesSearch = searchText.isEmpty ||
                                topic.title.localizedCaseInsensitiveContains(searchText)
            return matchesTag && matchesSearch
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header
                if filteredTopics.isEmpty {
                    emptyStateView
                } else {
                    topicGrid
                }
            }
            .padding(.top, 20)
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("iOS Topics")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            Text("Visual lessons for every concept")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
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
                NavigationLink(destination: TopicDetailView(topic: topic).hideTabBarInDetail()) {
                    TopicCard(topic: topic)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        ContentUnavailableView.search(text: searchText)
            .padding(.top, 40)
    }
}
