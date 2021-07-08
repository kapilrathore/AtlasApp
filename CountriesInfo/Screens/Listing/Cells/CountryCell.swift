//
//  CountryCell.swift
//  CountriesInfo
//
//  Created by Kapil Rathore on 08/07/21.
//

import UIKit

class CountryCell: UITableViewCell {
    
    static var id: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: id, bundle: nil) }
    
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var regionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.flagImageView.image = nil
    }
    
    func setupCell(with data: Country) {
        nameLabel.text = data.name
        regionLabel.text = "\(data.subregion), \(data.region)"
        flagImageView.downloadImage(from: data.alpha2Code)
    }
}
