import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        
        TabView {
            
            OverviewView()
                .tabItem {
                    Image(systemName: "folder")
                    Text(AppConstants.TAB_OVERVIEW)
                }
            StatsView()
                .tabItem {
                    Image(systemName: "text.aligncenter")
                    Text(AppConstants.TAB_STATS)
                }
        }
    }
}

#Preview{
    ContentView()
}
