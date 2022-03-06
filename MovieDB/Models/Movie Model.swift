//
//  Movie Model.swift
//  MovieDB
//
//  Created by Damir Yackupov on 01.03.2022.
//

import Foundation

struct MovieModel: Decodable {
    let page: Int?
    let results: [Movies]
}

struct Movies: Decodable {
    let adult: Bool
    let backdrop_path: String?
    let id: Int
    let title: String
    let overview: String
    let poster_path: String
    let release_date: String
    let vote_average: Float
    let vote_count: Int
}
