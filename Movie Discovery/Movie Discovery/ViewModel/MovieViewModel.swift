//
//  MovieViewModel.swift
//  Movie Discovery
//
//  Created by Adarsh Urs on 02/04/25.
//

import Foundation
import Combine
import Alamofire
class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchResults: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = "" {
        didSet { searchMovies() }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://api.themoviedb.org/3"
    private var apiKey = ""

    init() {
        configureCache()
        apiKey = getAPIKey()
        fetchMovies()
    }
    
    private func configureCache() {
          let cacheSizeMemory = 50 * 1024 * 1024 // 50MB Memory Cache
          let cacheSizeDisk = 100 * 1024 * 1024 // 100MB Disk Cache
          let urlCache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: "tmdbCache")
          URLCache.shared = urlCache
      }

    func fetchMovies() {
            isLoading = true
            errorMessage = nil

            let url = "\(baseURL)/discover/movie?api_key=\(apiKey)"
            
            let request = URLRequest(url: URL(string: url)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)

            AF.request(request)
                .publishDecodable(type: MovieResponse.self)
                .compactMap { $0.value }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                    self.isLoading = false
                }, receiveValue: { response in
                    self.movies = response.results
                })
                .store(in: &cancellables)
        }

        func searchMovies() {
                guard !searchText.isEmpty else {
                    searchResults = []
                    return
                }

                let url = "\(baseURL)/search/movie?query=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&api_key=\(apiKey)"

                let request = URLRequest(url: URL(string: url)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)

                AF.request(request)
                    .publishDecodable(type: MovieResponse.self)
                    .compactMap { $0.value }
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            self.errorMessage = error.localizedDescription
                        }
                    }, receiveValue: { response in
                        self.searchResults = response.results
                    })
                    .store(in: &cancellables)
            }
        

    var displayedMovies: [Movie] {
        searchResults.isEmpty ? movies : searchResults
    }
    
    
    func getAPIKey() -> String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let apiKey = plist["TMDB_API_KEY"] as? String else {
            fatalError("API Key not found. Make sure to add it to Secrets.plist")
        }
        return apiKey
    }
}


