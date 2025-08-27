//  Tokens.swift
//  Created by Vino_Swify on 25/08/25.
import SwiftUI

// Colors (dark theme)
public enum AppColors {
    public static let bg = Color(hex: 0x0F172A)          // slate-900
    public static let card = Color(hex: 0x111827)        // gray-900
    public static let primaryText = Color(hex: 0xF8FAFC) // slate-50
    public static let secondaryText = Color(hex: 0x94A3B8) // slate-400
    public static let accent = Color(hex: 0x38BDF8)      // sky-400
    public static let error = Color(hex: 0xF87171)
}

public enum AppTypography {
    public static let h1 = Font.system(size: 40, weight: .bold, design: .rounded)
    public static let h2 = Font.system(size: 28, weight: .semibold, design: .rounded)
    public static let body = Font.system(size: 17, weight: .regular, design: .rounded)
    public static let caption = Font.system(size: 13, weight: .medium, design: .rounded)
}

public enum Spacing { public static let xs: CGFloat = 6; public static let sm: CGFloat = 10
    public static let md: CGFloat = 16; public static let lg: CGFloat = 24; public static let xl: CGFloat = 32 }

public enum Radius { public static let md: CGFloat = 16; public static let lg: CGFloat = 24 }
public enum Shadows { public static let soft = Color.black.opacity(0.12) }

public extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF)/255,
                  green: Double((hex >> 8) & 0xFF)/255,
                  blue: Double(hex & 0xFF)/255,
                  opacity: alpha)
    }
}
