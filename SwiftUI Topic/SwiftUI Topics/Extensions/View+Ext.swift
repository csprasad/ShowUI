//
//
//  View+Ext.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `16/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Custom view modifier for tabbar filter accessory
extension View {
    @ViewBuilder
    func applyLiquidFilterBar(isEnabled: Bool, @ViewBuilder content: @escaping () -> some View) -> some View {
        if #available(iOS 26.0, *) {
            if isEnabled {
                self.tabViewBottomAccessory {
                    content()
                        .frame(height: isEnabled ? nil : 0)
                        .opacity(isEnabled ? 1 : 0)
                        .clipped()
                        .animation(.easeIn, value: isEnabled)
                }
            } else {
                self // Return the view without the accessory slot
            }
        } else {
            // iOS 18: Overlay approach
            self.overlay(alignment: .bottom) {
                if isEnabled {
                    content()
                        .padding(.bottom, 80)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .opacity
                        ))
                }
            }
        }
    }
}
