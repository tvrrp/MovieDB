//
//  URLFactory.swift
//  MovieDB
//
//  Created by Damir Yackupov on 04.03.2022.
//

import Foundation

struct URLFactory {
    private let apiToken = "?api_key=b4224f0b04af00fb7e67ea6a31c530bd"
    private let movieLanguage = "&language=en-US"
    private let moviePageNumber: String
    private let movieDBURL = "https://api.themoviedb.org/3/movie/popular"
    
    var apiCallURL: String {
        return movieDBURL + apiToken + movieLanguage + (moviePageNumber)
    }
    
    init(moviePageNumber: String) {
        self.moviePageNumber = "&page=" + moviePageNumber
    }
}

struct LikedMovieURL {
    private let apiToken = "?api_key=b4224f0b04af00fb7e67ea6a31c530bd"
    private let movieLanguage = "&language=en-US"
    private let movieID: String
    private let movieDBURL = "https://api.themoviedb.org/3/movie/"
    
    var apiCallURL: String {
        return movieDBURL + movieID + apiToken + movieLanguage
    }
    
    init(movieID: String) {
        self.movieID = movieID
    }
}

struct URLToImage {
    private let urlPath = "https://image.tmdb.org/t/p/w500"
    let urlToImage: String
    
    init(apiUrl: String) {
        self.urlToImage = urlPath + apiUrl
    }
}

struct URLToPost {
    private let movieDBURL = "https://api.themoviedb.org/3/movie/"
    private let moviePostNumber: String
    private let apiToken = "?api_key=b4224f0b04af00fb7e67ea6a31c530bd"
    private let movieLanguage = "&language=en-US"
    
    var apiCallURL: String {
        return movieDBURL + moviePostNumber + apiToken + movieLanguage
    }
    
    init(moviePostNumber: String) {
        self.moviePostNumber = moviePostNumber
    }
}

struct URLToPosterPath {
    private let urlPath = "https://image.tmdb.org/t/p/original"
    let urlToImage: String
    
    init(apiUrl: String) {
        self.urlToImage = urlPath + apiUrl
    }
}
