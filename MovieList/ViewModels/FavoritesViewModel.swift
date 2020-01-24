//
//  FavoritesViewModel.swift
//  MovieList
//
//  Created by mn669704 on 24/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
class FavoritesViewModel {
    
    
    func getFavoriteMovies() -> [Movie]? {
        var specimens = try! Realm().objects(MovieRealm.self)
        
        for specimen in specimens {
            print(specimen)
        }
        
        return nil
    }
}
