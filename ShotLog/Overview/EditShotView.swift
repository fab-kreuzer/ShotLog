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
    var tenth: Bool
    @State var inputText: String = ""

    init(shot: Schuss, tenth: Bool) {
        self.shot = shot
        self.tenth = tenth
    }
    
    var body: some View {
        
        Form {
            Section(AppConstants.SECTION_SHOTS) {
                HStack{
                    Text("Ring:")
                    TextField("", text: Binding(
                        get: {
                            shot.getFormattedValue(pTenth: tenth)
                        },
                        set: {val in
                            inputText = val
                        }
                    ), onEditingChanged: {isEditing in
                        if !isEditing {
                            // Handle when the user exits the TextField
                            if let doubleValue = Double(inputText.replacingOccurrences(of: ",", with: ".")) {
                                shot.ring = doubleValue // Update the stored value
                            }
                        }
                    })
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
        return EditShotView(shot: example, tenth: true)
    }catch {
        fatalError("Failed to create model container.")

    }
}
