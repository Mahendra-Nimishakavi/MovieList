//
//  FavoritesViewController.swift
//  MovieList
//
//  Created by mn669704 on 24/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import UIKit

class FavoritesViewController: BaseViewController {
    var favoritesViewModel : FavoritesViewModel!
    @IBOutlet var favoritesGrid : UICollectionView!
    private var indexOfSelectedCell:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.favoritesGrid?.backgroundColor = .clear
        self.favoritesGrid?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.favoritesViewModel.loadFavoriteMovies()
        self.favoritesGrid.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationViewController = segue.destination as? MovieDetailsViewController
            destinationViewController?.movieDetailsViewModel = MovieDetailsViewModel(movie: self.favoritesViewModel.getMovieForSelectedCell(indexPath:indexOfSelectedCell!)!,dataStore: MovieDataStore())
          
        }

}

extension FavoritesViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.favoritesViewModel.numberOfRows(for: section)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchController", for: indexPath) as! ThumbnailCell
        
        cell.thumbNail?.image = favoritesViewModel.getThumNailImage(indexPath: indexPath)
        
        configureCell(cell)
        return cell
    }
    
    private func configureCell(_ cell:UICollectionViewCell) {
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.masksToBounds = true
        cell.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexOfSelectedCell = collectionView.indexPathsForSelectedItems?.first
        self.performSegue(withIdentifier: "Favorites", sender: self)
    }
    
}
