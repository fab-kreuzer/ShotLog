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
            Section(AppConstants.SECTION_GENERAL) {
                TextField(AppConstants.INPUT_LOCATION, text: $shot.dest)
                DatePicker(AppConstants.INPUT_DATE, selection: $shot.date)
            }
            
            Section(header: Text(AppConstants.SECTION_SHOTS)) {
                HStack(spacing: 10) {
                    Text(AppConstants.SHOT_TEST)
                    TextField("", value: $shot.serieTest, formatter: NumberFormatter())
                }
                HStack(spacing: 10) {
                    Text(AppConstants.SHOT_ONE)
                    TextField("", value: $shot.serieOne, formatter: NumberFormatter())
                }
                HStack(spacing: 10) {
                    Text(AppConstants.SHOT_TWO)
                    TextField("", value: $shot.serieTwo, formatter: NumberFormatter())
                }
                HStack(spacing: 10) {
                    Text(AppConstants.SHOT_THREE)
                    TextField("", value: $shot.serieThree, formatter: NumberFormatter())
                }
                HStack(spacing: 10) {
                    Text(AppConstants.SHOT_THREE)
                    TextField("", value: $shot.serieFour, formatter: NumberFormatter())
                }
            }
            
            Section(AppConstants.WEAPON_TYPE) {
                Picker(AppConstants.WEAPON_TYPE, selection: $shot.weapon) {
                    Text(AppConstants.AIR_RIFLE).tag(AppConstants.AIR_RIFLE)
                    Text(AppConstants.AIR_PISTOL).tag(AppConstants.AIR_PISTOL)
                }
                .pickerStyle(.segmented)
            }

        }
        .navigationTitle(AppConstants.EDIT_SHOTS)
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
