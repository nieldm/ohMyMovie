import Foundation
import RxSwift
import ohMyPostBase
import CoreData

extension PostViewModel: ReactiveCompatible {}

extension Reactive where Base == PostViewModel {
    
    func getPostsFromPersistence() -> Observable<[Resource]> {
        let request = NSFetchRequest<ResourceItem>(entityName: "ResourceItem")
        let items = try? self.base.context.fetch(request).map { $0.toResource() }
        return Observable<[Resource]>.of(items ?? [])
    }
    
    func getPostsFromPersistence(withCategory category: MovieCategory) -> Observable<[Resource]> {
        let request = NSFetchRequest<ResourceItem>(entityName: "ResourceItem")
        request.predicate = NSPredicate(format: "category == %i", category.rawValue)
        let items = try? self.base.context.fetch(request).map { $0.toResource() }
        return Observable<[Resource]>.of(items ?? [])
    }
    
    private func resetAll() -> Single<Void> {
        return Single<Void>.create { observer in
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ResourceItem")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do
            {
                try self.base.context.execute(deleteRequest)
                try self.base.context.save()
                observer(.success(()))
            }
            catch let error
            {
                observer(.error(error))
                print ("There was an error \(error.localizedDescription)")
            }
            return Disposables.create()
        }

    }
    
    private func loadResource() -> Observable<[Resource]> {
        return Observable.create { observer in
            self.base.model.loadResource(callback: { (posts) in
                posts.forEach { let _ = ResourceItem.insertOrUpdate(into: self.base.context, post: $0) }
                observer.onNext(posts)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func forceReload() -> Observable<[Resource]> {
        return self.resetAll()
            .asObservable()
            .flatMap { _ -> Observable<[Resource]> in
                return self.loadResource()
            }
    }
    
    func getPosts() -> Observable<[Resource]> {
        return self.loadResource().flatMap { _ in self.getPostsFromPersistence() }
    }
    
    func getPosts(withCategory category: MovieCategory) -> Observable<[Resource]> {
        return self.loadPost(byCategory: category)
            .flatMap { _ in Observable<Int>.timer(0.5, scheduler: MainScheduler.instance) }
            .flatMap { _ in self.getPostsFromPersistence() }
    }
    
    func getFiltered(withCategory category: MovieCategory) -> Observable<[Resource]> {
        return Observable.create { observer in
            self.base.getFavoritePosts(withCategory: category) { posts in
                observer.onNext(posts)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func getUnread(withCategory category: MovieCategory) -> Observable<[Resource]> {
        return Observable.create { observer in
            self.base.getReadedPosts(withCategory: category) { posts in
                observer.onNext(posts)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func loadPost(byCategory category: MovieCategory) -> Observable<[Resource]> {
        return Observable.create { observer in
            self.base.model.loadResource(byCategory: category.rawValue) { posts in
                posts.forEach { let _ = ResourceItem.insertOrUpdate(into: self.base.context, post: $0) }
                observer.onNext(posts)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func getBySegment(segment: PostSegmentValue, withCategory category: MovieCategory) -> Observable<[Resource]> {
        switch segment {
        case .all: return self.getPostsFromPersistence(withCategory: category)
        case .favorite: return self.getFiltered(withCategory: category)
        case .unread: return self.getUnread(withCategory: category)
        }
    }
    
    func getByCategory(category: MovieCategory) -> Observable<[Resource]> {
        return self.loadPost(byCategory: category)
    }
    
}
