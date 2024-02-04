//
//  Serie.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 24.01.24.
//

import SwiftData
import Foundation

@Model
class Serie {
    var shots: [Schuss]
    
    init(shots: [Schuss] = [Schuss(), Schuss(), Schuss(),Schuss(),Schuss(),Schuss(),Schuss(),Schuss(),Schuss(),Schuss()]) {
        self.shots = shots
    }
    
    func getAllShots(pTenth: Bool = false) -> String {
        var sum: Double = 0.0
        
        for schuss in shots {
            if var val = Double(schuss.getFormattedValue(pTenth: pTenth)) {
                val = round(100 * val) / 100
                sum += val
            }
        }
        return String(sum)
    }
    
    func saveShots(totalRings: Double) {
        var remainingValue = totalRings
        
        shots.removeAll()
        
        // Subtract 10.9 from the input value until it becomes less than 10.9
        while remainingValue >= 10.9 {
            shots.append(Schuss(ring: 10.9))
            remainingValue -= 10.9
        }
        
        // If there is remaining value after subtracting multiples of 10.9, add it to the array
        if remainingValue > 0 {
            shots.append(Schuss(ring: remainingValue))
        }
        
        // Fill the remaining array slots with empty Schusse if the count is less than 10
        while shots.count < 10 {
            shots.append(Schuss(ring: 0.0))
        }
    }
}
