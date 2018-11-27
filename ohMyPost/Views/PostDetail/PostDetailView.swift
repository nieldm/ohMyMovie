import UIKit
import RxSwift
import RxDataSources

class PostDetailView: UIView {

    private let disposeBag = DisposeBag()
    
    lazy var tableView = UITableView(frame: .zero, style: .plain)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tableView.do {
            self.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 240
            $0.backgroundColor = .lightGrayBG
            $0.register(PostDetailDescriptionTableViewCell.self, forCellReuseIdentifier: PostDetailDescriptionTableViewCell.identifier)
            $0.register(PostDetailUserTableViewCell.self, forCellReuseIdentifier: PostDetailUserTableViewCell.identifier)
            $0.register(PostDetailCommentTableViewCell.self, forCellReuseIdentifier: PostDetailCommentTableViewCell.identifier)
            $0.register(PostDetailCommentDetailTableViewCell.self, forCellReuseIdentifier: PostDetailCommentDetailTableViewCell.identifier)
            $0.showsVerticalScrollIndicator = false
            $0.separatorColor = .lightGrayBG
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(withModel model: PostDetailViewModel) {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfPostDetail>(configureCell: { (_, tv: UITableView, ip: IndexPath, item: PostDetailSection) -> UITableViewCell in

            switch item {
            case .resource(let resource):
                guard let cell = tv.dequeueReusableCell(withIdentifier: PostDetailDescriptionTableViewCell.identifier, for: ip) as? PostDetailDescriptionTableViewCell else {
                    return UITableViewCell(frame: .zero)
                }
                return cell.then {
                    $0.set(data: resource)
                }
            case .user(let user):
                guard let cell = tv.dequeueReusableCell(withIdentifier: PostDetailUserTableViewCell.identifier, for: ip) as? PostDetailUserTableViewCell else {
                    return UITableViewCell(frame: .zero)
                }
                return cell.then {
                    $0.set(data: user)
                }
            case .comments(let comments):
                guard let cell = tv.dequeueReusableCell(withIdentifier: PostDetailCommentTableViewCell.identifier, for: ip) as? PostDetailCommentTableViewCell else {
                    return UITableViewCell(frame: .zero)
                }
                return cell.then {
                    $0.set(data: comments)
                }
            case .comment(let comment):
                guard let cell = tv.dequeueReusableCell(withIdentifier: PostDetailCommentDetailTableViewCell.identifier, for: ip) as? PostDetailCommentDetailTableViewCell else {
                    return UITableViewCell(frame: .zero)
                }
                return cell.then {
                    $0.set(data: comment)
                }
            }
        })
        
        model.data
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        model.load()
    }
}
