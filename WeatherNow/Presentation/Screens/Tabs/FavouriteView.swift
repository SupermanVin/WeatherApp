//  FavouriteView.swift
//  WeatherNow
//  Created by Vino_Swify on 26/08/25.
import SwiftUI

struct FavouriteView: View {
    // Example list of favourite cities
    @State private var favourites: [String] = AppConstants.sampleFavourites

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                if favourites.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: SystemIcons.starSlashFill)
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text(AppStrings.noFavourites)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(favourites, id: \.self) { city in
                            HStack {
                                Image(systemName: SystemIcons.mappinAndEllipse)
                                    .foregroundColor(.blue)
                                Text(city)
                            }
                        }
                        .onDelete { indexSet in
                            favourites.remove(atOffsets: indexSet)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle(AppStrings.favouritesTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        favourites.append(AppStrings.newCity)
                    } label: {
                        Image(systemName: SystemIcons.plus)
                    }
                }
            }
        }
    }
}

#Preview {
    FavouriteView()
}
