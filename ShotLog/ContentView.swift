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
                .navigationTitle(AppConstants.APP_TITLE)
                .navigationDestination(for: Shot.self, destination: EditShotsView.init)
                .searchable(text: $searchText)
                .toolbar {
                    Button(AppConstants.ADD_SHOT, systemImage: "plus", action: addShot)
                    
                    Menu(AppConstants.SORT_BTN, systemImage: "arrow.up.arrow.down") {
                        Picker(AppConstants.SORT_BTN, selection: $sortOrder) {
                            Text(AppConstants.SORT_DATE).tag(SortDescriptor(\Shot.date, order: .reverse))
                            Text(AppConstants.SORT_RINGS).tag(SortDescriptor(\Shot.allShots, order: .reverse))
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
