//
//  Movie.swift
//  MovieList
//
//  Created by mn669704 on 23/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import UIKit

struct MovieAPIResponse {
    let numberOfResults : Int
    let movies : [Movie]
}

extension MovieAPIResponse: Decodable {
    
    private enum MovieAPIResponseCodingKeys : String, CodingKey {
        case numberOfResults = "resultCount"
        case movies = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieAPIResponseCodingKeys.self)
        
        numberOfResults = try container.decode(Int.self, forKey: .numberOfResults)
        movies = try container.decode([Movie].self, forKey: .movies)
        
    }
}

struct Movie {
     let id : String
     let title : String
     let posterPath : String
     let overView : String
     var thumbNail:UIImage?
}

extension Movie: Decodable {
    private enum MovieCodingKeys : String, CodingKey {
        case id = "trackId"
        case title = "trackName"
        case posterPath = "artworkUrl100"
        case overView = "longDescription"
        
    }
    
    init(from decoder: Decoder) throws {
        let movieContainer = try decoder.container(keyedBy: MovieCodingKeys.self)
        
        do{
            id = try String(movieContainer.decode(Int.self, forKey: .id))
            title = try movieContainer.decode(String.self, forKey: .title)
            //Strange that iTunes API doesnot give this ... little hack
            posterPath = try movieContainer.decode(String.self, forKey: .posterPath).replacingOccurrences(of: "100x100bb", with: "600x600bb")
            overView = try movieContainer.decode(String.self, forKey: .overView)
            //print("current movie is \(title)")
        }
        
    }
    
}

