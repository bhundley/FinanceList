//
//  ImageTableViewCell.swift
//  FinanceList
//
//  Created by Byron Hundley on 8/13/21.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    lazy var checkImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    fileprivate func commonInit() {
        contentView.addSubview(checkImageView)
        
        NSLayoutConstraint.activate([
            checkImageView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            checkImageView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            checkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            checkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
