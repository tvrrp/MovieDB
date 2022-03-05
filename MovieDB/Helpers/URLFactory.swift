//
//  URLFactory.swift
//  MovieDB
//
//  Created by Damir Yackupov on 04.03.2022.
//

import Foundation

struct URLFactory {
    private let apiToken = "?api_key=b4224f0b04af00fb7e67ea6a31c530bd"
    private let movieLanguage = "&language=ru-RU"
    private let moviePageNumber: String?
    private let movieDBURL = "https://api.themoviedb.org/3/movie/popular"
    
    var apiCallURL: String {
        return movieDBURL + apiToken + movieLanguage + (moviePageNumber ?? "")
    }
    
    init(moviePageNumber: String?) {
        self.moviePageNumber = "&page=" + (moviePageNumber ?? "")
    }
}