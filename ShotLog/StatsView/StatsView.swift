//
//  StatsView.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 21.01.24.
//

import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var shots: [Session]
    
    var body: some View {
        Form {
            Section(AppConstants.SECTION_STATS_SHOT) {
                List {
                    // Display the statistic
                    ForEach(Array(shotsStatistic().keys.sorted()), id: \.self) { date in
                        if let count = shotsStatistic()[date] {
                            Text("\(date): \(count)" + AppConstants.SECTION_STATS_SHOT_TIMES)
                        }
                    }
                }
                Chart {
                    ForEach(Array(shotsStatistic().keys.sorted()), id: \.self) { date in
                        if let count = shotsStatistic()[date] {
                            BarMark(
                                x: .value("", date),
                                y: .value("", count)
                            )
                        }
                        
                    }
                }
            }
            Section(AppConstants.SECTION_STATS_WEAPON) {
            }
        }
    }
    
    func shotsStatistic() -> [String: Int] {
        let groupedByMonthYear = Dictionary(grouping: shots) { shot in
            let components = Calendar.current.dateComponents([.year, .month], from: shot.date)
            return "\(components.month!)/\(components.year!)"
        }

        return groupedByMonthYear.mapValues { $0.count }
    }

}

#Preview {
    StatsView()
}
