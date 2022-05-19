//
//  SortHeaderView.swift
//  FinanceList
//
//  Created by Byron Hundley on 8/13/21.
//

import UIKit

protocol SortHeaderViewDelegate: NSObjectProtocol {
    func sortHeaderViewTapped(_ headerView: SortHeaderView)
}

enum SortType: String {
    case date = "Date"
    case amount = "Amount"
}

enum SortOrder: Int {
    case ascending, descending
}

class SortHeaderView: UITableViewHeaderFooterView {
    weak var delegate: SortHeaderViewDelegate?
    
    var sortType: SortType = .date
    
    fileprivate lazy var sortContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var roundedView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var sortByLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    fileprivate lazy var sortedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    fileprivate lazy var sortIcon: UIImageView = {
        let image = UIImage(systemName: "chevron.down")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.sortByLabel, self.sortedLabel, self.sortIcon])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        return stackView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        contentView.addSubview(sortContainerView)
        sortContainerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            sortContainerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 14),
            sortContainerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -14),
            sortContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            sortContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leftAnchor.constraint(equalTo: sortContainerView.leftAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: sortContainerView.rightAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: sortContainerView.topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: sortContainerView.bottomAnchor, constant: -4),
            sortContainerView.heightAnchor.constraint(lessThanOrEqualToConstant: 56)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.sortViewTapped(_:)))
        sortContainerView.addGestureRecognizer(tap)
        sortContainerView.isUserInteractionEnabled = true
        
        applyStyle()
    }
    
    @objc func sortViewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.sortHeaderViewTapped(self)
    }

    func update() {
        sortByLabel.text = "Sort by:"
        sortedLabel.text = sortType.rawValue
    }
    
    func applyStyle() {
        contentView.backgroundColor = Theme.customSecondayBackground
        sortContainerView.layer.cornerRadius = 8
        sortContainerView.layer.borderWidth = 0.3
        sortContainerView.layer.borderColor = UIColor.gray.cgColor
        sortIcon.tintColor = .gray
        sortByLabel.font = Theme.heavyLabel.font
        sortedLabel.font = Theme.defaultLabel.font
    }
}
