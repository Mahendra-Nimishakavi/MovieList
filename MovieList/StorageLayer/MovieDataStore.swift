//
//  MovieDataStore.swift
//  MovieList
//
//  Created by mn669704 on 23/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import RealmSwift

enum DataStoreError : String,Error{
    case saveFailed = "Database Error!!! Saving Data Failed"
    case fetchFailed = "Database Error!!! Fetching Data Failed"
    
}


class MovieDataStore : MovieDataStorageProtocol {
    
    func addMovieToFavorites (movie:Movie) throws -> Bool {
        let realmMovie = self.convertMovieToRealmObject(movie: movie)
        let realm = try! Realm()
        
        do{
            try realm.write {
                realm.add(realmMovie, update: .modified)
            }
        } catch let error as NSError {
            print("MovieDataStore: addMovieToFavorites: \(error)")
            throw DataStoreError.saveFailed
        }
        
        return true
    }
    
    
    //API to fetch the favorite movies that were saved
    
    func fetchFavoriteMovies() throws -> [Movie]? {
        do{
            let realmMovies = try Realm().objects(MovieRealm.self)
            
            let favoriteMovies:[Movie] = realmMovies.compactMap { realmMovie in
                let movie: Movie = Movie(id: realmMovie.id, title: realmMovie.title, posterPath: realmMovie.posterPath, overView: realmMovie.overView)
                return movie
            }
            
            return favoriteMovies
        }catch {
            print("MovieDataStore: fetchFavoriteMovies: \(error)")
            throw DataStoreError.fetchFailed
        }
    }
    
    //API to check if movie already exists
    func isMovieInFavorites(movie:Movie) -> Bool {
        
        guard (try! Realm().object(ofType: MovieRealm.self, forPrimaryKey: movie.id)) != nil
            else{return false}

        return true
        
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

//extension to store the images/thumbnails to disk
extension MovieDataStore {
    func saveMovieThumbNail(movie:Movie,thumbNail:UIImage)->Bool{
        guard let imageData = thumbNail.jpegData(compressionQuality: 1.0) else{
            return false
        }
        let fileName = getDocumentsDirectory().appendingPathComponent(getRelativePath(id: movie.id))
        print("Writing the image to disk at location : \(fileName)")
        try? imageData.write(to: fileName)
        return true
    }
    
    func getMovieThumbNail(movie:Movie) -> UIImage? {
        let fileName = getDocumentsDirectory().appendingPathComponent(getRelativePath(id: movie.id))
        return UIImage(contentsOfFile: fileName.path)
    }
    
    private func getDocumentsDirectory()->URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return paths
    }
    
    func getMovieAbsoluteFileURL(movieFilePath : String)->URL{
        //print(getDocumentsDirectory() .appendingPathComponent(movieFilePath))
        return getDocumentsDirectory() .appendingPathComponent(movieFilePath)
    }
    
    private func getRelativePath(id:String)->String {
        let relativePath = id + ".jpeg"
        return relativePath
    }
}
