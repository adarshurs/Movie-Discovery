//
//  MovieListView.swift
//  Movie Discovery
//
//  Created by Adarsh Urs on 02/04/25.
//

import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
            
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundColor(.red)
            } else {
                List(viewModel.filteredMovies) { movie in
                    HStack(spacing: 12) {
                        NavigationLink(destination: MovieDetailView(movie: movie, viewModel: viewModel)) {
                            HStack(spacing: 12) {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath ?? "")")) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 100)
                                            .cornerRadius(8)
                                            .clipped()
                                    } else {
                                        Color.gray.frame(width: 80, height: 120)
                                            .cornerRadius(8)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(movie.title)
                                        .font(.headline)
                                    Text(movie.releaseDate.prefix(4))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                }
            }
        }
        .navigationTitle("Movies")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    DispatchQueue.main.async {
                        viewModel.searchText = ""
                    }
                    viewModel.fetchMovies()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.showFavorites.toggle()
                }) {
                    Image(systemName: viewModel.showFavorites ? "star.fill" : "star")
                        .foregroundColor(viewModel.showFavorites ? .blue : .gray)
                }
            }
        })
    }
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
