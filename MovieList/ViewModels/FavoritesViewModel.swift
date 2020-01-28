//
//  FavoritesViewModel.swift
//  MovieList
//
//  Created by mn669704 on 24/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class FavoritesViewModel  {
    private var favoriteMovies : [Movie]?
    
    let dataStore: MovieDataStorageProtocol
    
    init(movieDataStore:MovieDataStorageProtocol){
        dataStore = movieDataStore
    }
    
    func loadFavoriteMovies() {
        do{
            self.favoriteMovies =  try self.dataStore.fetchFavoriteMovies()
        }catch{
            print("No favorites found with error \(error)")
        }
        
    }
}

extension FavoritesViewModel : MovieCollectionViewModelProtocol {
    
    
    func numberOfSections() -> Int {
        return 0 // we dont have different sections
    }
    
    func numberOfRows(for section: Int) -> Int {
        return self.favoriteMovies?.count ?? 0
    }
    
    func sectionTitle(section: Int) -> String {
        return "FavoriteMovies"
    }
    
    
    func getMovieForSelectedCell(indexPath : IndexPath) -> Movie? {
        guard let movies = self.favoriteMovies else {
            return nil
        }
        
        return (movies[indexPath.row])
    }
    
    func getThumNailImage(indexPath : IndexPath)-> UIImage {
        
        if let thumbNailImage = self.dataStore.getMovieThumbNail(movie: self.favoriteMovies![indexPath.row]){
            return thumbNailImage
        }
        
        return UIImage(named: "image_error")!
    }
}
