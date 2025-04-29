//
//  CityModel.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import Foundation

struct CityResponse: Decodable {
    let currentPage: Int
    let totalPage: Int
    let total: Int
    let itemPerPage: Int
    let pageSize: Int
    let data: [City]
}

struct City: Decodable {
    let city: String
    let locations: [Location]?
}

struct Location: Codable {
    let id: Int
    let name: String
    let description: String
    let coordinates: Coordinates
    let image: String?
}

struct Coordinates: Codable {
    let lat: Double
    let lng: Double
}
