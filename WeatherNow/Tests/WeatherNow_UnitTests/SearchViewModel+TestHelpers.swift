//
//  SearchViewModel+TestHelpers.swift
//  WeatherNow_UnitTests
//
//  Created by Vino_Swify on 27/08/25.
//
import Foundation
@testable import WeatherNow

extension SearchViewModel {
    /// A convenience initializer for testing (fast debounce, injectable repo)
    static func test(repo: WeatherRepository) -> SearchViewModel {
        SearchViewModel(repo: repo, debounceNS: 0) // no debounce delay in tests
    }
}
