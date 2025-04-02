//
//  MovieViewModelTests.swift
//  Movie Discovery
//
//  Created by Adarsh Urs on 02/04/25.
//

import XCTest
import Combine
@testable import Movie_Discovery

class MovieViewModelTests: XCTestCase {
    var viewModel: MovieViewModel!
    
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        viewModel = MovieViewModel()
    }

    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }

    
    func testFetchMovies_Success() {
        let mockMovies = [Movie(id: 1, adult: false, backdropPath: "2024-01-01", genreIDs: [32, 32], originalLanguage: "es", originalTitle: "Test Overview", overview: "en", popularity: 4.3, posterPath: "/2KIqFpvjVI6mNBTQw7MYZdzRYvs.jpg", releaseDate: "2024-01-01", title: "Test Movie", video: false, voteAverage: 10, voteCount: 10)]
        let mockResponse = MovieResponse(page: 1, results: mockMovies)

        let expectation = XCTestExpectation(description: "Movies fetched successfully")

        // Inject mock response
        viewModel.$movies
            .dropFirst() // Ignore initial empty value
            .sink { movies in
                XCTAssertEqual(movies.count, 1)
                XCTAssertEqual(movies.first?.title, "Test Movie")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Simulate API response
        viewModel.movies = mockResponse.results

        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchMovies_Failure() {
        let expectation = XCTestExpectation(description: "Fetch failed with error")

        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Simulate failure
        viewModel.errorMessage = "Network Error"

        wait(for: [expectation], timeout: 2.0)
    }


    func testSearchMovies_Success() {
        let mockMovies = [Movie(id: 1, adult: false, backdropPath: "2024-01-01", genreIDs: [32, 32], originalLanguage: "es", originalTitle: "Searched Overview", overview: "en", popularity: 4.3, posterPath: "/2KIqFpvjVI6mNBTQw7MYZdzRYvs.jpg", releaseDate: "2024-01-01", title: "Searched Movie", video: false, voteAverage: 10, voteCount: 10)]
        let expectation = XCTestExpectation(description: "Search movies fetched successfully")

        viewModel.$searchResults
            .dropFirst()
            .sink { searchResults in
                XCTAssertEqual(searchResults.count, 1)
                XCTAssertEqual(searchResults.first?.title, "Searched Movie")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Simulate search response
        viewModel.searchResults = mockMovies

        wait(for: [expectation], timeout: 2.0)
    }

    // 4️⃣ Test empty search response
    func testSearchMovies_Empty() {
        let expectation = XCTestExpectation(description: "Search returned empty results")

        viewModel.$searchResults
            .dropFirst()
            .sink { searchResults in
                XCTAssertTrue(searchResults.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Simulate empty response
        viewModel.searchResults = []

        wait(for: [expectation], timeout: 2.0)
    }
}
