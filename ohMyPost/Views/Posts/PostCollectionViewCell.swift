import UIKit
import ohMyPostBase

class PostCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCollectionViewCell"
    
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var iconImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.do {
            $0.backgroundColor = .white
        }
        
        self.iconImageView = UIImageView(frame: CGRect.zero).then {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.size.equalTo(32)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(16)
            }
            $0.backgroundColor = .blue
        }
        
        self.titleLabel = UILabel(frame: CGRect.zero).then {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.bottom.equalTo(self.contentView.snp.centerY)
                make.left.equalTo(self.iconImageView.snp.right).offset(4)
                make.right.equalToSuperview()
            }
            $0.text = "Title"
            $0.font = UIFont.OMPTitle
            $0.textColor = UIColor.dusk
        }
        
        self.subTitleLabel = UILabel(frame: CGRect.zero).then {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.contentView.snp.centerY)
                make.left.equalTo(self.iconImageView.snp.right).offset(4)
                make.right.equalToSuperview()
            }
            $0.text = "SubTitle"
            $0.font = UIFont.OMPSubTitle
            $0.textColor = UIColor.wisteria
        }
    }
    
    func set(data: Post) {
        self.titleLabel.text = data.title
        self.subTitleLabel.text = data.body
        self.iconImageView.isHidden = !data.unread()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
