import UIKit
import JellyGif
import SnapKit

final class MainCell: UICollectionViewCell {
    
    static let id = "gif"
    
    // MARK: JellyGifImageView
    let imageView: JellyGifImageView = {
        let imageView = JellyGifImageView(image: UIImage())
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(contentView)
        contentView.addSubview(imageView)
    }
    
    func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
