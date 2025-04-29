//
//  CityMapLocationCell.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class CityMapLocationCell: UICollectionViewCell {

    static let identifier = "CityMapLocationCell"

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    lazy var detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Detaya Git", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(detailButton)

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(80)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        detailButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(32)
            make.bottom.equalToSuperview().inset(8)
        }
    }

    func configure(with location: Location) {
        nameLabel.text = location.name

        if let imageURL = location.image, let url = URL(string: imageURL) {
            imageView.sd_setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }
}
