//
//  HistoryViewController.swift
//  Routes
//
//  Created by Vitor Costa on 26/02/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private Properties
    private var fetchedResultsController:NSFetchedResultsController<Search>!
    
    // MARK: - UIViewController Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMap" {
            let vc = segue.destination as! MapViewController
            vc.mapResult = (sender as! MapResult)
        }
    }
    
    // MARK: - IBActions
    @IBAction func closeButtonItemTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Functions
    private func loadData() {
        fetchedResultsController = DataHelper.shared.getSearchData()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    private func configureUI() {
        // Configure Table View
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Table View Override Functions
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        let item = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = "From: " + item.from!
        cell.detailTextLabel?.text = "To: " + item.to!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        
        showCenterIndicator()
        MapHelper.sharedInstance.getMapResultFromAddresses(from: item.from!, to: item.to!) { (result) in
            self.hideCenterIndicator()
            if let error = result.errorMessage {
                self.showAlert(title: "Attention", message: error)
            } else {
                self.performSegue(withIdentifier: "segueToMap", sender: result)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            DataHelper.shared.deleteSearch(fetchedResultsController.object(at: indexPath))
        }
    }
}

extension HistoryViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: UITableView.RowAnimation.fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            print("Moving item?")
        }
    }
}
