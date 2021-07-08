//
//  NetworkManager.swift
//  CountriesInfo
//
//  Created by Kapil Rathore on 08/07/21.
//

import Foundation

enum ApiResponse<T: Decodable> {
    case success(T)
    case error(Error)
}

protocol NetworkManagerType {
    func makeDataRequest<T: Decodable>(
        endpoint: String,
        completion: @escaping (ApiResponse<T>)->Void
    )
}

class NetworkManager: NetworkManagerType {
    private init() {}
    static let shared = NetworkManager()
    
    private let session = URLSession.shared
    
    func makeDataRequest<T: Decodable>(
        endpoint: String,
        completion: @escaping (ApiResponse<T>)->Void
    ) {
        guard let url = URL(string: endpoint) else {
            completion(.error(URLError(.badURL)))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.error(error))
                return
            }
            
            guard let data = data else {
                completion(.error(URLError(.cannotDecodeRawData)))
                return
            }
            
            if let model = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(model))
            } else {
                completion(.error(URLError(.cannotParseResponse)))
            }
        }.resume()
    }
}
