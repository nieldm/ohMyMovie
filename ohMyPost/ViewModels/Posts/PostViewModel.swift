import Foundation
import ohMyPostBase
import CoreData

class PostViewModel {
    
    let context: NSManagedObjectContext
    let model: PostModel
    
    init(model: PostModel, managedObjectContext: NSManagedObjectContext) {
        self.model = model
        self.context = managedObjectContext
    }
    
    func markAsRead(post: Post) {
        let request = NSFetchRequest<PostItem>(entityName: "PostItem")
        request.predicate = NSPredicate(format: "postId == %i", post.id)

        let items = try? context.fetch(request)
        if let item = items?.first {
            self.context.performChanges {
                item.setAsRead()
            }
            return
        }
        self.context.performChanges {
            let _ = PostItem.insert(into: self.context, post: post)
        }
    }
    
    func getFavoritePosts(callback: @escaping ([Int]) -> ()) {
        let request = NSFetchRequest<PostItem>(entityName: "PostItem")
        request.predicate = NSPredicate(format: "favorite == YES")
        
        let items = try? context.fetch(request)
        let ids = items?.map { Int($0.postId) } ?? []
        callback(ids)
    }
    
    func getReadedPosts(callback: @escaping ([Int]) -> ()) {
        let request = NSFetchRequest<PostItem>(entityName: "PostItem")
        request.predicate = NSPredicate(format: "read == YES")
        
        let items = try? context.fetch(request)
        let ids = items?.map { Int($0.postId) } ?? []
        callback(ids)
    }
    
}
