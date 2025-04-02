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
            MovieListView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
