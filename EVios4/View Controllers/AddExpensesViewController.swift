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
        guard let expenseName = expenseNameTF.text, !expenseName.isEmpty else {
            showAlert(title: "Champ manquant", message: "Le champ 'Nom de la dépense' ne peut pas être vide.")
            return
        }
        
        guard let valueText = expenseValueTF.text, !valueText.isEmpty else {
            showAlert(title: "Champ manquant", message: "Le champ 'Valeur de la dépense' ne peut pas être vide.")
            return
        }
        
        guard let value = Float(valueText) else {
            showAlert(title: "Format incorrect", message: "Le champ 'Valeur' doit contenir uniquement des nombres. Veuillez saisir un nombre valide.")
            return
        }
        
        let section = sections[expensePicker.selectedRow(inComponent: 0)]
        let selectedDate = datePicker.date
        
        dismiss(animated: true) {
            DataManager.shared.addExpense(name: expenseName, date: selectedDate, value: value, type: section)
        }
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
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
