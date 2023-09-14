//
//  AddExpensesViewController.swift
//  EVios4
//
//  Created by roman domasik on 14/09/2023.
//

import UIKit

class AddExpensesViewController: UIViewController {
    
    @IBOutlet weak var expenseNameTF: UITextField!
    @IBOutlet weak var expenseValueTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var ExpensePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func pressSaveExpenseBtn(_ sender: Any) {
    }
    
}
