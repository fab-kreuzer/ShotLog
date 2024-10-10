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
    var date: Date = Date()
    var location: String = ""
    var weapon: String = ""
    var serien: [Serie] = []  // Make this relationship optional
    var tenth: Bool = false
    
    var identifier = UUID()
    
    @Relationship(inverse: \Session.parent) var children: [Session]?
    @Relationship var parent: Session? // can make private if not using elsewhere

    init(date: Date = .now, dest: String = "Hader", weapon: String = AppConstants.AIR_RIFLE, serien: [Serie] = [Serie()], tenth: Bool = true) {
        self.date = date
        self.location = dest
        self.weapon = weapon
        self.serien = serien
        self.tenth = tenth
    }
    
    func hash(into hasher: inout Hasher) { hasher.combine(self.identifier) }
    
    func getAllShots() -> Double {
        return serien.reduce(0.0) { sum, serie in
            sum + serie.getAllShots(pTenth: self.tenth)
        }
    }
    
    func addSerie(serie: Serie = Serie()) {
        serien.append(serie)
    }
}
