import UIKit
import ohMyPostBase
import CoreData

class PostTableViewCell: UITableViewCell {
    static let identifier = "PostCollectionViewCell"
    
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var iconImageView: UIImageView!
    private lazy var favoriteImageView = UIImageView(frame: CGRect.zero)
    private lazy var postImageView = UIImageView(frame: CGRect.zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .lightGrayBG
        
        self.contentView.do {
            $0.backgroundColor = .white
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(ViewOffset.small.rawValue)
            }
            $0.layer.addBorderAndShadow()
            $0.clipsToBounds = true
        }
        
        self.postImageView.do {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.top.bottom.equalToSuperview()
                make.height.equalTo(self.postImageView.snp.width)
            }
            $0.backgroundColor = UIColor.turquoiseBlue
            $0.layer.addBorder()
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        self.iconImageView = UIImageView(frame: CGRect.zero).then {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.size.equalTo(ViewOffset.small.rawValue)
                make.left.equalToSuperview().offset(ViewOffset.small.rawValue)
                make.centerY.equalToSuperview()
            }
            $0.image = UIImage(named: "unread")
            $0.isHidden = true
        }
        
        self.favoriteImageView.do {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.size.equalTo(ViewOffset.big.rawValue)
                make.top.equalToSuperview().offset(ViewOffset.small.rawValue)
                make.right.equalToSuperview().inset(ViewOffset.small.rawValue)
            }
            $0.image = UIImage(named: "star-selected")
            $0.isHidden = false
        }
        
        self.titleLabel = UILabel(frame: CGRect.zero).then {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(ViewOffset.small.rawValue)
                make.bottom.equalTo(self.contentView.snp.centerY)
                make.left.equalTo(self.iconImageView.snp.right).offset(ViewOffset.small.rawValue)
                make.right.equalTo(self.postImageView.snp.left).offset(-ViewOffset.small.rawValue)
            }
            $0.numberOfLines = 1
            $0.text = "Title"
            $0.font = UIFont.OMPTitle
            $0.textColor = UIColor.dusk
        }
        
        self.subTitleLabel = UILabel(frame: CGRect.zero).then {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.contentView.snp.centerY)
                make.left.equalTo(self.titleLabel.snp.left)
                make.right.equalTo(self.postImageView.snp.left).offset(-ViewOffset.small.rawValue)
            }
            $0.numberOfLines = 2
            $0.text = "SubTitle"
            $0.font = UIFont.OMPSubTitle
            $0.textColor = UIColor.wisteria
        }

    }
    
    func set(data: Post, context: NSManagedObjectContext) {
        self.titleLabel.text = data.title.capitalized
        self.subTitleLabel.text = data.body
        
        if let imageUrl = data.image,
            let url = URL(string: imageUrl) {
            self.postImageView.af_setImage(
                withURL: url,
                placeholderImage: UIImage.from(color: .turquoiseBlue),
                filter: nil,
                progress: nil,
                progressQueue: DispatchQueue.global(qos: .userInitiated),
                imageTransition: UIImageView.ImageTransition.crossDissolve(0.3),
                runImageTransitionIfCached: false) { (response) in
                    switch response.result {
                    case .failure(let error):
                        self.postImageView.image = UIImage.from(color: UIColor.turquoiseBlue)
                        print("🖼 \(error.localizedDescription)")
                    default: ()
                    }
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let request = NSFetchRequest<PostItem>(entityName: "PostItem")
            request.predicate = NSPredicate(format: "postId == %i", data.id)
            
            let items = try? context.fetch(request)
            if let item = items?.first {
                DispatchQueue.main.async {
                    self.iconImageView.isHidden = item.read
                    self.favoriteImageView.isHidden = !item.favorite
                }
                return
            } else {
                DispatchQueue.main.async {
                    self.iconImageView.isHidden = false
                    self.favoriteImageView.isHidden = true
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.postImageView.image = UIImage.from(color: .turquoiseBlue)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.iconImageView.isHidden = true
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
