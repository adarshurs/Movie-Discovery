//
//  ContentView.swift
//  Movie Discovery
//
//  Created by Adarsh Urs on 02/04/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieViewModel()
        
        var body: some View {
            NavigationView {
                VStack {
                    SearchBar(text: $viewModel.searchText)
                    
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage).foregroundColor(.red)
                    } else {
                        List(viewModel.movies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                HStack(spacing: 12) { // Reduced gap between image & text
                                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath ?? "")")) { phase in
                                        if let image = phase.image {
                                            image.resizable()
                                                .scaledToFill() // Fills the frame without distortion
                                                .frame(width: 80, height: 100) // Increased size
                                                .cornerRadius(8)
                                                .clipped()
                                        } else {
                                            Color.gray.frame(width: 80, height: 120) // Placeholder
                                                .cornerRadius(8)
                                        }
                                    }

                                    VStack(alignment: .leading, spacing: 4) { // Reduced spacing
                                        Text(movie.title)
                                            .font(.headline)
                                        Text(movie.releaseDate.prefix(4))
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures better alignment
                                }
                                .padding(.vertical, 6) // Reduces unnecessary gaps
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)) // Makes items wider
                        }
                        .listStyle(.plain) // Removes extra spacing
                    }
                }
                .navigationTitle("Movies")
                .toolbar {
                    Button("Refresh") { viewModel.fetchMovies() }
                }
            }
        }
}

#Preview {
    ContentView()
}



struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search movies", text: $text)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}
