import Foundation
import CoreData
import ohMyPostBase

final class ResourceItem: NSManagedObject, Managed {
    @NSManaged fileprivate(set) var category: Int16
    @NSManaged fileprivate(set) var postId: Int64
    @NSManaged fileprivate(set) var favorite: Bool
    @NSManaged fileprivate(set) var read: Bool
    @NSManaged fileprivate(set) var title: String
    @NSManaged fileprivate(set) var body: String
    @NSManaged fileprivate(set) var imageUrl: String?
    @NSManaged fileprivate(set) var image: Data?
    
    static func insert(into context: NSManagedObjectContext, post: Resource) -> ResourceItem {
        let postItem: ResourceItem = context.insertObject()
        postItem.update(withPost: post)
        postItem.read = post.read
        postItem.favorite = post.favorited
        return postItem
    }
    
    private func update(withPost post: Resource) {
        self.postId = Int64(post.id)
        self.title = post.title
        self.body = post.body
        self.imageUrl = post.image
        self.read = self.read ? true : post.read
        self.favorite = self.favorite ? true : post.favorited
        self.category = Int16(post.category)
    }
    
    static func insertOrUpdate(into context: NSManagedObjectContext, post: Resource, callback: ((ResourceItem) -> ())? = nil) {
        let request = NSFetchRequest<ResourceItem>(entityName: "ResourceItem")
        request.predicate = NSPredicate(format: "postId == %i AND category == %i", post.id, post.category)
        
        let items = try? context.fetch(request)
        if let item = items?.first {
            context.performChanges {
                item.update(withPost: post)
                callback?(item)
            }
            return
        }
        context.performChanges {
            let item = ResourceItem.insert(into: context, post: post)
            callback?(item)
        }
    }
    
    func setAsRead() {
        self.read = true
    }
    
    func toogleFavorite() {
        self.favorite.toggle()
    }
    
    func toResource() -> Resource {
        return Resource(
            id: Int(self.postId),
            userId: 0,
            title: self.title,
            body: self.body,
            category: Int(self.category),
            image: self.imageUrl
        )
    }
}
