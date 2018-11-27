import UIKit
import Then
import SnapKit
import RxDataSources
import RxSwiftExt
import ohMyPostBase
import RxSwift
import RxCocoa
import CoreData

enum PostSegmentValue: Int {
    case all = 0, favorite, unread
}

enum MovieCategory: Int {
    case popular = 0, topRated, upcoming
}

class PostsViewController: UIViewController {

    private var launching = true
    private let viewModel: PostViewModel
    private let disposeBag = DisposeBag()
    fileprivate let data = BehaviorRelay<[Resource]>(value: [])
    private lazy var segmentController = UISegmentedControl(frame: .zero)
    private lazy var categorySegmentController = UISegmentedControl(frame: .zero)
    private lazy var noResults = UILabel(frame: .zero)
    
    private var actualSegment: PostSegmentValue? {
        return PostSegmentValue(rawValue: self.segmentController.selectedSegmentIndex)
    }
    private var actualCategory: MovieCategory {
        return MovieCategory(rawValue: self.categorySegmentController.selectedSegmentIndex) ?? MovieCategory.popular
    }
    
    fileprivate var tableView: UITableView! {
        didSet {
            self.configureTableView()
        }
    }
    
    init(managedObjectContext: NSManagedObjectContext) {
        let model = ResourceModel(api: Current.postApi())
        self.viewModel = PostViewModel(
            model: model,
            managedObjectContext: managedObjectContext
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies"
        self.view.do {
            $0.backgroundColor = .lightGrayBG
            $0.accessibilityIdentifier = "moviesView"
        }
        
        UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil).do {
            $0.tintColor = .turquoiseBlue
            self.navigationItem.rightBarButtonItem = $0
            $0.rx.tap
                .debounce(0.5, scheduler: MainScheduler.instance)
                .flatMap { self.viewModel.rx.forceReload() }
                .subscribe(onNext: { [weak self] posts in
                    self?.segmentController.selectedSegmentIndex = PostSegmentValue.all.rawValue
                    self?.data.accept(posts)
                    self?.tableView.reloadData()
                })
                .disposed(by: self.disposeBag)
        }
        
        self.categorySegmentController.do {
            self.view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.view.snp.topMargin).offset(16)
                make.left.right.equalToSuperview().inset(8)
            }
            $0.insertSegment(withTitle: "Popular", at: MovieCategory.popular.rawValue, animated: false)
            $0.insertSegment(withTitle: "Top Rated", at: MovieCategory.topRated.rawValue, animated: false)
            $0.insertSegment(withTitle: "Upcoming", at: MovieCategory.upcoming.rawValue, animated: false)
            $0.selectedSegmentIndex = 0
            $0.tintColor = .turquoiseBlue
            $0.rx.controlEvent(UIControlEvents.valueChanged)
                .map { _ in MovieCategory.init(rawValue: self.categorySegmentController.selectedSegmentIndex)! }
                .flatMap { self.viewModel.rx.getByCategory(category: $0) }
                .do(onNext: { [weak self] _ in
                    self?.segmentController.selectedSegmentIndex = PostSegmentValue.all.rawValue
                })
                .bind(to: self.data)
                .disposed(by: self.disposeBag)
        }
        
        self.segmentController.do {
            self.view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.categorySegmentController.snp.bottom).offset(16)
                make.left.right.equalToSuperview().inset(8)
            }
            $0.insertSegment(withTitle: "All", at: PostSegmentValue.all.rawValue, animated: false)
            $0.insertSegment(withTitle: "Favorite", at: PostSegmentValue.favorite.rawValue, animated: false)
            $0.insertSegment(withTitle: "UnWatched", at: PostSegmentValue.unread.rawValue, animated: false)
            $0.selectedSegmentIndex = 0
            $0.tintColor = .turquoiseBlue
            $0.rx.controlEvent(UIControlEvents.valueChanged)
                .map { _ in PostSegmentValue.init(rawValue: self.segmentController.selectedSegmentIndex) }
                .unwrap()
                .flatMap { self.viewModel.rx.getBySegment(segment: $0, withCategory: self.actualCategory) }
                .bind(to: self.data)
                .disposed(by: self.disposeBag)
        }
        
        self.tableView = UITableView(frame: .zero, style: .plain).then {
            self.view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.segmentController.snp.bottom).offset(8)
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            $0.rowHeight = 160
            $0.backgroundColor = .lightGrayBG
            $0.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
            $0.showsVerticalScrollIndicator = false
            $0.separatorColor = .lightGrayBG
            $0.accessibilityIdentifier = "postsTableView"
        }
        
        self.noResults.do {
            self.view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().inset(16)
                make.centerY.equalTo(self.tableView)
            }
            $0.font = UIFont.OMPHeader
            $0.numberOfLines = 3
            $0.text = "Bummer!\nNo post here\n😭"
            $0.textColor = .dusk
            $0.textAlignment = .center
            $0.isHidden = true
            self.data.map { $0.count > 0 }
                .bind(to: $0.rx.isHidden)
                .disposed(by: self.disposeBag)
        }
        

        self.viewModel.rx.getPosts(withCategory: actualCategory)
            .subscribe(onNext: { [weak self] posts in
                self?.data.accept(posts)
            })
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard !launching else {
            launching = false
            return
        }
        super.viewDidAppear(animated)
        self.reloadResource()
        self.tableView.reloadData()
    }
    
    private func configureTableView() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfPosts>(configureCell: { (_, tv: UITableView, ip: IndexPath, item: Resource) -> UITableViewCell in
            guard let cell = tv.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: ip) as? PostTableViewCell else {
                return UITableViewCell(frame: .zero)
            }
            return cell.then {
                $0.set(data: item, context: self.viewModel.context)
            }
        })
        dataSource.canEditRowAtIndexPath = { _, _ in true }
        
        self.data.asObservable()
            .map { [SectionOfPosts(header: "Initial", items: $0)] }
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        let _ = self.tableView.rx.setDelegate(self)
        
        self.tableView.rx.modelDeleted(Resource.self)
            .subscribe { [weak self] event in
                let result = self?.data.value.filter { event.element != $0 } ?? []
                self?.data.accept(result)
            }
            .disposed(by: disposeBag)

        self.tableView.rx.modelSelected(Resource.self)
            .asDriver()
            .drive(onNext: { [weak self] post in
                guard let `self` = self else {
                    return
                }
                let viewController = self.viewModel.getDetailView(for: post)
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func reloadResource() {
        guard let segment = PostSegmentValue(rawValue: self.segmentController.selectedSegmentIndex) else {
            return
        }
        self.viewModel.rx.getBySegment(segment: segment, withCategory: self.actualCategory)
            .subscribe(onNext: { [weak self] posts in
                self?.data.accept(posts)
            })
            .disposed(by: self.disposeBag)
    }
}

extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .destructive, title: "DELETE") { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        }
    
        return [deleteButton]
    }
}
