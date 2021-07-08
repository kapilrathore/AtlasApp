//
//  DetailsViewModel.swift
//  CountriesInfo
//
//  Created by Kapil Rathore on 08/07/21.
//

import Foundation

class DetailsViewModel {
    
    let country: Country
    
    var region: String { "\(country.subregion), \(country.region)" }
    var population: String { "\(country.population)" }
    var currencies: String { country.currencies.compactMap(\.code).reduce("") { $0 + "\($0.isEmpty ? "" : ", ")\($1)" } }
    var languages: String { country.languages.map(\.name).reduce("") { $0 + "\($0.isEmpty ? "" : ", ")\($1)" } }
    
    init(country: Country) {
        self.country = country
    }
}
