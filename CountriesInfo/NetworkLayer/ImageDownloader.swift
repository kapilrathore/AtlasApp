//
//  ImageDownloader.swift
//  CountriesInfo
//
//  Created by Kapil Rathore on 08/07/21.
//

import UIKit

class ImageDownloader {
    static let shared = ImageDownloader()
    private init() {}
    
    private let cache = NSCache<NSString, NSData>()
    
    func downloadImage(from countryCode: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: "https://www.countryflags.io/\(countryCode)/flat/64.png") else {
            completion(nil)
            return
        }
        
        if let imageData = cache.object(forKey: url.absoluteString as NSString) {
            completion(UIImage(data: imageData as Data))
            return
        }
        
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                self.cache.setObject(data as NSData, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            }.resume()
        }
    }
}

extension UIImageView {
    func downloadImage(from countryCode: String) {
        ImageDownloader.shared.downloadImage(from: countryCode) { [weak self] image in
            self?.image = image ?? UIImage(systemName: "flag")
        }
    }
}
