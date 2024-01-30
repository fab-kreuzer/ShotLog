//
//  Serie.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 24.01.24.
//

import SwiftData

@Model
class Serie {
    var schüsse: [Schuss]
    
    init(schüsse: [Schuss] = [Schuss(), Schuss(), Schuss(),Schuss(),Schuss(),Schuss(),Schuss(),Schuss(),Schuss(),Schuss()]) {
        self.schüsse = schüsse
    }
    
    func getAllShots() -> Double {
        var sum: Double = 0.0
        
        for schuss in schüsse {
            sum += schuss.ring
        }
        
        return sum
    }
    
    func saveShots(totalRings: Double) {
        
    }
}
