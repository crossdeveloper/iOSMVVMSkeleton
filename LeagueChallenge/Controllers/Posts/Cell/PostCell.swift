import UIKit
import RxSwift

class PostCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    let profileImgView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        view.layer.borderWidth = 1
        view.cornerRadius = 18
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        view.textColor = .darkGray
        view.numberOfLines = 1
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17)
        view.textColor = .darkGray
        view.numberOfLines = 1
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.textColor = .gray
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItem(_ item: PostCellVM) {
        if let urlStr = item.profileImage, let url = URL(string: urlStr) {
            profileImgView.af.setImage(withURL: url, placeholderImage: UIImage(named: "avatar_turned"))
        }else{
            profileImgView.image = UIImage(named: "avatar_turned")
        }
        
        nameLabel.text = item.username ?? "Unknown"
        titleLabel.text = item.title
        contentLabel.text = item.content
    }
}

private extension PostCell {
    private func setupUI() {
        self.contentView.addSubviews(profileImgView, nameLabel, titleLabel, contentLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        profileImgView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(5)
            $0.width.height.equalTo(36)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImgView)
            $0.leading.equalTo(profileImgView.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(profileImgView.snp.leading)
            $0.trailing.equalTo(nameLabel.snp.trailing)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(profileImgView.snp.leading)
            $0.bottom.equalToSuperview().offset(-10.0)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
    }
}
