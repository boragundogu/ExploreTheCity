//
//  FavoritesView.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import UIKit
import SnapKit

final class FavoritesView: UIView {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorInset = .zero
        table.showsVerticalScrollIndicator = false
        table.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
        return table
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Henüz hiçbir konumu favorilere eklemedin!"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
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
        addSubview(tableView)
        addSubview(emptyLabel)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    func showEmptyMessage(_ show: Bool) {
        emptyLabel.isHidden = !show
        tableView.isHidden = show
    }
}
