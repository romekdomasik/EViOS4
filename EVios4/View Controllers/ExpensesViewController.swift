//
//  ExpensesViewController.swift
//  EVios4
//
//  Created by roman domasik on 14/09/2023.
//

import UIKit
import CoreData

class ExpensesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    private var resultsController: NSFetchedResultsController<Expense>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        
        let request = Expense.fetchRequest()
        request.sortDescriptors = [
        NSSortDescriptor(key: "typeOfExpense.name", ascending: true),
        NSSortDescriptor(key: "name", ascending: true),
        NSSortDescriptor(key: "value", ascending: true)
        ]
        
        resultsController = NSFetchedResultsController(
                   fetchRequest: request,
                   managedObjectContext: DataManager.shared.context,
                   sectionNameKeyPath: "typeOfExpense.name",
                   cacheName: nil)
               resultsController.delegate = self

               do {
                   try resultsController.performFetch()
               } catch {
                   print("Error fetching initial data", error)
               }
    
    }
    
    @IBAction func pressAddExpenseBtn(_ sender: Any) {
        let modalViewController = (storyboard?.instantiateViewController(identifier: "AddExpensesViewController"))!
        let navigationController = UINavigationController(rootViewController: modalViewController)
        present(navigationController, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            resultsController.sections?.count ?? 0
            
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expense = resultsController.object(at: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(expense.name)                                                  \(expense.value) €"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           true
       }

       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               let expense = resultsController.object(at: indexPath)
               DataManager.shared.deleteExpense(expense)
           }
       }
       
       func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           resultsController.sections?[section].name
       }
       
       func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           tableView.beginUpdates()
       }

       func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           tableView.endUpdates()
       }
       
       func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
           switch type {
           case .insert:
               tableView.insertSections([sectionIndex], with: .automatic)
           case .delete:
               tableView.deleteSections([sectionIndex], with: .automatic)
           default:
               break
           }
       }
       
       func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
           switch type {
           case .insert:
               tableView.insertRows(at: [newIndexPath!], with: .automatic)
           case .delete:
               tableView.deleteRows(at: [indexPath!], with: .automatic)
           case .move:
               tableView.deleteRows(at: [indexPath!], with: .automatic)
               tableView.insertRows(at: [newIndexPath!], with: .automatic)
           case .update:
               tableView.reloadRows(at: [indexPath!], with: .automatic)
           default:
               break
           }
       }
    
    
    
    

}
