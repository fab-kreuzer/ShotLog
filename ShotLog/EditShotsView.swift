//
//  EditShotsView.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 20.01.24.
//

import SwiftUI
import SwiftData

struct EditShotsView: View {
    @Bindable var shot: Shot
    
    var body: some View {
        Form {
            Section("Allgemeines") {
                TextField("Ort", text: $shot.dest)
                DatePicker("Datum", selection: $shot.date)
            }
            
            Section(header: Text("Schüsse")) {
                HStack(spacing: 10) {
                    Text("Probeschüsse")
                    TextField("", value: $shot.serieTest, formatter: NumberFormatter())
                }
                HStack(spacing: 10) {
                    Text("Serie 1\t")
                    TextField("", value: $shot.serieOne, formatter: NumberFormatter())
                }
                HStack(spacing: 10) {
                    Text("Serie 2\t")
                    TextField("", value: $shot.serieTwo, formatter: NumberFormatter())
                }
                HStack(spacing: 10) {
                    Text("Serie 3\t")
                    TextField("", value: $shot.serieThree, formatter: NumberFormatter())
                }
                HStack(spacing: 10) {
                    Text("Serie 4\t")
                    TextField("", value: $shot.serieFour, formatter: NumberFormatter())
                }
                HStack(spacing: 10) {
                    Text("Gesamt\t")
                    TextField("", value: $shot.allShots, formatter: NumberFormatter())
                }
            }
            
            Section("Waffenart") {
                Picker("Waffenart", selection: $shot.weapon) {
                    Text("Luftgewehr").tag("Luftgewehr")
                    Text("Luftpistole").tag("Luftpistole")
                }
                .pickerStyle(.segmented)
            }

        }
        .navigationTitle("Edit Shot")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            calcAllShots(pShot: shot)
        }
    }
        
    
    func calcAllShots(pShot: Shot) {
        shot.allShots = shot.serieOne + shot.serieTwo + shot.serieThree + shot.serieFour
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Shot.self, configurations: config)
        let example = Shot()
        return EditShotsView(shot: example).modelContainer(container)
    } catch {
        fatalError("Faild to create model container.")
    }
    
}
