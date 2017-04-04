//
//  CoreDataManager.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/4/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation
import CoreData

class GasPriceStorageManager {
    
    var managedContext: NSManagedObjectContext!
    let entityId = "GasPriceEntity"
    let generalEntity: NSEntityDescription
    
    
    init() {
        if let entity = NSEntityDescription.entity(forEntityName: entityId, in: managedContext) {
            generalEntity = entity
        } else {
            throw("GasPriceEntity no declarada")
        }
    }
    
    func newGasPrice(location: GasPriceLocation) {
        
        let persona = GasPriceEntity(entity: personaEntity!, insertIntoManagedObjectContext: managedContext)
        // Asignar valores.
        persona.nombre = "Miguel"
        persona.edad = 32
        
        // Insertar un coche.
        // Crear un tipo de entidad: Coche.
        let cocheEntity = NSEntityDescription.entityForName("Coche", inManagedObjectContext: managedContext)
        // Crear una entidad del tipo: cocheEntity o sea Coche.
        let coche = Coche(entity: cocheEntity!, insertIntoManagedObjectContext: managedContext)
        // Asignar valores.
        coche.marca = "Ferrari"
        coche.ano_compra = 2045
        // Relacionar el propietario con el coche.
        coche.propietario = persona
        
        // Guardar en disco.
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error al insertar: \(error)")
        }
    }
    
    Swift
    
    func recuperarPersona(nombre: String?) -> Persona? {
        let fetchRequest = NSFetchRequest(entityName: "Persona")
        if let nombre = nombre {
            fetchRequest.predicate = NSPredicate(format: "nombre == %@", nombre)
        }
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                let p = results.first! as! Persona
                print("Encontrada una persona: \(p.nombre!) - \(p.edad!) con \(p.coches!.count) coche.")
                if let coches_de_p = p.coches {
                    for c in coches_de_p {
                        let c = c as! Coche
                        print("Coche de \(p.nombre!): \(c.marca!) - \(c.ano_compra!)")
                    }
                }
                return p
            } else {
                print("No hay personas.")
                return nil
            }
        } catch let error as NSError {
            print("Error al recuperar: \(error)")
        }
        
        return nil
    }

    func recuperarPersona(nombre: String?) -> Persona? {
        let fetchRequest = NSFetchRequest(entityName: "Persona")
        if let nombre = nombre {
            fetchRequest.predicate = NSPredicate(format: "nombre == %@", nombre)
        }
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                let p = results.first! as! Persona
                print("Encontrada una persona: \(p.nombre!) - \(p.edad!) con \(p.coches!.count) coche.")
                if let coches_de_p = p.coches {
                    for c in coches_de_p {
                        let c = c as! Coche
                        print("Coche de \(p.nombre!): \(c.marca!) - \(c.ano_compra!)")
                    }
                }
                return p
            } else {
                print("No hay personas.")
                return nil
            }
        } catch let error as NSError {
            print("Error al recuperar: \(error)")
        }
        
        return nil
    }
    

    func modificar(p: Persona) {
        // Cambiar los datos de la Persona p.
        p.nombre = "Manolo"
        p.edad = 23
        
        // Insertar un nuevo coche.
        // Crear un tipo de entidad: Coche.
        let cocheEntity = NSEntityDescription.entityForName("Coche", inManagedObjectContext: managedContext)
        // Crear una entidad del tipo: cocheEntity o sea Coche.
        let coche = Coche(entity: cocheEntity!, insertIntoManagedObjectContext: managedContext)
        // Asignar valores.
        coche.marca = "Seat"
        coche.ano_compra = 1989
        // Relacionar el propietario con el coche.
        coche.propietario = p
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error al modificar: \(error)")
        }
    }
    
    Swift
    
    func eliminar(p: Persona) {
        
        managedContext.deleteObject(p)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error al eliminar: \(error)")
        }
    }

    func eliminar(p: Persona) {
        
        managedContext.deleteObject(p)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error al eliminar: \(error)")
        }
    }
    
}
