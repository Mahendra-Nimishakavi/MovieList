//
//  MovieSearchViewModel.swift
//  MovieList
//
//  Created by mn669704 on 24/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//


import Foundation
import CoreData
import UIKit

public typealias SearchCompletion = (_ completed: Bool,_ error: MovieSearchError?)->()

protocol MovieSearchViewModelRefreshProtocol:AnyObject {
    func reloadView()
}

public enum MovieSearchError : String,Error {
    case invalidSearchString = "The Search String given is invalid"
    case searchStringLimit = "Lengthy Search Strings are not supported"
    case searchStringSpecialCharacters = "Search String Contains Special Characters"
    case noMoviesFound = "No Movies Found"
}

class MovieSearchViewModel  {
    internal var movies : [Movie]?
    weak var delegate : MovieSearchViewModelRefreshProtocol?
    private var movieService : MovieServiceProtocol
    
    let movieDataStore:MovieDataStorageProtocol
    
    init(movieService:MovieServiceProtocol,dataStore:MovieDataStorageProtocol) {
        self.movieService = movieService
        self.movieDataStore = dataStore
    }
    
    func searchMovies (_ searchString : String,completion:@escaping SearchCompletion) throws {
        
        try self.validateSearchString(searchString)
        
        clearOldSearch()
        
        func searchResultsCallback(movies:[Movie]?,error:Error?) {
            guard let movies = movies,
                movies.count != 0
            else{
                completion(false,MovieSearchError.noMoviesFound)
                return
            }
            
            self.movies = movies
            completion(true,nil)
        }
        movieService.searchMovies(searchString: searchString, completion: searchResultsCallback)
    }
    
    func clearOldSearch () {
        self.movies?.removeAll()
        self.delegate?.reloadView()
        
    }
    
    private func validateSearchString(_ searchString:String) throws  {
        
        if searchString.count == 0 {
            throw MovieSearchError.invalidSearchString
        }
        
        if searchString.count > 30 {
            throw MovieSearchError.searchStringLimit
        }
        
        if searchString.range(of: ".*[^A-Za-z0-9 ].*", options: .regularExpression) != nil  {
            throw MovieSearchError.searchStringSpecialCharacters
        }
    }
    
}

//CollectionView Protocol
extension MovieSearchViewModel : MovieCollectionViewModelProtocol {

    func numberOfRows(for section: Int) -> Int {
        switch section {
        case 0:
            guard let movies = self.movies else{
                return 0
            }
            return movies.count
        default:
            return 0
            
        }
    }
    
    func numberOfSections()->Int{
        return 1;
    }
    
    func sectionTitle(section sectionNumber : Int) -> String{
        var result = ""
        switch sectionNumber {
        case 0:
            result =  "Movies"
        
        default:
            result = ""
        }
        
        return result
    }
    
    
    func modelForCell (section:Int,row:Int) -> Movie? {
        
        guard let movies = self.movies,
            row < movies.count
        else {
            return nil
        }
        
        return movies[row]
    }
    
    
    func getMovieForSelectedCell(indexPath: IndexPath) -> Movie? {
        guard let movies = self.movies else {
            return nil
        }
        
        return (movies[indexPath.row])
    }
    
    
    func getHeightForImage(indexPath:IndexPath) -> CGFloat {
        
        if self.movies == nil {
            fatalError()
        }
        
        guard let movie = modelForCell(section: indexPath.section, row: indexPath.row)
            else{
                return 200.0
        }
        
        return movie.thumbNail?.size.height ?? 200.0
    }
}
    
//saving image
extension MovieSearchViewModel {
    func saveImage(for indexPath:IndexPath,image:UIImage?) {
        guard let image = image
            else{return}
        
        guard var movieObject = modelForCell(section: indexPath.section, row: indexPath.row)
            else{return}
        movieObject.thumbNail = image
        
        let isSaveSuccess = self.movieDataStore.saveMovieThumbNail(movie: movieObject, thumbNail: image)
        print("Movie saving \(isSaveSuccess)")
        
    }
    
    func urlForImage (section:Int,row:Int) -> URL? {
        guard let movieObject = modelForCell(section: section, row: row),
        let posterURL = URL(string: movieObject.posterPath)
            else{return nil}
        return posterURL
        
    }
    
}


