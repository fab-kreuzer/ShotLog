//
//  ShotListingView.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 20.01.24.
//

import SwiftData
import SwiftUI

struct ShotListingView: View {
    @Query(sort: [SortDescriptor(\Session.date, order: .reverse)]) var sessions: [Session]
    @Environment(\.modelContext) var modelContext

    var body: some View {
        List {
            ForEach(sessions, id: \.self) { session in
                NavigationLink(value: session) {
                    VStack(alignment: .leading) {
                        let formattedDate = session.date.formatted(date: .long, time: .shortened)
                        
                        Text(formattedDate)
                            .font(.headline)
                        Text(session.tenth ?
                            String(format: "%.2f Ringe in %@", session.getAllShots(), session.location) :
                            String(format: "%.0f Ringe in %@", session.getAllShots(), session.location)
                        )
                        Text(String(session.weapon))
                    }
                }
            }
            .onDelete(perform: deleteShots)
        }
    }
    
    init(sort: SortDescriptor<Session>, searchString: String) {
        _sessions = Query(filter: #Predicate {
            if searchString.isEmpty {
                return true
            } else {
                return $0.location.localizedStandardContains(searchString)
            }
        }, sort: [sort])
    }
    
    func deleteShots(_ indexSet: IndexSet) {
        for index in indexSet {
            let shot = sessions[index]
            modelContext.delete(shot)
            try? modelContext.save()
        }
    }
}

#Preview {
    ShotListingView(sort: SortDescriptor(\Session.date, order: .reverse), searchString: "")
}
