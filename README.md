# Movie Discovery App

Movie Discovery app is a simple app to know the details about any movies available on [TheMovieDB](https://www.themoviedb.org/)

Download this repository and open `Movie Discovery.xcodeproj` file on XCode, download the Alamofire package, then run the app on an emulator or a device. 
(You can even try the app by opening ContentView.swift file on XCode and interacting with the Preview)


## Features
> Shows a list of movies on opening the app
> Search for a movie
> Tapping on any movie in the list shows the details of the movie tapped in a new screen
>  In movie list screen, tapping on reset button resets the search to empty and shows default movie list


## Architecture
As mentioned the task, the app is based on MVVM architecture. 
Model > Movie.swift
ViewModel > MovieViewModel.swift
Views
> MovieListView.swift,
> MovieDetailView.swift 
