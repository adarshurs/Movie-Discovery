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
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = "" {
        didSet { searchMovies() } // Automatically triggers search on text change
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let apiURL = "https://api.themoviedb.org/3/discover/movie?api_key=01a635f7a0a2da67e08d3008bae4da43"
    
    init() {
        fetchMovies()
    }
    
    func fetchMovies() {
        isLoading = true
        errorMessage = nil
        
        AF.request(apiURL)
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
            fetchMovies() // Reset to original movies when search is cleared
            return
        }
        
        let searchURL = "https://api.themoviedb.org/3/search/movie?query=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&api_key=01a635f7a0a2da67e08d3008bae4da43"
        
        isLoading = true
        errorMessage = nil
        
        AF.request(searchURL)
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
}

