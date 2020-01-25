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

public typealias SearchCompletion = (_ completed: Bool,_ error: Error?)->()

protocol MovieSearchViewModelView:AnyObject {
    func reloadView()
}
class MovieSearchViewModel  {
    internal var movies : [Movie]?
    weak var delegate : MovieSearchViewModelView?
    private var movieService : MovieServiceProtocol
    
    init(movieService:MovieServiceProtocol) {
        self.movieService = movieService
    }
    
    func searchMovies (searchString : String,completion:@escaping SearchCompletion) {
        clearOldSearch()
        
        func searchResultsCallback(movies:[Movie]?,error:Error?) {
            guard let movies = movies else{
                completion(false,error)
                return
            }
            
            self.updateModel(movies: movies)
            completion(true,nil)
        }
        movieService.searchMovies(searchString: searchString, completion: searchResultsCallback)
    }
    
    func clearOldSearch () {
        self.movies?.removeAll()
        self.delegate?.reloadView()
        
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
        
        guard let movies = self.movies else {
            return nil
        }
        
        return movies[row]
    }
    
    func urlForImage (section:Int,row:Int) -> URL? {
        guard let movieObject = modelForCell(section: section, row: row),
        let posterURL = URL(string: movieObject.posterPath)
            else{return nil}
        return posterURL
        
    }
    
    private func updateModel(movies:[Movie]){
        self.movies = movies
        print("count after \(self.movies?.count ?? 0)")
    }
    
    
    func getMovieForSelectedCell(row: Int) -> Movie? {
        guard let movies = self.movies else {
            return nil
        }
        
        return (movies[row])
    }
    
}
    
//saving
extension MovieSearchViewModel {
    func saveImage(for indexPath:IndexPath,image:UIImage?) {
        guard let image = image
            else{return}
        
        guard let movieObject = modelForCell(section: indexPath.section, row: indexPath.row)
            else{return}
        
        let isSaveSuccess = MovieDataStore.sharedInstance.saveMovieThumbNail(movie: movieObject, thumbNail: image)
        print(isSaveSuccess)
        
    }
}


