//
//  SectionsViewController.swift
//  EVios4
//
//  Created by roman domasik on 14/09/2023.
//

import UIKit
import CoreData

class SectionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
   
    
    @IBOutlet weak var tableView: UITableView!
    
    private var resultsController: NSFetchedResultsController<ExpenseSection>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let request = ExpenseSection.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        resultsController = NSFetchedResultsController(
            fetchRequest: request, // variable qui recupere les noms de types de recette
            managedObjectContext: DataManager.shared.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        resultsController.delegate = self

        do {
            try resultsController.performFetch()
        } catch {
            print("Error fetching initial data", error)
        }

    }
    
    @IBAction func pressAddSectionBtn(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Expense section", message: "Enter the name of the new section", preferredStyle: .alert)
        
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            //quand on clic sur add ça stocke le resultat du text field dans la variable fieldText
            guard let fieldText = alert.textFields?.first?.text,
                  !fieldText.isEmpty
            else { return }
            
            // on ajoute le type à la base de données en prenant la valeur entrée dans le champ texte
            DataManager.shared.addExpenseType(name: fieldText)
        }))
        present(alert, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = resultsController.object(at: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = sections.name
        return cell
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
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
