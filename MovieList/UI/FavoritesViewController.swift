//
//  FavoritesViewController.swift
//  MovieList
//
//  Created by mn669704 on 24/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    var favoritesViewModel : FavoritesViewModel!
    @IBOutlet var favoritesGrid : UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.favoritesViewModel.getFavoriteMovies()
    }

}

extension FavoritesViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.favoritesViewModel.numberOfRows(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.favoritesViewModel.willDisplayCell(section: indexPath.section, row: indexPath.row)
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
        
        favoritesViewModel.imageForCell(section: indexPath.section, row: indexPath.row, completion: completionHandler)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
