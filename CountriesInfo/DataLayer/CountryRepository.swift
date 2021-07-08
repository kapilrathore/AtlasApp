//
//  CountryRepository.swift
//  CountriesInfo
//
//  Created by Kapil Rathore on 08/07/21.
//

import Foundation

enum FetchResult<T: Decodable> {
    case inProgress
    case success(T)
    case failed(Error)
}

protocol CountryRepositoryType {
    func fetchCountries(completion: @escaping (FetchResult<[Country]>)->Void)
}

class CountryRepository: CountryRepositoryType {
    private let countryService: CountryServiceType
    private let countryDB: CountryDBType
    
    init(
        countryService: CountryServiceType = CountryService(),
        countryDB: CountryDBType = CountryDB.shared
    ) {
        self.countryService = countryService
        self.countryDB = countryDB
    }
    
    func fetchCountries(
        completion: @escaping (FetchResult<[Country]>) -> Void
    ) {
        completion(.inProgress)
        
        if let countries = self.countryDB.fetchCountries() {
            completion(.success(countries))
        }
        
        DispatchQueue.global().async { [weak self] in
            self?.countryService.fetchCountriesData { [weak self] response in
                switch response {
                
                case .success(let data):
                    self?.countryDB.saveCountries(data)
                    DispatchQueue.main.async {
                        completion(.success(data))
                    }
                case .error(let error):
                    DispatchQueue.main.async {
                        completion(.failed(error))
                    }
                }
            }
        }
    }
}
