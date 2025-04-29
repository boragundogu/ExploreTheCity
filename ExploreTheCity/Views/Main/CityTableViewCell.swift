//
//  CityTableViewCell.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import UIKit
import SnapKit

final class CityTableViewCell: UITableViewCell {

    static let identifier = "CityTableViewCell"

    var onMapButtonTapped: (() -> Void)?

    private lazy var expandIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private lazy var mapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(expandIcon)
        contentView.addSubview(cityLabel)
        contentView.addSubview(mapButton)

        expandIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(18)
            make.centerY.equalToSuperview()
        }

        cityLabel.snp.makeConstraints { make in
            make.leading.equalTo(expandIcon.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(mapButton.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }

        mapButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
    }

    func configure(with cityName: String, hasLocations: Bool, isExpanded: Bool) {
        cityLabel.text = cityName

        if hasLocations {
            let iconName = isExpanded ? "minus.circle" : "plus.circle"
            expandIcon.image = UIImage(systemName: iconName)
            expandIcon.isHidden = false
            mapButton.isHidden = false
        } else {
            expandIcon.isHidden = true
            mapButton.isHidden = true
        }
    }

    @objc private func mapButtonTapped() {
        onMapButtonTapped?()
    }
}
