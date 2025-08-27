//  SearchView.swift
//  Created by Vino_Swify on 25/08/25.
import SwiftUI
public struct SearchBar: View {
    @Binding var text: String
    public init(text: Binding<String>) { self._text = text }

    public var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: SystemIcons.magnifyingGlass)
                .foregroundColor(AppColors.secondaryText)

            TextField(AppStrings.searchPlaceholder, text: $text)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(true)
                .foregroundColor(AppColors.primaryText)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: SystemIcons.clearTextCircleFill)
                        .foregroundColor(AppColors.secondaryText)
                }
                .accessibilityLabel(AppStrings.clearText)
            }
        }
        .padding()
        .background(AppColors.card)
        .cornerRadius(Radius.md)
        .shadow(color: Shadows.soft, radius: 6, x: 0, y: 4)
    }
}


