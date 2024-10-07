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
    var ringe: Double = 0
    
    init(ringe: Double = 0) {
        self.ringe = ringe
    }
    
    func getAllShots(pTenth: Bool = false) -> String {
        if pTenth {
            return String(ringe)
        } else {
            return String(Int(ringe))
        }
    }
}
