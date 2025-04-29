//
//  LocationDetailViewController.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import UIKit

final class LocationDetailViewController: UIViewController {

    private let detailView = LocationDetailView()
    private let location: Location

    private var isFavorited: Bool {
        get {
            let saved = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
            return saved.contains(location.id)
        }
    }

    init(location: Location) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
        self.title = location.name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.configure(imageURL: location.image, description: location.description)
        setupFavoriteButton()
        setupMapButton()
    }

    private func setupFavoriteButton() {
        let iconName = isFavorited ? "heart.fill" : "heart"
        let icon = UIImage(systemName: iconName)
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(toggleFavorite))
        button.tintColor = .systemRed
        navigationItem.rightBarButtonItem = button
    }

    @objc private func toggleFavorite() {
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []

        if let index = favorites.firstIndex(of: location.id) {
            favorites.remove(at: index)
        } else {
            favorites.append(location.id)
        }

        UserDefaults.standard.set(favorites, forKey: "favorites")
        setupFavoriteButton()
    }

    private func setupMapButton() {
        detailView.mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
    }

    @objc private func mapButtonTapped() {
        let mapVC = LocationMapViewController(location: location)
        navigationController?.pushViewController(mapVC, animated: true)
    }
}
