import UIKit
import ohMyPostBase
import CoreData

class PostTableViewCell: UITableViewCell {
    static let identifier = "PostCollectionViewCell"
    
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var iconImageView: UIImageView!
    private lazy var favoriteImageView = UIImageView(frame: CGRect.zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .lightGrayBG
        
        self.contentView.do {
            $0.backgroundColor = .white
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(8)
            }
            $0.layer.addBorderAndShadow()
        }
        
        self.iconImageView = UIImageView(frame: CGRect.zero).then {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.size.equalTo(8)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(16)
            }
            $0.image = UIImage(named: "unread")
            $0.isHidden = true
        }
        
        self.favoriteImageView.do {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.size.equalTo(24)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(16)
            }
            $0.image = UIImage(named: "star-selected")
            $0.isHidden = false
        }
        
        self.titleLabel = UILabel(frame: CGRect.zero).then {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.bottom.equalTo(self.contentView.snp.centerY)
                make.left.equalTo(self.iconImageView.snp.right).offset(16)
                make.right.equalTo(self.favoriteImageView.snp.left).offset(-8)
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
                make.left.equalTo(self.iconImageView.snp.right).offset(16)
                make.right.equalTo(self.favoriteImageView.snp.left).offset(-8)
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.iconImageView.isHidden = true
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
