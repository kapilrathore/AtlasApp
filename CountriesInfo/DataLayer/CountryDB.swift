//
//  CountryDB.swift
//  CountriesInfo
//
//  Created by Kapil Rathore on 08/07/21.
//

import Foundation

protocol CountryDBType {
    func saveCountries(_ data: [Country])
    func fetchCountries() -> [Country]?
}

class CountryDB: CountryDBType {
    private init() {}
    static let shared = CountryDB()
    
    private let persistanceStorage = UserDefaults.standard
    private let countriesKey = "countriesData"
    
    func saveCountries(_ data: [Country]) {
        self.storeCodable(data, key: self.countriesKey)
    }
    
    func fetchCountries() -> [Country]? {
        self.retrieveCodable(for: self.countriesKey)
    }
}

extension CountryDB {
    private func storeCodable<T: Codable>(_ object: T, key: String) {
        do {
            let encoded = try JSONEncoder().encode(object)
            persistanceStorage.set(encoded, forKey: key)
        } catch let err {
            print("Error encoding data: \(err)")
        }
    }
    
    private func retrieveCodable<T: Codable>(for key: String) -> T? {
        do {
            guard let storedObjItem = persistanceStorage.object(forKey: key) as? Data else {
                return nil
            }
            let storedItems = try JSONDecoder().decode(T.self, from: storedObjItem)
            return storedItems
        } catch let err {
            print("Error decoding data: \(err)")
            return nil
        }
    }
}
