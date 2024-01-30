//
//  Shots.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 20.01.24.
//

import Foundation
import SwiftData

@Model
class Session: Hashable {
    var date: Date
    var location: String
    var weapon: String
    var serien: [Serie]
    
    let identifier = UUID()
    
    init(date: Date = .now, dest: String = "Hader", weapon: String = AppConstants.AIR_RIFLE, serien: [Serie] = [Serie()]) {
        self.date = date
        self.location = dest
        self.weapon = weapon
        self.serien = serien
    }
    
    func hash(into hasher: inout Hasher) { hasher.combine(self.identifier) }
    
    func getAllShots() -> Double {
        var sum: Double = 0.0
        
        for serie in serien {
            sum += serie.getAllShots()
        }
        
        return sum
    }
    
    func addSerie(serie: Serie = Serie()) {
        serien.append(serie)
    }
}
