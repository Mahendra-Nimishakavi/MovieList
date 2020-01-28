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

let NoNetworkError = "No Internet Connection!! Please Connect and Try Again."
let UnKnownError = "Unknown Error"

class MovieSearchViewController: BaseViewController {
    @IBOutlet var collectionView : UICollectionView!
    var searchViewModel : MovieSearchViewModel!
    private var selectedFrame : CGRect?
    fileprivate var customInteractor : CustomInteractor?
    private var selectedImage : UIImage?
    private var indexOfSelectedCell:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.delegate = self
        self.searchViewModel.delegate = self
        
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        
        if let layout = collectionView?.collectionViewLayout as? MovieCollectionViewLayout {
          layout.delegate = self
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as? MovieDetailsViewController
        destinationViewController?.movieDetailsViewModel = MovieDetailsViewModel(movie: self.searchViewModel.getMovieForSelectedCell(indexPath:indexOfSelectedCell!)!,dataStore: MovieDataStore())
      
    }
}


//Search Extension
extension MovieSearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchString = searchBar.text, searchString.count > 0 else {
            self.displayAlert(title: "Search String Error!!!", message: "Invalid Search String!!")
            return
        }
        
        //basically this can go to the network layer and we can get back the error
        //but we can also show proactive error related UI when network appears offline and also we can move this to view model. For simplicity, just checking it here
        if !Reachability().checkReachable() {
            self.displayAlert(title: "Network Error!!!", message: NoNetworkError)
            return
        }
        
        SwiftSpinner.show("Hold Tight!!! Searching For Movies....")
        
        do {
            try self.searchViewModel.searchMovies(searchString, completion: { completed,error in
                SwiftSpinner.hide()
                guard completed
                    else {
                        self.displayAlert(title: "Search Error", message: error?.rawValue ?? UnKnownError)
                        return
                    }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
        } catch let error as MovieSearchError{
            SwiftSpinner.hide()
            self.displayAlert(title: "Search Error", message: error.rawValue)
        } catch {
            SwiftSpinner.hide()
            self.displayAlert(title: "Search Error", message: error.localizedDescription)
        }
        
        print("Search String is \(searchBar.text!)")
        
    }
}


//Collection View

extension MovieSearchViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.searchViewModel.numberOfRows(for: section)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchController", for: indexPath) as! ThumbnailCell
        
        let urlForImage = searchViewModel.urlForImage(section: indexPath.section, row: indexPath.row)
        cell.thumbNail?.sd_setImage(with: urlForImage, placeholderImage: UIImage(named: "image_error.png"), options: SDWebImageOptions.retryFailed, completed: {
            (image, error, type, url) in
            self.searchViewModel.saveImage(for: indexPath, image: image)
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
        
        configureCell(cell)
        
        return cell
    }
    
    //configuring few UI properties of the cell
    private func configureCell(_ cell:UICollectionViewCell) {
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.masksToBounds = true
        cell.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
        selectedFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
        let cell = collectionView.cellForItem(at: indexPath) as? ThumbnailCell
        self.selectedImage = cell?.thumbNail?.image
        
        self.indexOfSelectedCell = collectionView.indexPathsForSelectedItems?.first
        self.performSegue(withIdentifier: "Movie", sender: self)
        
    }
}


//Collection View Layout
extension MovieSearchViewController: MovieCollectionViewLayoutDelegate {
  func collectionView(
      _ collectionView: UICollectionView,
      heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    return self.searchViewModel.getHeightForImage(indexPath: indexPath)
  }
}

extension MovieSearchViewController : MovieSearchViewModelRefreshProtocol {
    func reloadView() {
        self.collectionView.reloadData()
    }
}

//Custom Transition
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

