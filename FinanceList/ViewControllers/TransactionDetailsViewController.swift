//
//  TransactionDetailsViewController.swift
//  FinanceList
//
//  Created by Byron Hundley on 8/13/21.
//

import UIKit

class TransactionDetailsViewController: UIViewController {

    // Injected property
    var transaction: Transaction!
    
    enum TableRow: Int, CaseIterable {
        case desc, amount, date, memo, image
    }
    
    private var tableRows: [TableRow] = []
    private let savedMemoKey = "SavedMemosKey"
    
    // UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: "MemoTableViewCell")
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        return tableView
    }()
    
    private var styledAmount: String? {
        get {
            if let amount = transaction.amount, let amountString = CurrencyUtils.formatToCurrencyString(amount: amount) {
                if transaction.isCredit == true {
                    return amountString
                } else {
                    return "-\(amountString)"
                }
            }
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(transaction != nil, "transaction must be set")
        
        navigationController?.navigationItem.backButtonDisplayMode = .minimal
        title = "Transaction Details"
        
        setupTableView()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveMemoIfNeeded()
    }
    
    fileprivate func setupTableView() {
        if transaction.description != nil {
            tableRows.append(.desc)
        }
        
        if transaction.amount != nil {
            tableRows.append(.amount)
        }
        
        if transaction.date != nil {
            tableRows.append(.date)
        }
        
        tableRows.append(.memo)
        
        if transaction.imageUrl != nil {
            tableRows.append(.image)
        }
    }
    
    fileprivate func setupUI() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func styleCell(_ cell: UITableViewCell) {
        cell.textLabel?.font = Theme.cellPreTitle.font
        cell.textLabel?.textColor = Theme.cellPreTitle.color
        cell.detailTextLabel?.font = Theme.cellDetail.font
        cell.detailTextLabel?.textColor = Theme.cellDetail.color
    }
}

// MARK: - Memo functionality
extension TransactionDetailsViewController {
    public var savedMemos: [Memo]? {
        get {
            if let data = UserDefaults.standard.value(forKey: savedMemoKey) as? Data {
                return try? PropertyListDecoder().decode(Array<Memo>.self, from: data)
            }
            return [Memo]()
        }
        set(newValue) {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: savedMemoKey)
        }
    }
    
    private var isMemoDirty: Bool {
        if let transactionID = transaction.id, let existingMemo = getMemoForTransId(transactionID) {
            return existingMemo.text != (memoTextView?.text ?? "")
        } else {
            return !(memoTextView?.text ?? "").isEmpty
        }
    }
    
    private var memoTextView: UITextView? {
        if let row = tableRows.firstIndex(where: { return $0 == .memo }) {
            let indexPath = IndexPath(row: row, section: 0)
            if let memoCell = tableView.cellForRow(at: indexPath) as? MemoTableViewCell {
                return memoCell.textView
            }
        }
        return nil
    }
    
    private func saveMemo(_ memo: Memo) {
        // Remove any existing memo for this transactions before saving
        if let itemIndex = savedMemos?.firstIndex(where: { $0.transactionId == memo.transactionId }) {
            savedMemos?.remove(at: itemIndex)
        }
        
        savedMemos?.append(memo)
    }
    
    private func getMemoForTransId(_ id: Int64) -> Memo? {
        return savedMemos?.first(where: { return $0.transactionId == id })
    }
    
    private func saveMemoIfNeeded() {
        guard let transactionID = transaction.id,
              let memoText = memoTextView?.text,
              isMemoDirty
        else { return }
        
        saveMemo(Memo(transactionId: transactionID, text: memoText))
    }
}

// MARK: - UITableViewDelegate
extension TransactionDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = tableRows[indexPath.row]
        switch row {
        case .image:
            return UITableView.automaticDimension
        case .memo:
            return 120
        default:
            return 52
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableRows[indexPath.row]
        
        switch row {
        case .desc:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "descCell")
            cell.textLabel?.text = "DESCRIPTION"
            cell.detailTextLabel?.text = transaction.description ?? ""
            styleCell(cell)
            return cell
        case .amount:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "amountCell")
            cell.textLabel?.text = "AMOUNT"
            cell.detailTextLabel?.text = styledAmount
            styleCell(cell)
            return cell
        case .date:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "dateCell")
            cell.textLabel?.text = "DATE"
            cell.detailTextLabel?.text = transaction.date ?? ""
            if let dateString = transaction.date {
                cell.detailTextLabel?.text = DateUtils.formattedDateString(dateString)
            }
            styleCell(cell)
            return cell
        case .memo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as? MemoTableViewCell, let transID = transaction.id {
                cell.textView.text = getMemoForTransId(transID)?.text
                cell.updatePlaceHolder()
                return cell
            }
        case .image:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell,
               let imageString = transaction.imageUrl,
               let url = URL(string: imageString)
            {
                tableView.beginUpdates()
                cell.checkImageView.load(url: url, completion: { [weak self] in
                    UIView.performWithoutAnimation {
                        self?.tableView.endUpdates()
                    }
                })
                return cell
            }
        }
        return UITableViewCell()
    }
}
