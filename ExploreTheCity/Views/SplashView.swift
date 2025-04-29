//
//  SplashView.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import UIKit
import SnapKit

final class SplashView: UIView {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ExploreTheCity"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textColor = .black
        return label
    }()

    lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Yükleniyor..."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        label.isHidden = true
        return label
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemBlue
        indicator.isHidden = true
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(activityIndicator)
        addSubview(loadingLabel)

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }

        loadingLabel.snp.makeConstraints { make in
            make.top.equalTo(activityIndicator.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }

    func showLoadingState() {
        loadingLabel.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
}
