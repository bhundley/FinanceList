//
//  TransactionListViewController.swift
//  FinanceList
//
//  Created by Byron Hundley on 8/12/21.
//

import UIKit

class TransactionListViewController: UIViewController {
    fileprivate var transactions: [Transaction] = []
    fileprivate var currentSortInfo: (type: SortType, order: SortOrder) = (.date, .ascending)
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = nil
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = 56
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 56
        tableView.register(SortHeaderView.self, forHeaderFooterViewReuseIdentifier: "SortHeaderView")
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        return tableView
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.label
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    fileprivate lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.text = "An error occurred. Please try again."
        label.font = Theme.defaultLabel.font
        label.textColor = Theme.errorMessage.color
        return label
    }()
    
    fileprivate lazy var tryAgainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        button.setTitle("Try Again", for: .normal)
        button.setTitleColor(Theme.buttonTitle.color, for: .normal)
        button.titleLabel?.font = Theme.buttonTitle.font
        return button
    }()
    
    private lazy var errorStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [errorLabel, tryAgainButton])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    fileprivate lazy var errorView: UIView = {
        let errorView = UIView()
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.isHidden = true
        errorView.addSubview(errorStackView)
        errorView.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            errorStackView.centerYAnchor.constraint(equalTo: errorView.centerYAnchor),
            errorStackView.centerXAnchor.constraint(equalTo: errorView.centerXAnchor)
        ])
        return errorView
    }()
    
    enum State {
        case list
        case loading
        case error
    }
    
    fileprivate var state: State = .loading {
        didSet {
            switch state {
            case .loading:
                errorView.isHidden = true
                tableView.isHidden = true
                activityIndicator.startAnimating()
            case .error:
                tableView.isHidden = true
                activityIndicator.stopAnimating()
                errorView.isHidden = false
            case .list:
                errorView.isHidden = true
                activityIndicator.stopAnimating()
                tableView.isHidden = false
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Transactions"
        
        fetchData()
        setupListStates()
        setupTableView()
    }
    
    func fetchData() {
        state = .loading
        DataRequestManager.shared.getData {[weak self] data, error in
            DispatchQueue.main.async {
                if error != nil {
                    self?.state = .error
                }
                
                guard let trans = data?.transactions else {
                    self?.state = .error
                    return
                }
                
                self?.transactions = trans
                self?.state = .list
            }
        }
    }
    
    func setupListStates() {
        view.addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        activityIndicator.startAnimating()
    }
    
    func setupTableView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @objc private func retryButtonTapped() {
        fetchData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = transactions[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as? TransactionTableViewCell {
            cell.updateWithTransaction(transaction)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SortHeaderView") as! SortHeaderView
        view.delegate = self
        view.sortType = currentSortInfo.type
        view.update()
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // NOTE: I'm not sure if I was supposed to do nothing if the user taps on a credit transaction with no image.  I'm showing the transactions details still so the behavior is the same and not confusing to the user.  Sorry, if I misunderstood this part.
        
//        let transation = transactions[indexPath.row]
        
        // Don't go to details if it's a credit without a check image
//        guard (transation.isCredit == true && transation.imageUrl != nil) ||
//                transation.isCredit == false
//            else { return }
        
        let vc = TransactionDetailsViewController()
        vc.transaction = transactions[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Sort Functionality
extension TransactionListViewController {
    func sortList(type: SortType) {
        var order: SortOrder = currentSortInfo.order == .ascending ? .descending : .ascending
        
        // Reset sort order if changing sort type
        if currentSortInfo.type != type {
            order = .ascending
        }
        
        currentSortInfo = (type, order)
        switch(type, order) {
        case (.date, .ascending):
            let sortedDate = transactions.sorted {
                $0.date! < $1.date!
            }
            transactions = sortedDate
        case (.date, .descending):
            let sortedDate = transactions.sorted {
                $0.date! > $1.date!
            }
            transactions = sortedDate
        case (.amount, .ascending):
            let sortedAmount = transactions.sorted {
                $0.amount! < $1.amount!
            }
            transactions = sortedAmount
        case (.amount, .descending):
            let sortedAmount = transactions.sorted {
                $0.amount! > $1.amount!
            }
            transactions = sortedAmount
        }
        
        tableView.reloadData()
    }
    
    func showSortMenu() {
        let sortImage = UIImage(systemName: "arrow.up.arrow.down")
        
        let dateAction = UIAlertAction(title: "Sort by Date", style: .default) { (action) in
            self.sortList(type: .date)
        }
        dateAction.setValue(sortImage, forKey: "image")
        
        let amountAction = UIAlertAction(title: "Sort by Amount", style: .default) { (action) in
            self.sortList(type: .amount)
        }
        amountAction.setValue(sortImage, forKey: "image")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(dateAction)
        alert.addAction(amountAction)
        alert.addAction(cancelAction)
        
        let titleString = NSAttributedString(string: "Sort Transactions", attributes: Theme.actionSheetTitleStyle)
        alert.setValue(titleString, forKey: "attributedTitle")
        alert.view.tintColor = Theme.buttonTitle.color
        
        present(alert, animated: true)
    }
}

// MARK: - SortHeaderViewDelegate
extension TransactionListViewController: SortHeaderViewDelegate {
    func sortHeaderViewTapped(_ headerView: SortHeaderView) {
        showSortMenu()
    }
}
