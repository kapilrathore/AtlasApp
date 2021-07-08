//
//  ListingViewModel.swift
//  CountriesInfo
//
//  Created by Kapil Rathore on 08/07/21.
//

import Foundation

protocol ListingRenderer: AnyObject {
    func render(_ state: ListingState)
    
    func reloadCountriesData()
    func showNoData()
    func showLoading(_ show: Bool)
    func showError(_ message: String)
}

extension ListingRenderer {
    func render(_ state: ListingState) {
        
        self.showLoading(state.isLoading)
        
        if let message = state.errorMessage {
            self.showError(message)
        }
        
        if state.countries.isEmpty {
            self.showNoData()
        } else {
            self.reloadCountriesData()
        }
    }
}

struct ListingState: Equatable {
    let countries: [Country]
    let errorMessage: String?
    let isLoading: Bool
    
    static let initial: ListingState = .init(countries: [], errorMessage: nil, isLoading: true)
    
    func copy(
        countries: [Country]?,
        errorMessage: String??,
        isLoading: Bool?
    ) -> ListingState {
        .init(
            countries: countries ?? self.countries,
            errorMessage: errorMessage ?? self.errorMessage,
            isLoading: isLoading ?? self.isLoading
        )
    }
}

class ListingViewModel {
    private weak var renderer: ListingRenderer?
    private let repository: CountryRepositoryType
    
    private(set) var state: ListingState
    
    init(
        state: ListingState = .initial,
        renderer: ListingRenderer?,
        repository: CountryRepositoryType
    ) {
        self.state = state
        self.renderer = renderer
        self.repository = repository
    }
    
    private var allCountries: [Country] = []
    
    func fetchCountries() {
        self.repository.fetchCountries { [weak self] fetchResult in
            switch fetchResult {
            
            case .inProgress:
                self?.updateState(isLoading: true)
                
            case .success(let data):
                self?.allCountries = data
                self?.updateState(countries: data, isLoading: false)
            
            case .failed(let error):
                self?.updateState(errorMessage: error.localizedDescription, isLoading: false)
            }
        }
    }
    
    func searchCountry(_ query: String) {
        let filteredCountries = query.isEmpty
            ? self.allCountries
            : self.allCountries.filter { $0.name.lowercased().contains(query.lowercased()) }
        
        self.updateState(countries: filteredCountries)
    }
    
    private func updateState(
        countries: [Country]? = nil,
        errorMessage: String?? = nil,
        isLoading: Bool? = nil
    ) {
        self.state = self.state.copy(countries: countries, errorMessage: errorMessage, isLoading: isLoading)
        self.renderer?.render(self.state)
    }
}
