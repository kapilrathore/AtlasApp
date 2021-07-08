//
//  NavigationUtil.swift
//  CountriesInfo
//
//  Created by Kapil Rathore on 08/07/21.
//

import UIKit

class NavigationUtil {
    static func getListingScreen() -> UIViewController {
        let vc = CountryListingVC()
        let navController = UINavigationController(rootViewController: vc)
        return navController
    }
    
    static func pushDetailsScreen(on navigationController: UINavigationController?, country: Country) {
        let vc = CountryDetailVC(country: country)
        navigationController?.pushViewController(vc, animated: true)
    }
}
