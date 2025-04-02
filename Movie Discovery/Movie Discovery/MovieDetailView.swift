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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) { // Added spacing for better readability
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                            .scaledToFit() // Keeps aspect ratio
                                            .frame(maxWidth: .infinity) // Centers image without stretching
                                            .cornerRadius(12)
                                    } else if phase.error != nil {
                                        Color.gray.frame(height: 300) // Placeholder in case of an error
                                    } else {
                                        ProgressView().frame(height: 300) // Loading indicator
                                    }
                                }
                
                Text(movie.releaseDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(movie.overview)
            }
            .padding(.horizontal, 16) // Adds side padding
        }
        .navigationTitle(movie.title)
    }
}
#Preview {
    MovieDetailView(movie: .init(id: 1, adult: false, backdropPath: nil, genreIDs: [], originalLanguage: "en", originalTitle: "", overview: "", popularity: 0, posterPath: nil, releaseDate: "", title: "", video: false, voteAverage: 0, voteCount: 0))
}
