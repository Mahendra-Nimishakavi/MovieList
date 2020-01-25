//
//  iTunesMovieService.swift
//  MovieList
//
//  Created by mn669704 on 24/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import UIKit

enum ParsingError:String,Error {
    case success
    case JSONParseError = "The data received is not in the proper format"
}

class ITunesService: MovieServiceProtocol {
    let router = NetworkRouter.sharedInstance
    
    func searchMovies(searchString: String, completion: @escaping ([Movie]?, Error?) -> Void) {
        
        if searchString.count == 0 {
            completion(nil,ServiceError.invalidSearchString)
        }
        
        
        router.request(from: iTunesAPI(movie: searchString), completion: {data,error in
        
                guard let responseData = data else {
                    completion(nil,error)
                    return
                }
                
                do {
                    try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    let apiResponse = try JSONDecoder().decode(MovieAPIResponse.self, from: responseData)
                    
                    completion(apiResponse.movies,nil)
                } catch{
                    print(error)
                    completion(nil,ParsingError.JSONParseError)
                }
        })
    }
}
