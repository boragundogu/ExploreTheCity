//
//  LocationMapView.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import UIKit
import MapKit
import SnapKit

final class LocationMapView: UIView {
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = false
        map.isRotateEnabled = false
        map.isPitchEnabled = false
        return map
    }()
    
    lazy var routebutton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Yol Tarifi Al", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var userLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 24
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
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
        addSubview(mapView)
        addSubview(routebutton)
        addSubview(userLocationButton)

        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        routebutton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }

        userLocationButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(routebutton.snp.top).offset(-20)
        }
    }
}
