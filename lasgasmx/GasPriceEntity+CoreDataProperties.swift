


//
//  GasPriceEntity+CoreDataProperties.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/4/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension GasPriceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GasPriceEntity> {
        return NSFetchRequest<GasPriceEntity>(entityName: "GasPriceEntity");
    }

    public var state: String
    public var city: String
    public var dateText: String?
    public var magna: Float?
    public var premium: Float?
    public var diesel: Float?

}
