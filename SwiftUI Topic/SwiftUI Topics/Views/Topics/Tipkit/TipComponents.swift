//
//
//  TipComponents.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `14/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import TipKit

// MARK: - Shared tip definitions (used across lessons)
struct WelcomeTip: Tip {
    var title: Text { Text("Welcome to the app!") }
    var message: Text? { Text("Tap the + button to create your first item and get started.") }
    var image: Image? { Image(systemName: "hand.wave.fill") }
}

struct SearchTip: Tip {
    var title: Text { Text("Search smarter") }
    var message: Text? { Text("Use filters to narrow results by date, category, or priority.") }
    var image: Image? { Image(systemName: "magnifyingglass") }
}

struct FavouriteTip: Tip {
    var title: Text { Text("Save for later") }
    var message: Text? { Text("Tap the heart icon to add items to your favourites list.") }
    var image: Image? { Image(systemName: "heart.fill") }
    var actions: [Action] {[
        Action(id: "learn-more", title: "Learn more"),
        Action(id: "dismiss",    title: "Got it"),
    ]}
}

struct ShareTip: Tip {
    var title: Text { Text("Share with friends") }
    var message: Text? { Text("Tap share to send items via Messages, Mail, or AirDrop.") }
    var image: Image? { Image(systemName: "square.and.arrow.up") }
}

struct ProFeatureTip: Tip {
    var title: Text { Text("Pro feature") }
    var message: Text? { Text("Upgrade to Pro to unlock unlimited exports, themes, and priority support.") }
    var image: Image? { Image(systemName: "star.circle.fill") }
    var actions: [Action] {[
        Action(id: "upgrade", title: "Upgrade to Pro"),
    ]}
}

struct NotificationTip: Tip {
    var title: Text { Text("Stay on schedule") }
    var message: Text? { Text("Enable notifications to get reminders before deadlines.") }
    var image: Image? { Image(systemName: "bell.badge.fill") }
}
