//
//  FarmViewController.swift
//  Agribusiness
//
//  Created by Aluno on 24/05/18.
//  Copyright © 2018 Quaini, Tiago. All rights reserved.
//

import UIKit

class FarmViewController : UITableViewController {
    
    var isStartDatePickerHidden = true
    var isEndDatePickerHidden = true
    var farm: Farm?
    
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
        initDatePickers()
        
        if let farm = farm {
            navigationItem.title = "Edit Farm"
            nameTextField.text = farm.name
            addressTextField.text = farm.address
            milkBarrelsTextField.text = String(farm.milkBarrels)
            startDatePicker.date = farm.startTime
            endDatePicker.date = farm.endTime
        } else {
            startDatePicker.date = Date(timeIntervalSinceReferenceDate:11*60*60)
            endDatePicker.date = Date(timeIntervalSinceReferenceDate: 20*60*60)
        }
        
        updateStartDateLabel(date: startDatePicker.date)
        updateEndDateLabel(date: endDatePicker.date)
    }
    
    func initDatePickers() {
        startDatePicker.datePickerMode = .time
        startDatePicker.minuteInterval = 15
        endDatePicker.datePickerMode = .time
        endDatePicker.minuteInterval = 15
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        
        switch(indexPath) {
        case [3,0]: //Start Date
            return isStartDatePickerHidden ? normalCellHeight : largeCellHeight
            
        case [3,1]: //End Date
            return  isEndDatePickerHidden ? normalCellHeight :largeCellHeight
            
        default: return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath) {
        case [3,0]:
            isStartDatePickerHidden = !isStartDatePickerHidden
            
            startDateLabel.textColor = isStartDatePickerHidden ? .black : tableView.tintColor
            
            tableView.beginUpdates()
            tableView.endUpdates()
        case [3,1]:
            isEndDatePickerHidden = !isEndDatePickerHidden
            endDateLabel.textColor = isEndDatePickerHidden ? .black : tableView.tintColor
            
            tableView.beginUpdates()
            tableView.endUpdates()
        default: break
        }
    }
    
    func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        let address = addressTextField.text ?? ""
        let milkBarrels = milkBarrelsTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty && !address.isEmpty && !milkBarrels.isEmpty
    }
}
