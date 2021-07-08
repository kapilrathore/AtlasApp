//
//  DataModels.swift
//  CountriesInfo
//
//  Created by Kapil Rathore on 08/07/21.
//

import Foundation

struct Country: Codable, Equatable {
    let name: String
    let capital: String
    let alpha2Code: String
    let flag: String // image-url
    let region: String
    let subregion: String
    let population: Double
    let currencies: [Currency]
    let languages: [Language]
}

struct Language: Codable, Equatable {
    let name: String
}

struct Currency: Codable, Equatable {
    let code: String?
    let name: String?
    let symbol: String?
}
