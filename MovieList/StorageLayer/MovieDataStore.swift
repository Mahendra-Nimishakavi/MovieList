//
//  MovieDataStore.swift
//  MovieList
//
//  Created by mn669704 on 23/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import RealmSwift
class MovieDataStore {
    //Singleton Instance
    static let sharedInstance = MovieDataStore()
    
    private init(){
        
    }
    
    func addMovieToFavorites (movie:Movie) throws -> Bool {
        let realmMovie = self.convertMovieToRealmObject(movie: movie)
        let realm = try! Realm()
        
        //TODO : Error handling
        do{
            try realm.write {
                realm.add(realmMovie)
            }
        } catch let error as NSError {
            print(error)
        }
        
        return true
    }
    
    
    //API to fetch the favorite movies that were saved 
    func fetchFavoriteMovies() throws -> [Movie]? {
        
        return nil
    }
    
    

}


//private methods
extension MovieDataStore {
    private func convertMovieToRealmObject(movie:Movie) -> MovieRealm {
        let movieRealm = MovieRealm()
        movieRealm.id = movie.id
        movieRealm.overView = movie.overView
        movieRealm.posterPath = movie.posterPath
        movieRealm.title = movie.title
        
        return movieRealm
    }
}
