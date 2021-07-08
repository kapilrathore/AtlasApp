//
//  CountryDetailVC.swift
//  CountriesInfo
//
//  Created by Kapil Rathore on 08/07/21.
//

import UIKit

class CountryDetailVC: UIViewController {
    
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var regionLabel: UILabel!
    @IBOutlet private weak var capitalLabel: UILabel!
    @IBOutlet private weak var populationLabel: UILabel!
    @IBOutlet private weak var currenciesLabel: UILabel!
    @IBOutlet private weak var langugaesLabel: UILabel!
    
    private var viewModel: DetailsViewModel!
    
    init(country: Country) {
        super.init(nibName: "CountryDetailVC", bundle: nil)
        self.viewModel = DetailsViewModel(country: country)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("use custom init")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.title = self.viewModel.country.name
        
        self.nameLabel.text = self.viewModel.country.name
        self.regionLabel.text = self.viewModel.region
        self.capitalLabel.text = self.viewModel.country.capital
        self.populationLabel.text = self.viewModel.population
        self.currenciesLabel.text = self.viewModel.currencies
        self.langugaesLabel.text = self.viewModel.languages
        self.flagImageView.downloadImage(from: self.viewModel.country.alpha2Code)
    }
}
