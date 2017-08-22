//
//  NetworkActivity.swift
//  MarvelDB
//
//  Created by Dario Fanjul on 22/08/2017.
//  Copyright © 2017 Dario Fanjul. All rights reserved.
//

import UIKit

struct NetworkActivity {
    
    private static var networkActivities = 0
    
    static func startedRequest() {
        DispatchQueue.main.async {
            if NetworkActivity.networkActivities == 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            NetworkActivity.networkActivities += 1
        }
    }
    
    static func stoppedRequest() {
        DispatchQueue.main.async {
            NetworkActivity.networkActivities -= 1
            if NetworkActivity.networkActivities == 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
}
