//
//  Extension.swift
//  AllianzHomework
//
//  Created by Vincent on 21/09/22.
//

import Foundation

extension UIImageView {
    func loadImage(fromURL urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let activityView = UIActivityIndicatorView(style: .large)
        self.addSubview(activityView)
        activityView.frame = self.bounds
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityView.startAnimating()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            }

            if let data = data, error == nil {
                let image = UIImage(data: data)?.jpegData(compressionQuality: 0.0)
                DispatchQueue.main.async {
                    self.image = UIImage(data: image ?? Data())
                }
            }else{
                return
            }
        }.resume()
    }
}
