//
//  StatsOverviewView.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 21.01.24.
//

import SwiftUI

struct StatsOverviewView: View {
    
    var body: some View {
        NavigationStack {
            StatsView()
                .navigationTitle(AppConstants.TAB_STATS)
        }

    }
}

#Preview {
    StatsOverviewView()
}
