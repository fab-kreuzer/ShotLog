//
//  ShotListingView.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 20.01.24.
//

import SwiftData
import SwiftUI

struct ShotListingView: View {
    @Query(sort: [SortDescriptor(\Shot.date, order: .reverse), SortDescriptor(\Shot.allShots, order: .reverse)]) var shots: [Shot]
    @Environment(\.modelContext) var modelContext

    var body: some View {
        List {
            ForEach(shots, id: \.self) { shot in
                NavigationLink(value: shot) {
                    VStack(alignment: .leading) {
                        let formattedDate = shot.date.formatted(date: .long, time: .shortened)
                        let ringsText = String(shot.allShots) + "R @ " + shot.dest
                        
                        Text(formattedDate).font(.headline)
                        Text(ringsText)
                        Text(String(shot.weapon))
                    }
                }
            }
            .onDelete(perform: deleteShots)
        }
    }
    
    init(sort: SortDescriptor<Shot>, searchString: String) {
        _shots = Query(filter: #Predicate {
            if searchString.isEmpty {
                return true
            } else {
                return $0.dest.localizedStandardContains(searchString)
            }
        }, sort: [sort])
    }
    
    func deleteShots(_ indexSet: IndexSet) {
        for index in indexSet {
            let shot = shots[index]
            modelContext.delete(shot)
        }
    }
}

#Preview {
    ShotListingView(sort: SortDescriptor(\Shot.date, order: .reverse), searchString: "")
}
