//
//  iTunesAPI.swift
//  MovieList
//
//  Created by mn669704 on 24/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation

public struct iTunesAPI : EndPoint {
    var movieSearchString : String!
    init(movie:String){
        movieSearchString = movie
    }
    var baseURL: String {
        let url = "https://itunes.apple.com"
        return url
    }

    var path : String {
        let path = "/search"
        return path
    }

    var httpMethod: HTTPMethod {
        return .GET
    }

    var headers: HTTPHeaders? {
        return nil
    }

    var parameters: HTTPHeaders? {
        let parameters = ["term":movieSearchString!,"media":"movie"]
        return parameters
    }
}
