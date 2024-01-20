//
//  Shots.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 20.01.24.
//

import Foundation
import SwiftData

@Model
class Shot {
    var date: Date
    var dest: String
    
    var serieTest: Int
    var serieOne: Int
    var serieTwo: Int
    var serieThree: Int
    var serieFour: Int
    
    init(date: Date = .now, dest: String = "Hader", serieTest: Int = 0, serieOne: Int = 0, serieTwo: Int = 0, serieThree: Int = 0, serieFour: Int = 0) {
        self.date = date
        self.dest = dest
        self.serieTest = serieTest
        self.serieOne = serieOne
        self.serieTwo = serieTwo
        self.serieThree = serieThree
        self.serieFour = serieFour
    }
}
