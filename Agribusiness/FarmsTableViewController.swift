//
//  FarmsTableViewController.swift
//  Agribusiness
//
//  Created by Aluno on 24/05/18.
//  Copyright © 2018 Quaini, Tiago. All rights reserved.
//

import UIKit

class FarmsTableViewController : UITableViewController {
    
    var farms : [Farm] = []
    
    @IBAction func unwindToFarmList(segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedFarms = Farm.loadFarms() {
            farms = savedFarms
        } else {
            farms = Farm.loadSampleFarms()
        }
        
        Farm.saveFarms(farms)
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return farms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FarmCellIdentifier") else {
            fatalError("Could not dequeue a cell")
        }
        let farm = farms[indexPath.row]
        cell.textLabel?.text = farm.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            farms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Farm.saveFarms(farms)
        }
    }
}
