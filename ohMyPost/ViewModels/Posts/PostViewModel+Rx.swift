import Foundation
import RxSwift
import ohMyPostBase
import CoreData

extension PostViewModel: ReactiveCompatible {}

extension Reactive where Base == PostViewModel {
    
    func getPostsFromPersistence() -> Observable<[Post]> {
        let request = NSFetchRequest<PostItem>(entityName: "PostItem")
        let items = try? self.base.context.fetch(request).map { $0.toPost() }
        return Observable<[Post]>.of(items ?? [])
    }
    
    func getPostsFromPersistence(withCategory category: MovieCategory) -> Observable<[Post]> {
        let request = NSFetchRequest<PostItem>(entityName: "PostItem")
        request.predicate = NSPredicate(format: "category == %i", category.rawValue)
        let items = try? self.base.context.fetch(request).map { $0.toPost() }
        return Observable<[Post]>.of(items ?? [])
    }
    
    private func resetAll() -> Single<Void> {
        return Single<Void>.create { observer in
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PostItem")
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
    
    private func loadPosts() -> Observable<[Post]> {
        return Observable.create { observer in
            self.base.model.loadPosts(callback: { (posts) in
                posts.forEach { let _ = PostItem.insertOrUpdate(into: self.base.context, post: $0) }
                observer.onNext(posts)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func forceReload() -> Observable<[Post]> {
        return self.resetAll()
            .asObservable()
            .flatMap { _ -> Observable<[Post]> in
                return self.loadPosts()
            }
    }
    
    func getPosts() -> Observable<[Post]> {
        return self.loadPosts().flatMap { _ in self.getPostsFromPersistence() }
    }
    
    func getFiltered(withCategory category: MovieCategory) -> Observable<[Post]> {
        return Observable.create { observer in
            self.base.getFavoritePosts(withCategory: category) { posts in
                observer.onNext(posts)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func getUnread(withCategory category: MovieCategory) -> Observable<[Post]> {
        return Observable.create { observer in
            self.base.getReadedPosts(withCategory: category) { posts in
                observer.onNext(posts)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func getPost(byCategory category: MovieCategory) -> Observable<[Post]> {
        return Observable.create { observer in
            self.base.model.loadPosts(byCategory: category.rawValue) { posts in
                posts.forEach { let _ = PostItem.insertOrUpdate(into: self.base.context, post: $0) }
                observer.onNext(posts)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func getBySegment(segment: PostSegmentValue, withCategory category: MovieCategory) -> Observable<[Post]> {
        switch segment {
        case .all: return self.getPostsFromPersistence(withCategory: category)
        case .favorite: return self.getFiltered(withCategory: category)
        case .unread: return self.getUnread(withCategory: category)
        }
    }
    
    func getByCategory(category: MovieCategory) -> Observable<[Post]> {
        return self.getPost(byCategory: category)
    }
    
}
