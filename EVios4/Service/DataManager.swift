//
//  DataManager.swift
//  EVios4
//
//  Created by roman domasik on 14/09/2023.
//

import Foundation
import CoreData

class DataManager{
    
    static let shared = DataManager()
    
    let context: NSManagedObjectContext
    
    init() {
        let container = NSPersistentContainer(name: "Expenses")
        let dbFileURL = FileManager.default
                    .urls(for: .documentDirectory, in: .userDomainMask)[0]
                    .appendingPathComponent("db.sqlite")
                
                let storeDescription = NSPersistentStoreDescription(url: dbFileURL)
                storeDescription.type = NSSQLiteStoreType
                container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        context = container.viewContext
    }
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Error saving context", error)
        }
    }
    
    func addExpenseType(name: String) {
        let type = ExpenseSection(context: context)
        type.name = name
        saveContext()
    }
    
    func addExpense(name: String, date: Date, value: Float, type: ExpenseSection) {
        let expense = Expense(context: context)
        expense.name = name
        expense.date = date
        expense.value = value
        expense.typeOfExpense = type
        saveContext()
    }

    func deleteExpense(_ expense: Expense) {
        context.delete(expense)
        saveContext()
    }

}
