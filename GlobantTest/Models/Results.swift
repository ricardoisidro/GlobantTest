//
//  Results.swift
//  GlobantTest
//
//  Created by Ricardo Isidro on 2/20/19.
//  Copyright © 2019 RicardoIsidro. All rights reserved.
//

import Foundation

class Results: NSObject, Decodable {
    var name: String
    var height: String
    var mass: String
    var hair_color: String
    var skin_color: String
    var eye_color: String
    var birth_year: String
    var gender: String
    var homeworld: String
    var films: [String]
    var species: [String]
    var vehicles: [String]
    var starships: [String]
    var created: String
    var edited: String
    var url: String
    
    override init() {
        self.name = ""
        self.height = ""
        self.mass = ""
        self.hair_color = ""
        self.skin_color = ""
        self.eye_color = ""
        self.birth_year = ""
        self.gender = ""
        self.homeworld = ""
        self.films = []
        self.species = []
        self.vehicles = []
        self.starships = []
        self.created = ""
        self.edited = ""
        self.url = ""
        
        
    }
}
