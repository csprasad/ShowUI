//
//
//  PlaceHolderTopic.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Buttons Topic
struct ButtonsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Buttons"
    let subtitle    = "Custom styles, roles, loading states and interactions"
    let icon        = "hand.tap.fill"
    let color       = Color(hex: "#EEEDFE")
    let accentColor = Color(hex: "#534AB7")
    let tag         = "Controls"

    var lessons: [AnyLesson] { [] }   // Add ButtonsLesson entries here
}

// MARK: - Masking Topic
struct MaskingTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Masking"
    let subtitle    = "Clip shapes, masks and reveal animations"
    let icon        = "theatermask.and.paintbrush.fill"
    let color       = Color(hex: "#FAECE7")
    let accentColor = Color(hex: "#993C1D")
    let tag         = "Visual"

    var lessons: [AnyLesson] { [] }
}

// MARK: - Bottom Sheets Topic
struct BottomSheetsTopic: TopicProtocol {
    let id          = UUID()
    let title       = "Bottom Sheets"
    let subtitle    = "Detents, drag indicators, custom presentations"
    let icon        = "rectangle.bottomhalf.inset.filled"
    let color       = Color(hex: "#EAF3DE")
    let accentColor = Color(hex: "#3B6D11")
    let tag         = "Navigation"

    var lessons: [AnyLesson] { [] }
}
