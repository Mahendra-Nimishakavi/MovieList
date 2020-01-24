//
//  MovieRealm.swift
//  MovieList
//
//  Created by mn669704 on 23/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import RealmSwift

class MovieRealm : Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var posterPath: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var overView: String = ""
}
