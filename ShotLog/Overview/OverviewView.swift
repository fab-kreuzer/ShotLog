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
    @State private var path = [Session]()
    @State private var sortOrder = SortDescriptor(\Session.date, order: .reverse)
    @Environment(\.modelContext) var modelContext
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationStack(path: $path) {
            ShotListingView(sort: sortOrder, searchString: searchText)
                .navigationTitle(AppConstants.APP_TITLE)
                .navigationDestination(for: Session.self, destination: EditSessionView.init)
                .searchable(text: $searchText)
                .toolbar {
                    Button(AppConstants.ADD_SHOT, systemImage: "plus", action: addShot)
                    
                    Menu(AppConstants.SORT_BTN, systemImage: "arrow.up.arrow.down") {
                        Picker(AppConstants.SORT_BTN, selection: $sortOrder) {
                            Text(AppConstants.SORT_DATE).tag(SortDescriptor(\Session.date, order: .reverse))
                            //Text(AppConstants.SORT_RINGS).tag(SortDescriptor(\Shot.allShots, order: .reverse))
                        }
                        .pickerStyle(.inline)
                    }
                }
        }

    }
    
    func addShot() {
        let session = Session()
        session.location = locationManager.currentCity
        modelContext.insert(session)
        path = [session]
    }
    
}
