//
//  EditShotsView.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 20.01.24.
//

import SwiftUI
import SwiftData

struct EditSessionView: View {
    @Bindable var session: Session
    @AppStorage(AppConstants.PROP_TENTH) private var tenth: Bool = false

    var body: some View {
        Form {
            Section(AppConstants.SECTION_GENERAL) {
                TextField(AppConstants.INPUT_LOCATION, text: $session.location)
                DatePicker(AppConstants.INPUT_DATE, selection: $session.date)
                Toggle(isOn: $tenth) {
                    Text("Zehntelwertung")
                }
                //.toggleStyle(.checkmark)
            }
            
            Section(AppConstants.SECTION_SERIE) {
                
                ForEach(Array(session.serien.enumerated()), id: \.offset) { index, serie in
                    NavigationLink(destination: EditSerieView(serie: serie)) {
                        HStack() {
                            Text("Serie \(index + 1): \(serie.getAllShots(pTenth: tenth))")
                        }
                    }
                }
            }
            
            Section(AppConstants.WEAPON_TYPE) {
                Picker(AppConstants.WEAPON_TYPE, selection: $session.weapon) {
                    Text(AppConstants.AIR_RIFLE).tag(AppConstants.AIR_RIFLE)
                    Text(AppConstants.AIR_PISTOL).tag(AppConstants.AIR_PISTOL)
                }
                .pickerStyle(.segmented)
            }

        }
        .navigationTitle(AppConstants.EDIT_SESSION)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Add Serie", action: addSerie)
        }
    }
    
    
    func addSerie() {
        session.addSerie()
    }
    
}
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Session.self, configurations: config)
        let example = Session()
        return EditSessionView(session: example)
    } catch {
        fatalError("Failed to create model container.")
    }
}
