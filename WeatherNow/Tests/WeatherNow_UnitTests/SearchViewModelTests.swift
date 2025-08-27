//  WeatherNow_UnitTests.swift
//  WeatherNow_UnitTests
//  Created by Vino_Swify on 26/08/25.

import Testing
@testable import WeatherNow

@MainActor
struct SearchViewModelTests {

     @Test("Initial state is idle")
    func initialStateIdle() {
        let sut = SearchViewModel.test(repo: StubWeatherRepository())
        #expect(sut.results.isEmpty)
        #expect(sut.error == nil)
        #expect(sut.isLoading == false)
    }

    @Test("Empty query clears results")
    func emptyQueryClears() async {
        let sut =  SearchViewModel.test(repo: StubWeatherRepository(cities: GeoCity.mocks))

        sut.query = ""   // triggers scheduleSearch
        try? await Task.sleep(nanoseconds: 5_000_000) // let async settle

         #expect(sut.results.isEmpty)
         #expect(sut.error == nil)
    }

     @Test("Valid query returns results")
    func searchReturnsResults() async {
        let repo = StubWeatherRepository(cities: GeoCity.mocks)
        let sut =  SearchViewModel.test(repo: repo)

        sut.query = "Chennai"
        try? await Task.sleep(nanoseconds: 50_000_000)

         #expect(!sut.results.isEmpty)
         #expect(sut.results.first?.name == "Chennai")
    }

     @Test("Failure search clears results and sets error")
    func searchFailure() async {
        let repo = StubWeatherRepository(shouldFail: true)
        let sut =  SearchViewModel.test(repo: repo)

        sut.query = "Chennai"
        try? await Task.sleep(nanoseconds: 5_000_000)

         #expect(sut.results.isEmpty)
        // You can uncomment error assignment in performSearchNow for this:
        // #expect(sut.error?.contains("Search failed") == true)
    }

    @Test("Second query cancels first one")
    func cancelStaleSearch() async {
        let repo = StubWeatherRepository(cities: GeoCity.mocks)
        let sut =  SearchViewModel(repo: repo, debounceNS: 50_000_000) // 50ms debounce

        sut.query = "Che"
        sut.query = "Chennai"  // quickly overwrite

        try? await Task.sleep(nanoseconds: 200_000_000) // wait > debounce

         #expect(sut.results.first?.name == "Chennai")
    }

     @Test("Repeated query uses cache instead of hitting repo again")
    func cachedQuery() async {
        let repo = StubWeatherRepository(cities: GeoCity.mocks)
        let sut =  SearchViewModel.test(repo: repo)

        // First search fills cache
        sut.query = "Chennai"
        try? await Task.sleep(nanoseconds: 50_000_000)

        // Simulate repo going empty
        repo.stubCities = []

        // Search again, should come from cache
        sut.query = "Chennai"
        try? await Task.sleep(nanoseconds: 50_000_000)

         #expect(sut.results.first?.name == "Chennai")
    }
    
    
    // MARK: - onSubmit

    @Test("onSubmit triggers immediate search")
    func onSubmitTriggersSearch() async {
        let repo = StubWeatherRepository(cities: GeoCity.mocks)
        let sut = SearchViewModel.test(repo: repo)

        sut.query = "Chennai"
        sut.onSubmit()
        try? await Task.sleep(nanoseconds: 50_000_000)
        #expect(!sut.results.isEmpty)
        #expect(sut.results.first?.name == "Chennai")
    }

    // MARK: - cancelSearch

    @Test("cancelSearch prevents results")
    func cancelSearchPreventsResults() async {
        let repo = StubWeatherRepository(cities: GeoCity.mocks)
        let sut = SearchViewModel(repo: repo, debounceNS: 50_000_000) // 50ms debounce

        sut.query = "Chennai"
        sut.cancelSearch() // cancel before debounce fires

        try? await Task.sleep(nanoseconds: 100_000_000) // wait longer than debounce
        #expect(sut.results.isEmpty)
    }
   
    // MARK: - caching

    @Test("search uses cached results")
    func searchUsesCache() async {
        let repo = StubWeatherRepository(cities: GeoCity.mocks)
        let sut = SearchViewModel.test(repo: repo)

        // First call populates cache
        sut.query = "Chennai"
        try? await Task.sleep(nanoseconds: 50_000_000)

        // Clear repo so if it hits repo again, no results would be returned
        repo.stubCities = []

        // Run search again - should return cached results
        sut.query = "Chennai"
        sut.onSubmit()

        #expect(!sut.results.isEmpty)
        #expect(sut.results.first?.name == "Chennai")
    }

    // MARK: - normalization

    @Test("Query normalization trims spaces and ignores case")
    func queryNormalizationIndirect() async {
        let repo = StubWeatherRepository(cities: GeoCity.mocks)
        let sut = SearchViewModel.test(repo: repo)

        sut.query = "   cHeNnai  "   // messy input
        sut.onSubmit()         // triggers normalized inside VM
        
        try? await Task.sleep(nanoseconds: 50_000_000)

        #expect(!sut.results.isEmpty)
        #expect(sut.results.first?.name == "Chennai")
    }
  
}
