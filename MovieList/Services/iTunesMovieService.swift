//
//  iTunesMovieService.swift
//  MovieList
//
//  Created by mn669704 on 24/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import UIKit
class ITunesService: MovieServiceProtocol {
    let router = NetworkRouter()
    func searchMovies(searchString: String, completion: @escaping ([Movie]?, Error?) -> Void) {
        if searchString.count == 0 {
            completion(nil,ServiceError.invalidSearchString)
        }
        
        
        router.request(from: iTunesAPI(movie: searchString), completion: {data,error in
            
            if error != nil {
                completion(nil,error)
                return
            }
            
            guard let responseData = data else {
                completion(nil,error)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print(jsonData)
                let apiResponse = try JSONDecoder().decode(MovieAPIResponse.self, from: responseData)
                

                completion(apiResponse.movies,nil)
            } catch{
                print(error)
            }
        })
    }
    
    

}
