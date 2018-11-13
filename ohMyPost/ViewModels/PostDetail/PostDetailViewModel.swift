import Foundation
import ohMyPostBase
import RxSwift
import RxCocoa
import CoreData

class PostDetailViewModel {
    
    let context: NSManagedObjectContext
    private let disposeBag = DisposeBag()
    
    let model: PostDetailModel
    let data: BehaviorRelay<[SectionOfPostDetail]>
    
    init(model: PostDetailModel, context: NSManagedObjectContext) {
        self.model = model
        self.context = context
        let postSection = SectionOfPostDetail(
            header: "Description",
            items: [PostDetailSection.post(model.post)]
        )
        self.data = BehaviorRelay<[SectionOfPostDetail]>(value: [postSection])
    }
    
    func load() {
        self.rx.getUser()
            .catchError({ (_) -> Observable<User> in
                return Observable<User>.never()
            })
            .map { SectionOfPostDetail(header: "User", items: [PostDetailSection.user($0)]) }
            .map { section in
                var sections = self.data.value
                sections.append(section)
                return sections
            }
            .sorted()
            .bind(to: self.data)
            .disposed(by: self.disposeBag)
        
        self.rx.getComments()
            .catchError({ (_) -> Observable<[Comment]> in
                return Observable<[Comment]>.never()
            })
            .map { comments -> [SectionOfPostDetail] in
                var commentSections = comments.map({ (comment) -> SectionOfPostDetail in
                    return SectionOfPostDetail(header: "Comment\(comment.id)", items: [PostDetailSection.comment(comment)])
                })
                let headerSection = SectionOfPostDetail(header: "Comments", items: [PostDetailSection.comments(comments)])
                commentSections.insert(headerSection, at: 0)
                return commentSections
            }
            .map { commentSections in
                let sections = self.data.value + commentSections
                return sections
            }
            .sorted()
            .bind(to: self.data)
            .disposed(by: self.disposeBag)
    }
    
    func markAsFavorite(callback: @escaping (Bool) -> ()) {
        let request = NSFetchRequest<PostItem>(entityName: "PostItem")
        request.predicate = NSPredicate(format: "postId == %i", model.post.id)
        
        let items = try? context.fetch(request)
        if let item = items?.first {
            self.context.performChanges {
                item.toogleFavorite()
                callback(item.favorite)
            }
            return
        }
        self.context.performChanges {
            let _ = PostItem.insert(
                into: self.context,
                post: self.model.post.with {
                    $0.favorited = true
                }
            )
        }
        callback(true)
    }
    
    func getFavoritedState(callback: @escaping (Bool) -> ()) {
        let request = NSFetchRequest<PostItem>(entityName: "PostItem")
        request.predicate = NSPredicate(format: "postId == %i", model.post.id)
        
        let items = try? context.fetch(request)
        if let item = items?.first {
            callback(item.favorite)
        }
    }
}

fileprivate extension Observable where Element == Array<SectionOfPostDetail> {
    
    func sorted() -> Observable<Element> {
        return self.map { sections in
            return sections.sorted(by: { (lhs: SectionOfPostDetail, rhs: SectionOfPostDetail) -> Bool in
                return lhs.items.first?.position ?? 0 < rhs.items.first?.position ?? 0
            })
        }
    }
    
}
