//
//
//  Tip-Test.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `15/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///
import SwiftUI
import TipKit

struct MyTip: Tip {
    let id: String // 💡 This allows us to "reset" the tip by changing its identity
    
    var title: Text { Text("Dynamic Tip") }
    var message: Text? { Text("This reappears even after clicking X!") }
    
    @Parameter static var isEnabled: Bool = true
    var rules: [Rule] {
        #Rule(Self.$isEnabled) { $0 == true }
    }
}

#Preview {
    TipTriggerView()
}

struct TipTriggerView: View {
    @State private var isVisible = true
    @State private var tipSeed = 0

    // Computed property: Whenever tipSeed changes, this becomes a "New" tip
    var currentTip: MyTip {
        MyTip(id: "tip-v\(tipSeed)")
    }

    var body: some View {
        VStack(spacing: 20) {
            if isVisible {
                TipView(currentTip)
                    .id("view-v\(tipSeed)") // 💡 Force SwiftUI to redraw the TipView
                    .padding()
            }

            Button(isVisible ? "Dismiss" : "Show Again") {
                withAnimation {
                    if isVisible {
                        isVisible = false
                        MyTip.isEnabled = false
                    } else {
                        // 💡 THE MAGIC: Incrementing the seed generates a new ID.
                        // TipKit thinks this is a completely different tip.
                        tipSeed += 1
                        MyTip.isEnabled = true
                        isVisible = true
                    }
                }
            }
        }
        .task {
            try? Tips.configure([.displayFrequency(.immediate)])
            
            // This syncs the 'X' button with your local 'isVisible' state
            for await shouldDisplay in currentTip.shouldDisplayUpdates {
                if !shouldDisplay { isVisible = false }
            }
        }
    }
}
