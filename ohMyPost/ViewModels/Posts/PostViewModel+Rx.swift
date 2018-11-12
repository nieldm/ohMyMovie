import Foundation
import RxSwift
import ohMyPostBase

extension PostViewModel: ReactiveCompatible {}

extension Reactive where Base == PostViewModel {
    
    func getPosts() -> Observable<[Post]> {
        return Observable.create { observer in
            self.base.model.loadPosts(callback: { (posts) in
                observer.onNext(posts)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func getFiltered() -> Observable<[Post]> {
        return Observable.create { observer in
            self.base.getFavoritePosts { ids in
                self.base.model.loadPosts(callback: { (posts) in
                    let favoritedPost = posts.filter { ids.contains($0.id) }
                    observer.onNext(favoritedPost)
                    observer.onCompleted()
                })
            }
            return Disposables.create()
        }
    }
    
    func getUnread() -> Observable<[Post]> {
        return Observable.create { observer in
            self.base.getReadedPosts { ids in
                self.base.model.loadPosts(callback: { (posts) in
                    let favoritedPost = posts.filter { !ids.contains($0.id) }
                    observer.onNext(favoritedPost)
                    observer.onCompleted()
                })
            }
            return Disposables.create()
        }
    }
    
    func getBySegment(segment: PostSegmentValue) -> Observable<[Post]> {
        switch segment {
        case .all: return self.getPosts()
        case .favorite: return self.getFiltered()
        case .unread: return self.getUnread()
        }
    }
    
}
