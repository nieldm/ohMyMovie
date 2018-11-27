import Foundation
import ohMyPostBase
import CoreData

class PostViewModel {
    
    let context: NSManagedObjectContext
    let model: ResourceModel
    
    init(model: ResourceModel, managedObjectContext: NSManagedObjectContext) {
        self.model = model
        self.context = managedObjectContext
    }
    
    func getDetailView(for post: Resource) -> PostDetailViewController {
        self.markAsRead(post: post)
        let model = ResourceDetailModel(
            api: Current.postDetailApi(),
            resource: post)
        let viewModel = PostDetailViewModel(model: model, context: self.context)
        let viewController = PostDetailViewController(viewModel: viewModel)
        return viewController
    }
    
    func markAsRead(post: Resource) {
        ResourceItem.insertOrUpdate(
            into: self.context,
            post: post.with {
                $0.read = true
            }
        )
    }
    
    func getFavoritePosts(withCategory category: MovieCategory, callback: @escaping ([Resource]) -> ()) {
        let request = NSFetchRequest<ResourceItem>(entityName: "ResourceItem")
        request.predicate = NSPredicate(format: "favorite == YES AND category == %i", category.rawValue)
        
        let items = try? context.fetch(request).map { $0.toResource() }
        callback(items ?? [])
    }
    
    func getReadedPosts(withCategory category: MovieCategory, callback: @escaping ([Resource]) -> ()) {
        let request = NSFetchRequest<ResourceItem>(entityName: "ResourceItem")
        request.predicate = NSPredicate(format: "read == NO AND category == %i", category.rawValue)
        
        let items = try? context.fetch(request).map { $0.toResource() }
        callback(items ?? [])
    }
    
}
