//
//  UIImageView+Extensions.swift
//  FinanceList
//
//  Created by Byron Hundley on 8/13/21.
//

import UIKit

extension UIImageView {
    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.color = UIColor.label
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 20),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        ])
        
        return activityIndicator
    }
    
    func load(url: URL, completion: (() -> Void)? = nil) {
        let activityIndicator = self.activityIndicator
        DispatchQueue.main.async {
            activityIndicator.startAnimating()
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                        completion?()
                    }
                }
            }
        }
    }
}
