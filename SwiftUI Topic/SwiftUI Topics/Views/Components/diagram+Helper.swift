//
//
//  diagram+Helper.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `03/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Shared diagram primitives
struct NavScreenMock: View {
    let title: String
    let color: Color
    let isTop: Bool
    var items: [String] = []
    var hasBackButton: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 4) {
                if hasBackButton {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 9, weight: .semibold)).foregroundStyle(color)
                    Text("Back").font(.system(size: 9)).foregroundStyle(color)
                }
                Spacer()
                Text(title).font(.system(size: 10, weight: .semibold)).foregroundStyle(.primary)
                Spacer()
                if !hasBackButton { Color.clear.frame(width: 24) }
            }
            .padding(.horizontal, 8).padding(.vertical, 5)
            .background(Color(.systemBackground))
            .overlay(Divider(), alignment: .bottom)

            if items.isEmpty {
                Text("Content").font(.system(size: 9)).foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: 0) {
                    ForEach(items.prefix(3), id: \.self) { item in
                        HStack {
                            Text(item).font(.system(size: 9)).foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: "chevron.right").font(.system(size: 7)).foregroundStyle(.tertiary)
                        }
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        Divider().padding(.leading, 8)
                    }
                    Spacer()
                }
            }
        }
        .frame(width: 100, height: 80)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(isTop ? 0.1 : 0.04), radius: isTop ? 5 : 2, y: isTop ? 2 : 1)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(isTop ? color.opacity(0.4) : Color(.systemFill), lineWidth: isTop ? 1.5 : 0.5))
    }
}

func navCodeChip(_ text: String, color: Color = .navBlue) -> some View {
    Text(text)
        .font(.system(size: 9, design: .monospaced))
        .foregroundStyle(color)
        .padding(.horizontal, 6).padding(.vertical, 3)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 4))
}
