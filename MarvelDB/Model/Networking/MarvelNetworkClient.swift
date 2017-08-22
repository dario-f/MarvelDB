//
//  MarvelNetworkClient.swift
//  MarvelDB
//
//  Created by Dario Fanjul on 21/08/2017.
//  Copyright © 2017 Dario Fanjul. All rights reserved.
//

import Foundation

class MarvelNetworkClient {
    
    private var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    private func buildURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.myjson.com"
        components.path = "/bins/bvyob"
        return components.url
    }
    
    public func fetchHeroes(completion: @escaping ([Hero]?, Error?) -> Void) -> URLSessionDataTask? {
        guard let url = buildURL() else {
            completion(nil, MarvelError.invalidURL)
            return nil
        }
        
        let request = URLRequest(url: url)
        NetworkActivity.startedRequest()
        let task = session.dataTask(with: request) { (data, urlResponse, error) in
            NetworkActivity.stoppedRequest()
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let response = urlResponse as? HTTPURLResponse,
                200..<300 ~= response.statusCode else {
                    completion(nil, MarvelError.statusCodeError((urlResponse as? HTTPURLResponse)?.statusCode))
                    return
            }
            
            guard let dataReceived = data,
                let result = try? JSONDecoder().decode(HeroList.self, from: dataReceived) else {
                    completion(nil, MarvelError.invalidData)
                    return
            }
            
            completion(result.superheroes, nil)
        }
        task.resume()
        return task
    }
    
}

enum MarvelError: Error {
    case invalidURL
    case statusCodeError(Int?)
    case invalidData
}
