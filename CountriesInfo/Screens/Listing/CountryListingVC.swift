//
//  CountryListingVC.swift
//  CountriesInfo
//
//  Created by Kapil Rathore on 08/07/21.
//

import UIKit

class CountryListingVC: UIViewController {
    
    @IBOutlet private weak var countriesTable: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    
    private lazy var repository: CountryRepository = {
        return CountryRepository(countryService: CountryService(), countryDB: CountryDB.shared)
    }()
    
    private lazy var viewModel: ListingViewModel = {
        return ListingViewModel(renderer: self, repository: self.repository)
    }()
    
    init() {
        super.init(nibName: "CountryListingVC", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("use custom init")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.initViews()
        self.setupActions()
        self.viewModel.fetchCountries()
    }
    
    private func initViews() {
        self.title = "Take Me To"
        self.searchBar.searchTextField.placeholder = "Search by Country Name"
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.countriesTable.delegate = self
        self.countriesTable.dataSource = self
        self.countriesTable.register(CountryCell.nib, forCellReuseIdentifier: CountryCell.id)
        self.countriesTable.rowHeight = 80
    }
    
    private func setupActions() {
        self.searchBar.searchTextField.addTarget(self, action: #selector(searchCountries), for: .editingChanged)
    }
    
    @objc private func searchCountries() {
        self.viewModel.searchCountry(self.searchBar.searchTextField.text ?? "")
    }
}

extension CountryListingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.state.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.id, for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        
        let country = self.viewModel.state.countries[indexPath.row]
        cell.setupCell(with: country)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = self.viewModel.state.countries[indexPath.row]
        NavigationUtil.pushDetailsScreen(on: self.navigationController, country: country)
    }
}

extension CountryListingVC: ListingRenderer {
    func reloadCountriesData() {
        self.countriesTable.isHidden = false
        self.countriesTable.reloadData()
    }
    
    func showNoData() {
        self.countriesTable.isHidden = true
    }
    
    func showLoading(_ show: Bool) {
        self.loadingView.isHidden = !show
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in self.viewModel.fetchCountries() }))
    }
}
