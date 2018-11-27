import Foundation
import CoreData

func createContainer(completion: @escaping (NSPersistentContainer) -> ()) {
    let container = NSPersistentContainer(name: "Posts")
    container.loadPersistentStores { _, error in
        if let error = error {
            fatalError(error.localizedDescription)
        } else {
            DispatchQueue.main.async {
                completion(container)
            }
        }
    }
}
