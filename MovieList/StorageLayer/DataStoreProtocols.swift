//
//  DataStoreProtocols.swift
//  MovieList
//
//  Created by mn669704 on 27/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import UIKit

//Protocol that specifies methods about storing images to disk
protocol ImageDataStorageProtocol {
    func saveMovieThumbNail(movie:Movie,thumbNail:UIImage)->Bool
    func getMovieThumbNail(movie:Movie) -> UIImage?
}

//protocol that specifies  saving movie objects to database
protocol MovieDataStorageProtocol:ImageDataStorageProtocol {
    func addMovieToFavorites (movie:Movie) throws -> Bool
    func fetchFavoriteMovies() throws -> [Movie]?
    func isMovieInFavorites(movie:Movie) -> Bool
}
