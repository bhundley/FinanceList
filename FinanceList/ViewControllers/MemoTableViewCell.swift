//
//  MemoTableViewCell.swift
//  FinanceList
//
//  Created by Byron Hundley on 8/13/21.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    
    private lazy var memoTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.text = "MEMO"
        label.font = Theme.cellPreTitle.font
        label.textColor = Theme.cellPreTitle.color
        label.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.backgroundColor = nil
        textView.isUserInteractionEnabled = true
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.maximumNumberOfLines = 2
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.font = Theme.defaultLabel.font
        return textView
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [memoTitleLabel, textView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textStackView)

        NSLayoutConstraint.activate([
            textStackView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            textStackView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        contentView.layoutIfNeeded()
    }
    
    func updatePlaceHolder() {
        textView.placeholder = "Tap to enter a memo"
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
}
