//
//  LocationDetailView.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class LocationDetailView: UIView {

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        return scroll
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center  // 💥 artık ortalanıyor
        label.lineBreakMode = .byWordWrapping
        label.textColor = .darkGray
        return label
    }()

    lazy var mapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Haritada Göster", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(mapButton)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView) // Dikey scroll için şart
        }

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(self.snp.height).multipliedBy(0.45) // 🔁 daha büyük ama taşmaz
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        mapButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(200)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    func configure(imageURL: String?, description: String?) {
        if let imageURL = imageURL, let url = URL(string: imageURL) {
            imageView.sd_setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }

        descriptionLabel.text = description ?? "Açıklama Yok."
    }
}
