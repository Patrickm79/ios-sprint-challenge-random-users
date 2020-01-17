//
//  PersonTableViewController.swift
//  Random Users
//
//  Created by Patrick Millet on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class PersonTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    private var apiController = PersonClientAPI()
    private var fetchOperations: FetchPhotoOperation?
    var cache: Cache = Cache<String, Data>()
    private var operations = [String: Operation]()
    private let photoFetchQueue = OperationQueue()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiController.fetchRequest { (_) in
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiController.persons.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonTableViewCell else { return UITableViewCell()}
        let person = apiController.persons[indexPath.row]
        cell.personNameLabel.text = "\(person.firstName) \(person.lastName)"
        loadImage(forCell: cell, forRowAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        fetchOperations?.cancel()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PersonDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let personDetailVC = segue.destination as? PersonDetailViewController else { return }
            personDetailVC.person = apiController.persons[indexPath.row]
        }
    }
    
    private func loadImage(forCell cell: PersonTableViewCell, forRowAt indexPath: IndexPath) {
        let person = apiController.persons[indexPath.row]
        if let cachedData = cache.value(forKey: person.id), let image = UIImage(data: cachedData) {
            cell.personThumbNail.image = image
            return
        }
        
        let fetchOperation = FetchPhotoOperation(photoType: .thumbNail, person: person)
        let cacheOperation = BlockOperation {
            if let data = fetchOperation.imageData {
                self.cache.cache(value: data, forKey: person.id)
            }
        }
        
        let completionOperation = BlockOperation {
            defer {self.operations.removeValue(forKey: person.id)}
            if let currentIndexpath = self.tableView.indexPath(for: cell),
                currentIndexpath != indexPath {
                return
            }
            if let data = fetchOperation.imageData {
                cell.personThumbNail.image = UIImage(data: data)
            }
        }
        
        cacheOperation.addDependency(fetchOperation)
        completionOperation.addDependency(fetchOperation)
        photoFetchQueue.addOperation(fetchOperation)
        photoFetchQueue.addOperation(cacheOperation)
        OperationQueue.main.addOperation(completionOperation)
        operations[person.id] = fetchOperation
    }
}
