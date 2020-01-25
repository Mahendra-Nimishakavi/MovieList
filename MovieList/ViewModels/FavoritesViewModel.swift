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
    
    func getFavoriteMovies() -> [Movie]? {
        let realmMovies = try! Realm().objects(MovieRealm.self)
        
        favoriteMovies = realmMovies.compactMap { realmMovie in
            let movie: Movie = Movie(id: realmMovie.id, title: realmMovie.title, posterPath: realmMovie.posterPath, overView: realmMovie.posterPath)
            return movie
            
        }
        
        return favoriteMovies
    }
}

extension FavoritesViewModel : CollectionViewModelProtocol {
    func numberOfSections() -> Int {
        return 0 // we dont have different sections
    }
    
    func numberOfRows(for section: Int) -> Int {
        return self.favoriteMovies?.count ?? 0
    }
    
    func sectionTitle(section: Int) -> String {
        return "FavoriteMovies"
    }
    
    func willDisplayCell(section: Int, row: Int) {
        
    }
    
    func didEndDisplay(section: Int, row: Int) {
        
    }
    
    func imageForCell(section: Int, row: Int, completion: @escaping (UIImage?) -> Void) {
        
    }
}
