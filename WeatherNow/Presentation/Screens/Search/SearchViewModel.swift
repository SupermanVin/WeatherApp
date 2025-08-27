//
//  SearchViewModel.swift
//  WeatherNow
//
//  Created by Vino_Swify on 25/08/25.
import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    // MARK: - Published (UI bindings)
    @Published var query: String = "" { didSet { scheduleSearch() } } // live text input
    @Published var results: [GeoCity] = []   // search results bound to UI
    @Published var isLoading = false         // drives spinner
    @Published var error: String?            // error message to show in UI
    
    // MARK: - Dependencies
    private let repo: WeatherRepository      // repository to fetch cities
    
    // MARK: - Search control
    private var searchTask: Task<Void, Never>? // debounce task
    private var currentSearchID = 0             // unique ID to drop stale responses
    private var cache: [String: [GeoCity]] = [:] // in-memory cache for repeated queries
    
    // MARK: - Tuning parameters
    private let minLength: Int                 // minimum query length before searching
    private let debounceNS: UInt64             // debounce interval in nanoseconds
    
    init(
        repo: WeatherRepository = WeatherRepositoryImpl(),
        minLength: Int = AppConstants.searchMinLength,
        debounceNS: UInt64 = AppConstants.searchDebounceNS // ~300ms
    ) {
        self.repo = repo
        self.minLength = minLength
        self.debounceNS = debounceNS
    }
    
    /// Run search immediately (used on TextField submit)
    func onSubmit() {
        searchTask?.cancel()
        let q = normalized(query)
        guard q.count >= minLength else {
            results.removeAll(); error = nil; return
        }
        Task { await performSearchNow(q) }
    }
    
    /// Cancel any in-flight search
    func cancelSearch() {
        searchTask?.cancel()
    }
    
    // MARK: - Private
    
    /// Debounced search scheduling → waits a bit before firing request
    private func scheduleSearch() {
        searchTask?.cancel()
        
        let q = normalized(query)
        guard q.count >= minLength else {
            results.removeAll(); error = nil
            return
        }
        
        // Start a new debounced task
        searchTask = Task { [weak self] in
            guard let self else { return }
            do { try await Task.sleep(nanoseconds: debounceNS) } catch { return }
            await self.performSearchNow(q)
        }
    }
    
    /// Performs the actual API search
    private func performSearchNow(_ q: String) async {
        // 1) Return cached results instantly if available
        if let cached = cache[q] {
            self.error = nil
            self.results = cached
            return
        }
        
        // 2) Otherwise fetch from network
        isLoading = true
        error = nil
        let searchID = nextSearchID()
        
        do {
            let cities = try await repo.searchCities(query: q)
            
            // Drop results if a newer search started meanwhile
            guard !Task.isCancelled, searchID == currentSearchID else { return }
            
            cache[q] = cities
            results = cities
        } catch is CancellationError {
            // Ignore → search cancelled in favor of a newer one
            return
        } catch {
            // Only show error if still current search
            guard searchID == currentSearchID else { return }
            results = []
            self.error = AppStrings.searchFailed
        }
        
        isLoading = false
    }
    
    /// Generates monotonically increasing ID for each search
    private func nextSearchID() -> Int {
        currentSearchID &+= 1
        return currentSearchID
    }
    
    /// Normalize query (lowercase + remove accents + trim)
    private func normalized(_ s: String) -> String {
        s.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

