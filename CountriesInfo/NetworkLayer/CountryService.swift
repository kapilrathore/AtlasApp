//
//  CountryService.swift
//  CountriesInfo
//
//  Created by Kapil Rathore on 08/07/21.
//

import Foundation

protocol CountryServiceType {
    func fetchCountriesData(completion: @escaping (ApiResponse<[Country]>)->Void)
}

class CountryService: CountryServiceType {
    private let networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchCountriesData(completion: @escaping (ApiResponse<[Country]>)->Void) {
        let endpoint = "https://restcountries.eu/rest/v2/all"
        self.networkManager.makeDataRequest(endpoint: endpoint, completion: completion)
    }
}
