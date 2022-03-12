//
//  LikedMovieModel.swift
//  MovieDB
//
//  Created by Damir Yackupov on 12.03.2022.
//

import Foundation

struct LikedMovieModel {
    var id: Int
    var isLiked: Bool
    
    mutating func changeValue(withId id: Int, with isLiked: Bool) {
        self.id = id
        self.isLiked = isLiked
    }
}
