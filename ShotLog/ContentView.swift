import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = [Shot]()
    @State private var sortOrder = SortDescriptor(\Shot.date, order: .reverse)
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack(path: $path) {
            ShotListingView(sort: sortOrder, searchString: searchText)
                .navigationTitle("ShotLog")
                .navigationDestination(for: Shot.self, destination: EditShotsView.init)
                .searchable(text: $searchText)
                .toolbar {
                    Button("Add Shot", systemImage: "plus", action: addShot)
                    
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Datum").tag(SortDescriptor(\Shot.date, order: .reverse))
                            Text("Ringe").tag(SortDescriptor(\Shot.allShots, order: .reverse))
                        }
                        .pickerStyle(.inline)
                    }
                }
        }

    }    
    func addShot() {
        let shot = Shot()
        modelContext.insert(shot)
        path = [shot]
    }

}

#Preview{
    ContentView()
}
