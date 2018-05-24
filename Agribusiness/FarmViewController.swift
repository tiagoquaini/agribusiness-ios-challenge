//
//  FarmViewController.swift
//  Agribusiness
//
//  Created by Aluno on 24/05/18.
//  Copyright © 2018 Quaini, Tiago. All rights reserved.
//

import UIKit

class FarmViewController : UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var milkBarrelsTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonState()
        startDatePicker.datePickerMode = .time
        endDatePicker.datePickerMode = .time
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder() // hide keyboard
    }
    
    @IBAction func textChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func startDatePickerChanged(_ sender: UIDatePicker) {
        updateStartDateLabel(date: sender.date)
    }
    
    @IBAction func endDatePickerChanged(_ sender: UIDatePicker) {
        updateEndDateLabel(date: sender.date)
    }
    
    func updateStartDateLabel(date: Date) {
        startDateLabel.text = Farm.dateFormatter.string(from: date)
    }
    
    func updateEndDateLabel(date: Date) {
        endDateLabel.text = Farm.dateFormatter.string(from: date)
    }
    
    func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        let address = addressTextField.text ?? ""
        let milkBarrels = milkBarrelsTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty && !address.isEmpty && !milkBarrels.isEmpty
    }
}
