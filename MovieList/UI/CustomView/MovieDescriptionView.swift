//
//  CustomMovieView.swift
//  MovieList
//
//  Created by mn669704 on 25/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import UIKit


//Custom View that displays Text given
@IBDesignable class MovieDescriptionView: UITextView {
    var cornnerRadius : CGFloat = 20
    var shadowOfSetWidth : CGFloat = 10
    var shadowOfSetHeight : CGFloat = 5
    
    var shadowColour : UIColor = UIColor.green
    var shadowOpacity : CGFloat = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornnerRadius
        layer.shadowColor = shadowColour.cgColor
        layer.shadowOffset = CGSize(width: shadowOfSetWidth, height: shadowOfSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornnerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }
}
