//
//  ImageProvider.swift
//  MarvelDB
//
//  Created by Dario Fanjul on 22/08/2017.
//  Copyright © 2017 Dario Fanjul. All rights reserved.
//

import UIKit

protocol ImageProvider {
    
    /// Returns image from URL location
    ///
    /// - Parameters:
    ///   - url: Image URL
    ///   - completion: completion handler receiving downloaded image
    func fetchImage(url: URL, completion: @escaping (_ image: UIImage?) -> Void)
    
}
