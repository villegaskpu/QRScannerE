//
//  QRCodeEntity+CoreDataProperties.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//
//

import Foundation
import CoreData


extension QRCodeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QRCodeEntity> {
        return NSFetchRequest<QRCodeEntity>(entityName: "QRCodeEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var scanDate: Date?
    @NSManaged public var content: String?

}

extension QRCodeEntity : Identifiable {

}
