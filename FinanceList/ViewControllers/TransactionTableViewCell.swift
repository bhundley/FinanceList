//
//  TransactionTableViewCell.swift
//  FinanceList
//
//  Created by Byron Hundley on 8/12/21.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        return label
    }()
    
    fileprivate lazy var checkImageView: UIImageView = {
        let checkIcon = UIImage(named: "bank-check")
        let imageView = UIImageView(image: checkIcon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        imageView.isHidden = true
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 18),
            imageView.heightAnchor.constraint(equalToConstant: 10)
        ])
        return imageView
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, checkImageView])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(30, after: checkImageView)
        stackView.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        return stackView
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [descLabel, dateStackView])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textStackView, amountLabel])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    fileprivate func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            containerStackView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        applyStyle()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        amountLabel.text = ""
        dateLabel.text = ""
        descLabel.text = ""
        checkImageView.isHidden = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }

    func updateWithTransaction(_ transaction: Transaction) {
        if transaction.imageUrl != nil {
            checkImageView.isHidden = false
        }
        
        if let amount = transaction.amount, let amountString = CurrencyUtils.formatToCurrencyString(amount: amount) {
            if transaction.isCredit == true {
                amountLabel.text = amountString
                amountLabel.textColor = Theme.creditLabel.color
            } else {
                amountLabel.text = "-\(amountString)"
                amountLabel.textColor = Theme.defaultLabel.color
            }
        }
        
        descLabel.text = transaction.description
        
        if let dateString = transaction.date {
            dateLabel.text = DateUtils.formattedDateString(dateString)
        }
    }
    
    func applyStyle() {
        contentView.backgroundColor = .systemBackground
        amountLabel.font = Theme.defaultLabel.font
        descLabel.font = Theme.defaultLabel.font
        dateLabel.font = Theme.smallerSecondaryTitle.font
        amountLabel.textColor = Theme.defaultLabel.color
        descLabel.textColor = Theme.defaultLabel.color
        dateLabel.textColor = Theme.smallerSecondaryTitle.color
        checkImageView.tintColor = Theme.smallerSecondaryTitle.color
    }
}
