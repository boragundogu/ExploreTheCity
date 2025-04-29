//
//  NetworkService.swift
//  ExploreTheCity
//
//  Created by Bora Gündoğu on 25.04.2025.
//

import Foundation
import Alamofire

final class NetworkService {
    static let shared = NetworkService()

    private init() {}

    func fetchCities(page: Int, completion: @escaping (Result<CityResponse, Error>) -> Void) {
        let url = "https://storage.googleapis.com/invio-com/usg-challenge/city-location/page-\(page).json"
        
        AF.request(url).validate().responseDecodable(of: CityResponse.self) { response in
            switch response.result {
            case .success(let cityData):
                completion(.success(cityData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
