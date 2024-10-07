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
    @State private var showingOverlay = false
    @State private var inputValue: String = ""
    
    var body: some View {
        Form {
            Section(AppConstants.SECTION_GENERAL) {
                TextField(AppConstants.INPUT_LOCATION, text: $session.location)
                DatePicker(AppConstants.INPUT_DATE, selection: $session.date)
                Toggle(isOn: $session.tenth) {
                    Text("Zehntelwertung")
                }
            }
            
            Section(AppConstants.SECTION_SERIE) {
                // Break down ForEach loop into simpler parts
                ForEach(0..<session.serien.count, id: \.self) { index in
                    let serie = session.serien[index]
                    HStack {
                        Text("Serie \(index + 1): \(serie.getAllShots(pTenth: session.tenth))")
                    }
                }
                .onDelete(perform: deleteSerie)
                .onMove(perform: moveShots) 
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
            Button("Serie hinzufügen") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showingOverlay = true // Dismiss the overlay
                }            }
        }
        
        // Custom bottom overlay
        if showingOverlay {
            BottomSheetView(isPresented: $showingOverlay) {
                VStack(spacing: 20) {
                    Text("Ringe eingeben")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .foregroundColor(.primary)
                    
                    TextField("100", text: $inputValue)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    Button(action: {
                        if let input = Double(inputValue) {
                            session.addSerie(serie: Serie(ringe: input))
                            inputValue = "" // Clear the input field
                        }
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingOverlay = false // Dismiss the overlay
                        }
                    }) {
                        Text("Übernehmen")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(Color.white)
                            .background(Color.brown)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    Button("Abbrechen") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingOverlay = false // Dismiss the overlay
                        }
                    }
                    .foregroundColor(.red)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    // Method to handle deletion of a series
    func deleteSerie(offsets: IndexSet) {
        session.serien.remove(atOffsets: offsets)
    }
    // Method to handle reordering of the series
    func moveShots(from source: IndexSet, to destination: Int) {
        session.serien.move(fromOffsets: source, toOffset: destination)
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
