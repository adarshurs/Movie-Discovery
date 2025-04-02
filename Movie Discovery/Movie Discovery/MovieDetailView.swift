//
//  MovieDetailView.swift
//  Movie Discovery
//
//  Created by Adarsh Urs on 02/04/25.
//


import Foundation
import Combine
import Alamofire
import UIKit
import SwiftUICore
import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @ObservedObject var viewModel: MovieViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(12)
                    } else if phase.error != nil {
                        Color.gray.frame(height: 300)
                    } else {
                        ProgressView().frame(height: 300)
                    }
                }
                
                Text(movie.releaseDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(movie.overview)
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle(movie.title)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleFavorite(movie)
                }) {
                    Image(systemName: viewModel.isFavorite(movie) ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite(movie) ? .blue : .gray)
                }
            }
        }
    }
}
//#Preview {
//    MovieDetailView(movie: .init(id: 1, adult: false, backdropPath: nil, genreIDs: [], originalLanguage: "en", originalTitle: "", overview: "", popularity: 0, posterPath: nil, releaseDate: "", title: "", video: false, voteAverage: 0, voteCount: 0), viewModel: )
//}
