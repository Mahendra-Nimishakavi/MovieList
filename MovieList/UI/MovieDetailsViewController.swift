//
//  MovieDetailsViewController.swift
//  MovieList
//
//  Created by mn669704 on 24/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import UIKit
import SwiftSpinner

class MovieDetailsViewController: BaseViewController {
    var movieDetailsViewModel : MovieDetailsViewModel!
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var movieName : UILabel!
    @IBOutlet weak var saveMovieButton : UIButton!
    @IBOutlet weak var movieOverView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fillUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.movieDetailsViewModel.canShowSaveMovieButton() {
            self.saveMovieButton.isHidden = false
        }
        else {
            self.saveMovieButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillUI(){
        SwiftSpinner.show("Setting Up Movie Details .....")
        self.title = self.movieDetailsViewModel.getMovieTitle() ?? "Movie"
        self.imageView.image = UIImage(named: "image_error")
        updateImage()
    }
    
    
    func updateImage(){
        
        func onImageRetrieved(image:UIImage?){
            DispatchQueue.main.async {
                SwiftSpinner.hide()
                guard let image = image else{
                    return
                }
                self.imageView.image = image
            }
            
        }
        self.movieDetailsViewModel.getPosterImage(completion: onImageRetrieved)
    }
    
    @IBAction func onSaveMovieClicked(sender:UIButton){
    
        var title : String,message : String
        
        if(self.movieDetailsViewModel.saveMovie()){
            print("onSaveMovieClicked: saving movie succeeded")
            title = "Success"
            message = "Successfully added Movie to WatchList"
        }
        else{
            title = "Oops!!! Error"
            message = "Unable to add movie"
        }
        
        self.displayAlert(title: title, message: message)
    }
    
    @IBAction func onShowMovieDescriptionClicked(sender:UIButton) {
        self.movieOverView.isHidden = false
        self.movieOverView.text = self.movieDetailsViewModel.getMovieOverView()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.imageView.alpha = 0.3
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOutside)))
    }
    
    @objc func didTapOutside() {
        self.movieOverView.isHidden = true
        self.view.gestureRecognizers?.forEach(self.view.removeGestureRecognizer)
        if let patternImage = UIImage(named: "Pattern") {
          view.backgroundColor = UIColor(patternImage: patternImage)
        }
        self.imageView.alpha = 1.0
    }

}


