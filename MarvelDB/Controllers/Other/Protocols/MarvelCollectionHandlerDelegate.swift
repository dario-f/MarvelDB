//
//  MarvelCollectionDelegate.swift
//  MarvelDB
//
//  Created by Dario Fanjul on 22/08/2017.
//  Copyright © 2017 Dario Fanjul. All rights reserved.
//

import Foundation

protocol MarvelCollectionHandlerDelegate: class {
    
    /// Method for notification that data was updated
    func reloadData()
    
    /// Method for selection notification
    ///
    /// - Parameter hero: selected hero
    func displayDetail(for hero: Hero)
    
    /// Notifies network error
    func networkError()
    
}
