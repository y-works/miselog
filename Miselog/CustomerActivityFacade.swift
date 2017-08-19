//
//  CustomerActivityFacade.swift
//  Miselog
//
//  Created by 成田裕之 on 2017/06/03.
//  Copyright © 2017年 Hiroyuki Narita. All rights reserved.
//

import UIKit
import CoreData

class CustomerActivityFacade {
    let entityName = "CustomerActivity"
    let attrCustomer = "customer"
    let attrMemo = "memo"
    let attrDate = "date"
    
    func create(customer: Customer, memo: String, date: Date) -> Bool {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let customerActivity = NSEntityDescription.entity(
            forEntityName: self.entityName,
            in: context)
        let newRecord = NSManagedObject(entity: customerActivity!,
                                        insertInto: context)
        
        newRecord.setValue(customer, forKey: self.attrCustomer)
        newRecord.setValue(memo, forKey: self.attrMemo)
        newRecord.setValue(date, forKey: self.attrDate)
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
    func delete(related: Customer) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let request: NSFetchRequest<CustomerActivity> =
            CustomerActivity.fetchRequest()
        request.predicate = NSPredicate(format: "customer=%@", related)
        
        do {
            let fetchResults = try context.fetch(request)
            for result: CustomerActivity in fetchResults {
                context.delete(result)
            }
            print("-------->")
            print(fetchResults.count)
            print("<--------")
                
            try context.save()
        } catch {
            
        }
    }
    
    func delete(object: CustomerActivity) {
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
        
        let activity = NSEntityDescription.entity(forEntityName: self.entityName,
                                                  in: context)
        let query: NSFetchRequest<CustomerActivity>
            = CustomerActivity.fetchRequest()
        query.entity = activity
        
        
        do {
            let results = try context.fetch(query)
            for result in results {
                context.delete(result as CustomerActivity)
            }
            
            try context.save()
        } catch {
            
        }
    }
    
    func selectAll() -> [CustomerActivity] {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let query: NSFetchRequest<CustomerActivity> =
            CustomerActivity.fetchRequest()
        
        var ret = [CustomerActivity]()
        
        do {
            let fetchResults = try context.fetch(query)
            for result: CustomerActivity in fetchResults {
                ret.append(result)
            }
            
            try context.save()
        } catch {
            
        }
        
        return ret
    }
    
    func select(customer: Customer) -> [CustomerActivity] {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let request: NSFetchRequest<CustomerActivity>
            = CustomerActivity.fetchRequest()
        print(customer.objectID)
        request.predicate = NSPredicate(format: "customer = %@", customer)
        
        var ret = [CustomerActivity]()
        
        do {
            let fetchResults = try context.fetch(request)
            for result: CustomerActivity in fetchResults {
                ret.append(result)
            }
            
            try context.save()
        } catch {
            
        }
        
        return ret
    }
}
