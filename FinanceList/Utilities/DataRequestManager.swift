//
//  DataRequestManager.swift
//  FinanceList
//
//  Created by Byron Hundley on 8/12/21.
//

import Foundation

class DataRequestManager {
    fileprivate let transactionsUrl = "https://m1-technical-assessment-data.netlify.app/transactions-v1.json"
    
    static let shared = DataRequestManager()
    
    func getData(completion: ((Transactions?, Error?) -> Void)?) {
        guard let url = URL(string: transactionsUrl) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion?(nil, error)
            }
            
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            if let handler = completion, let testData = try? JSONDecoder().decode(Transactions.self, from: data) {
                handler(testData, nil)
            } else {
                completion?(nil, NSError(domain: "", code: 0, userInfo: nil))
            }
        }.resume()
    }
}
