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
    case networkError = "A Network Error Occured"
}

class ITunesService: MovieServiceProtocol {
    
    let router : Router
    
    init(router:Router){
        self.router = router
    }
    
    //method to search movies
    func searchMovies(searchString: String, completion: @escaping ([Movie]?, Error?) -> Void) {
        
        if searchString.count == 0 {
            completion(nil,ServiceError.invalidSearchString)
        }
        
        self.router.request(from: iTunesAPI(movie: searchString), completion: {data,error in
        
                guard let responseData = data else {
                    print("Network router failed with \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil,ParsingError.networkError)
                    return
                }
                
                do {
                    let data = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    print("received data \(data)")
                    let apiResponse = try JSONDecoder().decode(MovieAPIResponse.self, from: responseData)
                    
                    completion(apiResponse.movies,nil)
                } catch{
                    print("Parsing error \(error.localizedDescription)")
                    completion(nil,ParsingError.JSONParseError)
                }
        })
    }
}
