//  View+Extensions.swift
//  WeatherNow
//  Created by Vino_Swify on 27/08/25.

import Foundation
import SwiftUI

extension View {
    /// Applies a common card style
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
    }

    /// Conditionally apply a modifier
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
