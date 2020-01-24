//
//  MovieDetailsViewModel.swift
//  MovieList
//
//  Created by mn669704 on 24/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import UIKit
class MovieDetailsViewModel {
    private var movie:Movie
    
    init(movie : Movie){
        self.movie = movie
    }
    
    func getPosterImage(completion : @escaping (UIImage?)->Void) {
        
        guard let imageData = try? Data(contentsOf: (URL(string: self.movie.posterPath) ?? nil)!)
            else {
                completion(nil)
                return
            }

        if let image = UIImage(data: imageData) {
          completion(image)
        }
        else{
            completion(nil)
        }
        
        return
    }
    
    private func downloadPoster(completion:@escaping (UIImage?)->Void){
        
//        func onMovieDownload(image:UIImage?){
//            if image != nil && !DataController.sharedInstance.saveMoviePosterImage(movie: self.movie, downloadedImage: image!){
//                print("Unable to save poster image")
//            }
//            completion(image)
//        }
//
//        MovieHelper().downloadPosterImage(movie: self.movie, completion: onMovieDownload)
    }
    
    func getMovieTitle()->String?{
        return self.movie.title
    }
    
    func getMovieOverView()->String? {
        return self.movie.overView
    }
    
    func saveMovie()->Bool{
        try? MovieDataStore.sharedInstance.addMovieToFavorites(movie: self.movie)
        return false//return DataController.sharedInstance.addMovieToWatchList(movie: self.movie)
    }
    
    func canShowSaveMovie()->Bool{
        return true
        //return !self.movie.isMovieSaved()
    }
}
