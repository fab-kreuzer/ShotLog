//
//  EditSerieView.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 29.01.24.
//

import SwiftUI
import SwiftData

struct EditSerieView: View {
    @Bindable var serie: Serie
    @State var totalRings: Double = 0.0
    
    var body: some View {
        Form {
            Section("Gesamt ändern") {
                HStack {
                    TextField("Gesamt", value: $totalRings, formatter: NumberFormatter())
                    Button("Übernehmen") {
                        serie.saveShots(totalRings: totalRings)
                    }
                }
            }
            
            Section("Serien ändern") {
                ForEach(Array(serie.shots.enumerated()), id: \.offset) { index, shot in
                    HStack {
                        Text("Schuss \(index + 1):")
                        TextField("", value: self.$serie.shots[index].ring, formatter: NumberFormatter.decimalFractionDigits(1))
                    }
                }
            }
        }
    }
}

extension NumberFormatter {
    static func decimalFractionDigits(_ fractionDigits: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter
    }
}

// Custom TextField for Double values
struct DoubleTextField: View {
    @Binding var value: Double
    var formatter: NumberFormatter
    
    init(value: Binding<Double>, formatter: NumberFormatter) {
        self._value = value
        self.formatter = formatter
        // Ensure that decimal values are retained
        self.formatter.maximumFractionDigits = Int.max
    }
    
    var body: some View {
        TextField("", text: Binding(
            get: {
                // Format the double value using the provided formatter
                return self.formatter.string(for: self.value) ?? ""
            },
            set: { newValue in
                // Attempt to convert the string value back to a Double
                if let newValue = self.formatter.number(from: newValue)?.doubleValue {
                    self.value = newValue
                }
            }
        ))
        .keyboardType(.decimalPad)
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Serie.self, configurations: config)
        let example = Serie()
        return EditSerieView(serie: example)
    }catch {
        fatalError("Failed to create model container.")

    }

}
