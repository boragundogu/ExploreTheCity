//
//  LocationTableViewCell.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import UIKit
import SnapKit

final class LocationTableViewCell: UITableViewCell {
    
    static let identifier = "LocationTableViewCell"
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    var onFavoriteToggle: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
        
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(favoriteButton)
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(favoriteButton.snp.leading).offset(-8)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    func configure(with name: String, isFavorited: Bool) {
        nameLabel.text = name
        let iconName = isFavorited ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    @objc private func favoriteTapped() {
        onFavoriteToggle?()
    }
}
