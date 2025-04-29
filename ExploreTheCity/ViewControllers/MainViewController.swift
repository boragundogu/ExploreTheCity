//
//  MainViewController.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let mainView = MainView()
    
    private var cities: [City] = []
    private var currentPage = 1
    private var totalPage = 1
    private var isLoading = false
    
    private var expandedIndexes: Set<Int> = []
    private var favoriteLocations: [Location] = []
    
    private var instertedSections: [Int] = []
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupButtons()
        loadFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
        mainView.tableView.reloadData()
    }
    
    func setData(firstPage: CityResponse) {
        self.cities = firstPage.data
        self.currentPage = firstPage.currentPage
        self.totalPage = firstPage.totalPage
    }
    
    private func setupTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    private func setupButtons() {
        mainView.favoritesButton.addTarget(self, action: #selector(favoritesTapped), for: .touchUpInside)
        mainView.collapseAllButton.addTarget(self, action: #selector(collapseAllTapped), for: .touchUpInside)
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favoriteLocations"),
           let decoded = try? JSONDecoder().decode([Location].self, from: data) {
            favoriteLocations = decoded
        } else {
            favoriteLocations = []
        }
    }

    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteLocations) {
            UserDefaults.standard.set(data, forKey: "favoriteLocations")
        }
    }
    
    @objc private func favoritesTapped() {
        let favoritesVC = FavoritesViewController(favoriteLocations: favoriteLocations)
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
    @objc private func collapseAllTapped() {
        expandedIndexes.removeAll()
        mainView.tableView.reloadData()
    }
    
    private func fetchCities(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        
        NetworkService.shared.fetchCities(page: page) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    self.totalPage = response.totalPage
                    let newSectionStart = self.cities.count
                    self.cities.append(contentsOf: response.data)
                    
                    let sectionIndexes = (newSectionStart..<self.cities.count).map { $0 }
                    self.instertedSections = sectionIndexes
                    
                    self.mainView.tableView.reloadData()
                    
                case .failure(let error):
                    print("Veri alınamadı: \(error)")
                }
            }
        }
    }
}

// MARK: - UITableView Delegate & DataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandedIndexes.contains(section) {
            return 1 + (cities[section].locations?.count ?? 0)
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let city = cities[indexPath.section]
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as? CityTableViewCell else {
                return UITableViewCell()
            }

            if instertedSections.contains(indexPath.section) {
                cell.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    cell.alpha = 1
                }
            }

            if indexPath.section == cities.count - 1 && indexPath.row == 0 {
                instertedSections.removeAll()
            }

            let hasLocations = !(city.locations ?? []).isEmpty
            let isExpanded = expandedIndexes.contains(indexPath.section)

            cell.configure(with: city.city, hasLocations: hasLocations, isExpanded: isExpanded)

            cell.onMapButtonTapped = { [weak self] in
                guard let self else { return }
                let cityMapVC = CityMapViewController(city: city)
                self.navigationController?.pushViewController(cityMapVC, animated: true)
            }

            return cell
        } else {
            guard let location = city.locations?[indexPath.row - 1],
                  let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as? LocationTableViewCell else {
                return UITableViewCell()
            }
            
            let isFavorited = favoriteLocations.contains(where: { $0.id == location.id })
            cell.configure(with: location.name, isFavorited: isFavorited)

            cell.onFavoriteToggle = { [weak self] in
                guard let self else { return }

                if let index = self.favoriteLocations.firstIndex(where: { $0.id == location.id }) {
                    self.favoriteLocations.remove(at: index)
                } else {
                    self.favoriteLocations.append(location)
                }

                self.saveFavorites()
                tableView.reloadRows(at: [indexPath], with: .fade)
            }

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.section]
        
        if indexPath.row == 0 {
            if !(city.locations ?? []).isEmpty {
                if expandedIndexes.contains(indexPath.section) {
                    expandedIndexes.remove(indexPath.section)
                } else {
                    expandedIndexes.insert(indexPath.section)
                }
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            }
            
        } else {
            guard let location = city.locations?[indexPath.row - 1] else { return }
            let detailVC = LocationDetailViewController(location: location)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        let threshold: CGFloat = 100
        let distanceToBottom = contentHeight - offsetY - height
        
        if distanceToBottom < threshold && !isLoading && currentPage < totalPage {
            currentPage += 1
            fetchCities(page: currentPage)
        }
    }
}
