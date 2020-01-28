//
//  MovieDetailsViewModel.swift
//  MovieList
//
//  Created by mn669704 on 24/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import UIKit

//View Model responsible for handling Movie Details UI
class MovieDetailsViewModel {
    private var movie:Movie
    
    let dataStore : MovieDataStorageProtocol
    
    init(movie : Movie,dataStore:MovieDataStorageProtocol){
        self.movie = movie
        self.dataStore  = MovieDataStore()
    }
    
    func getPosterImage(completion : @escaping (UIImage?)->Void) {
        
        let image = self.dataStore.getMovieThumbNail(movie: self.movie)
        completion(image)
        return
        
    }
    
    func getMovieTitle()->String?{
        return self.movie.title
    }
    
    func getMovieOverView()->String? {
        return self.movie.overView
    }
    
}

//saving movie
extension MovieDetailsViewModel {
    
    func saveMovie()->Bool{
        do {
            let saveResult = try dataStore.addMovieToFavorites(movie: self.movie)
            return saveResult
        }catch {
            return false
        }
    }
    
    func canShowSaveMovieButton()->Bool{
        return !dataStore.isMovieInFavorites(movie: self.movie)
    }
}
