//
//  MarvelImageProvider.swift
//  MarvelDB
//
//  Created by Dario Fanjul on 22/08/2017.
//  Copyright © 2017 Dario Fanjul. All rights reserved.
//

import UIKit

class MarvelImageProvider {
    private var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

extension MarvelImageProvider: ImageProvider {
    
    func fetchImage(url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
        NetworkActivity.startedRequest()
        session.dataTask(with: url) { (data, urlResponse, error) in
            NetworkActivity.stoppedRequest()
            guard error == nil,
                let response = urlResponse as? HTTPURLResponse,
                200..<300 ~= response.statusCode,
                let data = data else {
                    completion(nil)
                    return
            }
            let image = UIImage(data: data)
            completion(image)
            }.resume()
    }
    
}
