//
//  CustomerEditor.swift
//  Miselog
//
//  Created by 成田裕之 on 2017/06/03.
//  Copyright © 2017年 Hiroyuki Narita. All rights reserved.
//

import UIKit
import CoreData

class CustomerFacade {
    let entityName = "Customer"
    let attrName = "name"
    let attrMemo = "memo"
    
    func create(name: String, memo: String) -> Bool {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let customer = NSEntityDescription.entity(forEntityName: "Customer",
                                                  in: context)
        let newRecord = NSManagedObject(entity: customer!,
                                        insertInto: context)
        
        newRecord.setValue(name, forKey: self.attrName)
        newRecord.setValue(memo, forKey: self.attrMemo)
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
    func delete(object: Customer) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        context.delete(object)
        
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func deleteAll() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let customer = NSEntityDescription.entity(forEntityName: self.entityName,
                                                  in: context)
        let query: NSFetchRequest<Customer> = Customer.fetchRequest()
        query.entity = customer
        
        
        do {
            let results = try context.fetch(query)
            for result in results {
                context.delete(result as Customer)
            }
            
            try context.save()
        } catch {
            
        }
    }
    
    func selectAll() -> [Customer] {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let query: NSFetchRequest<Customer> = Customer.fetchRequest()
        
        var ret = [Customer]()
        
        do {
            let fetchResults = try context.fetch(query)
            for result: Customer in fetchResults {
                ret.append(result)
            }
            
            try context.save()
        } catch {
            
        }
        
        return ret
    }
    
    func select(id: NSManagedObjectID) -> Customer {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        return context.object(with: id) as! Customer
    }
    
    func update(_ id: NSManagedObjectID,
                newName: String,
                newMemo: String) -> Bool {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let customer = context.object(with: id)
        customer.setValue(newName, forKey: self.attrName)
        customer.setValue(newMemo, forKey: self.attrMemo)
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
}
