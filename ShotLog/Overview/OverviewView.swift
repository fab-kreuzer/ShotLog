//
//  OverviewView.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 21.01.24.
//

import SwiftUI
import SwiftData
import UserNotifications

struct OverviewView: View {
    
    @State private var searchText = ""
    @State private var path = [Shot]()
    @State private var sortOrder = SortDescriptor(\Shot.date, order: .reverse)
    @Environment(\.modelContext) var modelContext

    var body: some View {
        NavigationStack(path: $path) {
            ShotListingView(sort: sortOrder, searchString: searchText)
                .navigationTitle(AppConstants.APP_TITLE)
                .navigationDestination(for: Shot.self, destination: EditShotsView.init)
                .searchable(text: $searchText)
                .toolbar {
                    Button(AppConstants.ADD_SHOT, systemImage: "plus", action: addShot)
                    
                    Menu(AppConstants.SORT_BTN, systemImage: "arrow.up.arrow.down") {
                        Picker(AppConstants.SORT_BTN, selection: $sortOrder) {
                            Text(AppConstants.SORT_DATE).tag(SortDescriptor(\Shot.date, order: .reverse))
                            Text(AppConstants.SORT_RINGS).tag(SortDescriptor(\Shot.allShots, order: .reverse))
                        }
                        .pickerStyle(.inline)
                    }
                }
        }

    }
    
    func addShot() {
        let shot = Shot()
        modelContext.insert(shot)
        path = [shot]
    }
    
}
