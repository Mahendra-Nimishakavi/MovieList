//
//  MovieSearchViewController.swift
//  MovieList
//
//  Created by mn669704 on 23/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import UIKit
import SwiftSpinner
import SDWebImage

class MovieSearchViewController: BaseViewController {
    @IBOutlet var collectionView : UICollectionView!
    var searchViewModel : MovieSearchViewModel!
    private var selectedFrame : CGRect?
    private var customInteractor : CustomInteractor?
    private var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.delegate = self
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as? MovieDetailsViewController
        //destinationViewController!.transitioningDelegate = self
        let index : [IndexPath]  = self.collectionView.indexPathsForSelectedItems!
        let row = index[0];
        destinationViewController?.movieDetailsViewModel = MovieDetailsViewModel(movie: self.searchViewModel.getMovieForSelectedCell(row: row.row)!)
      
    }
}


extension MovieSearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchString = searchBar.text, searchString.count > 0 else {
            self.displayAlert(title: "Search String Error!!!", message: "Invalid Search String!!")
            return
        }
        
        if !Reachability().checkReachable() {
            self.displayAlert(title: "Network Error!!!", message: "No Internet Connection!! Please Connect and Try Again.")
            return
        }
        
        SwiftSpinner.show("Hold Tight!!! Searching For Movies....")
        self.searchViewModel.searchMovies(searchString: searchString, completion: { completed,error in
            
            SwiftSpinner.hide()
            
            guard completed
                else {
                    self.displayAlert(title: "Search Error", message: error?.localizedDescription ?? "Unknown Error")
                    return
                }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            
        })
        
        print(searchBar.text!)
        
    }
}

extension MovieSearchViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.searchViewModel.numberOfRows(for: section)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchController", for: indexPath) as! ThumbnailCell
        
        func completionHandler(image:UIImage?){
            guard let image = image
                else{
                    return
            }
            DispatchQueue.main.async{
                cell.contentView.layer.cornerRadius = 2.0
                cell.contentView.layer.borderWidth = 1.0
                cell.contentView.layer.borderColor = UIColor.clear.cgColor
                cell.contentView.layer.masksToBounds = true
                print("width \(image.size.width) and height is  \(image.size.height)")
                cell.thumbNail?.image = image//self.resizeImage(image: image)
            }
            
        }
        
        let urlForImage = searchViewModel.urlForImage(section: indexPath.section, row: indexPath.row)
        cell.thumbNail?.sd_setImage(with: urlForImage, placeholderImage: UIImage(named: "image_error.png"), options: SDWebImageOptions.progressiveLoad, completed: {
            (image, error, type, url) in
            self.searchViewModel.saveImage(for: indexPath, image: image)
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
        selectedFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
        let indexOfSelectedCell = collectionView.indexPathsForSelectedItems?.first
        let cell = collectionView.cellForItem(at: indexPath) as? ThumbnailCell
        self.selectedImage = cell?.thumbNail?.image
        self.performSegue(withIdentifier: "Movie", sender: self)
        
    }
}



extension MovieSearchViewController : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let ci = customInteractor else { return nil }
        return ci.transitionInProgress ? customInteractor : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let frame = self.selectedFrame else { return nil }
        switch operation {
        case .push:
            self.customInteractor = CustomInteractor(attachTo: toVC)
            return CustomAnimator(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: true, originFrame: frame, image: self.selectedImage ?? UIImage(named:"image_error")!)
        default:
            return CustomAnimator(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: false, originFrame: frame, image:self.selectedImage ?? UIImage(named:"image_error")!)
        }
    }
}

