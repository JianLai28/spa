import SwiftUI
import CoreData

@main
struct AccountManagerApp: App {
    let persistenceController = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct CoreDataStack {
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "AccountData")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}