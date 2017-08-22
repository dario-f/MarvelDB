//
//  Hero.swift
//  MarvelDB
//
//  Created by Dario Fanjul on 21/08/2017.
//  Copyright © 2017 Dario Fanjul. All rights reserved.
//

import Foundation

struct Hero: Decodable {
    public let name: String
    public let photo: URL
    public let realName: String
    public let height: String
    public let power: String
    public let abilities: String
    public let groups: String
}
