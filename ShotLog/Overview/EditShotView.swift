//
//  EditShotView.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 03.02.24.
//

import SwiftUI
import SwiftData

struct EditShotView: View {
    @Bindable var shot: Schuss
    
    var body: some View {
        Form {
            Section(AppConstants.SECTION_SHOTS) {
                HStack{
                    Text("Ring:")
                    TextField("", text: Binding(
                        get: { "\(shot.ring)" },
                        set: {
                            if let newValue = NumberFormatter().number(from: $0) {
                                shot.ring = newValue.doubleValue
                            }
                        }
                    ))
                    .keyboardType(.decimalPad)
                }
                HStack {
                    Text("Teiler: ")
                    TextField("", value: $shot.teiler, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)

                }
            }
        }.navigationTitle(AppConstants.EDIT_SHOTS)
    }
}



#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Schuss.self, configurations: config)
        let example = Schuss()
        return EditShotView(shot: example)
    }catch {
        fatalError("Failed to create model container.")

    }
}
