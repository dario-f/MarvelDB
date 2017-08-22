//
//  MarvelCollectionHandler.swift
//  MarvelDB
//
//  Created by Dario Fanjul on 21/08/2017.
//  Copyright © 2017 Dario Fanjul. All rights reserved.
//

import UIKit

class MarvelCollectionHandler: NSObject {
    
    fileprivate var data = [Hero]() {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.reloadData()
            }
        }
    }
    private let networkClient: MarvelNetworkClient = {
        return MarvelNetworkClient()
    }()
    fileprivate let imageProvider: ImageProvider
    fileprivate var cellSize = CGSize(width: Constants.maxCellSize, height: Constants.maxCellSize)
    
    weak var delegate: MarvelCollectionHandlerDelegate?
    
    private struct Constants {
        static let maxCellSize = CGFloat(200)
        static let numberOfColumns = CGFloat(2)
    }
    
    init(with delegate: MarvelCollectionHandlerDelegate, imageProvider: ImageProvider) {
        self.delegate = delegate
        self.imageProvider = imageProvider
        super.init()
        updateData()
    }
    
    
    /// Triggers network request
    func updateData() {
        _ = networkClient.fetchHeroes { [weak self] (result, error) in
            guard error == nil else {
                self?.delegate?.networkError()
                return
            }
            if let result = result {
                self?.data = result
            }
        }
    }
    
    /// Sets maximum width allowed for cells
    ///
    /// - Parameter width: maximum width allowed for cells
    func max(width: CGFloat) {
        let calculatedSize = (width/Constants.numberOfColumns) - 8 //padding
        let size = min(Constants.maxCellSize, calculatedSize)
        cellSize = CGSize(width: size, height: size)
        delegate?.reloadData()
    }
    
}

extension MarvelCollectionHandler: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedHero = data[indexPath.row]
        delegate?.displayDetail(for: selectedHero)
    }
    
}

extension MarvelCollectionHandler: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "heroCell", for: indexPath)
        
        if let cell = cell as? HeroCollectionViewCell {
            let hero = data[indexPath.row]
            cell.nameLabel.text = hero.name
            imageProvider.fetchImage(url: hero.photo, completion: { (image) in
                DispatchQueue.main.async {
                    if let cell = collectionView.cellForItem(at: indexPath) as? HeroCollectionViewCell {
                        cell.heroImage.image = image
                    }
                }
            })
        }
        
        return cell
    }
        
}

extension MarvelCollectionHandler: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
}
