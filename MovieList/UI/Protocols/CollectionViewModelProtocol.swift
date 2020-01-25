//
//  CollectionViewModelProtocol.swift
//  MovieList
//
//  Created by mn669704 on 25/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewModelProtocol {
    //method that tells the number of sections
    func numberOfSections() -> Int
    
    //method that tells number of rows of a section
    func numberOfRows(for section:Int) -> Int
    
    //method to give back the title of the section
    func sectionTitle(section:Int) -> String
    
    //method to take some action when the cell is about to go visible
    func willDisplayCell(section:Int,row:Int)
    
    //method to take some action when the cell is about to end display
    func didEndDisplay(section:Int,row:Int)
    
    //method that gives back the image for the cell
    func imageForCell(section:Int,row:Int,completion:@escaping (UIImage?)->Void)
}
