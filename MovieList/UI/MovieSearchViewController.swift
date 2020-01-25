//
//  MovieSearchViewController.swift
//  MovieList
//
//  Created by mn669704 on 23/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import UIKit
import SwiftSpinner
//import

class MovieSearchViewController: BaseViewController {
    @IBOutlet var collectionView : UICollectionView!
    var searchViewModel : MovieSearchViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //self.collectionView.em
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as? MovieDetailsViewController
        destinationViewController!.transitioningDelegate = self
        let index : [IndexPath]  = self.collectionView.indexPathsForSelectedItems!
        let row = index[0];
        destinationViewController?.movieDetailsViewModel = MovieDetailsViewModel(movie: self.searchViewModel.getSelectedRowObject(row: row.row)!)
      
    }
}


extension MovieSearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchString = searchBar.text, searchString.count > 0 else {
            self.displayAlert(title: "Search String Error!!!", message: "Invalid Search String!!")
            return
        }
        
        SwiftSpinner.show("Hold Tight!!! Searching For Movies....")
        self.searchViewModel.searchMovies(searchString: searchString, completion: {_,_ in
            SwiftSpinner.hide()
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        })
        
        print(searchBar.text!)
        
    }
}

extension MovieSearchViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.searchViewModel.numberOfRowsForModel(sectionNumber: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.searchViewModel.willDisplayCell(section: indexPath.section, row: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchController", for: indexPath) as! ThumbnailCell
        
        func completionHandler(image:UIImage?){
            guard let image = image
                else{
                    return
            }
            DispatchQueue.main.async{
                
                //cell.thumbNail?.layer.masksToBounds = true
                //cell.thumbNail?.layer.cornerRadius = 6
                cell.contentView.layer.cornerRadius = 2.0
                cell.contentView.layer.borderWidth = 1.0
                cell.contentView.layer.borderColor = UIColor.clear.cgColor
                cell.contentView.layer.masksToBounds = true
                print("width \(image.size.width) and height is  \(image.size.height)")
                cell.thumbNail?.image = image//self.resizeImage(image: image)
            }
            
        }
        
        searchViewModel.imageForCell(section: indexPath.section, row: indexPath.row, completion: completionHandler)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let popup = UIStoryboard(name: "Main", bundle: nil)
        let vc = popup.instantiateViewController(identifier: "moviesearch") as! MovieDetailsViewController
        vc.transitioningDelegate = self
        let index : [IndexPath]  = self.collectionView.indexPathsForSelectedItems!
        let row = index[0];
        vc.movieDetailsViewModel = MovieDetailsViewModel(movie: self.searchViewModel.getSelectedRowObject(row: row.row)!)
        present(vc, animated: true, completion: nil)
    }
}

extension MovieSearchViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FlipPresentAnimationController(originFrame: self.view.frame)
    }
    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//      guard let revealVC = dismissed as? MovieDetailsViewController else {
//        return nil
//      }
//      return FlipDismissAnimationController(destinationFrame: cardView.frame, interactionController: revealVC.swipeInteractionController)
//    }
    
    
}

