import UIKit
import ohMyPostBase

class PostDetailDescriptionTableViewCell: UITableViewCell {
    static let identifier = "PostDetailDescriptionTableViewCell"
    
    lazy var titleLabel = UILabel(frame: .zero)
    lazy var bodyLabel = UILabel(frame: .zero)
    lazy var imageContainer = UIImageView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.titleLabel.do {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.equalToSuperview().offset(16)
                make.right.equalToSuperview().inset(16)
            }
            $0.numberOfLines = 0
            $0.text = "Title"
            $0.font = .OMPHeader
            $0.textColor = .dusk
        }
        
        self.imageContainer.do {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().inset(16)
                make.height.equalTo(120)
            }
            $0.backgroundColor = UIColor.turquoiseBlue
            $0.layer.addBorderAndShadow()
        }
        
        self.bodyLabel.do {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.right.bottom.equalToSuperview().inset(16)
                make.top.equalTo(self.imageContainer.snp.bottom).offset(16)
            }
            $0.numberOfLines = 0
            $0.text = "SubTitle"
            $0.font = UIFont.OMPDescription
            $0.textColor = UIColor.wisteria
        }
    }
    
    func set(data: Post) {
        self.titleLabel.text = data.title.capitalized
        self.bodyLabel.text = data.body
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
}
