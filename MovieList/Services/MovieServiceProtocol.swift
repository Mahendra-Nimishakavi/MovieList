//
//  MovieServiceProtocol.swift
//  MovieList
//
//  Created by mn669704 on 23/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation

public enum ServiceError : String, Error{
    case invalidSearchString = "Invalid Search String"
    
}

protocol MovieServiceProtocol {
    
    func searchMovies (searchString:String, completion: @escaping ([Movie]?,Error?)->Void)
    
}
