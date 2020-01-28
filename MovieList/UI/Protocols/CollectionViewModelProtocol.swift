//
//  CollectionViewModelProtocol.swift
//  MovieList
//
//  Created by mn669704 on 25/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import UIKit

//Protocol that represents the data needed for collectionview
protocol CollectionViewModelProtocol {
    //method that tells the number of sections
    func numberOfSections() -> Int
    
    //method that tells number of rows of a section
    func numberOfRows(for section:Int) -> Int
    
    //method to give back the title of the section
    func sectionTitle(section:Int) -> String
    
}

//protocol that represents movie specific details for the cell

protocol MovieCollectionViewModelProtocol : CollectionViewModelProtocol {
    associatedtype Movie
    //method to get the movie for the cell
    func getMovieForSelectedCell(indexPath:IndexPath) -> Movie?
}
