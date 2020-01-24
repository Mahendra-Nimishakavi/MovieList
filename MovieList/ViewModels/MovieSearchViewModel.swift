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

protocol MovieSearchViewModelView:AnyObject {
    func reloadView()
}
class MovieSearchViewModel : NSObject,ImageTaskDownloader {
    private var movies : [Movie]?
    private var imageTasks = [Int:ImageTask]()
    private let session = URLSession(configuration: .default)
    var imageCompletionHandler  = [Int:((UIImage?)->Void)]()
    weak var delegate : MovieSearchViewModelView?
    private var movieService : MovieServiceProtocol
    
    init(movieService:MovieServiceProtocol) {
        self.movieService = movieService
    }
    
    
    func searchMovies (searchString : String,completion:@escaping ([Movie]?,Error?)->Void) {
        clearOldSearch()
        
        
        func searchResultsCallback(movies:[Movie]?,error:Error?) {
            guard let movies = movies else{
                completion(nil,error)
                return
            }
            
            self.updateModel(movies: movies)
            completion(movies,nil)
        }
        movieService.searchMovies(searchString: searchString, completion: searchResultsCallback)
    }
    
    func clearOldSearch () {
        self.imageTasks.removeAll()
        self.imageCompletionHandler.removeAll()
        self.movies?.removeAll()
        self.delegate?.reloadView()
        
    }
    
    //TO-Do make it powerful
    func numberOfSections()->Int{
        return 1;
    }
    
    func sectionTitle(sectionNumber : Int) -> String{
        var result = ""
        switch sectionNumber {
        case 0:
            result =  "Movies"
        case 1:
            result =  "Actors"
        default:
            result = ""
        }
        
        return result
    }
    
    func numberOfRowsForModel(sectionNumber : Int) -> Int {
        var result = 1
        
        switch sectionNumber {
        case 0:
            guard let movies = self.movies else{
                result = 0
                return result
            }
            result = movies.count
        default:
            return 1
            
        }
        return result
    }
    
    func modelForCell (section:Int,row:Int) -> Movie? {
        
        guard let movies = self.movies else {
            return nil
        }
        
        return movies[row]
    }
    
    
    private func updateModel(movies:[Movie]){
        self.movies = movies
        print("count after \(self.movies?.count ?? 0)")
    }
    
    func getSelectedRowObject(row:Int)->Movie? {
        guard let movies = self.movies else {
            return nil
        }
        
        return (movies[row])
    }
    
    
    func imageForCell(section:Int,row:Int,completion:@escaping (UIImage?)->Void) -> Void {
        
        print(section,row)
        guard let imageTask = self.imageTasks[row]
            else{
                guard let movieObject = modelForCell(section: section, row: row)
                    else{
                        completion(nil)
                        return
                }
                
                
                guard let posterURL = URL(string: movieObject.posterPath)
                    else{
                        completion(nil)
                        return
                }
                setupImageTask(position: row, url: posterURL)
                imageCompletionHandler[row] = completion
                return
        }
        
        completion(imageTask.image)
        
    }
    
    func willDisplayCell(section:Int,row:Int){
        self.imageTasks[row]?.resume()
    }
    
    func didEndDisplay(section:Int,row:Int) {
        self.imageTasks[row]?.pause()
    }
    
    private func setupImageTask(position:Int,url:URL){
        let imageTask = ImageTask(position: position, url: url, session: self.session, delegate: self)
        self.imageTasks[position] = imageTask
        print("Setting up image download for image \(url) count of tasks \(self.imageTasks.count)")
    }
    
    func imageDownloaded(position: Int,image: UIImage?,error:Error?) {
        if error != nil {
            print("Error occured while downloading Image  for position \(position)")
            imageCompletionHandler[position]!(UIImage(named: "image_error"))
            return
        }
        print("Image downloaded for position \(position)")
        DispatchQueue.main.async {
            self.imageCompletionHandler[position]!(image)
        }
        
    }
}

