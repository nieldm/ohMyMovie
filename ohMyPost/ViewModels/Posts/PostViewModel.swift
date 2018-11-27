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
    
    func getDetailView(for post: Post) -> PostDetailViewController {
        self.markAsRead(post: post)
        let model = PostDetailModel(
            api: Current.postDetailApi(),
            post: post)
        let viewModel = PostDetailViewModel(model: model, context: self.context)
        let viewController = PostDetailViewController(viewModel: viewModel)
        return viewController
    }
    
    func markAsRead(post: Post) {
        PostItem.insertOrUpdate(
            into: self.context,
            post: post.with {
                $0.read = true
            }
        )
    }
    
    func getFavoritePosts(withCategory category: MovieCategory, callback: @escaping ([Post]) -> ()) {
        let request = NSFetchRequest<PostItem>(entityName: "PostItem")
        request.predicate = NSPredicate(format: "favorite == YES AND category == %i", category.rawValue)
        
        let items = try? context.fetch(request).map { $0.toPost() }
        callback(items ?? [])
    }
    
    func getReadedPosts(withCategory category: MovieCategory, callback: @escaping ([Post]) -> ()) {
        let request = NSFetchRequest<PostItem>(entityName: "PostItem")
        request.predicate = NSPredicate(format: "read == NO AND category == %i", category.rawValue)
        
        let items = try? context.fetch(request).map { $0.toPost() }
        callback(items ?? [])
    }
    
}
