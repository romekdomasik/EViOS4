//
//  AddExpensesViewController.swift
//  EVios4
//
//  Created by roman domasik on 14/09/2023.
//

import UIKit

class AddExpensesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var expenseNameTF: UITextField!
    @IBOutlet weak var expenseValueTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var expensePicker: UIPickerView!
    
    private var sections = [ExpenseSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expensePicker.delegate = self
        expensePicker.dataSource = self
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        
        let request = ExpenseSection.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            sections = try DataManager.shared.context.fetch(request)
        } catch {
            print("Unable to fetch sections", error)
        }
    }
    
    @IBAction func pressSaveExpenseBtn(_ sender: Any) {
        guard let expenseName = expenseNameTF.text,
              let valueText = expenseValueTF.text,
              let value = Float(valueText)
        else {return}
        
        let section = sections[expensePicker.selectedRow(inComponent: 0)]
        let selectedDate = datePicker.date
        
        dismiss(animated: true){
            DataManager.shared.addExpense(name: expenseName, date: selectedDate, value: value, type: section)
        }
    }
    
    @IBAction func pressCancelBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sections.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        sections[row].name
    }
}
