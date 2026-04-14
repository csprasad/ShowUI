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

import SwiftUI

// MARK: - Topic Registry
/// The single source of truth for all topics in the app.
///
// ⚠️ ARCHITECTURE NOTE:
/// To prevent Git Merge Conflicts in a team environment, this list MUST be maintained
/// in ALPHABETICAL ORDER.
///
/// WHY? Git merges work by comparing lines. If multiple developers append to the bottom,
/// it causes a conflict. By inserting topics alphabetically into "Letter Zones,"
/// Git can auto-merge changes to different parts of this file without human intervention.
struct TopicRegistry {
    static let all: [any TopicProtocol] = [
        // --- @ ---
        ObservableStateTopic(),
        
        // --- A ---
        AnimationsTopic(),
        AlertsSheetsTopic(),
        AnimationsDeepDiveTopic(),
        
        // --- B ---
        BlendModesTopic(),
        BottomSheetsTopic(),
        ButtonsTopic(),
        
        // --- C ---
        ConcurrencyTopic(),
        ColorsGradientsTopic(),
        ControlsDeepDiveTopic(),
        
        // --- E ---
        EnvironmentDependenciesTopic(),
        
        // --- F ---
        FormsTopic(),
        
        // --- G ---
        GesturesTopic(),
        GridsTopic(),
        GeometryReaderTopic(),
        
        // --- I ---
        ImagesTopic(),
        
        // --- K ---
        KeyboardTopic(),
        
        // --- L ---
        ListForEachTopic(),
        
        // --- M ---
        MaskingTopic(),
        
        // --- N ---
        NavigationStackTopic(),
        
        // --- S ---
        SFSymbolsTopic(),
        StacksSpacerTopic(),
        StateBindingTopic(),
        ScrollViewsTopic(),
        ShapesPathsTopic(),
        SwiftDataTopic(),
        SwiftChartsTopic(),
        
        // --- T ---
        TextTypographyTopic(),
        TextFieldDeepDiveTopic(),
        TabViewBarsTopic(),
        
        // --- V ---
        ViewModifiersTopic(),
        
        // 💡 Rule: Always keep a trailing comma on the last item to prevent diff-noise.
    ]
}
