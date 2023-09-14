//
//  Expense+CoreDataProperties.swift
//  EVios4
//
//  Created by roman domasik on 14/09/2023.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var date: Date
    @NSManaged public var name: String
    @NSManaged public var value: Float
    @NSManaged public var typeOfExpense: ExpenseSection?
    

}

extension Expense : Identifiable {

}
