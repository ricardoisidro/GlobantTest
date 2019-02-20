//
//  People.swift
//  GlobantTest
//
//  Created by Ricardo Isidro on 2/20/19.
//  Copyright © 2019 RicardoIsidro. All rights reserved.
//

import Foundation

class People: NSObject, Decodable {
    var count: Int
    var next: String
    var previous: String?
    var results: [Results]
    
    override init() {
        self.count = -1
        self.next = ""
        self.previous = ""
        self.results = []
    }
}
