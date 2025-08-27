//  HomeView.swift
//  Created by Vino_Swify on 25/08/25.

import SwiftUI
import CoreLocation
import Combine

/// Main screen that shows current weather, forecast, and search
struct HomeView: View {
    // ViewModels and Managers
    @StateObject private var vm = HomeViewModel()
    @StateObject private var loc = LocationManager()
    @StateObject private var searchVM = SearchViewModel()

    // State for manual city selection
    @State private var useManual = false
    @State private var manualCoord: CLLocationCoordinate2D?
    @State private var lastLoadedCoord: CLLocationCoordinate2D?

    /// Converts ForecastDay → ForecastItemVM for UI display
    private func pills(from days: [ForecastDay]) -> [ForecastItemVM] {
        let df = DateFormatter(); df.dateFormat = DateFormats.dayOfWeekShort
        return days.prefix(AppConstants.forecastDaysLimit).map {
            ForecastItemVM(day: df.string(from: $0.date),
                           min: Int($0.minC.rounded()),
                           max: Int($0.maxC.rounded()),
                           symbol: $0.symbol)
        }
    }

    var body: some View {
        ZStack {
            // Background gradient theme
            LinearGradient(
                gradient: Gradient(colors: [.indigo, .blue, .black.opacity(0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // MARK: - Header
                HStack {
                    // App title with gradient text
                    Text(AppStrings.appTitle)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(LinearGradient(
                            colors: [.white, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .shadow(radius: 3)
                    Spacer()

                    // Button to jump back to GPS location if user selected manually
                    if useManual {
                        Button {
                            useManual = false
                            if let c = loc.coord {
                                lastLoadedCoord = c
                                Task { await vm.load(lat: c.latitude, lon: c.longitude) }
                            }
                        } label: {
                            Image(systemName: SystemIcons.locationFill)
                                .font(.title2)
                                .padding(10)
                                .background(.ultraThinMaterial, in: Circle())
                                .shadow(radius: 4)
                        }
                    }

                    // Navigation → Search screen
                    NavigationLink {
                        SearchView { city in
                            // On city select → use manual coords & save to defaults
                            useManual = true
                            let c = CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon)
                            manualCoord = c
                            lastLoadedCoord = c
                            UserDefaults.standard.set(city.lat, forKey: UserDefaultsKeys.lastLatitude)
                            UserDefaults.standard.set(city.lon, forKey: UserDefaultsKeys.lastLongitude)
                            Task { await vm.load(lat: city.lat, lon: city.lon) }
                        }
                    } label: {
                        Image(systemName: SystemIcons.magnifyingGlass)
                            .font(.title2)
                            .padding(10)
                            .background(.ultraThinMaterial, in: Circle())
                            .shadow(radius: 4)
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 0)

                // MARK: - Main Content
                switch vm.state {
                case .idle, .loading:
                    // Show fallback if location permission denied
                    if loc.status == .denied || loc.status == .restricted {
                        deniedFallback
                    } else {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                            .padding(.top, 60)
                    }

                case .error(let msg):
                    // Error state with retry option
                    VStack(spacing: 12) {
                        Image(systemName: SystemIcons.exclamationTriangleFill)
                            .font(.system(size: 40))
                            .foregroundColor(.yellow)
                        Text(msg)
                            .foregroundColor(.white)
                        Button(AppStrings.retry) {
                            if useManual, let c = manualCoord {
                                lastLoadedCoord = c
                                Task { await vm.load(lat: c.latitude, lon: c.longitude) }
                            } else if let c = loc.coord {
                                lastLoadedCoord = c
                                Task { await vm.load(lat: c.latitude, lon: c.longitude) }
                            }
                        }
                        .padding(.horizontal, 16).padding(.vertical, 8)
                        .background(.ultraThinMaterial, in: Capsule())
                        .shadow(radius: 6)
                    }

                case .loaded(let w, let f):
                    // MARK: - Weather Card
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(w.city)
                                    .font(.title.bold())
                                Text(w.condition)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: SystemIcons.cloudFill)
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                                .shadow(radius: 4)
                        }

                        // Big temperature display
                        Text("\(Int(w.tempC.rounded()))°")
                            .font(.system(size: 80, weight: .heavy))
                            .transition(.scale)
                            .foregroundColor(.white)
                            .shadow(radius: 6)

                        // Quick stats row
                        HStack(spacing: 24) {
                            Label("\(Int(w.feelsLikeC))°C", systemImage: SystemIcons.thermometer)
                            Label("\(w.humidity)%", systemImage: SystemIcons.dropFill)
                            Label("\(Int(w.windKph)) km/h", systemImage: SystemIcons.wind)
                        }
                        .foregroundColor(.white.opacity(0.9))
                        .font(.subheadline)
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
                    .shadow(radius: 12)
                    .padding(.horizontal)
                    .animation(.easeInOut, value: w.tempC)

                    // MARK: - Forecast Strip
                    VStack(alignment: .leading, spacing: 12) {
                        Text(AppStrings.forecastTitle)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(pills(from: f)) { item in
                                    VStack(spacing: 8) {
                                        Text(item.day)
                                            .font(.headline)
                                        Image(systemName: item.symbol)
                                            .font(.title2)
                                            .foregroundColor(.cyan)
                                        Text("\(item.max)° / \(item.min)°")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.8))
                                            .minimumScaleFactor(0.7)
                                            .lineLimit(1)
                                    }
                                    .padding()
                                    .frame(width: 90, height: 130)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                                    .shadow(radius: 6)
                                    .transition(.opacity.combined(with: .slide))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                Spacer()
            }
        }
        // MARK: - Auto load weather when location updates
        .onReceive(loc.$coord.compactMap { $0 }) { c in
            guard !useManual else { return }
            if let last = lastLoadedCoord,
               last.latitude == c.latitude, last.longitude == c.longitude { return }
            lastLoadedCoord = c
            Task { await vm.load(lat: c.latitude, lon: c.longitude) }
        }
        // MARK: - Initial load
        .task {
            guard !useManual, let c = loc.coord else { return }
            lastLoadedCoord = c
            await vm.load(lat: c.latitude, lon: c.longitude)
        }
    }

    // MARK: - Fallback when location denied
    private var deniedFallback: some View {
        VStack(spacing: 20) {
            Image(systemName: SystemIcons.locationSlash)
                .font(.system(size: 40))
                .foregroundColor(.red)

            Text(AppStrings.locationDisabled)
                .font(.headline)
                .foregroundColor(.white)

            // Inline search bar to fallback when GPS blocked
            SearchBar(text: $searchVM.query)
                .padding(.horizontal)

            if searchVM.isLoading {
                ProgressView().tint(.white)
            }

            // List of city search results
            List {
                ForEach(searchVM.results) { city in
                    CityRow(name: "\(city.name), \(city.country)")
                        .onTapGesture {
                            useManual = true
                            let c = CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon)
                            manualCoord = c
                            lastLoadedCoord = c
                            Task { await vm.load(lat: city.lat, lon: city.lon) }
                        }
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
