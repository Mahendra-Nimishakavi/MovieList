//
//  BaseViewController.swift
//  MovieList
//
//  Created by mn669704 on 24/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import UIKit

//Base ViewController that loads pattern
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let patternImage = UIImage(named: "Pattern") {
          view.backgroundColor = UIColor(patternImage: patternImage)
        }
    }
    
    
     func displayAlert(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController,animated: true, completion: nil);
    }

}
