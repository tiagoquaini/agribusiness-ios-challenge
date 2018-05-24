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
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        let address = addressTextField.text ?? ""
        let milkBarrels = milkBarrelsTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty && !address.isEmpty && !milkBarrels.isEmpty
    }
}
