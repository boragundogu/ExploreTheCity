//
//  MainView.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import UIKit
import SnapKit

final class MainView: UIView {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Önemli Konumlar"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()

    lazy var favoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorInset = .zero
        table.showsVerticalScrollIndicator = false
        table.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
        table.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
        return table
    }()

    lazy var collapseAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.down.right.and.arrow.up.left"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 28
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
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
        addSubview(titleLabel)
        addSubview(favoritesButton)
        addSubview(tableView)
        addSubview(collapseAllButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().inset(16)
        }

        favoritesButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(28)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }

        collapseAllButton.snp.makeConstraints { make in
            make.width.height.equalTo(56)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
}
