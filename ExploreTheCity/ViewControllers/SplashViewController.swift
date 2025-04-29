//
//  ViewController.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import UIKit

final class SplashViewController: UIViewController {

    private let splashView = SplashView()

    override func loadView() {
        self.view = splashView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.splashView.showLoadingState()
            self.fetchInitialCities()
        }
    }

    private func fetchInitialCities() {
        NetworkService.shared.fetchCities(page: 1) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success(let response):
                    let mainVC = MainViewController()
                    mainVC.setData(firstPage: response)
                    self.navigationController?.setViewControllers([mainVC], animated: true)

                case .failure:
                    self.showErrorAlert()
                }
            }
        }
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Hata",
            message: "Şehir verileri alınamadı. Lütfen internet bağlantınızı kontrol edin.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Tekrar Dene", style: .default) { [weak self] _ in
            self?.splashView.showLoadingState()
            self?.fetchInitialCities()
        })

        present(alert, animated: true)
    }
}
