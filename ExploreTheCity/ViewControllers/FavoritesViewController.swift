//
//  FavoritesViewController.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    private let favoritesView = FavoritesView()
    private var favoriteLocations: [Location] = []
    
    init(favoriteLocations: [Location]) {
        self.favoriteLocations = favoriteLocations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = favoritesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorilerim"
        setupTableView()
        loadFavoriteLocations()
    }
    
    private func setupTableView() {
        favoritesView.tableView.delegate = self
        favoritesView.tableView.dataSource = self
    }
    
    private func loadFavoriteLocations() {
        if let data = UserDefaults.standard.data(forKey: "favoriteLocations"),
           let decoded = try? JSONDecoder().decode([Location].self, from: data) {
            favoriteLocations = decoded
        } else {
            favoriteLocations = []
        }
        favoritesView.showEmptyMessage(favoriteLocations.isEmpty)
        favoritesView.tableView.reloadData()
    }
    
    private func removeFromFavorites(location: Location) {
        favoriteLocations.removeAll { $0.id == location.id }
        saveFavorites()
        loadFavoriteLocations()
    }
    
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteLocations) {
            UserDefaults.standard.set(data, forKey: "favoriteLocations")
        }
    }
}

// MARK: - UITableView

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let location = favoriteLocations[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: location.name, isFavorited: true)
        cell.accessoryType = .none
        
        cell.onFavoriteToggle = { [weak self] in
            self?.removeFromFavorites(location: location)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = favoriteLocations[indexPath.row]
        let detailVC = LocationDetailViewController(location: location)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
