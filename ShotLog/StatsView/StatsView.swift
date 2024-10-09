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
    
    @State private var currentMonth: Date = Date() // Track the current displayed month
    
    var body: some View {
        Form {
            // Calendar heatmap with month name, weekdays, and swipe gesture
            Section("Session Calendar") {
                VStack {
                    // Display the month and navigation arrows
                    HStack {
                        Image(systemName: "chevron.left")
                            .onTapGesture {
                                currentMonth = getPreviousMonth(from: currentMonth)
                            }
                        Spacer()
                        Text(currentMonth, formatter: DateFormatter.monthAndYear)
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .onTapGesture {
                                currentMonth = getNextMonth(from: currentMonth)
                            }
                    }
                    .padding()
                    
                    // Weekday labels (starting with Monday and ending with Sunday)
                    HStack {
                        ForEach(reorderedWeekdaySymbols(), id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(isWeekend(day: day) ? .red : .primary) // Color weekends in red
                        }
                    }

                    // Calendar heatmap with swipe gesture
                    calendarHeatmap()
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.width < 0 { // Swipe left to go to the next month
                                        currentMonth = getNextMonth(from: currentMonth)
                                    } else if value.translation.width > 0 { // Swipe right to go to the previous month
                                        currentMonth = getPreviousMonth(from: currentMonth)
                                    }
                                }
                        )
                }
            }
        }
    }
    
    // Function to generate the calendar heatmap
    func calendarHeatmap() -> some View {
        let daysInMonth = getDaysInMonth(for: currentMonth)
        let sessionDays = Set(shots.map { Calendar.current.startOfDay(for: $0.date) })
        let firstWeekday = getFirstWeekdayOfMonth(for: currentMonth) // Get the first weekday of the month
        
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                // Skip the days before the first day of the month
                ForEach(0..<firstWeekday, id: \.self) { _ in
                    Text("") // Empty spaces for alignment
                        .frame(width: 30, height: 30)
                }
                
                // Render days of the month
                ForEach(daysInMonth, id: \.self) { date in
                    let weekday = Calendar.current.component(.weekday, from: date)
                    Text("\(Calendar.current.component(.day, from: date))")
                        .frame(width: 30, height: 30)
                        .background(sessionDays.contains(date) ? Color.green : Color.gray.opacity(0.2))
                        .cornerRadius(5)
                        .foregroundColor(isWeekend(weekday: weekday) ? .red : .primary) // Color weekends in red
                }
            }
        }
    }

    // Get the first weekday of the current month (adjusted for calendar starting with Monday)
    func getFirstWeekdayOfMonth(for date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: components)!
        let weekday = calendar.component(.weekday, from: startOfMonth)
        let adjustedWeekday = (weekday + 5) % 7 // Adjust so Monday = 0, Sunday = 6
        return adjustedWeekday
    }
    
    // Get all the days of the current month
    func getDaysInMonth(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        let components = calendar.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: components)!
        
        return range.compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    // Get the next month from the current date
    func getNextMonth(from date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: 1, to: date) ?? date
    }
    
    // Get the previous month from the current date
    func getPreviousMonth(from date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -1, to: date) ?? date
    }

    // Modify shotsStatistic to group by exact day
    func shotsStatistic() -> [String: Int] {
        let groupedByDay = Dictionary(grouping: shots) { shot in
            let components = Calendar.current.dateComponents([.year, .month, .day], from: shot.date)
            return "\(components.day!)/\(components.month!)/\(components.year!)"
        }

        return groupedByDay.mapValues { $0.count }
    }

    // Helper function to determine if a weekday is a weekend (Saturday or Sunday)
    func isWeekend(day: String) -> Bool {
        return day == Calendar.current.veryShortStandaloneWeekdaySymbols[6] || day == Calendar.current.veryShortStandaloneWeekdaySymbols[5] // Adjust to Saturday and Sunday
    }
    
    func isWeekend(weekday: Int) -> Bool {
        return weekday == 1 || weekday == 7 // 1 = Sunday, 7 = Saturday
    }
    
    // Reorder the weekday symbols to start with Monday and end with Sunday
    func reorderedWeekdaySymbols() -> [String] {
        var symbols = Calendar.current.shortWeekdaySymbols
        let sunday = symbols.removeFirst() // Remove Sunday
        symbols.append(sunday) // Add Sunday to the end
        return symbols
    }
}

#Preview {
    StatsView()
}

// Helper extension for date formatting
extension DateFormatter {
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}
