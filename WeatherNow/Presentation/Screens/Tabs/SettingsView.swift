//  SettingsView.swift
//  WeatherNow
//  Created by Vino_Swify on 26/08/25.
import SwiftUI

struct SettingsView: View {
    @AppStorage(UserDefaultsKeys.useCelsius) private var useCelsius: Bool = true
    @AppStorage(UserDefaultsKeys.notificationsEnabled) private var notificationsEnabled: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(AppStrings.generalSection)) {
                    Toggle(AppStrings.useCelsius, isOn: $useCelsius)
                    Toggle(AppStrings.enableNotifications, isOn: $notificationsEnabled)
                }

                Section(header: Text(AppStrings.aboutSection)) {
                    HStack {
                        Text(AppStrings.appVersion)
                        Spacer()
                        Text(AppStrings.versionNumber)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text(AppStrings.developer)
                        Spacer()
                        Text(AppStrings.developerName)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(AppStrings.settingsTitle)
        }
    }
}

#Preview {
    SettingsView()
}
