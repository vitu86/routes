//
//  HistoryViewController.swift
//  Routes
//
//  Created by Vitor Costa on 26/02/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private Contants
    private let dataSource:DataSource = DataSource() // Temporary before core data
    
    // MARK: - UIViewController Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.load() // Temporary before core data
        configureUI()
    }
    
    // MARK: - IBActions
    @IBAction func closeButtonItemTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        // Configure Table View
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        let item = dataSource.data[indexPath.row]
        
        cell.textLabel?.text = item.from
        cell.detailTextLabel?.text = item.to
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToMap", sender: nil)
    }
}

// MARK: - Temporary Class To Fill Table
class DataSource {
    var data:[DataModel] = []
    func load() {
        for i in 0 ..< 20 {
            data.append(DataModel(to: "Destination: \(i)", from: "From: \(i)"))
        }
    }
}

struct DataModel {
    var to:String
    var from:String
}
