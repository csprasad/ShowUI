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

struct HomeView: View {
    private let topics = TopicRegistry.all

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    header
                    topicGrid
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
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
            ForEach(topics, id: \.id) { topic in
                NavigationLink(destination: TopicDetailView(topic: topic)) {
                    TopicCard(topic: topic)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
}
