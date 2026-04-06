//
//
//  TopicRegistry.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `18/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Topic Registry
/// The single source of truth for all topics in the app.
/// To add a new topic: create its struct, conform to TopicProtocol, add it here.
struct TopicRegistry {
    static let all: [any TopicProtocol] = [
        ConcurrencyTopic(),
        AnimationsTopic(),
        SFSymbolsTopic(),
        StateBindingTopic(),
        NavigationStackTopic(),
        ListForEachTopic(),
        TextTypographyTopic(),
        StacksSpacerTopic(),
        GesturesTopic(),
        KeyboardTopic(),
        MaskingTopic(),
        BlendModesTopic(),
        ButtonsTopic(),
        BottomSheetsTopic(),
    ]
}
