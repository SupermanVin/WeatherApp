//  SearchView.swift.swift
//  WeatherNow
//  Created by Vino_Swify on 25/08/25.

import SwiftUI

/// A single row representing a city in the search results
struct CityRow: View {
    let name: String
    
    var body: some View {
        HStack {
            Image(SystemIcons.mappinAndEllipse)
                .foregroundColor(AppColors.accent)
            Text(name)
                .foregroundColor(AppColors.primaryText)
            Spacer()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle()) // makes whole row tappable
    }
}

/// Search screen to find cities by name
/// Used by HomeView to let user manually pick a location
struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = SearchViewModel()

    /// Callback to send chosen city back to HomeView
    let onSelect: (GeoCity) -> Void

    var body: some View {
        VStack(spacing: Spacing.md) {
            // MARK: - Search bar
            SearchBar(text: $vm.query)
                .padding(.horizontal, Spacing.md)

            // Show loading spinner while querying API
            if vm.isLoading {
                ProgressView()
                    .tint(AppColors.accent)
                    .padding()
            }

            // Show error message if search fails
            if let err = vm.error {
                Text(err)
                    .foregroundColor(AppColors.secondaryText)
                    .padding(.horizontal, Spacing.md)
            }

            // MARK: - Search results
            if #available(iOS 16.0, *) {
                List {
                    ForEach(vm.results) { city in
                        CityRow(name: "\(city.name), \(city.country)")
                            .listRowBackground(AppColors.bg)
                            .onTapGesture {
                                // Select city → pass to parent + close screen
                                onSelect(city)
                                dismiss()
                            }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(AppColors.bg)
            } else {
                // iOS 15 fallback
                List {
                    ForEach(vm.results) { city in
                        CityRow(name: "\(city.name), \(city.country)")
                            .listRowBackground(AppColors.bg)
                            .onTapGesture {
                                onSelect(city)
                                dismiss()
                            }
                    }
                }
                .listStyle(.plain)
                .background(AppColors.bg)
                .onAppear {
                    // Clear UITableView background for older versions
                    UITableView.appearance().backgroundColor = .clear
                }
            }
        }
        .padding(.top, Spacing.md)
        .background(AppColors.bg.ignoresSafeArea())
        .navigationTitle(AppStrings.search)
    }
}
