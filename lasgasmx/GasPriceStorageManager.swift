//
//  CoreDataManager.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/4/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit
import CoreData

class GasPriceStorageManager {
    
    private let entityId = "GasPriceEntity"
    private let generalEntity: NSEntityDescription
    private var context: NSManagedObjectContext
    
    init(){
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        
        if let e = NSEntityDescription.entity(forEntityName: entityId, in:  self.context ) {
            self.generalEntity = e
        } else {
            print("\(entityId) Not Found")
            abort()
        }
    }
    
    func newGasPrice(location: GasPriceLocation) {
        let newGasPriceStorage = GasPriceEntity(entity: generalEntity, insertInto: context)
        newGasPriceStorage.set(location: location)
        newGasPriceStorage.dateText = ""
        newGasPriceStorage.magna = 0.0
        newGasPriceStorage.diesel = 0.0
        newGasPriceStorage.premium = 0.0
        newGasPriceStorage.id = generateIdTimestamp()
        saveChanges()
    }
    
    func saveChanges() {
        do {
            try context.save()
        } catch let error  {
            print("Could not save \(error), \(error.localizedDescription)")
        }
    }
    
    func fetchAll() -> [GasPriceEntity] {
        let fetchRequest: NSFetchRequest<GasPriceEntity> = GasPriceEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func fetchAllAsGasPrices() -> [GasPriceInState] {
        return fetchAll().map{ $0.getStruct() } as [GasPriceInState]
    }
    
    func editLocation(with actualLocation: GasPriceLocation, recordChanges: (_ item: GasPriceEntity) -> Bool) {

    }
    
    func deleteWith(id: String) {
        let predicate = NSPredicate(format: "id = %@" ,"\(id)")
        let fetchRequest: NSFetchRequest<GasPriceEntity> = GasPriceEntity.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            if let itemToDelete = searchResults.first {
                context.delete(itemToDelete)
                saveChanges()
            }
        } catch let error {
            print("Could not save \(error), \(error.localizedDescription)")
        }
    }
    
    
    func updatePriceBy(id:String, recordChanges:(_ gasPriceEntity: GasPriceEntity) -> Void){
        
        let predicate = NSPredicate(format: "id = %@" ,"\(id)")
        let fetchRequest: NSFetchRequest<GasPriceEntity> = GasPriceEntity.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            if let itemToUpdate = searchResults.first {
                recordChanges(itemToUpdate)
                saveChanges()
            }
        } catch let error {
            print("Could not save \(error), \(error.localizedDescription)")
        }
    }
    
}
