//
//  LocationMapViewController.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import UIKit
import MapKit
import CoreLocation

final class LocationMapViewController: UIViewController {

    private let mapView = LocationMapView()
    private let location: Location
    private let locationManager = CLLocationManager()
    private var userLocationShown = false

    init(location: Location) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
        self.title = location.name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        setupMap()
        setupButtons()
    }

    private func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func setupMap() {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinates.lat,
                                                 longitude: location.coordinates.lng)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.name
        mapView.mapView.addAnnotation(annotation)
    }

    private func setupButtons() {
        mapView.routebutton.addTarget(self, action: #selector(openInMaps), for: .touchUpInside)
        mapView.userLocationButton.addTarget(self, action: #selector(focusOnUserLocation), for: .touchUpInside)
    }

    @objc private func openInMaps() {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinates.lat,
                                                longitude: location.coordinates.lng)

        let alert = UIAlertController(title: "Yol Tarifi Al", message: "Harita uygulaması seç", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Apple Maps", style: .default) { _ in
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            destination.name = self.location.name
            destination.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        })

        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            alert.addAction(UIAlertAction(title: "Google Maps", style: .default) { _ in
                let urlString = "comgooglemaps://?daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving"
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            })
        }

        if UIApplication.shared.canOpenURL(URL(string: "yandexnavi://")!) {
            alert.addAction(UIAlertAction(title: "Yandex Maps", style: .default) { _ in
                let urlString = "yandexnavi://build_route_on_map?lat_to=\(coordinate.latitude)&lon_to=\(coordinate.longitude)"
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            })
        }

        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func focusOnUserLocation() {
        let status = locationManager.authorizationStatus

        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if let userLoc = mapView.mapView.userLocation.location?.coordinate {
                let region = MKCoordinateRegion(center: userLoc, latitudinalMeters: 800, longitudinalMeters: 800)
                mapView.mapView.setRegion(region, animated: true)
            }
        } else if status == .notDetermined {
            requestLocationPermission(withAlert: true)
        } else {
            showSettingsAlert()
        }
    }

    private func requestLocationPermission(withAlert: Bool = false) {
        if withAlert {
            let alert = UIAlertController(title: "Konum İzni", message: "Kendi konumunu haritada görmek ister misin?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Evet", style: .default) { _ in
                self.locationManager.requestWhenInUseAuthorization()
            })
            alert.addAction(UIAlertAction(title: "Hayır", style: .cancel))
            present(alert, animated: true)
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
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

extension LocationMapViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.mapView.showsUserLocation = true
        case .denied:
            showSettingsAlert()
        case .notDetermined:
            break
        default:
            break
        }
    }
}
