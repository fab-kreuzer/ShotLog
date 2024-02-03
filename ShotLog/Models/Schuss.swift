//
//  Schuss.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 24.01.24.
//

import SwiftData

@Model
class Schuss {
    var ring: Double
    var teiler: Double
    
    init(ring: Double = 0.0, teiler: Double = 0.0) {
        self.ring = ring
        self.teiler = teiler
    }
    
    func getFormattedValue(pTenth: Bool = false) -> String {
        if pTenth {
            return String(self.ring)
        }
        else {
            return String(Int(self.ring))
        }
    }
}
