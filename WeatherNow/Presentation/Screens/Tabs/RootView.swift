//  RootView.swift
//  WeatherNow
//  Created by Vino_Swify on 26/08/25.

import SwiftUI

struct RootView: View {
    init() {
        // Global tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Label(AppStrings.weatherTitle, systemImage: SystemIcons.cloudSunFill)
            }

            NavigationView {
                FavouriteView()
            }
            .tabItem {
                Label(AppStrings.favouritesTitle, systemImage: SystemIcons.starFill)
            }

            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label(AppStrings.settingsTitle, systemImage: SystemIcons.gearshapeFill)
            }
        }
    }
}
