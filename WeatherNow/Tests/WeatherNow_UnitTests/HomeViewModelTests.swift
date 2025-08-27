//  WeatherNow_UnitTests.swift
//  WeatherNow_UnitTests
//  Created by Vino_Swify on 26/08/25.

import Testing
@testable import WeatherNow
@MainActor
struct HomeViewModelTests {

  @Test("Initial state should be idle")
        func initialStateIdle() {
            let repo = StubWeatherRepository()
            let sut = HomeViewModel(repo: repo)

            #expect(sut.state == .idle)
        }

@Test("Successful load updates state to loaded")
        func loadSuccess() async throws {
            let repo = StubWeatherRepository(
                weather: .mock,
                forecast: [.mock],
                cities: [.mock],
                shouldFail: false
            )
            let sut =  HomeViewModel(repo: repo)

            await sut.load(lat: 12.97, lon: 77.59)

            if case .loaded(let weather, let forecast) =  sut.state {
                #expect(weather.tempC == 25)
                #expect(forecast.count == 1)
            } else {
                Issue.record("Expected loaded state, got \( sut.state)")
            }
        }

@Test("Failure load updates state to error")
        func loadFailure() async throws {
            let repo = StubWeatherRepository(shouldFail: true)
            let sut =  HomeViewModel(repo: repo)

            await sut.load(lat: 12.97, lon: 77.59)

            if case .error(let message) =  sut.state {
                #expect(message.contains("Couldn’t load weather"))
            } else {
                Issue.record("Expected error state, got \( sut.state)")
            }
        }

        @Test("Search cities returns stubbed results")
        func searchCities() async throws {
            let repo = StubWeatherRepository(cities: [.mock])
            let cities = try await repo.searchCities(query: "Chen")

            #expect(cities.count == 1)
            #expect(cities.first?.name == "Chennai")
        }

}
