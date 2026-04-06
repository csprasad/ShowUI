//
//
//  SectionHeader.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `06/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Section Header
struct SectionHeader: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .padding(.bottom, 2)
    }
}
