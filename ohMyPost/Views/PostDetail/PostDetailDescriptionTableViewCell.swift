import UIKit
import ohMyPostBase
import AlamofireImage

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
            $0.font = .OMPMegaHeader
            $0.textColor = .dusk
        }
        
        self.imageContainer.do {
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
                make.centerX.equalToSuperview()
                make.height.equalTo(280)
                make.width.equalTo(self.imageContainer.snp.height).multipliedBy(0.7)
            }
            $0.contentMode = .scaleAspectFill
            $0.layer.addBorderAndShadow()
            $0.clipsToBounds = true
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
        if let imageUrl = data.image,
            let url = URL(string: imageUrl) {
            self.imageContainer.af_setImage(
                withURL: url,
                placeholderImage: UIImage.from(color: .turquoiseBlue),
                filter: nil,
                progress: nil,
                progressQueue: DispatchQueue.global(qos: .userInitiated),
                imageTransition: UIImageView.ImageTransition.crossDissolve(0.3),
                runImageTransitionIfCached: true) { (response) in
                    switch response.result {
                    case .failure(let error):
                        self.imageContainer.image = UIImage.from(color: UIColor.dusk36)
                        Current.log("\(error.localizedDescription)")
                    default: ()
                    }
            }
        } else {
            self.imageContainer.snp.remakeConstraints { make in
                make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
                make.height.equalTo(0)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
}
