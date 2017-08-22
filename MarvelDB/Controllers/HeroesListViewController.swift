//
//  HeroesListViewController.swift
//  MarvelDB
//
//  Created by Dario Fanjul on 21/08/2017.
//  Copyright © 2017 Dario Fanjul. All rights reserved.
//

import UIKit

class HeroesListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var collectionController: MarvelCollectionHandler?
    private var imageProvider: ImageProvider = {
        return MarvelImageProvider()
    }()
    fileprivate let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSpinner()
        displaySpinner()
        title = "Marvel Super Hero DB"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionController?.max(width: self.view.bounds.width)
    }
}

//MARK: Helpers
extension HeroesListViewController {
    
    fileprivate func setupCollectionView() {
        collectionController = MarvelCollectionHandler(with: self, imageProvider: imageProvider )
        collectionView.delegate = collectionController
        collectionView.dataSource = collectionController
        collectionView.isPrefetchingEnabled = false
    }
    
    fileprivate func displaySpinner() {
        spinner.startAnimating()
    }
    
    fileprivate func stopSpinner() {
        spinner.stopAnimating()
    }
    
    fileprivate func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
    }
    
}

extension HeroesListViewController: MarvelCollectionHandlerDelegate {
    
    func reloadData() {
        stopSpinner()
        collectionView.reloadData()
    }
    
    func displayDetail(for hero: Hero) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "heroDetail") as? HeroDetailViewController,
        let navigation = navigationController else {
            return
        }
        vc.hero = hero
        vc.imageProvider = imageProvider
        navigation.pushViewController(vc, animated: true)
    }
    
    func networkError() {
        let ac = UIAlertController(title: "Error downloading", message: "An error ocurred downloading data from network", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { [weak self] (_) in
            self?.collectionController?.updateData()
            self?.displaySpinner()
        }))
        present(ac, animated: true, completion: nil)
    }
    
}
