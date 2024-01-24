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
            StatsOverviewView()
                .tabItem {
                    Image(systemName: "text.aligncenter")
                    Text(AppConstants.TAB_STATS)
                }
        }
        .onAppear() {
            checkPermissionaAndNotify()
        }
    }
    
    func checkPermissionaAndNotify() {
        let notCenter = UNUserNotificationCenter.current()
        notCenter.getNotificationSettings {settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.dispatchNotification()
                    }
                }
            case .denied:
                return
            case .authorized:
                self.dispatchNotification()
            default:
                return
            }
        }
    }
    
    func dispatchNotification() {
        print("Nachricht geplant")
        let identifyer = "my-friday-shoot-reminder"
        let notCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Zeit zum Schießen"
        content.body = "Hast du bereits geschossen? Dann trag jetzt schnell deine Ergebnisse ein!"
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponent = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponent.hour = 18
        dateComponent.minute = 00
        dateComponent.weekday = 6
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request = UNNotificationRequest(identifier: identifyer, content: content, trigger: trigger)
         
        notCenter.removePendingNotificationRequests(withIdentifiers: [identifyer])
        notCenter.add(request)
        
        }
}

#Preview {
    ContentView()
}
