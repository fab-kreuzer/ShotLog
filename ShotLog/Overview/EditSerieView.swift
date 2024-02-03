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
    @AppStorage(AppConstants.PROP_TENTH) private var tenth: Bool = false

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
                Toggle(isOn: $tenth) {
                    Text("Zehntelwertung")
                }
                .toggleStyle(.checkmark)

            }
            
            Section("Serien ändern") {
                ForEach(Array(serie.shots.enumerated()), id: \.offset) { index, shot in
                    NavigationLink(destination: {EditShotView(shot: shot)}) {
                        HStack {
                            Text("Schuss \(index + 1): " + shot.getFormattedValue(pTenth: tenth))
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
        return EditSerieView(serie: example)
    }catch {
        fatalError("Failed to create model container.")

    }

}
