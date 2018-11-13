import UIKit
import RxSwift

class PostDetailViewController: UIViewController {
 
    private let disposeBag = DisposeBag()
    let viewModel: PostDetailViewModel
    private lazy var favoriteBarButton = UIBarButtonItem(
        image: UIImage(named: "star"),
        style: .plain,
        target: nil,
        action: nil
    )
    
    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = PostDetailView().then {
            $0.render(withModel: self.viewModel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.accessibilityIdentifier = "postDetailView"
        
        self.viewModel.getFavoritedState { [weak self] favorited in
            self?.changeFavoriteBarButton(favorited: favorited)
        }
        
        self.favoriteBarButton.do {
            self.navigationItem.rightBarButtonItem = $0
            $0.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.viewModel.markAsFavorite {
                        self?.changeFavoriteBarButton(favorited: $0)
                    }
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    private func changeFavoriteBarButton(favorited: Bool) {
        var imageName = "star"
        if favorited {
            imageName = "star-selected"
        }
        self.favoriteBarButton.image = UIImage(named: imageName)
    }

}
