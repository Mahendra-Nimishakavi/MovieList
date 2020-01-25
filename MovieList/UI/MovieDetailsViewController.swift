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
        if self.movieDetailsViewModel.canShowSaveMovie() {
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
       // self.movieName.text = self.movieDetailsViewModel.getMovieTitle()
        self.imageView.image = UIImage(named: "image_error")
        updateImage()
        showMovieOverView()
    }
    
    func showMovieOverView() {
        self.movieOverView.text = self.movieDetailsViewModel.getMovieOverView()
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
            print("saving movie succeeded")
            title = "Success"
            message = "Successfully added Movie to WatchList"
        }
        else{
            title = "Oops!!! Error"
            message = "Unable to add movie"
        }
        
        //self.displa
        
//        let alertCOntroller = UIUtilities.createAlert(title: title, message: message)
//        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
//        alertCOntroller.addAction(cancelAction)
//        self.present(alertCOntroller, animated: true, completion: nil)
    }

}


