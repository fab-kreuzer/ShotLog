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
    @State var totalRings: Double
    var tenth: Bool
    
    init(serie: Serie, tenth: Bool) {
        self.tenth = tenth
        self._totalRings = State(initialValue: 0.0)
        self.serie = serie
    }

    var body: some View {
        Form {
            Section("Gesamt ändern") {
                HStack {
                    TextField("", text: Binding(
                        get: { "\(totalRings)" },
                        set: {
                            if let newValue = NumberFormatter().number(from: $0) {
                                totalRings = newValue.doubleValue
                            }
                        }
                    ))
                    .keyboardType(.decimalPad) 
                    Button("Übernehmen") {
                        serie.saveShots(totalRings: totalRings)
                    }
                }
            }
            
            Section("Serien ändern") {
                ForEach(Array(serie.shots.enumerated()), id: \.offset) { index, shot in
                    NavigationLink(destination: {EditShotView(shot: shot, tenth: self.tenth)}) {
                        HStack {
                            Text("Schuss \(index + 1): " + shot.getFormattedValue(pTenth: self.tenth))
                        }
                    }
                }
            }
        }
        .navigationTitle(AppConstants.EDIT_SERIE)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Serie.self, configurations: config)
        let example = Serie()
        return EditSerieView(serie: example, tenth: true)
    }catch {
        fatalError("Failed to create model container.")

    }

}
