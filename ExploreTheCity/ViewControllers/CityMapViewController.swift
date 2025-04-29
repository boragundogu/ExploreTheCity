//
//  CityMapViewController.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import UIKit
import MapKit
import CoreLocation

final class CityMapViewController: UIViewController {

    private let mapView = CityMapView()
    private let city: City
    private var selectedLocationIndex = 0
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocation?
    private var sortedLocations: [Location] = []

    init(city: City) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
        self.title = city.city
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupLocation()
        setupMap()
        mapView.userLocationButton.addTarget(self, action: #selector(focusOnUserLocation), for: .touchUpInside)
    }

    private func setupCollectionView() {
        mapView.collectionView.delegate = self
        mapView.collectionView.dataSource = self
        mapView.collectionView.register(CityMapLocationCell.self, forCellWithReuseIdentifier: CityMapLocationCell.identifier)
    }

    private func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func setupMap() {
        sortedLocations = city.locations ?? []

        // Bonus: Mesafeye göre sıralama
        if let userLoc = userLocation {
            sortedLocations.sort {
                let dist1 = CLLocation(latitude: $0.coordinates.lat, longitude: $0.coordinates.lng).distance(from: userLoc)
                let dist2 = CLLocation(latitude: $1.coordinates.lat, longitude: $1.coordinates.lng).distance(from: userLoc)
                return dist1 < dist2
            }
        }

        mapView.mapView.delegate = self
        mapView.mapView.removeAnnotations(mapView.mapView.annotations)

        for (index, location) in sortedLocations.enumerated() {
            let coord = location.coordinates
            let annotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lng), index: index)
            mapView.mapView.addAnnotation(annotation)
        }

        focusOnLocation(index: selectedLocationIndex)
    }

    private func focusOnLocation(index: Int) {
        guard sortedLocations.indices.contains(index) else { return }
        let location = sortedLocations[index]
        let coord = location.coordinates
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lng), latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.mapView.setRegion(region, animated: true)
    }

    @objc private func focusOnUserLocation() {
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if let userLoc = mapView.mapView.userLocation.location?.coordinate {
                let region = MKCoordinateRegion(center: userLoc, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.mapView.setRegion(region, animated: true)
            }
        } else if status == .notDetermined {
            requestLocationPermission()
        } else {
            showSettingsAlert()
        }
    }

    private func requestLocationPermission() {
        let alert = UIAlertController(title: "Konum İzni", message: "Kendi konumunu haritada görmek ister misin?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Evet", style: .default) { _ in
            self.locationManager.requestWhenInUseAuthorization()
        })
        alert.addAction(UIAlertAction(title: "Hayır", style: .cancel))
        present(alert, animated: true)
    }

    private func showSettingsAlert() {
        let alert = UIAlertController(title: "Konum İzni Gerekli", message: "Lütfen ayarlardan konum izni ver.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ayarlar", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate

extension CityMapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.mapView.showsUserLocation = true
            if let location = manager.location {
                userLocation = location
            }
        case .denied:
            showSettingsAlert()
        case .notDetermined:
            break
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension CityMapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedLocations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityMapLocationCell.identifier, for: indexPath) as? CityMapLocationCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: sortedLocations[indexPath.item])
        cell.detailButton.tag = indexPath.item
        cell.detailButton.addTarget(self, action: #selector(detailButtonTapped(_:)), for: .touchUpInside)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedLocationIndex = indexPath.item
        focusOnLocation(index: selectedLocationIndex)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: collectionView.frame.height - 16)
    }

    @objc private func detailButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard sortedLocations.indices.contains(index) else { return }
        let location = sortedLocations[index]
        let detailVC = LocationDetailViewController(location: location)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension CityMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "LocationAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }

        annotationView?.annotation = annotation
        annotationView?.markerTintColor = (annotation as? CustomAnnotation)?.index == selectedLocationIndex ? .systemYellow : .systemBlue
        annotationView?.glyphImage = UIImage(systemName: "star.fill")
        annotationView?.canShowCallout = true

        return annotationView
    }
}

final class CustomAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let index: Int

    init(coordinate: CLLocationCoordinate2D, index: Int) {
        self.coordinate = coordinate
        self.index = index
    }
}
